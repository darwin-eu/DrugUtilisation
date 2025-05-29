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

#' @noRd
drugStrengthPattern <- function(cdm,
                                ingredientConceptId = NULL,
                                pattern = TRUE,
                                patternDetails = TRUE,
                                unit = TRUE,
                                formula = TRUE,
                                ingredient = TRUE) {
  # start table
  drugStrengthRelated <- cdm[["drug_strength"]]

  # filter ingredients
  if (!is.null(ingredientConceptId)) {
    drugStrengthRelated <- drugStrengthRelated |>
      dplyr::filter(.data$ingredient_concept_id %in% .env$ingredientConceptId)
  }

  # add info
  nm <- omopgenerics::uniqueTableName(omopgenerics::tmpPrefix())
  cdm <- omopgenerics::insertTable(cdm = cdm, name = nm, table = patterns)
  cdm[[nm]] <- cdm[[nm]] |> dplyr::compute()
  omopgenerics::dropSourceTable(cdm = cdm, name = nm)

  drugStrengthRelated <- drugStrengthRelated |>
    dplyr::mutate(
      amount_numeric = dplyr::if_else(!is.na(.data$amount_value), 1, 0),
      numerator_numeric = dplyr::if_else(
        !is.na(.data$numerator_value), 1, 0
      ),
      denominator_numeric = dplyr::if_else(
        !is.na(.data$denominator_value), 1, 0
      )
    ) |>
    dplyr::left_join(
      cdm[[nm]],
      by = c(
        "amount_numeric", "amount_unit_concept_id", "numerator_numeric",
        "numerator_unit_concept_id", "denominator_numeric",
        "denominator_unit_concept_id"
      ),
      na_matches = "na"
    )

  # select desired columns
  variables <- c(
    {
      if (pattern) "pattern_id"
    },
    {
      if (patternDetails) {
        c(
          "amount_value", "numerator_value", "denominator_value",
          "amount_unit_concept_id", "numerator_unit_concept_id",
          "denominator_unit_concept_id"
        )
      }
    },
    {
      if (unit) "unit"
    },
    {
      if (formula) "formula_name"
    },
    {
      if (ingredient) "ingredient_concept_id"
    }
  )
  drugStrengthRelated <- drugStrengthRelated |>
    dplyr::select(dplyr::all_of(c("drug_concept_id", variables)))

  return(drugStrengthRelated)
}

.addRoute <- function(drugTable) {
  cdm <- omopgenerics::cdmReference(drugTable)
  drugTable |>
    dplyr::left_join(
      cdm[["concept_relationship"]] |>
        dplyr::select(c("concept_id_1", "concept_id_2", "relationship_id")) |>
        dplyr::filter(.data$relationship_id == "RxNorm has dose form") |>
        dplyr::select(-"relationship_id") |>
        dplyr::rename(
          "drug_concept_id" = "concept_id_1",
          "dose_form_concept_id" = "concept_id_2"
        ),
      by = "drug_concept_id"
    ) |>
    dplyr::left_join(routes, by = "dose_form_concept_id", copy = TRUE) |>
    dplyr::select(-"dose_form_concept_id")
}

#' Function to create a tibble with the patterns from current drug strength table
#'
#' @inheritParams cdmDoc
#'
#' @return The function creates a tibble with the different patterns found in
#' the table, plus a column of potentially valid and invalid combinations.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#'
#' cdm <- mockDrugUtilisation()
#'
#' patternTable(cdm)
#' }
#'
patternTable <- function(cdm) {
  # Initial chekc on inputs
  cdm <- omopgenerics::validateCdmArgument(cdm)

  # drug strength pattern
  drugStrengthPattern <- drugStrengthPattern(cdm = cdm, unit = FALSE) |>
    dplyr::compute()

  # counts concepts and ingredients
  pattern <- drugStrengthPattern |>
    dplyr::group_by(
      .data$pattern_id, .data$formula_name
    ) |>
    dplyr::summarise(
      number_concepts = as.numeric(dplyr::n_distinct(.data$drug_concept_id)),
      number_ingredients = as.numeric(dplyr::n_distinct(.data$ingredient_concept_id)),
      .groups = "drop"
    ) |>
    dplyr::collect()

  # create patterns
  pattern <- pattern |>
    dplyr::full_join(
      cdm[["drug_exposure"]] |>
        dplyr::left_join(drugStrengthPattern, by = "drug_concept_id") |>
        dplyr::group_by(
          .data$pattern_id, .data$formula_name
        ) |>
        dplyr::summarise(
          number_records = as.numeric(dplyr::n()), .groups = "drop"
        ) |>
        dplyr::collect(),
      by = c("pattern_id", "formula_name")
    ) |>
    dplyr::mutate(number_records = dplyr::if_else(
      is.na(.data$number_records), 0, .data$number_records
    )) |>
    dplyr::arrange(.data$pattern_id) |>
    dplyr::left_join(
      patterns |> dplyr::select(-"unit"),
      by = c("pattern_id", "formula_name")
    )

  # not present / new patterns
  newPattern <- pattern |>
    dplyr::filter(is.na(.data$pattern_id)) |>
    dplyr::mutate(validity = dplyr::if_else(
      is.na(.data$amount_numeric) & is.na(.data$amount_unit_concept_id) &
        is.na(.data$numerator_numeric) &
        is.na(.data$numerator_unit_concept_id) &
        is.na(.data$denominator_numeric) &
        is.na(.data$denominator_unit_concept_id),
      "no pattern", "no formula for this pattern"
    ))

  # join supported and non supported patterns
  pattern <- pattern |>
    dplyr::filter(!is.na(.data$pattern_id)) |>
    dplyr::mutate(validity = "pattern with formula") |>
    dplyr::union_all(newPattern) |>
    dplyr::relocate(dplyr::starts_with("number")) |>
    dplyr::relocate(
      c("pattern_id", "formula_name", "validity")
    )

  return(pattern)
}
