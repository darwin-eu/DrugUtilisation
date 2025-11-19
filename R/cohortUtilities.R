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

conceptSetFromConceptSetList <- function(conceptSetList, cohortSet) {
  conceptSetList |>
    purrr::imap(\(x, nm) {
      cid <- cohortSet$cohort_definition_id[cohortSet$cohort_name == nm]
      dplyr::tibble(drug_concept_id = x, cohort_definition_id = cid)
    }) |>
    dplyr::bind_rows()
}

subsetTables <- function(cdm, conceptSet, name, subsetCohort, subsetCohortId) {
  # insert concepts as temporal table
  nm <- omopgenerics::uniqueTableName()
  cdm <- omopgenerics::insertTable(
    cdm = cdm, name = nm, table = conceptSet, overwrite = TRUE
  )
  cdm[[nm]] <- cdm[[nm]] |>
    dplyr::compute()
  omopgenerics::dropSourceTable(cdm = cdm, name = nm)

  # subset table
  cli::cli_inform(c("i" = "Subsetting {.pkg drug_exposure} table"))
  cohort <- cdm$drug_exposure |>
    dplyr::select(
      "drug_concept_id",
      "subject_id" = "person_id",
      "cohort_start_date" = "drug_exposure_start_date",
      "cohort_end_date" = "drug_exposure_end_date"
    )
  if (!is.null(subsetCohort)) {
    cohort <- cohort |>
      dplyr::inner_join(
        cdm[[subsetCohort]] |>
          dplyr::filter(.data$cohort_definition_id %in% .env$subsetCohortId) |>
          dplyr::distinct(.data$subject_id),
        by = "subject_id"
      )
  }
  cohort <- cohort |>
    dplyr::inner_join(cdm[[nm]], by = "drug_concept_id") |>
    dplyr::select(
      "cohort_definition_id", "subject_id", "cohort_start_date",
      "cohort_end_date"
    ) |>
    dplyr::compute(temporary = FALSE, name = name)

  # exclude records
  cli::cli_inform(c("i" = "Checking whether any record needs to be dropped."))
  n0 <- numberRecords(cohort)
  if (n0 > 0) {
    exclude <- cohort |>
      dplyr::summarise(
        na_start = sum(as.integer(is.na(.data$cohort_start_date)), na.rm = TRUE),
        na_end = sum(as.integer(is.na(.data$cohort_end_date) & !is.na(.data$cohort_start_date)), na.rm = TRUE),
        start_before_end = sum(as.integer(.data$cohort_start_date > .data$cohort_end_date), na.rm = TRUE)
      ) |>
      dplyr::collect()
    n0 <- numberRecords(cohort)
    cohort <- cohort |>
      dplyr::mutate(cohort_end_date = dplyr::coalesce(.data$cohort_end_date, .data$cohort_start_date)) |>
      dplyr::filter(!is.na(.data$cohort_start_date)) |>
      dplyr::filter(.data$cohort_start_date <= .data$cohort_end_date) |>
      dplyr::inner_join(
        cdm$observation_period |>
          dplyr::select(
            subject_id = "person_id",
            "observation_period_id",
            "observation_period_start_date",
            "observation_period_end_date"
          ),
        by = "subject_id"
      ) |>
      dplyr::filter(
        .data$cohort_start_date <= .data$observation_period_end_date,
        .data$cohort_end_date >= .data$observation_period_start_date
      ) |>
      dplyr::mutate(
        "cohort_start_date" = dplyr::if_else(
          .data$cohort_start_date < .data$observation_period_start_date,
          .data$observation_period_start_date,
          .data$cohort_start_date
        ),
        "cohort_end_date" = dplyr::if_else(
          .data$cohort_end_date > .data$observation_period_end_date,
          .data$observation_period_end_date,
          .data$cohort_end_date
        )
      ) |>
      dplyr::select(
        "cohort_definition_id", "subject_id", "cohort_start_date",
        "cohort_end_date", "observation_period_id"
      ) |>
      dplyr::compute(temporary = FALSE, name = name)
    nF <- numberRecords(cohort)
    reportDroppedRecords(n0, nF, exclude)

    # erafy
    cli::cli_inform(c("i" = "Collapsing overlaping records."))
    if (numberRecords(cohort) > 0) {
      cohort <- cohort %>%
        dplyr::mutate(
          number_exposures = 1L,
          days_prescribed = as.integer(clock::date_count_between(
            start = .data$cohort_start_date,
            end = .data$cohort_end_date,
            precision = "day"
          )) + 1L
        ) |>
        erafy(
          gap = 0L,
          toSummarise = c("number_exposures", "days_prescribed")
        )
    } else {
      cohort <- cohort |>
        dplyr::mutate(number_exposures = 0L, days_prescribed = 0L)
    }
  } else {
    cohort <- cohort |>
      dplyr::select(
        "cohort_definition_id", "subject_id", "cohort_start_date",
        "cohort_end_date"
      ) |>
      dplyr::mutate(
        observation_period_id = 0L,
        number_exposures = 0L,
        days_prescribed = 0L
      )
  }

  cohort |>
    dplyr::compute(name = name, temporary = FALSE)
}

reportDroppedRecords <- function(n0, nF, exclude) {
  mes <- character()
  if (nF < n0) {
    total <- n0 - nF
    naStart <- exclude$na_start
    startBeforeEnd <- exclude$start_before_end
    notObservation <- total - naStart - startBeforeEnd
    mes <- c(mes, "!" = "{total} record{?s} dropped:")
    if (naStart > 0) {
      mes <- c(mes, "*" = "{naStart} record{?s} dropped because drug_exposure_start_date is missing.")
    }
    if (startBeforeEnd > 0) {
      mes <- c(mes, "*" = "{startBeforeEnd} record{?s} dropped because drug_exposure_end_date < drug_exposure_start_date.")
    }
    if (notObservation > 0) {
      mes <- c(mes, "*" = "{notObservation} record{?s} dropped because {?it/they} {?is/are} not in observation.")
    }
  }
  naEnd <- exclude$na_end
  if (naEnd > 0) {
    mes <- c(mes, "!" = "{naEnd} record{?s} with missing `drug_exposure_end_date`; using `drug_exposure_start_date` as end date.")
  }
  if (length(mes) > 0) {
    cli::cli_inform(message = mes)
  }
  invisible()
}

numberRecords <- function(cohort) {
  cohort |>
    dplyr::ungroup() |>
    dplyr::tally() |>
    dplyr::pull() |>
    as.integer()
}

erafy <- function(x,
                  gap = 0,
                  start = "cohort_start_date",
                  end = "cohort_end_date",
                  group = c("cohort_definition_id", "subject_id", "observation_period_id"),
                  toSummarise = character()) {
  if (numberRecords(x) == 0) {
    return(x)
  }
  xstart <- x |>
    dplyr::select(dplyr::all_of(c(group, "date_event" = start, toSummarise))) |>
    dplyr::mutate(date_id = -1)
  newCols <- rep(0L, length(toSummarise)) |>
    as.list() |>
    rlang::set_names(nm = toSummarise)
  xend <- x |>
    dplyr::select(dplyr::all_of(c(group, "date_event" = end))) |>
    dplyr::mutate(date_id = 1, !!!newCols)
  if (gap > 0) {
    gap <- as.integer(gap)
    xend <- xend %>%
      dplyr::mutate("date_event" = as.Date(clock::add_days(
        x = .data$date_event, n = .env$gap
      )))
  }
  x <- xstart |>
    dplyr::union_all(xend) |>
    dplyr::group_by(dplyr::across(dplyr::all_of(group))) |>
    dplyr::arrange(.data$date_event, .data$date_id) |>
    dplyr::mutate(era_id = dplyr::if_else(
      cumsum(.data$date_id) == -1 & .data$date_id == -1, -1L, 0L
    )) |>
    dplyr::arrange(.data$date_event, .data$date_id, .data$era_id) |>
    dplyr::mutate(era_id = cumsum(.data$era_id)) |>
    dplyr::group_by(.data$era_id, .add = TRUE) |>
    dplyr::summarise(
      !!start := min(.data$date_event, na.rm = TRUE),
      !!end := max(.data$date_event, na.rm = TRUE),
      dplyr::across(
        dplyr::all_of(toSummarise), \(x) as.integer(sum(x, na.rm = TRUE))
      ),
      .groups = "drop"
    )
  if (gap > 0) {
    gap <- -gap
    x <- x %>%
      dplyr::mutate(!!end := as.Date(clock::add_days(
        x = .data[[end]], n = .env$gap
      )))
  }
  x <- x |>
    dplyr::select(dplyr::all_of(c(group, start, end, toSummarise)))
  return(x)
}
