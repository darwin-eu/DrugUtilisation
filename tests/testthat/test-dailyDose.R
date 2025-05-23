test_that("functionality of addDailyDose function", {
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

  daily_dose <- .addDailyDose(cdm[["drug_exposure"]], ingredientConceptId = 1)

  # compute behavior
  initialTables <- CDMConnector::listSourceTables(cdm)
  expect_no_error(
    x <- cdm[["drug_exposure"]] |>
      .addDailyDose(ingredientConceptId = 1, name = "my_custom_name")
  )
  finalTables <- CDMConnector::listSourceTables(cdm)
  expect_identical(omopgenerics::tableName(x), "my_custom_name")
  expect_true("my_custom_name" %in% setdiff(finalTables, initialTables))

  patterns1 <- drugStrengthPattern(cdm = cdm, ingredientConceptId = 1)

  expect_true(
    all(c(
      "fixed amount formulation", "time based with denominator",
      "time based no denominator", "concentration formulation"
    ) %in% {
      patterns1 |>
        dplyr::pull("formula_name") |>
        unique()
    })
  )

  drugFormula <- patterns1 |>
    dplyr::filter(!is.na(.data$formula_name)) |>
    dplyr::pull("drug_concept_id")
  drugNoFormula <- patterns1 |>
    dplyr::filter(is.na(.data$formula_name)) |>
    dplyr::pull("drug_concept_id")

  expect_true(
    daily_dose |>
      dplyr::filter(.data$drug_concept_id %in% .env$drugFormula) |>
      dplyr::filter(is.na(daily_dose)) |>
      dplyr::tally() |>
      dplyr::pull() == 0
  )
  expect_true(
    daily_dose |>
      dplyr::filter(.data$drug_concept_id %in% .env$drugNoFormula) |>
      dplyr::filter(!is.na(daily_dose)) |>
      dplyr::tally() |>
      dplyr::pull() == 0
  )

  expect_true(
    daily_dose |> dplyr::tally() |> dplyr::pull("n") ==
      cdm[["drug_exposure"]] |>
        dplyr::tally() |>
        dplyr::pull("n")
  )

  expect_true(
    length(colnames(cdm[["drug_exposure"]])) + 2 == length(colnames(daily_dose))
  )

  expect_true(all(colnames(cdm[["drug_exposure"]]) %in% colnames(daily_dose)))
  expect_true(all(c("daily_dose", "unit") %in% colnames(daily_dose)))

  withPattern <- cdm[["drug_exposure"]] |>
    dplyr::left_join(
      drugStrengthPattern(
        cdm = cdm, ingredientConceptId = 1, pattern = TRUE,
        patternDetails = FALSE, unit = TRUE, formula = TRUE, ingredient = FALSE
      ),
      by = "drug_concept_id"
    ) |>
    dplyr::collect()
  expect_true(
    cdm[["drug_exposure"]] |> dplyr::tally() |> dplyr::pull() ==
      withPattern |>
        dplyr::tally() |>
        dplyr::pull()
  )

  expect_true(all(colnames(cdm[["drug_exposure"]]) %in% colnames(withPattern)))
  expect_true(all(c("formula_name", "unit") %in% colnames(withPattern)))

  x <- daily_dose |>
    dplyr::select("drug_concept_id", "daily_dose", "unit") |>
    dplyr::left_join(
      drugStrengthPattern(
        cdm = cdm, ingredientConceptId = 1, pattern = FALSE,
        patternDetails = FALSE, unit = TRUE, formula = TRUE, ingredient = FALSE
      ),
      by = "drug_concept_id"
    ) |>
    dplyr::collect()

  expect_true(all(colnames(x) %in% c(
    "drug_concept_id", "daily_dose", "unit.x", "formula_name", "unit.y"
  )))

  expect_true(all(
    x |>
      dplyr::filter(is.na(.data$unit.x)) |>
      dplyr::arrange(.data$drug_concept_id) |>
      dplyr::pull("drug_concept_id") ==
      x |>
        dplyr::filter(is.na(.data$unit.y)) |>
        dplyr::arrange(.data$drug_concept_id) |>
        dplyr::pull("drug_concept_id")
  ))

  expect_true(all(
    x |>
      dplyr::filter(!is.na(.data$unit.x)) |>
      dplyr::arrange(.data$drug_concept_id) |>
      dplyr::pull("unit.x") ==
      x |>
        dplyr::filter(!is.na(.data$unit.y)) |>
        dplyr::arrange(.data$drug_concept_id) |>
        dplyr::pull("unit.y")
  ))

  expect_true(all(
    x |>
      dplyr::filter(is.na(.data$daily_dose)) |>
      dplyr::arrange(.data$drug_concept_id) |>
      dplyr::pull("drug_concept_id") ==
      x |>
        dplyr::filter(is.na(.data$formula_name)) |>
        dplyr::arrange(.data$drug_concept_id) |>
        dplyr::pull("drug_concept_id")
  ))

  coverage <- summariseDoseCoverage(cdm, 1)
  expect_true(inherits(coverage, "summarised_result"))
  # check suppress works
  coverage_sup <- omopgenerics::suppress(coverage, minCellCount = 200)
  expect_true(all(coverage_sup$estimate_value |> unique() %in% c("0", "-")))
  coverage_sup <- omopgenerics::suppress(coverage, minCellCount = 50)
  expect_true(all(
    coverage_sup |>
      dplyr::filter(strata_level == "overall", grepl("missing", estimate_name)) |>
      dplyr::pull("estimate_value") == "-"
  ))
  expect_true(all(!is.na(
    coverage_sup |>
      dplyr::filter(strata_level == "overall", !grepl("missing", estimate_name)) |>
      dplyr::pull("estimate_value")
  )))

  # test estimates
  coverage <- summariseDoseCoverage(cdm, 1, estimates = "mean")
  expect_true(all(coverage$estimate_name |> unique() == c("count", "mean")))

  # test min records
  coverage <- summariseDoseCoverage(cdm, 1, sampleSize = 50)
  expect_true(coverage$estimate_value[1] == "50")
  expect_true(settings(coverage)$sample_size == 50)

  # check it works without specifying cdm object
  expect_no_error(.addDailyDose(cdm[["drug_exposure"]], ingredientConceptId = 1))

  mockDisconnect(cdm = cdm)

  # integer64
  skip_if_not_installed("bit64")

  set.seed(12345)
  cdm <- mockDrugUtilisation(con = connection(), writeSchema = schema())
  res1 <- summariseDoseCoverage(cdm = cdm, ingredientConceptId = 1125315, sampleSize = 4)
  mockDisconnect(cdm = cdm)

  set.seed(12345)
  cdm <- mockDrugUtilisation(con = connection(), writeSchema = schema())
  res2 <- summariseDoseCoverage(cdm = cdm, ingredientConceptId = 1125315, sampleSize = 4L)
  mockDisconnect(cdm = cdm)

  set.seed(12345)
  cdm <- mockDrugUtilisation(con = connection(), writeSchema = schema())
  res3 <- summariseDoseCoverage(cdm = cdm, ingredientConceptId = 1125315, sampleSize = bit64::as.integer64(4))
  mockDisconnect(cdm = cdm)

  expect_identical(res1, res2)
  expect_identical(res1, res3)
  expect_identical(res2, res3)
})
