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

#' Summarise the drug restart per window.
#'
#' `r lifecycle::badge("experimental")`
#'
#' @inheritParams cohortDoc
#' @inheritParams cohortIdDoc
#' @param switchCohortTable A cohort table in the cdm that contains possible
#' alternative treatments.
#' @param switchCohortId The cohort ids to be used from switchCohortTable. If
#' NULL all cohort definition ids are used.
#' @inheritParams strataDoc
#' @param followUpDays A vector of number of days to follow up. It can be
#' multiple values.
#' @param restrictToFirstDiscontinuation Whether to consider only the first
#' discontinuation episode or all of them.
#' @inheritParams censorDateDoc
#' @param incident Whether the switch treatment has to be incident (start after
#' discontinuation) or not (it can start before the discontinuation and last
#' till after).
#'
#' @return A summarised_result object with the percentages of restart, switch
#' and not exposed per window.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#'
#' cdm <- mockDrugUtilisation()
#'
#' conceptlist <- list("a" = 1125360, "b" = c(1503297, 1503327))
#' cdm <- generateDrugUtilisationCohortSet(
#'   cdm = cdm,
#'   name = "switch_cohort",
#'   conceptSet = conceptlist
#' )
#'
#' result <- cdm$cohort1 |>
#'   summariseDrugRestart(switchCohortTable = "switch_cohort")
#'
#' tableDrugRestart(result)
#'
#' CDMConnector::cdmDisconnect(cdm = cdm)
#' }
summariseDrugRestart <- function(cohort,
                                 cohortId = NULL,
                                 switchCohortTable,
                                 switchCohortId = NULL,
                                 strata = list(),
                                 followUpDays = Inf,
                                 censorDate = NULL,
                                 incident = TRUE,
                                 restrictToFirstDiscontinuation = TRUE) {
  # check input
  cdm <- omopgenerics::cdmReference(cohort)
  cohort <- validateCohort(cohort)
  cohortId <- omopgenerics::validateCohortIdArgument({{cohortId}}, cohort)
  strata <- validateStrata(strata, cohort)
  omopgenerics::assertClass(cohort, class = "cohort_table")
  omopgenerics::assertLogical(restrictToFirstDiscontinuation, length = 1)
  omopgenerics::assertCharacter(censorDate, length = 1, null = TRUE)
  omopgenerics::assertNumeric(followUpDays, integerish = TRUE, min = 0)
  omopgenerics::assertLogical(incident, length = 1)
  omopgenerics::assertCharacter(switchCohortTable, length = 1)
  cdm[[switchCohortTable]] <- cdm[[switchCohortTable]] |>
    validateCohort()
  switchCohortId <- omopgenerics::validateCohortIdArgument({{switchCohortId}}, cdm[[switchCohortTable]])

  cohortTableName <- omopgenerics::tableName(cohort)
  cohortTableName[is.na(cohortTableName)] <- "temp"

  tmpName <- omopgenerics::uniqueTableName(omopgenerics::tmpPrefix())

  ns <- "drug_restart_in_{follow_up_days}_days"
  cohort <- cohort |>
    dplyr::filter(.data$cohort_definition_id %in% .env$cohortId) |>
    # add drug restart info
    .addDrugRestart(
      switchCohortTable = switchCohortTable,
      switchCohortId = switchCohortId,
      followUpDays = followUpDays,
      censorDate = censorDate,
      incident = incident,
      nameStyle = ns,
      name = tmpName
    )

  # restrict to first
  if (restrictToFirstDiscontinuation) {
    cohort <- cohort |>
      dplyr::filter(
        .data$cohort_start_date == min(.data$cohort_start_date, na.rm = TRUE),
        .by = c("cohort_definition_id", "subject_id")
      )
  }

  # remove cohort entries ending before censor date and throw warning saying how many
  if (!is.null(censorDate)) {
    nBefore <- numberRecords(cohort)
    cohort <- cohort |>
      dplyr::filter(.data[[censorDate]] > .data$cohort_end_date)
    nAfter <- numberRecords(cohort)
    if (nBefore > nAfter) {
      cli::cli_warn(c(
        "!" = "{nBefore-nAfter} record{?s} dropped because cohort_end_date <= {censorDate} (censorDate)."
      ))
    }
  }

  # variables to summarise
  variables <- tolower(as.character(glue::glue(ns, follow_up_days = followUpDays)))

  # summarise data
  result <- cohort |>
    # add cohort names
    PatientProfiles::addCohortName() |>
    dplyr::compute(name = tmpName, temporary = FALSE) |>
    PatientProfiles::summariseResult(
      group = list("cohort_name"),
      includeOverallGroup = FALSE,
      strata = strata,
      includeOverallStrata = TRUE,
      variables = variables,
      estimates = c("count", "percentage"),
      counts = FALSE
    ) |>
    suppressMessages()

  if (nrow(result) == 0) {
    strataOpt <- dplyr::tibble(strata_name = "overall", strata_level = "overall")
  } else {
    strataOpt <- result |>
      dplyr::distinct(.data$strata_name, .data$strata_level)
  }

  # populate zeros
  categories <- omopgenerics::settings(cohort) |>
    dplyr::filter(.data$cohort_definition_id %in% .env$cohortId) |>
    dplyr::select("cohort_name") |>
    omopgenerics::uniteGroup(cols = "cohort_name") |>
    dplyr::cross_join(strataOpt) |>
    dplyr::cross_join(tidyr::expand_grid(
      variable_name = variables,
      variable_level = c("restart", "switch", "restart and switch", "untreated")
    )) |>
    dplyr::cross_join(dplyr::tibble(
      estimate_name = c("count", "percentage"),
      estimate_type = c("integer", "percentage"),
    )) |>
    omopgenerics::uniteAdditional() |>
    dplyr::mutate(
      result_id = 1L,
      cdm_name = omopgenerics::cdmName(cdm),
      order_id = dplyr::row_number()
    )
  cols <- colnames(categories)[colnames(categories) != "order_id"]
  result <- categories |>
    dplyr::full_join(result, by = cols) |>
    # correct cdm_name
    dplyr::select(-"cdm_name") |>
    PatientProfiles::addCdmName(cdm = cdm) |>
    # add followUpDays
    dplyr::mutate(
      follow_up_days = .data$variable_name |>
        stringr::str_replace("drug_restart_in_", "") |>
        stringr::str_replace("_", " ")
    ) |>
    dplyr::select(!c("additional_name", "additional_level")) |>
    omopgenerics::uniteAdditional(cols = "follow_up_days") |>
    # correct variable_name
    dplyr::mutate(
      variable_name = dplyr::if_else(
        .data$variable_name == "drug_restart_in_inf_days",
        "Drug restart till end of observation",
        stringr::str_to_sentence(stringr::str_replace_all(.data$variable_name, "_", " "))
      )
    ) |>
    dplyr::mutate(estimate_value = dplyr::coalesce(.data$estimate_value, "0")) |>
    dplyr::arrange(.data$order_id) |>
    dplyr::select(!"order_id")

  # summarised result
  if (is.null(censorDate)) {
    censorDate <- "NA"
  }
  censorDate <- as.character(censorDate)
  censorDate[is.na(censorDate)] <- "NA"

  result <- result |>
    omopgenerics::newSummarisedResult(
      settings = dplyr::tibble(
        result_id = 1L,
        result_type = "summarise_drug_restart",
        package_name = "DrugUtilisation",
        package_version = pkgVersion(),
        cohort_table_name = cohortTableName,
        switch_cohort_table = switchCohortTable,
        incident = as.character(incident),
        restrict_to_first_discontinuation = as.character(restrictToFirstDiscontinuation),
        censor_date = as.character(censorDate %||% "NA")
      )
    )

  omopgenerics::dropTable(cdm = cdm, name = tmpName)

  return(result)
}

#' Summarise the drug restart per window.
#'
#' `r lifecycle::badge("experimental")`
#'
#' @inheritParams cohortDoc
#' @param switchCohortTable A cohort table in the cdm that contains possible
#' alternative treatments.
#' @param switchCohortId The cohort ids to be used from switchCohortTable. If
#' NULL all cohort definition ids are used.
#' @param followUpDays A vector of number of days to follow up. It can be
#' multiple values.
#' @inheritParams censorDateDoc
#' @param incident Whether the switch treatment has to be incident (start after
#' discontinuation) or not (it can start before the discontinuation and last
#' till after).
#' @inheritParams nameStyleDoc
#'
#' @return A summarised_result object with the percentages of restart, switch
#' and not exposed per window.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#'
#' cdm <- mockDrugUtilisation()
#'
#' conceptlist <- list("a" = 1125360, "b" = c(1503297, 1503327))
#' cdm <- generateDrugUtilisationCohortSet(
#'   cdm = cdm,
#'   name = "switch_cohort",
#'   conceptSet = conceptlist
#' )
#'
#' cdm$cohort1 |>
#'   addDrugRestart(switchCohortTable = "switch_cohort")
#'
#' CDMConnector::cdmDisconnect(cdm = cdm)
#' }
addDrugRestart <- function(cohort,
                           switchCohortTable,
                           switchCohortId = NULL,
                           followUpDays = Inf,
                           censorDate = NULL,
                           incident = TRUE,
                           nameStyle = "drug_restart_{follow_up_days}") {
  # check inputs
  cohort <- validateCohort(cohort)
  omopgenerics::assertCharacter(switchCohortTable, length = 1)
  cdm <- omopgenerics::cdmReference(cohort)
  cdm[[switchCohortTable]] <- cdm[[switchCohortTable]] |>
    validateCohort()
  switchCohortId <- omopgenerics::validateCohortIdArgument(
    {{switchCohortId}}, cdm[[switchCohortTable]])
  omopgenerics::assertNumeric(followUpDays, integerish = TRUE, min = 0, unique = TRUE)
  omopgenerics::assertCharacter(censorDate, length = 1, null = TRUE)
  omopgenerics::assertLogical(incident, length = 1)
  omopgenerics::assertCharacter(nameStyle, length = 1)
  if (length(followUpDays) > 1 & !grepl("{follow_up_days}", nameStyle, fixed = TRUE)) {
    cli::cli_abort("{{follow_up_days}} must be part of the nameStyle as multiple values of followUpDays are provided.")
  }

  cohort |>
    .addDrugRestart(
      switchCohortTable = switchCohortTable,
      switchCohortId = switchCohortId,
      followUpDays = followUpDays,
      censorDate = censorDate,
      incident = incident,
      nameStyle = nameStyle,
      name = NA_character_
    )
}

.addDrugRestart <- function(cohort,
                            switchCohortTable,
                            switchCohortId,
                            followUpDays,
                            censorDate,
                            incident,
                            nameStyle,
                            name) {
  prefix <- omopgenerics::tmpPrefix()

  join <- c("cohort_definition_id", "subject_id", "cohort_end_date", censorDate)

  x <- cohort |>
    dplyr::distinct(dplyr::across(dplyr::any_of(join))) |>
    dplyr::compute(name = omopgenerics::uniqueTableName(prefix), temporary = FALSE) |>
    # censor days
    addCensorDays(censorDate, prefix) |>
    # restart days
    addRestartDays(cohort, prefix) |>
    # switch days
    addSwitchDays(switchCohortTable, switchCohortId, incident, prefix) |>
    # add restart flags
    addRestartFlags(followUpDays, nameStyle) |>
    dplyr::select(!dplyr::all_of(c("censor_days", "restart_days", "switch_days"))) |>
    dplyr::compute(name = omopgenerics::uniqueTableName(prefix), temporary = FALSE)

  cohort <- cohort |>
    dplyr::left_join(
      x, by = c("cohort_definition_id", "subject_id", "cohort_end_date")
    )

  if (is.na(name)) {
    cohort <- cohort |>
      dplyr::compute()
  } else {
    cohort <- cohort |>
      dplyr::compute(name = name, temporary = FALSE)
  }

  # drop tables
  cdm <- cohort |>
    omopgenerics::cdmReference() |>
    omopgenerics::dropSourceTable(name = dplyr::starts_with(prefix))

  return(cohort)
}

addCensorDays <- function(x, censorDate, prefix) {
  if (is.null(censorDate)) {
    id <- "censor_days"
  } else {
    id <- omopgenerics::uniqueId(exclude = colnames(x))
  }
  x <- x |>
    PatientProfiles::addFutureObservationQuery(
      indexDate = "cohort_end_date",
      futureObservationName = id
    )
  if (!is.null(censorDate)) {
    x <- x %>%
      dplyr::mutate(censor_days = as.integer(!!CDMConnector::datediff(
        start = "cohort_end_date", end = censorDate
      ))) |>
      dplyr::mutate(censor_days = dplyr::case_when(
        is.na(.data$censor_days) ~ .data[[id]],
        .data[[id]] <= .data$censor_days ~ .data[[id]],
        .default = .data$censor_days
      ))
  }
  x <- x |>
    dplyr::distinct(dplyr::across(dplyr::all_of(c(
      "cohort_definition_id", "subject_id", "cohort_end_date", "censor_days"
    )))) |>
    dplyr::compute(
      name = omopgenerics::uniqueTableName(prefix), temporary = FALSE
    )
  return(x)
}
addRestartDays <- function(x, cohort, prefix) {
  x |>
    dplyr::left_join(
      x |>
        dplyr::distinct(dplyr::across(dplyr::all_of(c(
          "cohort_definition_id", "subject_id", "cohort_end_date"
        )))) |>
        dplyr::inner_join(
          cohort |>
            dplyr::distinct(dplyr::across(dplyr::all_of(c(
              "cohort_definition_id", "subject_id", "cohort_start_date"
            )))),
          by = c("cohort_definition_id", "subject_id")
        ) |>
        dplyr::filter(.data$cohort_start_date > .data$cohort_end_date) |>
        dplyr::group_by(
          .data$cohort_definition_id, .data$subject_id, .data$cohort_end_date
        ) |>
        dplyr::summarise(
          cohort_start_date = min(.data$cohort_start_date, na.rm = TRUE),
          .group = "drop"
        ) %>%
        dplyr::mutate(restart_days = as.integer(!!CDMConnector::datediff(
          "cohort_end_date", "cohort_start_date"
        ))) |>
        dplyr::select(
          "cohort_definition_id", "subject_id", "cohort_end_date",
          "restart_days"
        ),
      by = c("cohort_definition_id", "subject_id", "cohort_end_date")
    )  |>
    dplyr::mutate(restart_days = dplyr::if_else(
      .data$restart_days > .data$censor_days, NA_integer_, .data$restart_days
    )) |>
    dplyr::compute(name = omopgenerics::uniqueTableName(prefix), temporary = FALSE)
}
addSwitchDays <- function(x, switchCohortTable, switchCohortId, incident, prefix) {
  cdm <- omopgenerics::cdmReference(x)
  tmpName <- omopgenerics::uniqueTableName(prefix)
  tab <- cdm[[switchCohortTable]] |>
    dplyr::filter(.data$cohort_definition_id %in% .env$switchCohortId) |>
    dplyr::distinct(dplyr::across(dplyr::all_of(c(
      "subject_id",
      "switch_start" = "cohort_start_date",
      "switch_end" = "cohort_end_date"
    )))) |>
    dplyr::inner_join(
      x |>
        dplyr::distinct(.data$subject_id, .data$cohort_end_date),
      by = "subject_id"
    )
  if (incident) {
    tab <- tab |>
      dplyr::filter(.data$cohort_end_date <= .data$switch_end &
                      .data$cohort_end_date <= .data$switch_start)
  } else {
    tab <- tab |>
      dplyr::filter(.data$cohort_end_date <= .data$switch_end)
  }
  tab <- tab |>
    dplyr::group_by(.data$subject_id, .data$cohort_end_date) |>
    dplyr::summarise(
      switch_start = min(.data$switch_start, na.rm = TRUE), .group = "drop"
    ) %>%
    dplyr::mutate(switch_days = as.integer(!!CDMConnector::datediff(
      start = "cohort_end_date", end = "switch_start"
    ))) |>
    dplyr::select("subject_id", "cohort_end_date", "switch_days")
  x |>
    dplyr::left_join(tab, by = c("subject_id", "cohort_end_date")) |>
    dplyr::mutate(switch_days = dplyr::if_else(
      .data$switch_days > .data$censor_days, NA_integer_, .data$switch_days
    )) |>
    dplyr::compute(name = tmpName, temporary = FALSE)
}
addRestartFlags <- function(x, followUpDays, nameStyle) {
  follow_up_days <- followUpDays
  followUpDays[is.infinite(followUpDays)] <- 99999999999999
  variables <- tolower(as.character(glue::glue(nameStyle)))
  q <- glue::glue(
    "dplyr::case_when(",
    ".data$restart_days <= {followUpDays} & .data$switch_days <= {followUpDays} ~ 'restart and switch', ",
    ".data$restart_days <= {followUpDays} ~ 'restart', ",
    ".data$switch_days <= {followUpDays} ~ 'switch', ",
    ".default = 'untreated')"
  ) |>
    rlang::parse_exprs() |>
    rlang::set_names(variables)
  x |>
    dplyr::mutate(!!!q)
}
