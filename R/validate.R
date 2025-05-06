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

validateStrata <- function(strata, x, call = parent.frame()) {
  if (length(strata) == 0) {
    strata <- list()
  }
  if (is.character(strata)) {
    strata <- list(strata)
  }
  omopgenerics::assertList(strata, class = "character", call = call, unique = TRUE)
  notPresent <- strata |>
    unlist() |>
    unique() |>
    purrr::keep(\(col) !col %in% colnames(x))
  if (length(notPresent) > 0) {
    cli::cli_abort("{.var {notPresent}} not present in data.", call = call)
  }
  invisible(strata)
}
validateCohort <- function(cohort, dropExtraColumns = FALSE, call = parent.frame()) {
  cols <- c(
    "cohort_definition_id", "subject_id", "cohort_start_date",
    "cohort_end_date"
  )
  omopgenerics::assertTable(cohort, class = "cohort_table", columns = cols)
  if (dropExtraColumns) {
    extraCols <- colnames(cohort)[!colnames(cohort) %in% cols]
    if (length(extraCols) > 0) {
      cli::cli_inform("{.var {extraCols}} dropped as no extra columns allowed in cohort_table.")
      cohort <- cohort |>
        dplyr::select(dplyr::all_of(cols))
    }
  }
  return(invisible(cohort))
}
validateNameStyle <- function(nameStyle, ingredientConceptId, conceptSet, nv, call) {
  omopgenerics::assertCharacter(nameStyle, length = 1, call = call)
  msg <- character()
  if (length(ingredientConceptId) > 1 && !grepl("\\{ingredient\\}", nameStyle)) {
    msg <- c(msg, "*" = "{{ingredient}} must be part of nameStyle")
  }
  if (length(conceptSet) > 1 && !grepl("\\{concept_name\\}", nameStyle)) {
    msg <- c(msg, "*" = "{{concept_name}} must be part of nameStyle")
  }
  if (nv > 1 && !grepl("\\{value\\}", nameStyle)) {
    msg <- c(msg, "*" = "{{value}} must be part of nameStyle")
  }
  if (length(msg) > 0) {
    cli::cli_abort(message = c("!" = "Incorrect nameStyle:", msg), call = call)
  }
  return(invisible(nameStyle))
}
validateConceptSet <- function(conceptSet, call = parent.frame()) {
  if (is.null(conceptSet)) {
    cli::cli_abort("`conceptSet` can not be NULL. It muts be a named list of concept_id(s).", call = call)
  }
  if (rlang::is_bare_list(conceptSet)) {
    conceptSet <- conceptSet |>
      purrr::map(\(x) as.integer(x))
  }
  omopgenerics::validateConceptSetArgument(conceptSet)
}
