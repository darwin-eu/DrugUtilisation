test_that("plotDrugRestart works", {
  skip_on_cran()
  cdm <- mockDrugUtilisation(
    con = connection(),
    writeSchema = schema(),
    drug_exposure = dplyr::tibble(
      drug_exposure_id = 1:12,
      person_id = c(1, 1, 1, 2, 2, 2, 1, 1, 2, 4, 4, 1),
      drug_concept_id = c(
        1125360, 2905077, 1125360, 1125360, 1125315, 1125360, 1125360, 1503327,
        1503328, 1503297, 1503297, 1125360
      ),
      drug_exposure_start_date = as.Date(c(
        "2020-01-15", "2020-01-20", "2020-02-20", "2021-02-15", "2021-05-12",
        "2022-01-12", "2022-11-15", "2020-01-01", "2021-03-11", "2010-01-01",
        "2010-03-15", "2025-01-01"
      )),
      drug_exposure_end_date = as.Date(c(
        "2020-01-25", "2020-03-15", "2020-02-28", "2021-03-15", "2021-05-25",
        "2022-02-15", "2022-12-14", "2020-04-13", "2021-04-20", "2010-01-05",
        "2010-05-12", "2025-12-31"
      )),
      drug_type_concept_id = 0,
      quantity = c(10, 20, 30, 1, 10, 5, 15, 20, 30, 14, 10, 2)
    ),
    dus_cohort = dplyr::tibble(
      cohort_definition_id = c(1, 1, 1, 1, 1, 2, 2, 2, 2),
      subject_id = c(1, 1, 2, 3, 4, 4, 1, 2, 3),
      cohort_start_date = as.Date(c(
        "2020-01-15", "2020-03-24", "2021-01-15", "2022-02-01", "2010-01-05",
        "2010-03-16", "2022-02-01", "2010-01-05", "2010-01-05"
      )),
      cohort_end_date = as.Date(c(
        "2020-02-28", "2020-05-10", "2021-06-08", "2022-12-01", "2010-03-15",
        "2010-03-30", "2023-02-01", "2010-05-05", "2010-01-05"
      )),
      censor_column = as.Date(c(
        "2021-02-28", "2021-05-10", "2022-06-08", "2023-12-01", "2010-05-15",
        "2011-03-30", "2022-02-01", "2011-05-06", "2010-03-05"
      ))
    ),
    observation_period = dplyr::tibble(
      observation_period_id = 1:4,
      person_id = 1:4,
      observation_period_start_date = as.Date("2000-01-01"),
      observation_period_end_date = as.Date("2024-01-01"),
      period_type_concept_id = 0
    ),
    person = dplyr::tibble(
      person_id = c(1, 2, 3, 4) |> as.integer(),
      gender_concept_id = c(8507, 8507, 8532, 8532) |> as.integer(),
      year_of_birth = c(2000, 2000, 1988, 1964) |> as.integer(),
      day_of_birth = c(1, 1, 24, 13) |> as.integer(),
      month_of_birth = 1L,
      birth_datetime = as.Date(c(
        "2004-05-22", "2003-11-26", "1988-01-24", "1964-01-13"
      )),
      race_concept_id = 0L,
      ethnicity_concept_id = 0L,
      location_id = 0L,
      provider_id = 0L,
      care_site_id = 0L
    )
  )

  conceptlist <- list("a" = 1125360, "b" = c(1503297, 1503327), "c" = 1503328)
  cdm <- generateDrugUtilisationCohortSet(cdm = cdm, name = "switch_cohort", conceptSet = conceptlist)
  results <- cdm$dus_cohort |>
    PatientProfiles::addDemographics(
      ageGroup = list(c(0, 50), c(51, 100)), name = "dus_cohort"
    ) |>
    summariseDrugRestart(
      switchCohortTable = "switch_cohort", followUpDays = c(100, 300, Inf),
      strata = list("age_group", "sex", c("age_group", "sex"))
    )

  # default
  default <- plotDrugRestart(results)
  expect_true(ggplot2::is.ggplot(default))
  expect_true(all(c(
    "cdm_name", "cohort_name", "age_group", "sex", "percentage",
    "variable_level"
  ) %in% colnames(default$data)))

  # other combinations
  gg1 <- plotDrugRestart(results)
  expect_true(ggplot2::is.ggplot(gg1))

  mockDisconnect(cdm = cdm)
})
