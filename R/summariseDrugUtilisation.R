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

#' This function is used to summarise the dose utilisation table over multiple
#' cohorts.
#'
#' @inheritParams cohortDoc
#' @inheritParams cohortIdDoc
#' @inheritParams strataDoc
#' @param estimates Estimates that we want for the columns.
#' @inheritParams ingredientConceptIdDoc
#' @inheritParams conceptSetDoc
#' @inheritParams indexDateDoc
#' @inheritParams censorDateDoc
#' @param restrictIncident Whether to include only incident prescriptions in the
#' analysis. If FALSE all prescriptions that overlap with the study period will
#' be included.
#' @inheritParams gapEraDoc
#' @inheritParams drugUtilisationDoc
#'
#' @return A summary of drug utilisation stratified by cohort_name and strata_name
#'
#' @export
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(CodelistGenerator)
#'
#' cdm <- mockDrugUtilisation()
#' codelist <- CodelistGenerator::getDrugIngredientCodes(cdm, "acetaminophen")
#' cdm <- generateDrugUtilisationCohortSet(
#'   cdm, "dus_cohort", codelist
#' )
#' cdm[["dus_cohort"]] |>
#'   summariseDrugUtilisation(ingredientConceptId = 1125315)
#' }
#'
summariseDrugUtilisation <- function(cohort,
                                     cohortId = NULL,
                                     strata = list(),
                                     estimates = c(
                                       "q25", "median", "q75", "mean", "sd",
                                       "count_missing", "percentage_missing"
                                     ),
                                     ingredientConceptId = NULL,
                                     conceptSet = NULL,
                                     indexDate = "cohort_start_date",
                                     censorDate = "cohort_end_date",
                                     restrictIncident = TRUE,
                                     gapEra = 1,
                                     numberExposures = TRUE,
                                     numberEras = TRUE,
                                     daysExposed = TRUE,
                                     daysPrescribed = TRUE,
                                     timeToExposure = TRUE,
                                     initialExposureDuration = TRUE,
                                     initialQuantity = TRUE,
                                     cumulativeQuantity = TRUE,
                                     initialDailyDose = TRUE,
                                     cumulativeDose = TRUE,
                                     exposedTime = lifecycle::deprecated()) {
  if (lifecycle::is_present(exposedTime)) {
    lifecycle::deprecate_warn(
      when = "0.8.0", what = "addDrugUtilisation(exposedTime= )",
      with = "addDrugUtilisation(daysExposed= )"
    )
    if (missing(daysExposed)) {
      daysExposed <- exposedTime
    }
  }
  # checks
  cohort <- validateCohort(cohort)
  cohortId <- omopgenerics::validateCohortIdArgument({{cohortId}}, cohort)
  strata <- validateStrata(strata, cohort)
  omopgenerics::assertChoice(estimates, PatientProfiles::availableEstimates(variableType = "numeric", fullQuantiles = TRUE)$estimate_name)
  cdm <- omopgenerics::cdmReference(cohort)
  omopgenerics::assertNumeric(ingredientConceptId, integerish = TRUE, null = TRUE, call = call)
  if (is.null(conceptSet)) {
    if (is.null(ingredientConceptId)) {
      cli::cli_abort("`ingredientConceptId` or `conceptSet` must be provided.", call = call)
    } else {
      # https://github.com/darwin-eu-dev/omopgenerics/issues/618
      # conceptSet <- purrr::map(ingredientConceptId, \(x) {
      #   dplyr::tibble(concept_id = x, excluded = FALSE, descendants = TRUE, mapped = FALSE)
      # }) |>
      #   rlang::set_names(paste0("ingredient_", ingredientConceptId, "_descendants")) |>
      #   omopgenerics::newConceptSetExpression()
      conceptSet <- purrr::map(ingredientConceptId, \(x) {
        cdm[["concept_ancestor"]] |>
          dplyr::filter(.data$ancestor_concept_id %in% .env$x) |>
          dplyr::pull("descendant_concept_id")
      }) |>
        rlang::set_names(paste0("ingredient_", ingredientConceptId, "_descendants")) |>
        omopgenerics::newCodelist()
    }
  }
  conceptSet <- validateConceptSet(conceptSet, call = call)

  # concept dictionary
  dic <- dplyr::tibble(concept_set = names(conceptSet)) |>
    dplyr::mutate(
      concept_set_name_id = paste0("xxid", dplyr::row_number(), "xx"),
      concept_set_name = paste0("id", dplyr::row_number())
    )
  names(conceptSet) <- dic$concept_set_name_id

  # add drug utilisation
  initialCols <- c(
    "cohort_definition_id", "subject_id", indexDate, censorDate,
    unique(unlist(strata))
  )
  cohort <- cohort |>
    dplyr::filter(.data$cohort_definition_id %in% .env$cohortId) |>
  dplyr::select(dplyr::all_of(initialCols)) |>
    PatientProfiles::addCohortName() |>
    addDrugUseInternal(
      indexDate = indexDate,
      censorDate = censorDate,
      conceptSet = conceptSet,
      ingredientConceptId = ingredientConceptId,
      restrictIncident = restrictIncident,
      numberExposures = numberExposures,
      numberEras = numberEras,
      daysExposed = daysExposed,
      daysPrescribed = daysPrescribed,
      timeToExposure = timeToExposure,
      initialExposureDuration = initialExposureDuration,
      initialQuantity = initialQuantity,
      cumulativeQuantity = cumulativeQuantity,
      initialDailyDose = initialDailyDose,
      cumulativeDose = cumulativeDose,
      gapEra = gapEra,
      nameStyle = "{value}_{concept_name}_{ingredient}",
      name = NULL
    ) |>
    dplyr::collect()

  drugUseCols <- colnames(cohort)
  drugUseCols <- drugUseCols[!drugUseCols %in% initialCols]

  variableNames <- c(
    "number_exposures_", "time_to_exposure_", "cumulative_quantity_",
    "initial_quantity_", "initial_exposure_duration_", "number_eras_",
    "days_exposed_", "cumulative_dose_", "initial_daily_dose_",
    "days_prescribed_"
  )

  # summarise drug use columns
  suppressMessages(
    PatientProfiles::summariseResult(
      table = cohort,
      group = list("cohort_name"),
      strata = strata,
      variables = drugUseCols,
      estimates = estimates
    )
  ) |>
    dplyr::mutate(
      cdm_name = dplyr::coalesce(omopgenerics::cdmName(cdm), as.character(NA)),
      concept_set_name = dplyr::if_else(
        .data$variable_name %in% c("number records", "number subjects"),
        NA_character_,
        gsub(".*_xx|xx_.*|xx.*", "", .data$variable_name)
      ),
      ingredient_id = gsub(".*xx_|.*xx", "", .data$variable_name),
      ingredient_id = dplyr::if_else(
        nchar(.data$ingredient_id) == 0 | grepl("records|subjects", .data$variable_level),
        NA,
        suppressWarnings(as.numeric(.data$ingredient_id))
      ),
      variable_name = stringr::str_replace(.data$variable_name, "_xxid.*", "") |>
        stringr::str_replace_all("_", " ")
    ) |>
    dplyr::left_join(dic, by = "concept_set_name") |>
    dplyr::left_join(
      cdm$concept |>
        dplyr::filter(.data$concept_class_id == "Ingredient") |>
        dplyr::select("ingredient_id" = "concept_id", "ingredient" = "concept_name") |>
        dplyr::collect(),
      by = "ingredient_id"
    ) |>
    dplyr::select(-c(dplyr::starts_with("additional"))) |>
    omopgenerics::uniteAdditional(cols = c("concept_set", "ingredient")) |>
    dplyr::select(dplyr::all_of(omopgenerics::resultColumns())) |>
    dplyr::arrange(.data$result_id, .data$group_name, .data$group_level, .data$strata_name, .data$strata_level) |>
    omopgenerics::newSummarisedResult(settings = dplyr::tibble(
      result_id = 1L,
      result_type = "summarise_drug_utilisation",
      package_name = "DrugUtilisation",
      package_version = pkgVersion()
    ))
}

variableNameExp <- function(variableNames) {
  expr <- "dplyr::case_when("
  for (var in variableNames) {
    expr <- paste0(expr, "grepl('", var, "', .data$variable_name) ~ '", gsub("_", " ", substring(var, 0, nchar(var) - 1)), "',")
  }
  expr <- paste0(expr, ".default = .data$variable_name)") |>
    rlang::parse_exprs() |>
    rlang::set_names("variable_name")
}
