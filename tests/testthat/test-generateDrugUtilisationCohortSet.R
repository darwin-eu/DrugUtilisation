test_that("test inputs", {
  skip_on_cran()
  cdm <- mockDrugUtilisation() |>
    copyCdm()

  expect_error(generateDrugUtilisationCohortSet())
  expect_error(generateDrugUtilisationCohortSet(cdm = cdm))
  expect_error(generateDrugUtilisationCohortSet(cdm, "dus", 1))
  expect_error(generateDrugUtilisationCohortSet(cdm, "dus", list(1)))
  expect_no_error(generateDrugUtilisationCohortSet(cdm, "dus", list(acetaminophen = 1)))
  cdmNew <- generateDrugUtilisationCohortSet(cdm, "dus", list(acetaminophen = 1125360))
  expect_true("cohort_table" %in% class(cdmNew$dus))
  expect_true(all(c(
    "cohort_definition_id", "subject_id", "cohort_start_date", "cohort_end_date"
  ) %in% colnames(cdmNew$dus)))
  expect_true(length(colnames(cdmNew$dus)) == 4)
  expect_error(generateDrugUtilisationCohortSet(
    cdm, "dus", list(acetaminophen = 1125360),
    gapEra = "7"
  ))

  dropCreatedTables(cdm = cdm)
})

test_that("basic functionality drug_conceptId", {
  skip_on_cran()
  cdm <- mockDrugUtilisation(
    drug_exposure = dplyr::tibble(
      drug_exposure_id = 1:4,
      person_id = c(1, 1, 1, 1),
      drug_concept_id = sample(c(1125360, 2905077, 43135274), 4, replace = T),
      drug_exposure_start_date = as.Date(
        c("2020-04-01", "2020-06-01", "2021-02-12", "2021-03-01"), "%Y-%m-%d"
      ),
      drug_exposure_end_date = as.Date(
        c("2020-04-30", "2020-09-11", "2021-02-15", "2021-03-24"), "%Y-%m-%d"
      ),
      drug_type_concept_id = 38000177,
      quantity = 1
    )
  ) |>
    copyCdm()

  acetaminophen <- list(acetaminophen = c(1125360, 2905077, 43135274))

  # check gap
  cdm <- generateDrugUtilisationCohortSet(
    cdm = cdm, name = "dus", conceptSet = acetaminophen, gapEra = 0
  )
  expect_identical(cohortGapEra(cdm$dus), 0L)
  expect_identical(cohortGapEra(cdm$cohort1), NULL)
  expect_true(cdm$dus |> dplyr::tally() |> dplyr::pull() == 4)
  cdm <- generateDrugUtilisationCohortSet(
    cdm, "dus", acetaminophen,
    gapEra = 13
  )
  expect_true(cdm$dus |> dplyr::tally() |> dplyr::pull() == 4)
  cdm <- generateDrugUtilisationCohortSet(
    cdm, "dus", acetaminophen,
    gapEra = 14
  )
  expect_true(cdm$dus |> dplyr::tally() |> dplyr::pull() == 3)
  cdm <- generateDrugUtilisationCohortSet(
    cdm, "dus", acetaminophen,
    gapEra = 31
  )
  expect_true(cdm$dus |> dplyr::tally() |> dplyr::pull() == 3)
  cdm <- generateDrugUtilisationCohortSet(
    cdm, "dus", acetaminophen,
    gapEra = 32
  )
  expect_true(cdm$dus |> dplyr::tally() |> dplyr::pull() == 2)
  cdm <- generateDrugUtilisationCohortSet(
    cdm, "dus", acetaminophen,
    gapEra = 153
  )
  expect_true(cdm$dus |> dplyr::tally() |> dplyr::pull() == 2)
  cdm <- generateDrugUtilisationCohortSet(
    cdm, "dus", acetaminophen,
    gapEra = 154
  )
  expect_true(cdm$dus |> dplyr::tally() |> dplyr::pull() == 1)
  cdm <- generateDrugUtilisationCohortSet(
    cdm, "dus", acetaminophen,
    gapEra = 1500
  )
  expect_true(cdm$dus |> dplyr::tally() |> dplyr::pull() == 1)

  # check cdm reference in attributes
  expect_true(!is.null(omopgenerics::cdmReference(cdm$dus)))

  dropCreatedTables(cdm = cdm)
})

test_that("cohort attrition", {
  skip_on_cran()
  # create mock
  cdm <- mockDrugUtilisation(
    drug_exposure = dplyr::tibble(
      drug_exposure_id = 1:10L,
      person_id = c(rep(1L, 9), 2L),
      drug_concept_id = 1125360L,
      drug_exposure_start_date = as.Date(c(
        "2020-01-01", "2020-04-01", "2021-01-01", "2020-01-01", "2020-01-02",
        "2020-12-01", "2020-10-01", "2020-07-01", "2021-04-01", "2021-03-01"), "%Y-%m-%d"
      ),
      drug_exposure_end_date = as.Date(c(
        "2020-04-30", "2020-04-11", "2021-02-15", NA_character_, NA_character_,
        "2020-01-01", "2020-02-01", "2020-03-01", "2021-04-24", "2021-03-24"), "%Y-%m-%d"
      ),
      drug_type_concept_id = 38000177,
      quantity = 1
    ),
    observation_period = dplyr::tibble(
      observation_period_id = c(1L, 2L),
      person_id = c(1L, 2L),
      observation_period_start_date = as.Date("2010-01-01"),
      observation_period_end_date = as.Date(c("2021-03-01", "2022-01-01")),
      period_type_concept_id = 44814724L
    )
  ) |>
    copyCdm()

  # capture messages
  res <- capture.output(
    cdm <- generateDrugUtilisationCohortSet(
      cdm = cdm, name = "my_cohort", conceptSet = list(acetaminophen = 1125360L)
    ),
    type = "message"
  )

  # check that missing end dates are dropped
  expect_true(any(grepl(
    "2 records with missing `drug_exposure_end_date`; using `drug_exposure_start_date` as end date.",
    res
  )))

  # check that end before start dates are dropped
  expect_true(any(grepl(
    "3 records dropped because drug_exposure_end_date < drug_exposure_start_date.",
    res
  )))

  # check that not in observation start dates are dropped
  expect_true(any(grepl(
    "1 record dropped because it is not in observation.",
    res
  )))

  # number exposures and days prescribed
  cdm <- generateDrugUtilisationCohortSet(
    cdm = cdm,
    name = "cohort1",
    conceptSet = list(acetaminophen = 1125360L),
    numberExposures = TRUE,
    daysPrescribed = TRUE
  )
  expect_identical(
    colnames(cdm$cohort1),
    c(omopgenerics::cohortColumns("cohort"), "number_exposures", "days_prescribed")
  )
  cdm <- generateDrugUtilisationCohortSet(
    cdm = cdm,
    name = "cohort2",
    conceptSet = list(acetaminophen = 1125360L),
    numberExposures = TRUE,
    daysPrescribed = FALSE
  )
  expect_identical(
    colnames(cdm$cohort2),
    c(omopgenerics::cohortColumns("cohort"), "number_exposures")
  )
  cdm <- generateDrugUtilisationCohortSet(
    cdm = cdm,
    name = "cohort3",
    conceptSet = list(acetaminophen = 1125360L),
    numberExposures = FALSE,
    daysPrescribed = TRUE
  )
  expect_identical(
    colnames(cdm$cohort3),
    c(omopgenerics::cohortColumns("cohort"), "days_prescribed")
  )
  cdm <- generateDrugUtilisationCohortSet(
    cdm = cdm,
    name = "cohort4",
    conceptSet = list(acetaminophen = 1125360L),
    numberExposures = FALSE,
    daysPrescribed = FALSE
  )
  expect_identical(
    colnames(cdm$cohort4),
    omopgenerics::cohortColumns("cohort")
  )

  cohort1 <- collectCohort(cdm$cohort1)
  cohort2 <- collectCohort(cdm$cohort2)
  cohort3 <- collectCohort(cdm$cohort3)

  # values are always the same
  expect_identical(cohort1$number_exposures, cohort2$number_exposures)
  expect_identical(cohort1$days_prescribed, cohort3$days_prescribed)

  # expected values
  expect_identical(cohort1$number_exposures, c(4L, 1L, 1L))
  expect_identical(cohort1$days_prescribed, c(134L, 46L, 24L))

  dropCreatedTables(cdm = cdm)
})

test_that("subsetCohort functionality", {
  skip_on_cran()
  cdm <- mockDrugUtilisation(
    drug_exposure = dplyr::tibble(
      drug_exposure_id = 1:5L,
      person_id = c(1L, 2L, 3L, 4L, 1L),
      drug_concept_id = 1125360L,
      drug_exposure_start_date = as.Date(c(rep("2020-01-01", 4), "2021-01-01")),
      drug_exposure_end_date = as.Date(c(rep("2020-01-31", 4), "2021-01-20")),
      drug_type_concept_id = 38000177,
      quantity = 1
    ),
    cohort_1 = dplyr::tibble(
      cohort_definition_id = c(1L, 1L, 2L, 2L, 2L),
      subject_id = c(1L, 2L, 2L, 3L, 2L),
      cohort_start_date = as.Date(c(rep("2020-01-01", 4), "2021-01-01")),
      cohort_end_date = cohort_start_date
    )
  ) |>
    copyCdm()

  acetaminophen <- list(acetaminophen = c(1125360, 2905077, 43135274))

  # subset all cohort
  cdm <- generateDrugUtilisationCohortSet(
    cdm = cdm, name = "dus0", conceptSet = acetaminophen, gapEra = 0,
    subsetCohort = "cohort_1"
  )
  expect_true(all(c(1, 2, 3) %in% (cdm$dus0 |> dplyr::pull("subject_id"))))
  expect_false(all(c(4) %in% (cdm$dus0 |> dplyr::pull("subject_id"))))
  expect_true(cohortCount(cdm$dus0)$number_records == 4)
  expect_true(cohortCount(cdm$dus0)$number_subjects == 3)

  # subset only one cohort
  cdm <- generateDrugUtilisationCohortSet(
    cdm = cdm, name = "dus1", conceptSet = acetaminophen, gapEra = 0,
    subsetCohort = "cohort_1", subsetCohortId = 1L
  )
  expect_true(all(c(1, 2) %in% (cdm$dus1 |> dplyr::pull("subject_id"))))
  expect_false(all(c(3, 4) %in% (cdm$dus1 |> dplyr::pull("subject_id"))))
  expect_true(cohortCount(cdm$dus1)$number_records == 3)
  expect_true(cohortCount(cdm$dus1)$number_subjects == 2)

  dropCreatedTables(cdm = cdm)
})
