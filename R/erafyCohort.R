
#' Erafy a cohort_table collapsing records separated gapEra days or less.
#'
#' @inheritParams cohortDoc
#' @inheritParams gapEraDoc
#' @inheritParams cohortIdDoc
#' @param nameStyle String to create the new names of cohorts. Must contain
#' '\{cohort_name\}' if more than one cohort is present and '\{gap_era\}' if more
#' than one gapEra is provided.
#' @inheritParams newNameDoc
#'
#' @return A cohort_table object.
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#'
#' cdm <- mockDrugUtilisation()
#'
#' cdm$cohort2 <- cdm$cohort1 |>
#'   erafyCohort(gapEra = 30, name = "cohort2")
#'
#' cdm$cohort2
#'
#' settings(cdm$cohort2)
#'
#' mockDisconnect(cdm)
#' }
erafyCohort <- function(cohort,
                        gapEra,
                        cohortId = NULL,
                        nameStyle = "{cohort_name}_{gap_era}",
                        name = omopgenerics::tableName(cohort)) {
  # initial checks
  cohort <- validateCohort(cohort, dropExtraColumns = TRUE)
  omopgenerics::assertNumeric(gapEra, integerish = TRUE, min = 0)
  cohortId <- omopgenerics::validateCohortIdArgument({{cohortId}}, cohort)
  name <- omopgenerics::validateNameArgument(name, null = TRUE, call = call, validation = "warning")
  omopgenerics::assertCharacter(nameStyle, length = 1)
  if (!grepl("{cohort_name}", nameStyle, fixed = TRUE) & length(cohortId) > 1) {
    cli::cli_abort("`{{cohort_name}}` must be part of nameStyle.")
  }
  if (!grepl("{gap_era}", nameStyle, fixed = TRUE) & length(gapEra) > 1) {
    cli::cli_abort("`{{gap_era}}` must be part of nameStyle.")
  }

  prefix <- omopgenerics::tmpPrefix()

  # not erafied cohorts
  name1 <- omopgenerics::uniqueTableName(prefix)
  notCohortId <- omopgenerics::settings(cohort) |>
    dplyr::pull("cohort_definition_id") |>
    purrr::keep(\(x) !x %in% cohortId)
  notToErafy <- cohortSubset(cohort, notCohortId, name1)

  # erafied cohorts
  name2 <- omopgenerics::uniqueTableName(prefix)
  toErafy <- cohortSubset(cohort, cohortId, name2) |>
    PatientProfiles::addObservationPeriodId(name = name2)

  erafied <- purrr::map(gapEra, \(x) {
    if (x > 0) {
      res <- erafy(toErafy, x)
    } else {
      res <- toErafy
    }
    res |>
      dplyr::select(!"observation_period_id") |>
      dplyr::compute(
        name = omopgenerics::uniqueTableName(prefix), temporary = FALSE
      ) |>
      omopgenerics::recordCohortAttrition(glue::glue(
        "Collapse records separated by {x} or less days"
      )) |>
      omopgenerics::newCohortTable(
        cohortSetRef = omopgenerics::settings(toErafy) |>
          dplyr::mutate(gap_era = as.character(x)) |>
          dplyr::mutate(cohort_name = glue::glue(nameStyle))
      )
  })

  # bind all together
  cdm <- omopgenerics::bind(c(erafied, list(notToErafy, name = name)))

  # delete legacy tables
  cdm <- omopgenerics::dropSourceTable(
    cdm = cdm, name = dplyr::starts_with(prefix)
  )

  return(cdm[[name]])
}
cohortSubset <- function(cohort, cohortId, name) {
  cohort |>
    dplyr::filter(.data$cohort_definition_id %in% .env$cohortId) |>
    dplyr::compute(name = name, temporary = FALSE) |>
    omopgenerics::newCohortTable(
      cohortSetRef = omopgenerics::settings(cohort) |>
        dplyr::filter(.data$cohort_definition_id %in% .env$cohortId),
      cohortAttritionRef = omopgenerics::attrition(cohort) |>
        dplyr::filter(.data$cohort_definition_id %in% .env$cohortId),
      cohortCodelistRef = attr(cohort, "cohort_codelist") |>
        dplyr::filter(.data$cohort_definition_id %in% .env$cohortId),
      .softValidation = FALSE
    )
}
