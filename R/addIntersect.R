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

#' Add a variable indicating individuals indications
#'
#' @description
#' Add a variable to a drug cohort indicating their presence in an indication
#' cohort in a specified time window. If an individual is not in one of the
#' indication cohorts, they will be considered to have an unknown indication if
#' they are present in one of the specified OMOP CDM clinical tables. If they
#' are neither in an indication cohort or a clinical table they will be
#' considered as having no observed indication.
#'
#' @inheritParams cohortDoc
#' @param indicationCohortName Name of indication cohort table
#' @param indicationCohortId target cohort Id to add indication
#' @param indicationWindow time window of interests
#' @param unknownIndicationTable Tables to search unknown indications
#' @inheritParams indexDateDoc
#' @inheritParams censorDateDoc
#' @param mutuallyExclusive Whether to consider mutually exclusive categories
#' (one column per window) or not (one column per window and indication).
#' @param nameStyle Name style for the indications. By default:
#' 'indication_\{window_name\}' (mutuallyExclusive = TRUE),
#' 'indication_\{window_name\}_\{cohort_name\}' (mutuallyExclusive = FALSE).
#' @inheritParams compNameDoc
#'
#' @return The original table with a variable added that summarises the
#' individual´s indications.
#'
#' @export
#'
#' @examples
#' \donttest{
#' cdm <- mockDrugUtilisation()
#'
#' indications <- list("headache" = 378253, "asthma" = 317009)
#' cdm <- CDMConnector::generateConceptCohortSet(
#'   cdm = cdm, conceptSet = indications, name = "indication_cohorts"
#' )
#'
#' cdm <- generateIngredientCohortSet(
#'   cdm = cdm, name = "drug_cohort",
#'   ingredient = "acetaminophen"
#' )
#'
#' cdm$drug_cohort |>
#'   addIndication(
#'     indicationCohortName = "indication_cohorts",
#'     indicationWindow = list(c(0, 0)),
#'     unknownIndicationTable = "condition_occurrence"
#'   ) |>
#'   dplyr::glimpse()
#' }
#'
addIndication <- function(cohort,
                          indicationCohortName,
                          indicationCohortId = NULL,
                          indicationWindow = list(c(0, 0)),
                          unknownIndicationTable = NULL,
                          indexDate = "cohort_start_date",
                          censorDate = NULL,
                          mutuallyExclusive = TRUE,
                          nameStyle = NULL,
                          name = NULL) {
  .addIntersect(
    cohort = cohort,
    cohortTable = indicationCohortName,
    cohortTableId = indicationCohortId,
    window = indicationWindow,
    mutuallyExclusive = mutuallyExclusive,
    unknownTable = unknownIndicationTable,
    indexDate = indexDate,
    censorDate = censorDate,
    name = name,
    nameStyle = nameStyle,
    nm = "indications"
  )
}

#' Add a variable indicating individuals medications
#'
#' @description
#' Add a variable to a drug cohort indicating their presence of a medication
#' cohort in a specified time window.
#'
#' @inheritParams cohortDoc
#' @param treatmentCohortName Name of treatment cohort table
#' @param treatmentCohortId target cohort Id to add treatment
#' @param window time window of interests.
#' @inheritParams indexDateDoc
#' @inheritParams censorDateDoc
#' @param mutuallyExclusive Whether to consider mutually exclusive categories
#' (one column per window) or not (one column per window and treatment).
#' @param nameStyle Name style for the treatment columns. By default:
#' 'treatment_\{window_name\}' (mutuallyExclusive = TRUE),
#' 'treatment_\{window_name\}_\{cohort_name\}' (mutuallyExclusive = FALSE).
#' @inheritParams compNameDoc
#'
#' @return The original table with a variable added that summarises the
#' individual´s indications.
#'
#' @export
#'
#' @examples
#' \donttest{
#' cdm <- mockDrugUtilisation(numberIndividuals = 50)
#'
#'
#' cdm <- generateIngredientCohortSet(
#'   cdm = cdm, name = "drug_cohort", ingredient = "acetaminophen"
#' )
#'
#' cdm <- generateIngredientCohortSet(
#'   cdm = cdm, name = "treatments", ingredient = c("metformin", "simvastatin")
#' )
#'
#' cdm$drug_cohort |>
#'   addTreatment("treatments", window = list(c(0, 0), c(1, 30), c(31, 60))) |>
#'   dplyr::glimpse()
#' }
#'
addTreatment <- function(cohort,
                         treatmentCohortName,
                         treatmentCohortId = NULL,
                         window = list(c(0, 0)),
                         indexDate = "cohort_start_date",
                         censorDate = NULL,
                         mutuallyExclusive = TRUE,
                         nameStyle = NULL,
                         name = NULL) {
  .addIntersect(
    cohort = cohort,
    cohortTable = treatmentCohortName,
    cohortTableId = treatmentCohortId,
    window = window,
    mutuallyExclusive = mutuallyExclusive,
    unknownTable = character(),
    indexDate = indexDate,
    censorDate = censorDate,
    name = name,
    nameStyle = nameStyle,
    nm = "medications"
  )
}

.addIntersect <- function(cohort,
                          cohortTable,
                          cohortTableId,
                          window,
                          mutuallyExclusive,
                          unknownTable,
                          indexDate,
                          censorDate,
                          name,
                          nameStyle,
                          nm,
                          call = parent.frame()) {
  # initial checks
  omopgenerics::assertClass(cohort, "cdm_table", call = call)
  omopgenerics::assertCharacter({{cohortTable}}, length = 1, call = call)
  cdm <- omopgenerics::cdmReference(cohort)
  cohortTableId <- omopgenerics::validateCohortIdArgument({{cohortTableId}}, cdm[[cohortTable]], call = call)
  window <- omopgenerics::validateWindowArgument(window, call = call)
  omopgenerics::assertLogical(mutuallyExclusive, length = 1, call = call)
  unknownTable <- as.character(unknownTable)
  omopgenerics::assertCharacter(unknownTable, unique = TRUE, call = call)
  omopgenerics::assertCharacter(indexDate, length = 1, call = call)
  omopgenerics::assertTrue(indexDate %in% colnames(cohort), call = call)
  omopgenerics::assertCharacter(censorDate, null = TRUE, length = 1, call = call)
  omopgenerics::assertChoice(nm, c("indications", "medications"))
  if (!is.null(censorDate)) {
    omopgenerics::assertTrue(censorDate %in% colnames(cohort), call = call)
  }
  omopgenerics::assertCharacter(nameStyle, length = 1, call = call, null = TRUE)
  if (is.null(nameStyle)) {
    if (mutuallyExclusive) {
      nameStyle <- paste0(substr(nm, 1, nchar(nm)-1), "_{window_name}")
    } else {
      nameStyle <- paste0(substr(nm, 1, nchar(nm)-1), "_{window_name}_{cohort_name}")
    }
  } else {
    noCont <- c("{window_name}"[length(window) > 0], "{cohort_name}"[!mutuallyExclusive]) |>
      purrr::keep(\(x) !grepl(pattern = x, x = nameStyle, fixed = TRUE))
    if (length(noCont) > 0) {
      cli::cli_abort("{.var {noCont}} must be part of nameStyle.", call = call)
    }
  }
  name <- omopgenerics::validateNameArgument(name, null = TRUE, call = call, validation = "warning")

  cdm <- omopgenerics::cdmReference(cohort)
  prefix <- omopgenerics::tmpPrefix()
  windowNames <- names(window)
  names(window) <- paste0("win", seq_along(window))

  # add intersections
  cli::cli_inform(c("i" = "Intersect with {nm} table ({.pkg {cohortTable}})."))
  ind <- cohort |>
    dplyr::select(dplyr::all_of(c("subject_id", censorDate, indexDate))) |>
    dplyr::distinct() |>
    PatientProfiles::addCohortIntersectFlag(
      targetCohortTable = cohortTable,
      indexDate = indexDate,
      censorDate = censorDate,
      targetStartDate = "cohort_start_date",
      targetEndDate = "cohort_end_date",
      window = window,
      targetCohortId = cohortTableId,
      nameStyle = "x_{window_name}_{cohort_name}",
      name = omopgenerics::uniqueTableName(prefix)
    ) |>
    # add unknown table
    addUnknownIntersect(indexDate, censorDate, window, unknownTable, prefix)

  if (nm == "indications") {
    noLabel <- "none"
  } else if (nm == "medications") {
    noLabel <- "untreated"
  }

  if (mutuallyExclusive) {
    cli::cli_inform(c("i" = "Collapse {nm} to mutually exclusive categories"))
    ind <- ind |>
      collapseIntersections(windowNames, nameStyle, prefix, noLabel)
  } else {
    ind <- ind |>
      nameStyleColumns(windowNames, nameStyle)
  }

  # overwrite columns
  overwrite <- colnames(cohort) |>
    purrr::keep(\(x) !x %in% c("subject_id", censorDate, indexDate)) |>
    purrr::keep(\(x) x %in% colnames(ind))
  if (length(overwrite)) {
    cohort <- cohort |>
      dplyr::select(!dplyr::all_of(overwrite))
    cli::cli_warn(c("!" = "Columns {.var {overwrite}} will be overwritten."))
  }

  cohort <- cohort |>
    dplyr::left_join(
      ind, by = c("subject_id", censorDate, indexDate)
    ) |>
    dplyr::compute(name = name)

  omopgenerics::dropSourceTable(cdm = cdm, name = dplyr::starts_with(prefix))

  return(cohort)
}

addUnknownIntersect <- function(x, indexDate, censorDate, window, table, prefix) {
  if (length(table) == 0) return(x)

  cdm <- omopgenerics::cdmReference(x)

  tablePrefix <- omopgenerics::tmpPrefix()
  name <- omopgenerics::uniqueTableName(prefix)

  xx <- x |>
    dplyr::select(dplyr::any_of(c("subject_id", indexDate, censorDate))) |>
    dplyr::compute(
      name = omopgenerics::uniqueTableName(tablePrefix), temporary = FALSE
    )

  for (tab in table) {
    cli::cli_inform(c('i' = "Getting unknown indications from {.pkg {tab}}."))
    xx <- xx |>
      PatientProfiles::addTableIntersectFlag(
        indexDate = indexDate,
        censorDate = censorDate,
        tableName = tab,
        targetEndDate = NULL,
        window = window,
        nameStyle = "u_{window_name}_{table_name}",
        name = omopgenerics::uniqueTableName(tablePrefix)
      )
  }

  qq <- paste0("dplyr::if_else(", paste0(".data[['u_{win}_", table, "']] == 1", collapse = " | "), ", 1L, 0L)") |>
    glue::glue(win = names(window)) |>
    rlang::parse_exprs() |>
    rlang::set_names(paste0("x_", names(window), "_unknown"))

  x <- x |>
    dplyr::left_join(
      xx |>
        dplyr::mutate(!!!qq) |>
        dplyr::select(!dplyr::starts_with("u_")),
      by = c("subject_id", indexDate)
    ) |>
    dplyr::compute(name = name, temporary = FALSE)

  omopgenerics::dropSourceTable(cdm = cdm, name = dplyr::starts_with(tablePrefix))

  return(x)
}
collapseIntersections <- function(x, windowNames, nameStyle, prefix, noLabel) {
  windowNames <- glue::glue(nameStyle, window_name = windowNames) |>
    as.character()
  cdm <- omopgenerics::cdmReference(x)
  # get intersections names
  intersections <- colnames(x) |>
    purrr::keep(\(x) startsWith(x, "x_win")) |>
    purrr::map_chr(\(x) {
      x <- stringr::str_split_1(x, pattern = "_")
      paste0(x[-(1:2)], collapse = "_")
    }) |>
    unique()
  unknown <- "unknown" %in% intersections
  intersections <- sort(intersections[intersections != "unknown"])
  prefixInternal <- omopgenerics::tmpPrefix()
  xn <- x
  for (k in seq_along(windowNames)) {
    nm <- omopgenerics::uniqueTableName(prefix = prefixInternal)

    cols <- as.character(glue::glue("x_win{k}_{intersections}"))

    if (unknown) {
      unknownK <- as.character(glue::glue("x_win{k}_unknown"))
    } else {
      unknownK <- character()
    }

    colName <- windowNames[k]
    xi <- x |>
      dplyr::select(dplyr::all_of(c(cols, unknownK))) |>
      dplyr::distinct() |>
      dplyr::collect() |>
      dplyr::filter(!dplyr::if_any(dplyr::everything(), is.na)) |>
      dplyr::mutate(!!colName := "")

    for (i in seq_along(cols)) {
      xi <- xi |>
        dplyr::mutate(!!colName := dplyr::case_when(
          .data[[cols[i]]] == 1L & .data[[colName]] == "" ~ .env$intersections[i],
          .data[[cols[i]]] == 1L & .data[[colName]] != "" ~ paste0(.data[[colName]], " and ", .env$intersections[i]),
          .default = .data[[colName]]
        ))
    }

    if (unknown) {
      xi <- xi |>
        dplyr::mutate(!!colName := dplyr::if_else(
          .data[[colName]] == "",
          dplyr::if_else(.data[[glue::glue('x_win{k}_unknown')]] == 1L, 'unknown', .env$noLabel),
          .data[[colName]]
        ))
    } else {
      xi <- xi |>
        dplyr::mutate(!!colName := dplyr::if_else(
          .data[[colName]] == "", .env$noLabel, .data[[colName]]
        ))
    }

    cdm <- omopgenerics::insertTable(cdm = cdm, name = nm, table = xi)

    xn <- xn |>
      dplyr::left_join(cdm[[nm]], by = c(cols, unknownK))

  }
  xn <- xn |>
    dplyr::select(!dplyr::starts_with("x_win")) |>
    dplyr::mutate(dplyr::across(
      dplyr::all_of(windowNames),
      \(x) dplyr::coalesce(x, "not in observation")
    )) |>
    dplyr::compute(
      name = omopgenerics::uniqueTableName(prefix), temporary = FALSE
    )
  omopgenerics::dropSourceTable(cdm = cdm, name = dplyr::starts_with(prefixInternal))
  return(xn)
}
nameStyleColumns <- function(x, windowNames, nameStyle) {
  tib <- dplyr::tibble(original_name = colnames(x)) |>
    dplyr::mutate(
      window_short_name = purrr::map_chr(.data$original_name, \(x) {
        stringr::str_split_1(x, pattern = "_")[2]
      }),
      cohort_name = purrr::map_chr(.data$original_name, \(x) {
        x <- stringr::str_split_1(x, pattern = "_")
        paste0(x[-(1:2)], collapse = "_")
      })
    ) |>
    dplyr::inner_join(
      dplyr::tibble(
        window_short_name = paste0("win", seq_along(windowNames)),
        window_name = windowNames
      ),
      by = "window_short_name"
    ) |>
    dplyr::mutate(new_name = glue::glue(nameStyle))
  rename <- tib$original_name
  names(rename) <- tib$new_name

  # rename
  x <- x |>
    dplyr::rename(!!!rename)

  return(x)
}
