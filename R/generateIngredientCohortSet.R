# Copyright 2024 DARWIN EU (C)
#
# This file is part of DrugUtilisation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Generate a set of drug cohorts based on drug ingredients
#'
#' @description
#' Adds a new cohort table to the cdm reference with individuals who have drug
#' exposure records with the specified drug ingredient. Cohort start and end
#' dates will be based on drug record start and end dates, respectively. Records
#' that overlap or have fewer days between them than the specified gap era will
#' be concatenated into a single cohort entry.
#'
#' @inheritParams cdmDoc
#' @inheritParams newNameDoc
#' @param ingredient Accepts both vectors and named lists of ingredient names.
#' For a vector input, e.g., c("acetaminophen", "codeine"), it generates a
#' cohort table with descendant concept codes for each ingredient, assigning
#' unique cohort_definition_id. For a named list input, e.g., list(
#' "test_1" = c("simvastatin", "acetaminophen"), "test_2" = "metformin"),
#' it produces a cohort table based on the structure of the input, where
#' each name leads to a combined set of descendant concept codes for the
#' specified ingredients, creating distinct cohort_definition_id for each
#' named group.
#' @inheritParams gapEraDoc
#' @param subsetCohort Cohort table to subset.
#' @param subsetCohortId Cohort id to subset.
#' @inheritParams numberExposuresDoc
#' @inheritParams daysPrescribedDoc
#' @param ... Arguments to be passed to
#' `CodelistGenerator::getDrugIngredientCodes()`.
#'
#' @return The function returns the cdm reference provided with the addition of
#' the new cohort table.
#'
#' @export
#'
#' @examples
#' \donttest{
#' cdm <- mockDrugUtilisation()
#'
#' cdm <- generateIngredientCohortSet(
#'   cdm = cdm,
#'   ingredient = "acetaminophen",
#'   name = "acetaminophen"
#' )
#'
#' cdm$acetaminophen |>
#'   dplyr::glimpse()
#' }
#'
generateIngredientCohortSet <- function(cdm,
                                        name,
                                        ingredient = NULL,
                                        gapEra = 1,
                                        subsetCohort = NULL,
                                        subsetCohortId = NULL,
                                        numberExposures = FALSE,
                                        daysPrescribed = FALSE,
                                        ...) {
  generateSubFunctions(
    type = "ingredient",
    cdm = cdm,
    name = name,
    nam = ingredient,
    gapEra = gapEra,
    subsetCohort = subsetCohort,
    subsetCohortId = subsetCohortId,
    numberExposures = numberExposures,
    daysPrescribed = daysPrescribed,
    ...
  )
}

recordArgs <- function(fun, ...) {
  args <- list(...)
  arguments <- fun |>
    rlang::parse_expr() |>
    rlang::eval_tidy() |>
    formals()
  arguments <- arguments[!names(arguments) %in% c("name", "cdm", "type", "nameStyle")]
  vals <- names(arguments) |>
    purrr::map(\(x) {
      if (x %in% names(args)) {
        value <- args[[x]]
      } else {
        value <- arguments[[x]] |>
          rlang::eval_tidy()
      }
      prepareValue(value)
    })
  names(vals) <- omopgenerics::toSnakeCase(names(arguments))
  return(vals)
}
prepareValue <- function(val) {
  if (length(val) == 0) return("")
  paste0(as.character(val), collapse = "; ")
}
generateSubFunctions <- function(type,
                                 cdm,
                                 name,
                                 nam,
                                 gapEra,
                                 subsetCohort,
                                 subsetCohortId,
                                 numberExposures,
                                 daysPrescribed,
                                 ...) {
  if (type == "ingredient") {
    codesFunction <- "CodelistGenerator::getDrugIngredientCodes"
    reportFunction <- "DrugUtilisation::generateIngredientCohortSet"
  } else if (type == "atc") {
    codesFunction = "CodelistGenerator::getATCCodes"
    reportFunction = "DrugUtilisation::generateIngredientCohortSet"
  }

  if (!is.null(nam)) {
    if (!is.list(nam)) {
      if (is.null(names(nam))) nam <- rlang::set_names(nam)
      nam <- as.list(nam)
    }
    conceptSet <- purrr::map(nam, \(x) {
      paste0(codesFunction, "(cdm = cdm, name = x, ...)") |>
        rlang::parse_expr() |>
        rlang::eval_tidy() |>
        unlist() |>
        unique() |>
        as.integer()
    })
  } else {
    conceptSet <- paste0(codesFunction, "(cdm = cdm, ...)") |>
      rlang::parse_expr() |>
      rlang::eval_tidy()
    nam <- as.list(names(conceptSet))
  }

  cdm <- DrugUtilisation::generateDrugUtilisationCohortSet(
    cdm = cdm,
    name = name,
    conceptSet = conceptSet,
    gapEra = gapEra,
    subsetCohort = subsetCohort,
    subsetCohortId = subsetCohortId,
    numberExposures = numberExposures,
    daysPrescribed = daysPrescribed
  )

  values <- recordArgs(codesFunction, ...)
  values[[paste0(type, "_name")]] <- nam |>
    purrr::map_chr(\(x) paste0(x, collapse = "; "))

  cdm[[name]] <- cdm[[name]] |>
    omopgenerics::newCohortTable(
      cohortSetRef = settings(cdm[[name]]) |>
        dplyr::mutate(!!!values)
    )

  return(cdm)
}
