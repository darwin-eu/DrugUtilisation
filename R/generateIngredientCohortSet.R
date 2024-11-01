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
#' @param cdm A cdm reference.
#' @param name The name of the new cohort table to add to the cdm reference.
#' @param ingredient Accepts both vectors and named lists of ingredient names.
#' For a vector input, e.g., c("acetaminophen", "codeine"), it generates a
#' cohort table with descendant concept codes for each ingredient, assigning
#' unique cohort_definition_id. For a named list input, e.g., list(
#' "test_1" = c("simvastatin", "acetaminophen"), "test_2" = "metformin"),
#' it produces a cohort table based on the structure of the input, where
#' each name leads to a combined set of descendant concept codes for the
#' specified ingredients, creating distinct cohort_definition_id for each
#' named group.
#' @param gapEra Number of days between two continuous exposures to be
#' considered in the same era. Records that have fewer days between them than
#' this gap will be concatenated into the same cohort record.
#' @param ... Arguments to be passed to
#' `CodelistGenerator::getDrugIngredientCodes()`.
#' @param durationRange Deprecated.
#' @param imputeDuration Deprecated.
#' @param priorUseWashout Deprecated
#' @param priorObservation Deprecated.
#' @param cohortDateRange Deprecated.
#' @param limit Deprecated.
#'
#' @return The function returns the cdm reference provided with the addition of
#' the new cohort table.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(dplyr)
#'
#' cdm <- mockDrugUtilisation()
#'
#' cdm <- generateIngredientCohortSet(
#'   cdm = cdm,
#'   ingredient = "acetaminophen",
#'   name = "acetaminophen"
#' )
#'
#' cdm$acetaminophen |>
#'   glimpse()
#' }
#'
generateIngredientCohortSet <- function(cdm,
                                        name,
                                        ingredient = NULL,
                                        gapEra = 1,
                                        ...,
                                        durationRange = lifecycle::deprecated(),
                                        imputeDuration = lifecycle::deprecated(),
                                        priorUseWashout = lifecycle::deprecated(),
                                        priorObservation = lifecycle::deprecated(),
                                        cohortDateRange = lifecycle::deprecated(),
                                        limit = lifecycle::deprecated()) {
  codesFunction <- "CodelistGenerator::getDrugIngredientCodes"
  reportFunction <- "DrugUtilisation::generateIngredientCohortSet"

  return(cdm)
}

recordArgs <- function(fun, ...) {
  args <- list(...)
  arguments <- fun |>
    rlang::parse_expr() |>
    rlang::eval_tidy() |>
    formals()
  arguments <- arguments[!names(arguments) %in% c("name", "cdm", "type")]
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
generateSubFunctions <- function(codesFunction,
                                 reportFunction,
                                 cdm,
                                 name,
                                 nam,
                                 gapEra,
                                 ...,
                                 durationRange,
                                 imputeDuration,
                                 priorUseWashout,
                                 priorObservation,
                                 cohortDateRange,
                                 limit) {

  if (lifecycle::is_present(durationRange)) {
    lifecycle::deprecate_warn(
      when = "0.7.0",
      what = "generateIngredientCohortSet(durationRange = )"
    )
  }
  if (lifecycle::is_present(imputeDuration)) {
    lifecycle::deprecate_warn(
      when = "0.7.0", what = "generateIngredientCohortSet(imputeDuration = )"
    )
  }
  if (lifecycle::is_present(priorUseWashout)) {
    lifecycle::deprecate_warn(
      when = "0.7.0",
      what = "generateIngredientCohortSet(priorUseWashout = )",
      with = "requirePriorDrugWashout()"
    )
  }
  if (lifecycle::is_present(priorObservation)) {
    lifecycle::deprecate_warn(
      when = "0.7.0",
      what = "generateIngredientCohortSet(priorObservation = )",
      with = "requireObservationBeforeDrug()"
    )
  }
  if (lifecycle::is_present(cohortDateRange)) {
    lifecycle::deprecate_warn(
      when = "0.7.0",
      what = "generateIngredientCohortSet(cohortDateRange = )",
      with = "requireDrugInDateRange()"
    )
  }
  if (lifecycle::is_present(limit)) {
    lifecycle::deprecate_warn(
      when = "0.7.0",
      what = "generateIngredientCohortSet(limit = )",
      with = "requireIsFirstDrugEntry()"
    )
  }

  if (!is.list(ingredient)) {
    conceptSet <- CodelistGenerator::getDrugIngredientCodes(
      cdm = cdm,
      name = ingredient,
      ...
    )
  } else {
    conceptSet <- lapply(ingredient, function(values) {
      lapply(values, function(value) {
        CodelistGenerator::getDrugIngredientCodes(
          cdm = cdm,
          name = value,
          ...
        )
      }) |>
        unname() |>
        unlist() |>
        unique()
    })
  }

  cdm <- DrugUtilisation::generateDrugUtilisationCohortSet(
    cdm = cdm,
    name = name,
    conceptSet = conceptSet,
    gapEra = gapEra
  )

  values <- recordArgs("CodelistGenerator::getDrugIngredientCodes", ...)

  cdm[[name]] <- cdm[[name]] |>
    omopgenerics::newCohortTable(
      cohortSetRef = settings(cdm[[name]]) |>
        dplyr::mutate(!!!values)
    )

}
