
test_that("erafyCohort", {
  myCohort <- dplyr::tibble(
    cohort_definition_id = c(1L, 1L, 1L, 2L, 2L),
    subject_id = c(1L, 1L, 2L, 3L, 3L),
    cohort_start_date = as.Date(c(
      "2020-01-01", "2020-01-11", "2020-01-01", "2020-01-01", "2020-01-21"
    )),
    cohort_end_date = as.Date(c(
      "2020-01-05", "2020-01-20", "2020-01-05", "2020-01-01", "2020-01-22"
    ))
  )
  attr(myCohort, "cohort_set") <- dplyr::tibble(
    cohort_definition_id = c(1L, 2L, 3L),
    cohort_name = c("cohort1", "cohort2", "cohort3")
  )
  cdm <- mockDrugUtilisation(
    con = connection(),
    writeSchema = schema(),
    my_cohort = myCohort
  )

  initialTables <- omopgenerics::listSourceTables(cdm)

  # gap era = 0
  expect_no_error(
    cdm$cohort1 <- cdm$my_cohort |>
      erafyCohort(gapEra = 0, name = "cohort1")
  )
  expect_identical(collectCohort(cdm$cohort1), collectCohort(cdm$my_cohort))
  expect_true(nrow(settings(cdm$cohort1)) == 3)
  expect_true(all(
    c("cohort1_0", "cohort2_0", "cohort3_0") %in%
      settings(cdm$cohort1)$cohort_name
  ))

  # gap era = 0 and 10
  expect_no_error(
    cdm$cohort1 <- cdm$my_cohort |>
      erafyCohort(gapEra = c(0, 10), name = "cohort1")
  )
  expect_true(nrow(settings(cdm$cohort1)) == 6)
  expect_true(all(c("0", "10") %in% settings(cdm$cohort1)$gap_era))

  # 5 vs 6
  expect_no_error(
    cdm$cohort1 <- cdm$my_cohort |>
      erafyCohort(gapEra = c(5, 6), name = "cohort1")
  )
  expect_true(nrow(settings(cdm$cohort1)) == 6)
  expect_true(all(c("5", "6") %in% settings(cdm$cohort1)$gap_era))
  expect_true(
    cdm$cohort1 |>
      dplyr::filter(.data$subject_id == 1L) |>
      dplyr::tally() |>
      dplyr::pull() == 3
  )
  expect_identical(
    cdm$cohort1 |>
      dplyr::filter(.data$subject_id == 1L) |>
      collectCohort() |>
      dplyr::select("cohort_start_date", "cohort_end_date") |>
      dplyr::arrange(.data$cohort_start_date, .data$cohort_end_date),
    dplyr::tibble(
      cohort_start_date = as.Date(c("2020-01-01", "2020-01-01", "2020-01-11")),
      cohort_end_date = as.Date(c("2020-01-05", "2020-01-20", "2020-01-20"))
    )
  )

  # empty cohort
  expect_no_error(
    cdm$cohort1 <- cdm$my_cohort |>
      erafyCohort(gapEra = c(0, 10), cohortId = 3, name = "cohort1")
  )

  expect_identical(omopgenerics::listSourceTables(cdm), initialTables)

})
