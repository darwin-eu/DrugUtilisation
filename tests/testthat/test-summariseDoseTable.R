# THE FOLLOWONG ERRORS MUST BE IMPROVED TO PROVIDE MORE ACCURATE INFORMATION
test_that("expected errors on inputs", {
  # intantiate 2 cdm, cdm1 with different types of variables, cdm2 with only
  # numeric variables
  cdm1 <- mockDrugUtilisation(person = dplyr::tibble(
    cohort_definition_id = c(1, 1, 1, 2),
    subject_id = c(1, 1, 2, 1),
    cohort_start_date = as.Date(c(
      "2020-01-01", "2020-05-01", "2020-04-08", "2020-01-01"
    )),
    cohort_end_date = as.Date(c(
      "2020-01-10", "2020-06-01", "2020-07-18", "2020-01-11"
    )),
    number_x = c(1, 2, 3, 6),
    carcola = c(5, 6, 9, 7),
    piscina = c(TRUE, FALSE, TRUE, FALSE),
    cara = c("a", "b", "b", "a")
  ))
  cdm2 <- mockDrugUtilisation(person = dplyr::tibble(
    cohort_definition_id = c(1, 1, 1, 2),
    subject_id = c(1, 1, 2, 1),
    cohort_start_date = as.Date(c(
      "2020-01-01", "2020-05-01", "2020-04-08", "2020-01-01"
    )),
    cohort_end_date = as.Date(c(
      "2020-01-10", "2020-06-01", "2020-07-18", "2020-01-11"
    )),
    number_x = c(1, 2, 3, 6),
    carcola = c(5, 6, 9, 7)
  ))
  # no inputs
  expect_error(result <- summariseDoseTable())
  # only cdm
  expect_error(result <- summariseDoseTable(
    cdm = cdm1,
  ))
  # only cdm & doseCohortName with non numeric should fail
  expect_error(result <- summariseDoseTable(
    cdm = cdm1, doseCohortName = "person"
  ))
  # only cdm & doseCohortName works with only numeric
  result <- summariseDoseTable(
    cdm = cdm2, doseCohortName = "person"
  )
  expect_equal(summariseDoseTable(
    cdm = cdm2, doseCohortName = "person"
  ), summariseDoseTable(
    cdm = cdm1, doseCohortName = "person", variables = c("number_x", "carcola")
  ))
  # expect error if cdm is not a cdm_ref
  expect_error(summariseDoseTable(
    cdm = 1, doseCohortName = "person", variables = c("number_x", "carcola")
  ))
  # expect error if doseCohortName is not a character
  expect_error(summariseDoseTable(
    cdm = cdm, doseCohortName = 1, variables = c("number_x", "carcola")
  ))
  # expect error if doseCohortName is a vector
  expect_error(summariseDoseTable(
    cdm = cdm, doseCohortName = c("person", "person"), variables = c("number_x", "carcola")
  ))
  # expect error if aggegationCohortName is not a character
  expect_error(summariseDoseTable(
    cdm = cdm, doseCohortName = "x", variables = c("number_x", "carcola")
  ))
  # expect error if aggegationCohortName is a vector
  # expect error if aggegationCohortName does not contains the required fields
  # expect error if cohortId is not numeric
  # expect error if variable is not character
  # expect error if variable contains a non numeric variable
  # expect error if variable contains not present variable
  # expect error if estimate is not character
  # expect error if estimate contains a non standard function
  # expect error if minimumCellCount is not numeric
  # expect error if minimumCellCount is negative
  # expect error if minimumCellCount is a vector
})

test_that("check output format", {
  cdm <- mockDrugUtilisation(person = dplyr::tibble(
    cohort_definition_id = c(1, 1, 1, 2),
    subject_id = c(1, 1, 2, 1),
    cohort_start_date = as.Date(c(
      "2020-01-01", "2020-05-01", "2020-04-08", "2020-01-01"
    )),
    cohort_end_date = as.Date(c(
      "2020-01-10", "2020-06-01", "2020-07-18", "2020-01-11"
    )),
    number_x = c(1, 2, 3, 6),
    carcola = c(5, 6, 9, 7),
    piscina = c(TRUE, FALSE, TRUE, FALSE),
    cara = c("a", "b", "b", "a")
  ))
  result <- summariseDoseTable(
    cdm = cdm, doseCohortName = "person", variables = c("number_x", "carcola")
  )
  expect_true(all(c("tbl_df", "tbl", "data.frame") %in% class(result)))
  expect_true(length(result) == 4)
  expect_true(all(colnames(result) %in% c(
    "cohort_definition_id", "variable", "estimate", "value"
  )))
})

test_that("check all estimates", {
  all_estimates <- c(
    "min", "max", "mean", "median", "iqr", "range", "q5", "q10", "q15", "q20",
    "q25", "q30", "q35", "q40", "q45", "q55", "q60", "q65", "q70",
    "q75", "q80", "q85", "q90", "q95", "std"
  )
  cdm <- mockDrugUtilisation(person = dplyr::tibble(
    cohort_definition_id = c(1, 1, 1, 2),
    subject_id = c(1, 1, 2, 1),
    cohort_start_date = as.Date(c(
      "2020-01-01", "2020-05-01", "2020-04-08", "2020-01-01"
    )),
    cohort_end_date = as.Date(c(
      "2020-01-10", "2020-06-01", "2020-07-18", "2020-01-11"
    )),
    number_x = c(1, 2, 3, 6),
    carcola = c(5, 6, 9, 7),
    piscina = c(TRUE, FALSE, TRUE, FALSE),
    cara = c("a", "b", "b", "a")
  ))
  for (k in 1:length(all_estimates)) {
    expect_no_error(res <- summariseDoseTable(
      cdm = cdm, doseCohortName = "person", cohortId = 1,
      variables = c("number_x", "carcola"), estimates = all_estimates[k]
    ))
    expect_true(nrow(res[res$variable == c("number_x"), ]) == 1)
    expect_true(res$estimate[res$variable == c("number_x")] == all_estimates[k])
    expect_true(nrow(res[res$variable == c("carcola"), ]) == 1)
    expect_true(res$estimate[res$variable == c("carcola")] == all_estimates[k])
  }
  expect_no_error(result <- summariseDoseTable(
    cdm = cdm, doseCohortName = "person",
    variables = c("number_x", "carcola"), estimates = all_estimates
  ))
})

test_that("check all estimates", {
  cdm <- mockDrugUtilisation(
    person = dplyr::tibble(
      subject_id = c(1, 1, 2, 1),
      cohort_start_date = as.Date(c(
        "2020-01-01", "2020-05-01", "2020-04-08", "2020-01-01"
      )),
      cohort_end_date = as.Date(c(
        "2020-01-10", "2020-06-01", "2020-07-18", "2020-01-11"
      )),
      number_x = c(1, 2, 3, 6),
      carcola = c(5, 6, 9, 7)
    ),
    condition_occurrence = dplyr::tibble(
      cohort_definition_id = c(1, 3),
      subject_id = c(1, 1),
      cohort_start_date = as.Date(c("2020-01-01", "2020-01-01")),
      cohort_end_date = as.Date(c("2020-01-10", "2020-01-11"))
    )
  )
  # dose does not contain cohort_definition_id
  # N dose N aggregation N cohort --> error
  expect_error(summariseDoseTable(
    cdm = cdm
  ))
  # N dose N aggregation Y cohort --> error
  expect_error(summariseDoseTable(
    cdm = cdm,
    cohortId = 1
  ))
  # N dose Y aggregation N cohort --> error
  expect_error(summariseDoseTable(
    cdm = cdm,
    aggegationCohortName = "condition_occurrence"
  ))
  # N dose Y aggregation Y cohort --> error
  expect_error(summariseDoseTable(
    cdm = cdm,
    aggegationCohortName = "condition_occurrence",
    cohortId = 1
  ))
  # Y dose N aggregation N cohort --> okay
  expect_no_error(summariseDoseTable(
    cdm = cdm,
    doseCohortName = "person"
  ))
  # Y dose N aggregation Y cohort --> warning
  expect_warning(summariseDoseTable(
    cdm = cdm,
    doseCohortName = "person",
    cohortId = 2
  ))
  # Y dose Y aggregation N cohort --> okay
  expect_no_error(summariseDoseTable(
    cdm = cdm,
    doseCohortName = "person",
    aggegationCohortName = "condition_occurrence"
  ))
  # Y dose Y aggregation Y cohort --> okay
  expect_no_error(summariseDoseTable(
    cdm = cdm,
    doseCohortName = "person",
    aggegationCohortName = "condition_occurrence",
    cohortId = 1
  ))
  # dose does contains cohort_definition_id
  cdm <- mockDrugUtilisation(
    person = dplyr::tibble(
      cohort_definition_id = c(1, 2, 1, 3),
      subject_id = c(1, 1, 2, 1),
      cohort_start_date = as.Date(c(
        "2020-01-01", "2020-05-01", "2020-04-08", "2020-01-01"
      )),
      cohort_end_date = as.Date(c(
        "2020-01-10", "2020-06-01", "2020-07-18", "2020-01-11"
      )),
      number_x = c(1, 2, 3, 6),
      carcola = c(5, 6, 9, 7)
    ),
    condition_occurrence = dplyr::tibble(
      cohort_definition_id = c(1, 3),
      subject_id = c(1, 1),
      cohort_start_date = as.Date(c("2020-01-01", "2020-01-01")),
      cohort_end_date = as.Date(c("2020-01-10", "2020-01-11"))
    )
  )
  # N dose N aggregation N cohort --> error
  expect_error(summariseDoseTable(
    cdm = cdm
  ))
  # N dose N aggregation Y cohort --> error
  expect_error(summariseDoseTable(
    cdm = cdm,
    cohortId = 1
  ))
  # N dose Y aggregation N cohort --> error
  expect_error(summariseDoseTable(
    cdm = cdm,
    aggegationCohortName = "condition_occurrence"
  ))
  # N dose Y aggregation Y cohort --> error
  expect_error(summariseDoseTable(
    cdm = cdm,
    aggegationCohortName = "condition_occurrence",
    cohortId = 1
  ))
  # Y dose N aggregation N cohort --> okay
  expect_no_error(summariseDoseTable(
    cdm = cdm,
    doseCohortName = "person"
  ))
  # Y dose N aggregation Y cohort --> okay
  expect_no_error(summariseDoseTable(
    cdm = cdm,
    doseCohortName = "person",
    cohortId = 2
  ))
  # Y dose Y aggregation N cohort --> warning
  expect_warning(summariseDoseTable(
    cdm = cdm,
    doseCohortName = "person",
    aggegationCohortName = "condition_occurrence"
  ))
  # Y dose Y aggregation Y cohort --> warning
  expect_warning(summariseDoseTable(
    cdm = cdm,
    doseCohortName = "person",
    aggegationCohortName = "condition_occurrence",
    cohortId = 1
  ))
})

test_that("check obscure counts", {
  cdm1 <- mockDrugUtilisation(person = dplyr::tibble(
    cohort_definition_id = c(1, 1, 1, 2),
    subject_id = c(1, 1, 2, 1),
    cohort_start_date = as.Date(c(
      "2020-01-01", "2020-05-01", "2020-04-08", "2020-01-01"
    )),
    cohort_end_date = as.Date(c(
      "2020-01-10", "2020-06-01", "2020-07-18", "2020-01-11"
    )),
    number_x = c(1, 2, 3, 6),
    carcola = c(5, 6, 9, 7),
    piscina = c(TRUE, FALSE, TRUE, FALSE),
    cara = c("a", "b", "b", "a")
  ))
  # expect obscure for cohort_id = 1 when minimumCellCounts >= 4
  expect_true(
    summariseDoseTable(
      cdm = cdm1, doseCohortName = "person", cohortId = 1,
      variables = c("number_x", "carcola"), minimumCellCounts = 3
    ) %>%
      dplyr::filter(is.na(.data$value)) %>%
      dplyr::tally() %>%
      dplyr::pull() == 0
  )
  expect_true(
    summariseDoseTable(
      cdm = cdm1, doseCohortName = "person", cohortId = 1,
      variables = c("number_x", "carcola"), minimumCellCounts = 4
    ) %>%
      dplyr::filter(is.na(.data$value)) %>%
      dplyr::tally() %>%
      dplyr::pull() == 20 # 20 because all variables should be obscured
  )
  # expect obscure for cohort_id = 2 when minimumCellCounts >= 2
  expect_true(
    summariseDoseTable(
      cdm = cdm1, doseCohortName = "person", cohortId = 2,
      variables = c("number_x", "carcola"), minimumCellCounts = 1
    ) %>%
      dplyr::filter(is.na(.data$value)) %>%
      dplyr::tally() %>%
      dplyr::pull() == 2 # 2 because std of a variable of length 1 is always NA
  )
  expect_true(
    summariseDoseTable(
      cdm = cdm1, doseCohortName = "person", cohortId = 2,
      variables = c("number_x", "carcola"), minimumCellCounts = 2
    ) %>%
      dplyr::filter(is.na(.data$value)) %>%
      dplyr::tally() %>%
      dplyr::pull() == 20 # 20 because all variables should be obscured
  )
  # if minimumCellCount is 1 no obscure, if it is 2 or 3 only cohort 1 is
  # obscured. If it is 4 both cohorts are obscured
  expect_true(
    summariseDoseTable(
      cdm = cdm1, doseCohortName = "person", variables = c("number_x", "carcola"),
      minimumCellCounts = 1
    ) %>%
      dplyr::filter(is.na(.data$value)) %>%
      dplyr::tally() %>%
      dplyr::pull() == 2 # 2 because std of a variable of length 1 is always NA
  )
  expect_true(
    summariseDoseTable(
      cdm = cdm1, doseCohortName = "person", variables = c("number_x", "carcola"),
      minimumCellCounts = 2
    ) %>%
      dplyr::filter(is.na(.data$value)) %>%
      dplyr::tally() %>%
      dplyr::pull() == 20 # 20 because all variables in cohort 2 are obscured
  )
  expect_true(
    summariseDoseTable(
      cdm = cdm1, doseCohortName = "person", variables = c("number_x", "carcola"),
      minimumCellCounts = 3
    ) %>%
      dplyr::filter(is.na(.data$value)) %>%
      dplyr::tally() %>%
      dplyr::pull() == 20 # 20 because all variables in cohort 2 are obscured
  )
  expect_true(
    summariseDoseTable(
      cdm = cdm1, doseCohortName = "person", variables = c("number_x", "carcola"),
      minimumCellCounts = 4
    ) %>%
      dplyr::filter(is.na(.data$value)) %>%
      dplyr::tally() %>%
      dplyr::pull() == 40 # 40 because all variables are obscured
  )
})