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

#' Generate a set of drug cohorts based on given concepts
#'
#' @description
#' Adds a new cohort table to the cdm reference with individuals who have drug
#' exposure records with the specified concepts. Cohort start and end dates will
#' be based on drug record start and end dates, respectively. Records that
#' overlap or have fewer days between them than the specified gap era will be
#' concatenated into a single cohort entry.
#'
#' @inheritParams cdmDoc
#' @inheritParams newNameDoc
#' @inheritParams conceptSetDoc
#' @inheritParams gapEraDoc
#' @param subsetCohort Cohort table to subset.
#' @param subsetCohortId Cohort id to subset.
#' @inheritParams numberExposuresDoc
#' @inheritParams daysPrescribedDoc
#'
#' @return The function returns the cdm reference provided with the addition of
#' the new cohort table.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(CodelistGenerator)
#' library(dplyr, warn.conflicts = FALSE)
#'
#' cdm <- mockDrugUtilisation()
#'
#' druglist <- getDrugIngredientCodes(cdm = cdm,
#'                                    name = c("acetaminophen", "metformin"),
#'                                    nameStyle = "{concept_name}")
#'
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "drug_cohorts",
#'                                         conceptSet = druglist,
#'                                         gapEra = 30,
#'                                         numberExposures = TRUE,
#'                                         daysPrescribed = TRUE)
#'
#' cdm$drug_cohorts |>
#'   glimpse()
#' }
#'
generateDrugUtilisationCohortSet <- function(cdm,
                                             name,
                                             conceptSet,
                                             gapEra = 1,
                                             subsetCohort = NULL,
                                             subsetCohortId = NULL,
                                             numberExposures = FALSE,
                                             daysPrescribed = FALSE) {
  # initial checks
  cdm <- omopgenerics::validateCdmArgument(cdm)
  name <- omopgenerics::validateNameArgument(name, null = TRUE, call = call, validation = "warning")
  conceptSet <- validateConceptSet(conceptSet)
  omopgenerics::assertNumeric(gapEra, integerish = TRUE, length = 1)
  omopgenerics::assertLogical(numberExposures, length = 1)
  omopgenerics::assertLogical(daysPrescribed, length = 1)
  omopgenerics::assertCharacter(subsetCohort, length = 1, null = TRUE)
  if (!is.null(subsetCohort)) {
    validateCohort(cdm[[subsetCohort]])
    subsetCohortId <- omopgenerics::validateCohortIdArgument({{subsetCohortId}}, cdm[[subsetCohort]])
  }

  # get conceptSet
  cohortSet <- dplyr::tibble(cohort_name = names(conceptSet)) |>
    dplyr::mutate(cohort_definition_id = dplyr::row_number()) |>
    dplyr::select("cohort_definition_id", "cohort_name") |>
    dplyr::mutate(gap_era = as.character(.env$gapEra))

  conceptSet <- conceptSetFromConceptSetList(conceptSet, cohortSet)

  cohortCodelistAttr <- cohortSet |>
    dplyr::select("cohort_definition_id", "codelist_name" = "cohort_name") |>
    dplyr::inner_join(
      conceptSet |>
        dplyr::rename("concept_id" = "drug_concept_id"),
      by = "cohort_definition_id",
      relationship = "one-to-many"
    ) |>
    dplyr::mutate("type" = "index event")

  cdm[[name]] <- subsetTables(cdm, conceptSet, name, subsetCohort, subsetCohortId) |>
    omopgenerics::newCohortTable(
      cohortSetRef = cohortSet, cohortCodelistRef = cohortCodelistAttr
    )

  cols <- c(
    "number_exposures"[numberExposures], "days_prescribed"[daysPrescribed]
  )

  # collapse records
  if (gapEra > 0) {
    cli::cli_inform(c("i" = "Collapsing records with gapEra = {gapEra} days."))
    cdm[[name]] <- cdm[[name]] |>
      erafy(gap = gapEra, toSummarise = cols) |>
      dplyr::select(!"observation_period_id") |>
      dplyr::compute(name = name, temporary = FALSE) |>
      omopgenerics::recordCohortAttrition(glue::glue(
        "Collapse records separated by {gapEra} or less days"
      ))
  } else {
    cdm[[name]] <- cdm[[name]] |>
      dplyr::select(
        "cohort_definition_id", "subject_id", "cohort_start_date",
        "cohort_end_date", dplyr::all_of(cols)
      ) |>
      dplyr::compute(name = name, temporary = FALSE)
  }

  return(cdm)
}

#' Get the gapEra used to create a cohort
#'
#' @param cohort A `cohort_table` object.
#' @param cohortId Integer vector refering to cohortIds from cohort. If NULL all
#' cohort definition ids in settings will be used.
#'
#' @return gapEra values for the specific cohortIds
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(CodelistGenerator)
#'
#' cdm <- mockDrugUtilisation()
#'
#' druglist <- getDrugIngredientCodes(cdm = cdm,
#'                                    name = c("acetaminophen", "metformin"))
#'
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "drug_cohorts",
#'                                         conceptSet = druglist,
#'                                         gapEra = 100)
#'
#' cohortGapEra(cdm$drug_cohorts)
#' }
#'
cohortGapEra <- function(cohort, cohortId = NULL) {
  omopgenerics::assertClass(cohort, class = "cohort_table")
  cohortId <- omopgenerics::validateCohortIdArgument({cohortId}, cohort, validation = "warning")

  set <- settings(cohort)
  if ("gap_era" %in% colnames(set)) {
    gapEra <- set |>
      dplyr::select("gap_era", "cohort_definition_id") |>
      dplyr::inner_join(
        dplyr::tibble(
          "cohort_definition_id" = cohortId, "order" = seq_along(cohortId)
        ),
        by = "cohort_definition_id"
      ) |>
      dplyr::arrange(.data$order) |>
      dplyr::pull("gap_era") |>
      as.integer()
  } else {
    cli::cli_inform("`gap_era` not present in settings, returning NULL.")
    gapEra <- NULL
  }
  return(gapEra)
}
