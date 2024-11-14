test_that("test same results for ingredient cohorts", {
  skip_on_cran()
  cdm <- mockDrugUtilisation(con = connection(), writeSchema = schema())

  expect_warning(cdm <- generateAtcCohortSet(cdm = cdm, name = "test_cohort_1"))

  codes <- CodelistGenerator::getATCCodes(cdm)
  cdm <- generateDrugUtilisationCohortSet(
    cdm = cdm,
    conceptSet = codes,
    name = "test_cohort_2"
  )

  cdm <- generateAtcCohortSet(
    cdm = cdm,
    atcName = "Alimentary tract and metabolism",
    name = "test_cohort_3"
  )

  # Collect data from DuckDB tables into R data frames
  cohort_1_df <- cdm$test_cohort_1 |>
    collectCohort()
  cohort_2_df <- cdm$test_cohort_2 |>
    collectCohort()
  cohort_3_df <- cdm$test_cohort_3 |>
    collectCohort()

  expect_equal(cohort_1_df, cohort_2_df)
  expect_equal(cohort_1_df, cohort_3_df)

  mockDisconnect(cdm = cdm)
})
