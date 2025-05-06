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

test_that("plotIndication works", {
  skip_on_cran()
  targetCohortName <- dplyr::tibble(
    cohort_definition_id = c(1, 1, 1, 2),
    subject_id = c(1, 1, 2, 3),
    cohort_start_date = as.Date(c(
      "2020-01-01", "2020-06-01", "2020-01-02", "2020-01-01"
    )),
    cohort_end_date = as.Date(c(
      "2020-04-01", "2020-08-01", "2020-02-02", "2020-03-01"
    ))
  )
  indicationCohortName <- dplyr::tibble(
    cohort_definition_id = c(1, 1, 2, 1),
    subject_id = c(1, 3, 1, 1),
    cohort_start_date = as.Date(c(
      "2019-12-30", "2020-01-01", "2020-05-25", "2020-05-25"
    )),
    cohort_end_date = as.Date(c(
      "2019-12-30", "2020-01-01", "2020-05-25", "2020-05-25"
    ))
  )
  attr(indicationCohortName, "cohort_set") <- dplyr::tibble(
    cohort_definition_id = c(1, 2),
    cohort_name = c("asthma", "covid")
  )
  condition_occurrence <- dplyr::tibble(
    person_id = 1,
    condition_start_date = as.Date("2020-05-31"),
    condition_end_date = as.Date("2020-05-31"),
    condition_occurrence_id = 1,
    condition_concept_id = 0,
    condition_type_concept_id = 0
  )
  observationPeriod <- dplyr::tibble(
    observation_period_id = c(1, 2, 3),
    person_id = c(1, 2, 3),
    observation_period_start_date = as.Date(c(
      "2015-01-01", "2016-05-15", "2012-12-30"
    )),
    observation_period_end_date = as.Date("2024-01-01"),
    period_type_concept_id = 44814724
  )
  cdm <- mockDrugUtilisation(
    con = connection(),
    writeSchema = schema(),
    cohort1 = targetCohortName,
    cohort2 = indicationCohortName,
    condition_occurrence = condition_occurrence,
    observation_period = observationPeriod
  )

  result <- cdm$cohort1 |>
    summariseIndication(
      indicationCohortName = "cohort2",
      indicationWindow = list(c(0, 0), c(-7, 0), c(-30, 0), c(-Inf, 0)),
      unknownIndicationTable = "condition_occurrence"
    )

  expect_no_error(p <- plotIndication(result))

  mockDisconnect(cdm = cdm)
})

test_that("plotDrugUtilisation", {
  skip_on_cran()
  nExposures <- 10000
  nPersons <- 1000
  cdm <- mockDrugUtilisation(
    con = connection(),
    writeSchema = schema(),
    drug_exposure = dplyr::tibble(
      drug_exposure_id = seq_len(nExposures),
      person_id = sample(seq_len(nPersons), size = nExposures, replace = TRUE),
      drug_concept_id = 1125315L,
      drug_type_concept_id = 0,
      quantity = 0L
    ) |>
      dplyr::mutate(
        rand1 = runif(n = nExposures),
        rand2 = runif(n = nExposures),
        rand3 = runif(n = nExposures),
        total_rand = .data$rand1 + .data$rand2 + .data$rand3,
        drug_exposure_start_date = as.Date("2000-01-01") +
          as.integer(8788 * .data$rand1 / .data$total_rand),
        drug_exposure_end_date = as.Date("2000-01-01") +
          as.integer(8788 * (.data$rand1 + .data$rand2) / .data$total_rand)
      ) |>
      dplyr::select(!c("rand1", "rand2", "rand3", "total_rand")),
    observation_period = dplyr::tibble(
      observation_period_id = seq_len(nPersons),
      person_id = observation_period_id,
      observation_period_start_date = as.Date("2000-01-01"),
      observation_period_end_date = as.Date("2024-01-01"),
      period_type_concept_id = 0
    ),
    person = dplyr::tibble(
      person_id = seq_len(nPersons),
      gender_concept_id = sample(c(8507L, 8532L), size = nPersons, replace = TRUE),
      year_of_birth = 1990L,
      day_of_birth = 1L,
      month_of_birth = 1L,
      birth_datetime = as.Date("1990-01-01"),
      race_concept_id = 0L,
      ethnicity_concept_id = 0L,
      location_id = 0L,
      provider_id = 0L,
      care_site_id = 0L
    )
  )

  cdm <- generateDrugUtilisationCohortSet(
    cdm = cdm, name = "dus_cohort", conceptSet = list(acetaminophen = 1125315L)
  )

  result <- cdm$dus_cohort |>
    PatientProfiles::addSex(name = "dus_cohort") |>
    summariseDrugUtilisation(
      ingredientConceptId = 1125315L,
      strata = list("sex"),
      estimates = c("density", "min", "q25", "median", "q75", "max")
    )

  expect_no_error(
    p1 <- result |>
      dplyr::filter(
        .data$variable_name == "number exposures",
        .data$estimate_name == "median"
      ) |>
      plotDrugUtilisation(
        facet = . ~ concept_set,
        colour = "sex",
        plotType = "barplot"
      )
  )

  expect_no_error(
    p2 <- result |>
      dplyr::filter(
        .data$variable_name == "number exposures",
        .data$estimate_name == "median"
      ) |>
      plotDrugUtilisation(
        facet = . ~ concept_set,
        colour = "sex",
        plotType = "scatterplot"
      )
  )

  expect_no_error(
    p3 <- result |>
      dplyr::filter(.data$variable_name == "number exposures") |>
      plotDrugUtilisation(
        facet = . ~ concept_set,
        colour = "sex",
        plotType = "densityplot"
      )
  )

  expect_no_error(
    p4 <- result |>
      dplyr::filter(.data$variable_name == "number exposures") |>
      plotDrugUtilisation(
        facet = . ~ concept_set,
        colour = "sex",
        plotType = "boxplot"
      )
  )

  mockDisconnect(cdm = cdm)
})
