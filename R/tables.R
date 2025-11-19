# Copyright 2024 DARWIN EU (C)
#
# This file is part of DrugUtilisation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Create a table showing indication results
#'
#' @inheritParams resultDoc
#' @inheritParams tableDoc
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#'
#' cdm <- mockDrugUtilisation()
#'
#' result <- cdm$cohort1 |>
#'   summariseIndication(
#'     indicationCohortName = "cohort2",
#'     indicationWindow = list(c(-30, 0)),
#'     unknownIndicationTable = "condition_occurrence"
#'   )
#'
#' tableIndication(result)
#' }
#'
#' @return A table with a formatted version of summariseIndication() results.
#'
#' @export
#'
tableIndication <- function(result,
                            header = c("cdm_name", "cohort_name", strataColumns(result)),
                            groupColumn = "variable_name",
                            hide = c(
                              "window_name", "mutually_exclusive",
                              "unknown_indication_table", "censor_date",
                              "cohort_table_name", "index_date",
                              "indication_cohort_name"
                            ),
                            type = NULL,
                            style = NULL,
                            .options = list()) {
  dusTable(
    result = result,
    resultType = "summarise_indication",
    header = header,
    groupColumn = groupColumn,
    hide = hide,
    rename = c("Indication" = "variable_level"),
    modifyResults = \(x, ...) {
      x |>
        dplyr::filter(!grepl("number", .data$variable_name))
    },
    estimateName = c("N (%)" = "<count> (<percentage> %)"),
    type = type,
    style = style,
    .options = .options,
  )
}

#' Format a dose_coverage object into a visual table.
#'
#' @inheritParams resultDoc
#' @inheritParams tableDoc
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#'
#' cdm <- mockDrugUtilisation()
#'
#' result <- summariseDoseCoverage(cdm, 1125315)
#'
#' tableDoseCoverage(result)
#' }
#'
#' @return A table with a formatted version of summariseDrugCoverage() results.
#'
#' @export
#'
tableDoseCoverage <- function(result,
                              header = c("variable_name", "estimate_name"),
                              groupColumn = c("cdm_name", "ingredient_name"),
                              type = NULL,
                              hide = c("variable_level", "sample_size"),
                              style = NULL,
                              .options = list()) {
  dusTable(
    result = result,
    resultType = "summarise_dose_coverage",
    header = header,
    groupColumn = groupColumn,
    hide = hide,
    rename = character(),
    modifyResults = NULL,
    estimateName = c(
      "N (%)" = "<count_missing> (<percentage_missing> %)",
      "N" = "<count>",
      "Mean (SD)" = "<mean> (<sd>)",
      "Median (Q25 - Q75)" = "<median> (<q25> - <q75>)"
    ),
    type = type,
    style = style,
    .options = .options
  )
}

#' Format a drug_utilisation object into a visual table.
#'
#' @inheritParams resultDoc
#' @inheritParams tableDoc
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(CodelistGenerator)
#'
#' cdm <- mockDrugUtilisation()
#' codelist <- getDrugIngredientCodes(cdm = cdm, name = "acetaminophen")
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "dus_cohort",
#'                                         conceptSet = codelist)
#'
#' drugUse <- cdm$dus_cohort |>
#'   summariseDrugUtilisation(ingredientConceptId = 1125315)
#'
#' tableDrugUtilisation(drugUse)
#' }
#'
#' @return A table with a formatted version of summariseIndication() results.
#'
#' @export
#'
tableDrugUtilisation <- function(result,
                                 header = c("cdm_name"),
                                 groupColumn = c("cohort_name", strataColumns(result)),
                                 type = NULL,
                                 hide = c(
                                   "variable_level", "censor_date",
                                   "cohort_table_name", "gap_era", "index_date",
                                   "restrict_incident"
                                 ),
                                 style = NULL,
                                 .options = list()) {
  dusTable(
    result = result,
    resultType = "summarise_drug_utilisation",
    header = header,
    groupColumn = groupColumn,
    hide = hide,
    rename = character(),
    modifyResults = NULL,
    estimateName = c(
      "missing N (%)" = "<count_missing> (<percentage_missing> %)",
      "N" = "<count>",
      "Mean (SD)" = "<mean> (<sd>)",
      "Median (Q25 - Q75)" = "<median> (<q25> - <q75>)"
    ),
    type = type,
    style = style,
    .options = .options
  )
}

#' Format a summarised_treatment result into a visual table.
#'
#' @inheritParams resultDoc
#' @inheritParams tableDoc
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#'
#' cdm <- mockDrugUtilisation()
#'
#' result <- cdm$cohort1 |>
#'   summariseTreatment(
#'     treatmentCohortName = "cohort2",
#'     window = list(c(0, 30), c(31, 365))
#'   )
#'
#' tableTreatment(result)
#' }
#'
#' @return A table with a formatted version of summariseTreatment() results.
#'
#' @export
#'
tableTreatment <- function(result,
                           header = c("cdm_name", "cohort_name"),
                           groupColumn = "variable_name",
                           type = NULL,
                           hide = c(
                             "window_name", "mutually_exclusive", "censor_date",
                             "cohort_table_name", "index_date",
                             "treatment_cohort_name"
                           ),
                           style = NULL,
                           .options = list()) {
  dusTable(
    result = result,
    resultType = "summarise_treatment",
    header = header,
    groupColumn = groupColumn,
    hide = hide,
    rename = c("Treatment" = "variable_level"),
    modifyResults = NULL,
    estimateName = c("N (%)" = "<count> (<percentage> %)"),
    type = type,
    style = style,
    .options = .options
  )
}

#' Format a drug_restart object into a visual table.
#'
#' @inheritParams resultDoc
#' @inheritParams tableDoc
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#'
#' cdm <- mockDrugUtilisation()
#'
#' conceptlist <- list(acetaminophen = 1125360, metformin = c(1503297, 1503327))
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "switch_cohort",
#'                                         conceptSet = conceptlist)
#'
#' result <- cdm$cohort1 |>
#'   summariseDrugRestart(switchCohortTable = "switch_cohort")
#'
#' tableDrugRestart(result)
#' }
#'
#' @return A table with a formatted version of summariseDrugRestart() results.
#'
#' @export
#'
tableDrugRestart <- function(result,
                             header = c("cdm_name", "cohort_name"),
                             groupColumn = "variable_name",
                             type = NULL,
                             hide = c(
                               "censor_date",
                               "restrict_to_first_discontinuation",
                               "follow_up_days", "cohort_table_name",
                               "incident", "switch_cohort_table"
                             ),
                             style = NULL,
                             .options = list()) {
  dusTable(
    result = result,
    resultType = "summarise_drug_restart",
    header = header,
    groupColumn = groupColumn,
    hide = hide,
    rename = c("Treatment" = "variable_level"),
    modifyResults = NULL,
    estimateName = c("N (%)" = "<count> (<percentage> %)"),
    type = type,
    style = style,
    .options = .options
  )
}

#' Create a table with proportion of patients covered results
#'
#' @inheritParams resultDoc
#' @inheritParams tableDoc
#'
#' @return A table with a formatted version of summariseProportionOfPatientsCovered() results.
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#'
#' cdm <- mockDrugUtilisation()
#'
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "my_cohort",
#'                                         conceptSet = list(drug_of_interest = c(1503297, 1503327)))
#'
#' result <- cdm$my_cohort |>
#'   summariseProportionOfPatientsCovered(followUpDays = 365)
#'
#' tableProportionOfPatientsCovered(result)
#' }
#'
tableProportionOfPatientsCovered <- function(result,
                                             header = c("cohort_name", strataColumns(result)),
                                             groupColumn = "cdm_name",
                                             type = NULL,
                                             hide = c("variable_name", "variable_level", "cohort_table_name"),
                                             style = NULL,
                                             .options = list()) {
  dusTable(
    result = result,
    resultType = "summarise_proportion_of_patients_covered",
    header = header,
    groupColumn = groupColumn,
    hide = hide,
    rename = character(),
    modifyResults = \(x, ...) {
      x |>
        dplyr::filter(stringr::str_starts(.data$estimate_name, "ppc"))
    },
    estimateName = c(
      "PPC (95%CI)" = "<ppc>% [<ppc_lower>% - <ppc_upper>%]",
      "PPC" = "<ppc>%",
      "PPC lower" = "<ppc_lower>%",
      "PPC upper" = "<ppc_upper>%"
    ),
    type = type,
    style = style,
    .options = .options
  )
}

dusTable <- function(result,
                     resultType,
                     header,
                     groupColumn,
                     hide,
                     rename,
                     .options = list(),
                     modifyResults,
                     estimateName,
                     type,
                     style,
                     call = parent.frame()) {
  rlang::check_installed("visOmopResults", version = "1.2.0")

  # check inputs
  result <- omopgenerics::validateResultArgument(result, call = call)
  omopgenerics::assertCharacter(header, null = TRUE, call = call)
  omopgenerics::assertCharacter(groupColumn, null = TRUE, call = call)
  omopgenerics::assertCharacter(hide, null = TRUE, call = call)

  # overlap of parameters
  cols <- list(header = header, groupColumn = groupColumn, hide = hide)
  checkIntersection(cols, call)

  # subset to result_type
  result <- result |>
    omopgenerics::filterSettings(.data$result_type == .env$resultType)
  if (nrow(result) == 0) {
    cli::cli_warn("There are no results with `result_type = {resultType}`")
    return(visOmopResults::emptyTable(type = type, style = style))
  }

  checkVersion(result)

  if (is.function(modifyResults)) {
    result <- do.call(modifyResults, list(x = result, call = call))
    if (nrow(result) == 0) {
      return(visOmopResults::emptyTable(type = type, style = style))
    }
  }

  setColumns <- omopgenerics::settings(result) |>
    dplyr::filter(.data$result_id %in% unique(.env$result$result_id)) |>
    purrr::map(\(x) x[!is.na(x)]) |>
    purrr::compact() |>
    names()
  setColumns <- setColumns[!setColumns %in% c(
    "result_id", "result_type", "package_name", "package_version", "group",
    "strata", "additional", "min_cell_count")]

  cols <- c(
    "cdm_name", setColumns, groupColumns(result), strataColumns(result),
    additionalColumns(result), "variable_name", "variable_level",
    "estimate_name", "estimate_value"
  )

  # TODO
  # use rename in header, group and hide

  visOmopResults::visOmopTable(
    result = result,
    estimateName = estimateName,
    header = header,
    groupColumn = groupColumn,
    hide = hide,
    rename = rename,
    settingsColumn = setColumns,
    type = type,
    style = style,
    columnOrder = cols[!cols %in% c(hide, groupColumn, header)],
    .options = .options
  )
}

checkIntersection <- function(cols, call) {
  pairs <- tidyr::expand_grid(i = seq_along(cols), j = seq_along(cols)) |>
    dplyr::filter(.data$i < .data$j)
  mes <- purrr::map2(pairs$i, pairs$j, \(i, j) {
    x <- intersect(cols[[i]], cols[[j]])
    if (length(x) > 0) {
      nmi <- names(cols)[i]
      nmj <- names(cols)[j]
      res <- "{.var {x}} is present in {.pkg {nmi}} and {.pkg {nmj}}." |>
        cli::cli_text() |>
        cli::cli_fmt()
    } else {
      res <- character()
    }
    return(res)
  }) |>
    unlist()
  if (length(mes) > 0) {
    cli::cli_abort(mes, call = call)
  }
  invisible()
}
checkVersion <- function(result) {
  pkg <- "DrugUtilisation"
  set <- omopgenerics::settings(result) |>
    dplyr::filter(.data$result_id %in% .env$result$result_id)
  version <- unique(set$package_version[set$package_name == pkg])
  installedVersion <- as.character(utils::packageVersion(pkg))
  difVersions <- version[!version %in% installedVersion]
  if (length(difVersions) > 0) {
    c("!" = "result was generated with a different version ({.strong {difVersions}}) of {.pkg {pkg}} than the one installed: {.strong {installedVersion}}") |>
      cli::cli_inform()
  }
  invisible()
}
pkgVersion <- function() {
  as.character(utils::packageVersion("DrugUtilisation"))
}
