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

#' Summarise the indications of individuals in a drug cohort
#'
#' @description
#' Summarise the observed indications of patients in a drug cohort based on
#' their presence in an indication cohort in a specified time window. If an
#' individual is not in one of the indication cohorts, they will be considered
#' to have an unknown indication if they are present in one of the specified
#' OMOP CDM clinical tables. Otherwise, if they  are neither in an indication
#' cohort or a clinical table they will be considered as having no observed
#' indication.
#'
#' @inheritParams cohortDoc
#' @inheritParams cohortIdDoc
#' @inheritParams strataDoc
#' @param indicationCohortName Name of the cohort table with potential
#' indications.
#' @param indicationCohortId The target cohort ID to add indication. If NULL all
#' cohorts will be considered.
#' @param indicationWindow The time window over which to identify indications.
#' @param unknownIndicationTable Tables in the OMOP CDM to search for unknown
#' indications.
#' @inheritParams indexDateDoc
#' @param mutuallyExclusive Whether to report indications as mutually exclusive
#' or report them as independent results.
#' @inheritParams censorDateDoc
#'
#' @return A summarised result
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(CDMConnector)
#' library(dplyr, warn.conflicts = FALSE)
#'
#' cdm <- mockDrugUtilisation()
#'
#' indications <- list(headache = 378253, asthma = 317009)
#' cdm <- generateConceptCohortSet(cdm = cdm,
#'                                 conceptSet = indications,
#'                                 name = "indication_cohorts")
#'
#' cdm <- generateIngredientCohortSet(cdm = cdm,
#'                                    name = "drug_cohort",
#'                                    ingredient = "acetaminophen")
#'
#' cdm$drug_cohort |>
#'   summariseIndication(
#'     indicationCohortName = "indication_cohorts",
#'     unknownIndicationTable = "condition_occurrence",
#'     indicationWindow = list(c(-Inf, 0))
#'   ) |>
#'   glimpse()
#' }
#'
summariseIndication <- function(cohort,
                                strata = list(),
                                indicationCohortName,
                                cohortId = NULL,
                                indicationCohortId = NULL,
                                indicationWindow = list(c(0, 0)),
                                unknownIndicationTable = NULL,
                                indexDate = "cohort_start_date",
                                mutuallyExclusive = TRUE,
                                censorDate = NULL) {
  res <- .summariseIntersect(
    cohort = cohort,
    cohortId = {{cohortId}},
    cohortTable = indicationCohortName,
    cohortTableId = indicationCohortId,
    window = indicationWindow,
    strata = strata,
    mutuallyExclusive = mutuallyExclusive,
    unknownTable = unknownIndicationTable,
    indexDate = indexDate,
    censorDate = censorDate,
    nm = "indications"
  )

  cohortTableName <- omopgenerics::tableName(cohort)
  cohortTableName[is.na(cohortTableName)] <- "temp"

  res <- res |>
    omopgenerics::newSummarisedResult(
      settings = dplyr::tibble(
        result_id = 1L,
        result_type = "summarise_indication",
        package_name = "DrugUtilisation",
        package_version = pkgVersion(),
        mutually_exclusive = as.character(mutuallyExclusive),
        unknown_indication_table = paste0(unknownIndicationTable, collapse = "; "),
        cohort_table_name = cohortTableName,
        indication_cohort_name = indicationCohortName,
        index_date = indexDate,
        censor_date = as.character(censorDate %||% "observation_period_end_date")
      )
    )
}

#' This function is used to summarise treatments received
#'
#' @inheritParams cohortDoc
#' @inheritParams cohortIdDoc
#' @param window Time window over which to summarise the treatments.
#' @param treatmentCohortName Name of a cohort in the cdm that contains the
#'  treatments of interest.
#' @param treatmentCohortId Cohort definition id of interest from
#' treatmentCohortName.
#' @inheritParams strataDoc
#' @inheritParams indexDateDoc
#' @inheritParams censorDateDoc
#' @param mutuallyExclusive Whether to include mutually exclusive treatments or
#' not.
#'
#' @return A summary of treatments stratified by cohort_name and strata_name
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#'
#' cdm <- mockDrugUtilisation()
#' cdm$cohort1 |>
#'   summariseTreatment(
#'     treatmentCohortName = "cohort2",
#'     window = list(c(0, 30), c(31, 365))
#'   )
#' }
#'
summariseTreatment <- function(cohort,
                               window,
                               treatmentCohortName,
                               cohortId = NULL,
                               treatmentCohortId = NULL,
                               strata = list(),
                               indexDate = "cohort_start_date",
                               censorDate = NULL,
                               mutuallyExclusive = FALSE) {
  res <- .summariseIntersect(
    cohort = cohort,
    cohortId = {{cohortId}},
    cohortTable = treatmentCohortName,
    cohortTableId = treatmentCohortId,
    window = window,
    strata = strata,
    mutuallyExclusive = mutuallyExclusive,
    unknownTable = character(),
    indexDate = indexDate,
    censorDate = censorDate,
    nm = "medications"
  )

  cohortTableName <- omopgenerics::tableName(cohort)
  cohortTableName[is.na(cohortTableName)] <- "temp"

  res <- res |>
    omopgenerics::newSummarisedResult(
      settings = dplyr::tibble(
        result_id = 1L,
        result_type = "summarise_treatment",
        package_name = "DrugUtilisation",
        package_version = pkgVersion(),
        mutually_exclusive = as.character(mutuallyExclusive),
        cohort_table_name = cohortTableName,
        treatment_cohort_name = treatmentCohortName,
        index_date = as.character(indexDate),
        censor_date = as.character(censorDate %||% "observation_period_end_date")
      )
    )
}

.summariseIntersect <- function(cohort,
                                cohortId,
                                cohortTable,
                                cohortTableId,
                                window,
                                strata,
                                mutuallyExclusive,
                                unknownTable,
                                indexDate,
                                censorDate,
                                nm,
                                call = parent.frame()) {
  # initial checks
  prefix <- omopgenerics::tmpPrefix()
  cdm <- omopgenerics::cdmReference(cohort)
  cohort <- validateCohort(cohort, call = call)
  cohortId <- omopgenerics::validateCohortIdArgument({{cohortId}}, cohort, call = call)
  strata <- validateStrata(strata, cohort, call = call)
  omopgenerics::assertCharacter(cohortTable, call = call)
  cdm[[cohortTable]] <- validateCohort(cdm[[cohortTable]], call = call)
  cohortTableId <- omopgenerics::validateCohortIdArgument(cohortTableId, cdm[[cohortTable]], call = call)
  window <- omopgenerics::validateWindowArgument(window, call = call)
  names(window) <- paste0("win", seq_along(window))

  if (length(cohortTableId) > 5 & isTRUE(mutuallyExclusive)) {
    n <- length(cohortTableId)
    cli::cli_inform(c(
      "!" = "{n} {nm} with mutuallyExclusive = TRUE will generate {2^n} mutually exclusive categories.",
      "i" = "Consider using mutuallyExclusive = FALSE."
    ))
  }

  # get intersections
  cli::cli_inform(c("i" = "Intersect with {nm} table ({.pkg {cohortTable}})"))
  suppressMessages(
    cohort <- cohort |>
      dplyr::filter(.data$cohort_definition_id %in% .env$cohortId) |>
      .addIntersect(
        cohortTable = cohortTable,
        cohortTableId = cohortTableId,
        window = window,
        mutuallyExclusive = TRUE, # always TRUE
        unknownTable = unknownTable,
        indexDate = indexDate,
        censorDate = censorDate,
        name = omopgenerics::uniqueTableName(prefix),
        nm = nm,
        nameStyle = "xyz_{window_name}"
      )
  )

  # summarise data
  variables <- paste0("xyz_", names(window))
  cli::cli_inform(c("i" = "Summarising {nm}."))
  suppressMessages(
    result <- PatientProfiles::summariseResult(
      table = cohort,
      group = "cohort_definition_id",
      includeOverallGroup = FALSE,
      strata = strata,
      includeOverallStrata = TRUE,
      variables = variables,
      estimates = c("count", "percentage"),
      counts = FALSE
    )
  )

  # format output
  set <- omopgenerics::settings(cohort) |>
    dplyr::filter(.data$cohort_definition_id %in% .env$cohortId)
  variableNames <- dplyr::tibble(
    variable_name = variables,
    new_variable_name = paste(
      stringr::str_to_sentence(substr(nm, 1, nchar(nm)-1)),
      purrr::map_chr(window, windowName)
    ),
    window_name = window |>
      unname() |>
      omopgenerics::validateWindowArgument(snakeCase = FALSE) |>
      names()
  )
  extraLabs <- c("unknown"[length(unknownTable) > 0], dplyr::if_else(
    nm == "indications", "none", "untreated"
  ), "not in observation")
  labels <- omopgenerics::settings(cdm[[cohortTable]]) |>
    dplyr::filter(.data$cohort_definition_id %in% .env$cohortTableId) |>
    dplyr::pull("cohort_name") |>
    sort()
  result <- result |>
    formatOutput(
      mutuallyExclusive, labels, extraLabs, variableNames, set
    )

  # drop old tables
  omopgenerics::dropSourceTable(cdm = cdm, name = dplyr::starts_with(prefix))

  return(result)
}

temporalWord <- function(x) {
  if (x < 0) {
    return("before")
  } else {
    return("after")
  }
}
daysWord <- function(d) {
  if (is.infinite(d)) {
    return("any time")
  } else {
    nm <- cli::cli_text("{abs(d)} day{?s}") |>
      cli::cli_fmt() |>
      paste0(collapse = " ")
    return(nm)
  }
}
windowName <- function(win) {
  min <- win[1]
  max <- win[2]
  if (min == 0 & max == 0) {
    nm <- "on index date"
  } else if (is.infinite(min) & max == 0) {
    nm <- "any time before or on index date"
  } else if (min == 0 & is.infinite(max)) {
    nm <- "any time after or on index date"
  } else if (is.infinite(min) & is.infinite(max)) {
    nm <- "any time"
  } else if (min == 0) {
    nm <- glue::glue("from index date to {daysWord(max)} after")
  } else if (max == 0) {
    nm <- glue::glue("from {daysWord(min)} before to the index date")
  } else {
    nm <- glue::glue("from {daysWord(min)} {temporalWord(min)} to {daysWord(max)} {temporalWord(max)} the index date")
  }
  return(nm)
}
formatOutput <- function(result, mutuallyExclusive, labels, extraLabs, vars, set) {
  # remove additional (we will add window_name)
  result <- result |>
    dplyr::select(!c("additional_name", "additional_level"))

  # correct group_name
  result <- set |>
    dplyr::select(group_level = "cohort_definition_id", "cohort_name") |>
    dplyr::mutate(group_level = as.character(.data$group_level)) |>
    dplyr::inner_join(
      result |>
        dplyr::mutate(group_name = "cohort_name"),
      by = "group_level"
    ) |>
    dplyr::select(!"group_level") |>
    dplyr::rename(group_level = "cohort_name")

  # get original order
  strata <- result |>
    dplyr::distinct(.data$strata_name, .data$strata_level)

  # get labels
  if (mutuallyExclusive) {
    comb <- rep(list(c(1, 0)), length(labels)) |>
      rlang::set_names(labels) |>
      do.call(what = tidyr::expand_grid) |>
      dplyr::rowwise() |>
      dplyr::mutate(xyz_n = sum(dplyr::c_across(dplyr::everything()))) |>
      dplyr::ungroup() |>
      dplyr::arrange(.data$xyz_n) |>
      dplyr::select(!"xyz_n")
    labels <- purrr::map_chr(2:nrow(comb), \(i) {
      paste0(labels[as.logical(comb[i,])], collapse = " and ")
    })
  } else {
    # separate labels individually
    result <- result |>
      dplyr::mutate(estimate_value = as.numeric(.data$estimate_value)) |>
      dplyr::mutate(variable_level = purrr::map(.data$variable_level, \(x) {
        stringr::str_split_1(x, pattern = " and ")
      })) |>
      tidyr::unnest("variable_level") |>
      dplyr::group_by(dplyr::across(!c("estimate_value"))) |>
      dplyr::summarise(
        estimate_value = as.character(sum(.data$estimate_value)),
        .groups = "drop"
      )
  }
  labels <- c(labels, extraLabs)

  # prepare all combinations that must be present
  order <- tidyr::expand_grid(
    group_level = set$cohort_name,
    strata_id = seq_len(nrow(strata)),
    variable_name = vars$variable_name,
    variable_level = labels,
    estimate_name = c("count", "percentage")
  ) |>
    dplyr::mutate(estimate_type = dplyr::if_else(
      .data$estimate_name == "count", "integer", "percentage"
    )) |>
    dplyr::inner_join(
      strata |>
        dplyr::mutate(strata_id = dplyr::row_number()),
      by = "strata_id"
    ) |>
    dplyr::select(!"strata_id") |>
    dplyr::mutate(
      result_id = 1L,
      cdm_name = unique(result$cdm_name),
      group_name = "cohort_name"
    ) |>
    dplyr::mutate("order_id" = dplyr::row_number())
  cols <- colnames(order)[!colnames(order) %in% c(
    "order_id", "additional_name", "additional_level"
  )]

  result |>
    dplyr::right_join(order, by = cols) |>
    dplyr::inner_join(
      vars |>
        omopgenerics::uniteAdditional("window_name"),
      by = "variable_name"
    ) |>
    dplyr::arrange(.data$order_id) |>
    dplyr::select(!c("order_id", "variable_name")) |>
    dplyr::rename(variable_name = "new_variable_name") |>
    dplyr::mutate(estimate_value = dplyr::coalesce(.data$estimate_value, "0"))
}
