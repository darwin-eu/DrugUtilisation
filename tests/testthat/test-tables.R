test_that("tableIndication works", {
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

  result <- cdm[["cohort1"]] |>
    summariseIndication(
      indicationCohortName = "cohort2",
      indicationWindow = list(c(0, 0), c(-7, 0), c(-30, 0), c(-Inf, 0)),
      unknownIndicationTable = "condition_occurrence"
    )

  # default
  default <- tableIndication(result)
  expect_true("gt_tbl" %in% class(default))

  tib <- tableIndication(result, header = "variable", groupColumn = "cdm_name")

  # strata
  result <- cdm[["cohort1"]] |>
    dplyr::filter(cohort_definition_id == 1) |>
    PatientProfiles::addAge(
      ageGroup = list("<40" = c(0, 39), ">=40" = c(40, 150))
    ) |>
    PatientProfiles::addSex() |>
    summariseIndication(
      indicationCohortName = "cohort2",
      indicationWindow = list(c(0, 0), c(-7, 0), c(-30, 0), c(-Inf, 0)),
      unknownIndicationTable = "condition_occurrence",
      strata = list("age_group", "sex", c("age_group", "sex"))
    )

  fx <- tableIndication(result, type = "flextable", header = "group")
  expect_true(inherits(fx, "flextable"))

  outputFolder <- tempdir()
  omopgenerics::exportSummarisedResult(
    result, minCellCount = 0, fileName = "results.csv", path = outputFolder
  )
  results <- omopgenerics::importSummarisedResult(
    path = file.path(outputFolder, "results.csv")
  )
  fx2 <- tableIndication(results, type = "flextable", header = "group")
  expect_identical(fx, fx2)

  mockDisconnect(cdm = cdm)
})

test_that("tableDoseCoverage", {
  skip_on_cran()
  drug_strength <- dplyr::tibble(
    drug_concept_id = c(
      2905077, 1516983, 2905075, 1503327, 1516978, 1503326, 1503328, 1516980,
      29050773, 1125360, 15033297, 15030327, 15033427, 15036327, 15394662,
      43135274, 11253605, 431352774, 431359274, 112530, 1539465, 29050772,
      431352074, 15394062, 43135277, 15033327, 11253603, 15516980, 5034327,
      1539462, 15033528, 15394636, 15176980, 1539463, 431395274, 15186980,
      15316978
    ),
    ingredient_concept_id = c(rep(1, 37)),
    amount_value = c(100, 200, 300, 400, 500, 600, 700, rep(NA, 30)),
    amount_unit_concept_id = c(
      8718, 9655, 8576, 44819154, 9551, 8587, 9573, rep(NA, 30)
    ),
    numerator_value = c(
      rep(NA, 7), 1, 300, 5, 10, 13, 20, 3, 5, 2, 1, 1, 4, 11, 270, 130, 32, 34,
      40, 42, 15, 100, 105, 25, 44, 7, 3, 8, 12, 1, 31
    ),
    denominator_unit_concept_id = c(
      rep(NA, 7), 8576, 8587, 8505, 8505, 8587, 8587, 45744809, 8519, 8587, 8576,
      8576, 8587, 8576, 8587, 8576, 8587, 8587, 8505, 8587, 8576, 8587,
      45744809, 8505, 8519, 8576, 8587, 8576, 8587, 8576, 8587
    ),
    denominator_value = c(
      rep(NA, 7), 241, 30, 23, 410, 143, 2, 43, 15, 21, 1, 11, 42, 151, 20,
      rep(NA, 16)
    ),
    numerator_unit_concept_id = c(
      rep(NA, 7), 8718, 8718, 9655, 8576, 44819154, 9551, 8576, 8576, 8576, 8576,
      8587, 8587, 9573, 9573, 8718, 8718, 9439, 9655, 44819154, 9551, 9551,
      8576, 8576, 8576, 8576, 8576, 8587, 8587, 9573, 9573
    ),
    valid_start_date = as.Date("1900-01-01"),
    valid_end_date = as.Date("2100-01-01")
  )
  conceptsToAdd <- dplyr::tibble(
    concept_id = 1, concept_name = "ingredient 1", domain_id = "Drug",
    vocabulary_id = "RxNorm", concept_class_id = "Ingredient",
    standard_concept = "S"
  ) |>
    dplyr::bind_rows(
      dplyr::tibble(
        concept_id = c(
          2905077, 1516983, 2905075, 1503327, 1516978, 1503326, 1503328, 1516980,
          29050773, 1125360, 15033297, 15030327, 15033427, 15036327, 15394662,
          43135274, 11253605, 431352774, 431359274, 112530, 1539465, 29050772,
          431352074, 15394062, 43135277, 15033327, 11253603, 15516980, 5034327,
          1539462, 15033528, 15394636, 15176980, 1539463, 431395274, 15186980,
          15316978
        ), concept_name = "NA", domain_id = "Drug", vocabulary_id = "RxNorm",
        concept_class_id = "Clinical Drug", standard_concept = "S"
      ) |>
        dplyr::mutate(concept_name = paste0("drug", concept_id))
    )
  concept <- mockConcept |>
    dplyr::anti_join(conceptsToAdd, by = "concept_id") |>
    dplyr::bind_rows(conceptsToAdd)
  concept_ancestor <- mockConceptAncestor |>
    dplyr::bind_rows(dplyr::tibble(
      ancestor_concept_id = 1,
      descendant_concept_id = conceptsToAdd$concept_id,
      min_levels_of_separation = 0,
      max_levels_of_separation = 0
    ))

  concept_relationship <- dplyr::tibble(
    concept_id_1 = c(
      2905077, 1516983, 2905075, 1503327, 1516978, 1503326, 1503328, 1516980,
      29050773, 1125360, 15033297, 15030327, 15033427, 15036327, 15394662,
      43135274, 11253605, 431352774, 431359274, 112530, 1539465, 29050772,
      431352074, 15394062, 43135277, 15033327, 11253603, 15516980, 5034327,
      1539462, 15033528, 15394636, 15176980, 1539463, 431395274, 15186980,
      15316978
    ),
    concept_id_2 = c(
      19016586, 46275062, 35894935, 19135843, 19082107, 19011932, 19082108,
      2008660, 2008661, 2008662, 19082109, 43126087, 19130307, 42629089,
      19103220, 19082048, 19082049, 19082256, 19082050, 19082071, 19082072,
      19135438, 19135446, 19135439, 19135440, 46234466, 19082653, 19057400,
      19082227, 19082286, 19009068, 19082628, 19082224, 19095972, 19095973,
      35604394, 702776
    ),
    relationship_id = c(rep("RxNorm has dose form", 37)),
    valid_start_date = as.Date("1900-01-01"),
    valid_end_date = as.Date("2100-01-01")
  )

  cdm <- mockDrugUtilisation(
    con = connection(),
    writeSchema = schema(),
    seed = 11,
    drug_strength = drug_strength,
    concept = concept,
    numberIndividuals = 50,
    concept_ancestor = concept_ancestor,
    concept_relationship = concept_relationship
  )

  coverage <- summariseDoseCoverage(cdm, 1)

  # default
  default <- tableDoseCoverage(coverage)
  expect_true(inherits(default, "gt_tbl"))

  # other options working
  fx1 <- tableDoseCoverage(coverage, header = c("cdm_name", "ingredient_name"), groupColumn = "variable_name", type = "flextable")
  expect_true(inherits(fx1, "flextable"))

  expect_no_error(gt1 <- tableDoseCoverage(coverage))

  outputFolder <- tempdir()
  omopgenerics::exportSummarisedResult(
    coverage, minCellCount = 0, fileName = "results.csv", path = outputFolder
  )
  results <- omopgenerics::importSummarisedResult(
    path = file.path(outputFolder, "results.csv")
  )
  expect_no_error(gt2 <- tableDoseCoverage(results))
  expect_identical(gt1, gt2)

  mockDisconnect(cdm = cdm)
})

test_that("tableDrugUtilisation", {
  skip_on_cran()
  cdm <- mockDrugUtilisation(
    con = connection(),
    writeSchema = schema(),
    drug_exposure = dplyr::tibble(
      drug_exposure_id = 1:12,
      person_id = c(1, 1, 1, 2, 2, 3, 3, 1, 2, 4, 4, 1),
      drug_concept_id = c(
        1125360, 2905077, 1125360, 1125360, 1125315, 1125360, 1125360, 1503327,
        1503328, 1503297, 1503297, 1125360
      ),
      drug_exposure_start_date = as.Date(c(
        "2020-01-15", "2020-01-20", "2020-02-20", "2021-02-15", "2021-05-12",
        "2022-01-12", "2022-11-15", "2020-01-01", "2021-03-11", "2010-01-01",
        "2010-03-15", "2023-01-01"
      )),
      drug_exposure_end_date = as.Date(c(
        "2020-01-25", "2020-03-15", "2020-02-28", "2021-03-15", "2021-05-25",
        "2022-02-15", "2022-12-14", "2020-04-13", "2021-04-20", "2010-01-05",
        "2010-05-12", "2023-12-31"
      )),
      drug_type_concept_id = 0,
      quantity = c(10, 20, 30, 1, 10, 5, 15, 20, 30, 14, 10, 2)
    ),
    dus_cohort = dplyr::tibble(
      cohort_definition_id = c(1, 2, 1, 1, 1, 2),
      subject_id = c(1, 1, 2, 3, 4, 4),
      cohort_start_date = as.Date(c(
        "2020-01-15", "2020-01-24", "2021-01-15", "2022-02-01", "2010-01-05",
        "2010-01-05"
      )),
      cohort_end_date = as.Date(c(
        "2020-02-28", "2020-02-10", "2021-06-08", "2022-12-01", "2010-03-15",
        "2010-03-15"
      )),
      extra_column = "asd"
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

  result <- cdm$dus_cohort |>
    PatientProfiles::addSex(name = "dus_cohort") |>
    summariseDrugUtilisation(ingredientConceptId = c(1125315, 1539403, 1503297, 1516976), strata = list("sex"))

  # default
  expect_no_error(default <- tableDrugUtilisation(result))
  expect_true(inherits(default, "gt_tbl"))
  expect_true("gt_tbl" %in% class(default))

  outputFolder <- tempdir()
  omopgenerics::exportSummarisedResult(
    result, minCellCount = 0, fileName = "results.csv", path = outputFolder
  )
  results <- omopgenerics::importSummarisedResult(
    path = file.path(outputFolder, "results.csv")
  )
  expect_no_error(default2 <- tableDrugUtilisation(results))
  expect_identical(default, default2)

  mockDisconnect(cdm = cdm)
})

test_that("tableDrugRestart", {
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
        "2010-03-15", "2023-01-01"
      )),
      drug_exposure_end_date = as.Date(c(
        "2020-01-25", "2020-03-15", "2020-02-28", "2021-03-15", "2021-05-25",
        "2022-02-15", "2022-12-14", "2020-04-13", "2021-04-20", "2010-01-05",
        "2010-05-12", "2023-12-31"
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

  expect_no_error(gt1 <- tableDrugRestart(results))
  expect_true(inherits(gt1, "gt_tbl"))

  outputFolder <- tempdir()
  omopgenerics::exportSummarisedResult(
    results, minCellCount = 0, fileName = "results.csv", path = outputFolder
  )
  result <- omopgenerics::importSummarisedResult(
    path = file.path(outputFolder, "results.csv")
  )
  expect_no_error(gt2 <- tableDrugRestart(result))
  expect_identical(gt1, gt2)

  mockDisconnect(cdm = cdm)
})

test_that("tableProportionOfPatientsCovered works", {
  skip_on_cran()

  cdm <- mockDrugUtilisation(
    con = connection(),
    writeSchema = schema(),
    dus_cohort = dplyr::tibble(
      cohort_definition_id = 1,
      subject_id = c(1, 1, 2, 3, 4),
      cohort_start_date = as.Date(c("2000-01-01", "2000-01-10", "2002-01-01", "2010-01-01", "2011-01-01")),
      cohort_end_date = as.Date(c("2000-01-05", "2000-01-15", "2002-01-15", "2010-01-20", "2011-01-20"))
    ),
    observation_period = dplyr::tibble(
      observation_period_id = 1:4,
      person_id = 1:4,
      observation_period_start_date = as.Date(c("2000-01-01", "2002-01-01", "2010-01-01", "2011-01-01")),
      observation_period_end_date = as.Date(c("2000-01-25", "2002-01-15", "2010-01-25", "2011-01-25")),
      period_type_concept_id = 0
    )
  )
  cdm$dus_cohort <- cdm$dus_cohort |>
    dplyr::mutate(
      var0 = "group",
      var1 = dplyr::if_else(subject_id == 1, "group_1", "group_2"),
      var2 = dplyr::if_else(subject_id %in% c(1, 2), "group_a", "group_b")
    )

  ppc <- cdm$dus_cohort |>
    summariseProportionOfPatientsCovered(
      followUpDays = 30,
      strata = c("var1", "var2")
    )
  # without times specified
  expect_no_error(tab <- tableProportionOfPatientsCovered(ppc))
  expect_true(inherits(tab, "gt_tbl"))

  # with times specified
  ppc |>
    omopgenerics::filterAdditional(.data$time %in% c("0", "5", "10", "15")) |>
    tableProportionOfPatientsCovered() |>
    expect_no_error()

  # after suppression
  ppc_suppressed <- omopgenerics::suppress(ppc, 4)
  expect_no_error(tb1 <- tableProportionOfPatientsCovered(ppc_suppressed))

  outputFolder <- tempdir()
  omopgenerics::exportSummarisedResult(
    ppc_suppressed, minCellCount = 0, fileName = "results.csv", path = outputFolder
  )
  result <- omopgenerics::importSummarisedResult(
    path = file.path(outputFolder, "results.csv")
  )
  expect_no_error(tb2 <- tableProportionOfPatientsCovered(result))
  expect_identical(tb1, tb2)

  mockDisconnect(cdm = cdm)
})

test_that("tableTreatment", {
  skip_on_cran()
  cdm <- mockDrugUtilisation(con = connection(), writeSchema = schema(), seed = 1)
  result <- cdm$cohort1 |>
    summariseTreatment(
      treatmentCohortName = "cohort2", window = list(c(0, 30), c(31, 365))
    )

  expect_no_error(x <- tableTreatment(result))

  outputFolder <- tempdir()
  omopgenerics::exportSummarisedResult(
    result, minCellCount = 0, fileName = "results.csv", path = outputFolder
  )
  results <- omopgenerics::importSummarisedResult(
    path = file.path(outputFolder, "results.csv")
  )
  expect_no_error(x2 <- tableTreatment(results))
  expect_identical(x, x2)

  omopgenerics::cdmDisconnect(cdm = cdm)
})
