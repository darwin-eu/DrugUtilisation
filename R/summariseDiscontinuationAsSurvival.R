
#' Summarise discontinuation as a survival analysis
#'
#' `summariseDiscontinuationAsSurvival()` analyses discontinuation as a survival analysis
#' using the [CohortSurvival](https://darwin-eu.github.io/CohortSurvival/)
#' package. The function assumes that each cohort entry is a continuous
#' treatment era. Discontinuation will be assessed as a survival analysis with
#' index date: *start of the drug treatment era* (`cohort_start_date`) and event
#' of interest: *end of the drug treatment era* (`cohort_end_date`). The analysis
#' will use `estimateSingleEventSurvival()` or `estimateCompetingRiskSurvival()`
#' depending if `competingOutcomeCohortTable` is provided or not.
#'
#' @inheritParams cohortDoc
#' @inheritParams cohortIdDoc
#' @param followUpDays Number of days to follow up individuals (lower bound 1,
#' upper bound Inf).
#' @param censorDate if not NULL, an individual's follow up will be censored at
#' the given date.
#' @inheritParams strataDoc
#' @param competingOutcomeCohortTable The competing outcome cohort table of
#' interest.
#' @param competingOutcomeCohortId Competing outcome cohorts to include. It can
#' either be a cohort_definition_id value or a cohort_name. Multiple ids are
#' allowed.
#' @param eventGap Days between time points for which to report survival events,
#' which are grouped into the specified intervals.
#' @param estimateGap Days between time points for which to report survival
#' estimates. First day will be day zero with risk estimates provided for times
#' up to the end of follow-up, with a gap in days equivalent to eventGap.
#'
#' @returns A `<summarised_result>` object that contains the probability to not
#' discontinue over time and the summary statistics. Use
#' `tableDiscontinuationAsSurvival()` and `plotDiscontinuationAsSurvival()` to visualise the
#' results.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#'
#' cdm <- mockDrugUtilisation()
#'
#' result <- summariseDiscontinuationAsSurvival(cdm$cohort1)
#'
#' plotDiscontinuationAsSurvival(result)
#'
#' tableDiscontinuationAsSurvival(result)
#' }
#'
summariseDiscontinuationAsSurvival <- function(cohort,
                                     cohortId = NULL,
                                     followUpDays = Inf,
                                     censorDate = NULL,
                                     strata = list(),
                                     competingOutcomeCohortTable = NULL,
                                     competingOutcomeCohortId = NULL,
                                     eventGap = 30,
                                     estimateGap = 1) {
  rlang::check_installed("CohortSurvival")

  # input check
  cohort <- omopgenerics::validateCohortArgument(cohort)
  cohortId <- omopgenerics::validateCohortIdArgument({{cohortId}}, cohort)
  omopgenerics::assertNumeric(followUpDays, integerish = TRUE, length = 1, min = 0)
  if (!is.null(censorDate)) {
    omopgenerics::validateColumn(censorDate, cohort)
  }
  strata <- omopgenerics::validateStrataArgument(strata, cohort)
  omopgenerics::assertNumeric(eventGap, integerish = TRUE, length = 1, min = 0)
  omopgenerics::assertNumeric(estimateGap, integerish = TRUE, length = 1, min = 0)
  cdm <- omopgenerics::cdmReference(cohort)
  if (!is.null(competingOutcomeCohortTable)) {
    omopgenerics::validateCohortArgument(cdm[[competingOutcomeCohortTable]])
    competingOutcomeCohortId <- omopgenerics::validateCohortIdArgument({{competingOutcomeCohortId}}, cdm[[competingOutcomeCohortTable]])
    competingOutcomeNames <- omopgenerics::settings(cdm[[competingOutcomeCohortTable]]) |>
      dplyr::filter(.data$cohort_definition_id %in% .env$competingOutcomeCohortId) |>
      dplyr::pull("cohort_name")
  } else {
    competingOutcomeNames <- "none"
  }

  # cohorts
  set <- omopgenerics::settings(x = cohort)

  nm1 <- omopgenerics::uniqueTableName()
  nm2 <- omopgenerics::uniqueTableName()
  # calculate discontinuation as survival
  result <- cohortId |>
    purrr::map(\(id) {
      ts <- Sys.time()
      cohortName <- set$cohort_name[set$cohort_definition_id == id]
      cli::cli_inform(c(i = "Calculating discontinuation for {.pkg {cohortName}}."))

      # subset to cohort of interest
      cli::cli_inform(c(i = "Subsetting table to cohort of interest."))
      cdm[[nm1]] <- CohortConstructor::subsetCohorts(cohort = cohort, cohortId = id, name = nm1)

      # create discontinuation cohort
      cli::cli_inform(c(i = "Preparing discontinuation (outcome) cohort."))
      discontinuationCohort <- paste0("discontinuation_of_", cohortName)
      endFollowUp <- omopgenerics::uniqueId(exclude = colnames(cohort))
      cdm[[nm2]] <- cdm[[nm1]] |>
        PatientProfiles::addFutureObservation(
          futureObservationName = endFollowUp,
          futureObservationType = "date",
          name = nm2
        ) |>
        dplyr::filter(.data$cohort_end_date != .data[[endFollowUp]]) |>
        dplyr::mutate(cohort_start_date = .data$cohort_end_date) |>
        dplyr::compute(name = nm2) |>
        omopgenerics::newCohortTable(cohortSetRef = dplyr::tibble(
          cohort_definition_id = id,
          cohort_name = discontinuationCohort
        ))

      # check competing risks
      if (is.null(competingOutcomeCohortTable)) {
        cli::cli_inform(c(i = "Estimate single event survival for cohort: {.pkg {cohortName}} and outcome: {.pkg {discontinuationCohort}}."))
        result <- CohortSurvival::estimateSingleEventSurvival(
          cdm = cdm,
          targetCohortTable = nm1,
          targetCohortId = id,
          outcomeCohortTable = nm2,
          outcomeCohortId = id,
          censorOnCohortExit = FALSE,
          outcomeDateVariable = "cohort_start_date",
          censorOnDate = censorDate,
          followUpDays = followUpDays,
          strata = strata,
          eventGap = eventGap,
          estimateGap = estimateGap
        )
      } else {
        cli::cli_inform(c(i = "Estimate single event survival for cohort: {.pkg {cohortName}}, outcome: {.pkg {discontinuationCohort}} and competing outcome: {.pkg {competingOutcomeNames}}."))
        result <- CohortSurvival::estimateCompetingRiskSurvival(
          cdm = cdm,
          targetCohortTable = nm1,
          targetCohortId = id,
          outcomeCohortTable = nm2,
          outcomeCohortId = id,
          competingOutcomeCohortTable = competingOutcomeCohortTable,
          competingOutcomeCohortId = competingOutcomeCohortId,
          censorOnCohortExit = FALSE,
          outcomeDateVariable = "cohort_start_date",
          censorOnDate = censorDate,
          followUpDays = followUpDays,
          strata = strata,
          eventGap = eventGap,
          estimateGap = estimateGap
        )
      }

      # set
      newSet <- dplyr::tibble(
        result_id = seq_along(competingOutcomeNames),
        cohort_survival_version = as.character(utils::packageVersion("CohortSurvival")),
        package_name = "DrugUtilisation",
        package_version = pkgVersion(),
        result_type = "summarise_discontinuation_as_survival",
        competing_outcome = competingOutcomeNames,
        event_gap = as.character(eventGap),
        estimate_gap = as.character(estimateGap),
        follow_up_days = as.character(followUpDays),
      )

      if (nrow(result) == 0) {
        return(omopgenerics::emptySummarisedResult(settings = newSet))
      }

      # format results
      result <- dplyr::bind_rows(
        result |>
          omopgenerics::filterSettings(.data$result_type == "survival_summary") |>
          omopgenerics::addSettings(settingsColumn = "competing_outcome") |>
          dplyr::select(!c("additional_level", "additional_name", "result_id")) |>
          dplyr::mutate(
            variable_name = paste0(
              "Summary statistics of ", .data$variable_level, dplyr::if_else(
                .data$variable_level == .env$discontinuationCohort,
                " (Outcome)",
                " (Competing outcome)"
              )
            ),
            variable_level = NA_character_
          ),
        result |>
          omopgenerics::filterSettings(.data$result_type == "survival_events") |>
          omopgenerics::addSettings(settingsColumn = "competing_outcome") |>
          dplyr::mutate(
            variable_name = paste0(
              "Gap summary of ", .data$variable_level, dplyr::if_else(
                .data$variable_level == .env$discontinuationCohort,
                " (Outcome)",
                " (Competing outcome)"
              )
            ),
            variable_level = .data$additional_level
          ) |>
          dplyr::select(!c("additional_level", "additional_name", "result_id")),
        result |>
          omopgenerics::filterSettings(.data$result_type == "survival_estimates") |>
          omopgenerics::addSettings(settingsColumn = "competing_outcome") |>
          dplyr::mutate(
            variable_name = paste0(
              "Survival probability of ", .data$variable_level, dplyr::if_else(
                .data$variable_level == .env$discontinuationCohort,
                " (Outcome)",
                " (Competing outcome)"
              )
            ),
            variable_level = .data$additional_level
          ) |>
          dplyr::select(!c("additional_level", "additional_name", "result_id"))
      ) |>
        dplyr::mutate(
          group_name = "cohort_name",
          additional_name = "overall",
          additional_level = "overall",
          estimate_type = dplyr::if_else(grepl("count", .data$estimate_name), "integer", .data$estimate_type)
        ) |>
        dplyr::inner_join(
          newSet |>
            dplyr::select("result_id", "competing_outcome"),
          by = "competing_outcome"
        ) |>
        dplyr::select(!"competing_outcome")

      # merge
      result <- omopgenerics::newSummarisedResult(x = result, settings = newSet)

      elap <- floor(difftime(time1 = Sys.time(), time2 = ts, units = "secs"))
      cli::cli_inform(c(v = "Discontinuation analysis for {.pkg {cohortName}} completed in {elap}s."))

      return(result)
    }) |>
    omopgenerics::bind()

  # drop tables
  omopgenerics::dropSourceTable(cdm = cdm, name = c(nm1, nm2))

  return(result)
}
