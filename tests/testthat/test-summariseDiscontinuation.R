test_that("summariseDiscontinuationAsSurvival works", {
  cohort1 <- dplyr::tibble(
    cohort_definition_id = 1L,
    subject_id = 1:4,
    cohort_start_date = as.Date("2020-01-01"),
    cohort_end_date = as.Date(c(
      "2020-01-11", "2020-01-21", "2020-01-31", "2020-12-31"
    ))
  )
  observation_period <- dplyr::tibble(
    observation_period_id = 1:4,
    person_id = 1:4,
    observation_period_start_date = as.Date("2019-01-01"),
    observation_period_end_date = as.Date("2020-12-31"),
    period_type_concept_id = 0L
  )
  cdm <- mockDrugUtilisation(
    cohort1 = cohort1,
    observation_period = observation_period
  ) |>
    copyCdm()

  expect_no_error(
    result <- suppressMessages(
      cdm$cohort1 |>
        summariseDiscontinuationAsSurvival(
          followUpDays = 30, eventGap = 10, estimateGap = 10
        )
    )
  )

  expect_true(inherits(result, "summarised_result"))
  expect_identical(settings(result)$result_type, "summarise_discontinuation_as_survival")
  expect_identical(settings(result)$competing_outcome, "none")
  expect_identical(settings(result)$follow_up_days, "30")
  expect_identical(settings(result)$event_gap, "10")
  expect_identical(settings(result)$estimate_gap, "10")
  expect_true(all(unique(result$group_level) == "cohort_1"))
  expect_identical(
    sort(unique(result$variable_name)),
    sort(c(
      "Summary statistics of discontinuation_of_cohort_1 (Outcome)",
      "Gap summary of discontinuation_of_cohort_1 (Outcome)",
      "Survival probability of discontinuation_of_cohort_1 (Outcome)"
    ))
  )
  expect_identical(
    result |>
      dplyr::filter(
        grepl("Summary statistics", .data$variable_name),
        .data$estimate_name %in% c("number_records_count", "n_events_count")
      ) |>
      dplyr::pull("estimate_value"),
    c("4", "3")
  )
  expect_identical(
    result |>
      dplyr::filter(
        grepl("Gap summary", .data$variable_name),
        .data$estimate_name == "n_risk_count"
      ) |>
      dplyr::pull("estimate_value"),
    c("4", "4", "3", "2")
  )
  expect_identical(
    result |>
      dplyr::filter(
        grepl("Gap summary", .data$variable_name),
        .data$estimate_name == "n_events_count"
      ) |>
      dplyr::pull("estimate_value"),
    c("0", "1", "1", "1")
  )
  expect_identical(
    result |>
      dplyr::filter(
        grepl("Gap summary", .data$variable_name),
        .data$estimate_name == "n_censor_count"
      ) |>
      dplyr::pull("estimate_value"),
    c("0", "0", "0", "1")
  )
  expect_identical(
    result |>
      dplyr::filter(
        grepl("Survival probability", .data$variable_name),
        .data$estimate_name == "estimate"
      ) |>
      dplyr::pull("estimate_value"),
    c("1", "0.75", "0.5", "0.25")
  )

  # plot and tables
  expect_no_error(tableDiscontinuationAsSurvival(result, gapSummary = TRUE))
  expect_no_error(tableDiscontinuationAsSurvival(result, gapSummary = FALSE))
  expect_no_error(plotDiscontinuationAsSurvival(result))

  dropCreatedTables(cdm = cdm)
})

test_that("summariseDiscontinuationAsSurvival handles competing outcomes", {
  dus_cohort <- dplyr::tibble(
    cohort_definition_id = 10L,
    subject_id = 1:4,
    cohort_start_date = as.Date("2020-01-01"),
    cohort_end_date = as.Date(c(
      "2020-01-11", "2020-01-21", "2020-12-31", "2020-12-31"
    ))
  )
  attr(dus_cohort, "cohort_set") <- dplyr::tibble(
    cohort_definition_id = 10L,
    cohort_name = "my_drug"
  )
  outcome <- dplyr::tibble(
    cohort_definition_id = 20L,
    subject_id = 4L,
    cohort_start_date = as.Date("2020-12-31"),
    cohort_end_date = as.Date("2020-12-31")
  )
  attr(outcome, "cohort_set") <- dplyr::tibble(
    cohort_definition_id = 20L,
    cohort_name = "death"
  )
  observation_period <- dplyr::tibble(
    observation_period_id = 1:4L,
    person_id = 1:4L,
    observation_period_start_date = as.Date("2019-01-01"),
    observation_period_end_date = as.Date("2020-12-31"),
    period_type_concept_id = 0L
  )
  cdm <- mockDrugUtilisation(
    dus_cohort = dus_cohort,
    outcome = outcome,
    observation_period = observation_period
  ) |>
    copyCdm()

  expect_no_error(
    result <- suppressMessages(
      cdm$dus_cohort |>
        summariseDiscontinuationAsSurvival(
          cohortId = 10L,
          competingOutcomeCohortTable = "outcome",
          competingOutcomeCohortId = 20L,
          eventGap = 10,
          estimateGap = 10
        )
    )
  )

  expect_true(inherits(result, "summarised_result"))
  expect_identical(settings(result)$competing_outcome, "death")
  expect_true(all(unique(result$group_level) == "my_drug"))
  expect_true(any(result$variable_name == "Summary statistics of death (Competing outcome)"))
  eventSummary <- result |>
    dplyr::filter(
      grepl("Summary statistics", .data$variable_name),
      .data$estimate_name == "n_events_count"
    ) |>
    dplyr::select("variable_name", "estimate_value")
  expect_identical(
    eventSummary$estimate_value[grepl("Outcome", eventSummary$variable_name)],
    "2"
  )
  expect_identical(
    eventSummary$estimate_value[grepl("Competing", eventSummary$variable_name)],
    "1"
  )
  expect_identical(
    eventSummary$variable_name,
    c(
      "Summary statistics of discontinuation_of_my_drug (Outcome)",
      "Summary statistics of death (Competing outcome)"
    )
  )

  # plot and tables
  expect_no_error(tableDiscontinuationAsSurvival(result, gapSummary = TRUE))
  expect_no_error(tableDiscontinuationAsSurvival(result, gapSummary = FALSE))
  expect_no_error(plotDiscontinuationAsSurvival(result))

  dropCreatedTables(cdm = cdm)
})
