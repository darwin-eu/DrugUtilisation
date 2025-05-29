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

#' Run benchmark of drug utilisation cohort generation
#'
#' @inheritParams cdmDoc
#' @param ingredient Name of ingredient to benchmark.
#' @param alternativeIngredient Name of ingredients to use as alternative
#' treatments.
#' @param indicationCohort Name of a cohort in the cdm_reference object to use
#' as indicatiomn.
#'
#' @return A summarise_result object.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(CDMConnector)
#' library(duckdb)
#'
#' requireEunomia()
#' con <- dbConnect(drv = duckdb(dbdir = eunomiaDir()))
#' cdm <- cdmFromCon(con = con, cdmSchema = "main", writeSchema = "main")
#'
#' timings <- benchmarkDrugUtilisation(cdm)
#'
#' timings
#' }
#'
benchmarkDrugUtilisation <- function(cdm,
                                     ingredient = "acetaminophen",
                                     alternativeIngredient = c("ibuprofen", "aspirin", "diclofenac"),
                                     indicationCohort = NULL) {
  # initial checks
  cdm <- omopgenerics::validateCdmArgument(cdm = cdm)
  omopgenerics::assertCharacter(ingredient, length = 1)
  omopgenerics::assertCharacter(alternativeIngredient)
  omopgenerics::assertCharacter(indicationCohort, length = 1, null = TRUE)

  result <- dplyr::tibble(task = character(), time = numeric())

  # get necessary concepts
  task <- "get necessary concepts"
  benchmarkMessage(task)
  t0 <- Sys.time()
  prefix <- omopgenerics::tmpPrefix()
  concept <- CodelistGenerator::getDrugIngredientCodes(
    cdm = cdm, name = ingredient
  )
  ingredientNames <-  cdm$concept |>
    dplyr::filter(.data$concept_class_id == "Ingredient") |>
    dplyr::select("concept_id", "concept_name") |>
    dplyr::collect()
  ingredientConceptId <- ingredientNames |>
    dplyr::filter(tolower(.data$concept_name) == .env$ingredient) |>
    dplyr::pull("concept_id")
  mainCohort <- paste0(prefix, "main")
  altCohort <- paste0(prefix, "alt")
  inclusion <- paste0(prefix, "inclusion")
  time <- as.numeric(Sys.time() - t0)
  result <- result |>
    dplyr::union_all(dplyr::tibble(task = task, time = time))

  # create cohort
  task <- "generateDrugUtilisation"
  benchmarkMessage(task)
  t0 <- Sys.time()
  suppressMessages(
    cdm <- generateDrugUtilisationCohortSet(
      cdm = cdm,
      conceptSet = concept,
      name = mainCohort,
      gapEra = 30
    )
  )
  time <- as.numeric(Sys.time() - t0)
  result <- result |>
    dplyr::union_all(dplyr::tibble(task = task, time = time))

  # create cohort numberExposures and daysPrescribed
  task <- "generateDrugUtilisation with numberExposures and daysPrescribed"
  benchmarkMessage(task)
  t0 <- Sys.time()
  suppressMessages(
    cdm <- generateDrugUtilisationCohortSet(
      cdm = cdm,
      conceptSet = concept,
      name = mainCohort,
      gapEra = 30,
      numberExposures = TRUE,
      daysPrescribed = TRUE
    )
  )
  time <- as.numeric(Sys.time() - t0)
  result <- result |>
    dplyr::union_all(dplyr::tibble(task = task, time = time))

  # apply inclusion criteria
  task <- "require"
  benchmarkMessage(task)
  t0 <- Sys.time()
  suppressMessages(
    cdm[[inclusion]] <- cdm[[mainCohort]] |>
      requireObservationBeforeDrug(days = 365, name = inclusion) |>
      requirePriorDrugWashout(days = 365, name = inclusion)
  )
  time <- as.numeric(Sys.time() - t0)
  result <- result |>
    dplyr::union_all(dplyr::tibble(task = task, time = time))

  # create alternative ingredient
  task <- "generateIngredientCohortSet"
  benchmarkMessage(task)
  t0 <- Sys.time()
  suppressMessages(
    cdm <- generateIngredientCohortSet(
      cdm = cdm,
      ingredient = alternativeIngredient,
      name = altCohort
    )
  )
  time <- as.numeric(Sys.time() - t0)
  result <- result |>
    dplyr::union_all(dplyr::tibble(task = task, time = time))

  # summariseDrugUtilisation
  task <- "summariseDrugUtilisation"
  benchmarkMessage(task)
  t0 <- Sys.time()
  suppressMessages(
    cdm[[mainCohort]] |>
      summariseDrugUtilisation(
        gapEra = 30, ingredientConceptId = ingredientConceptId
      )
  )
  time <- as.numeric(Sys.time() - t0)
  result <- result |>
    dplyr::union_all(dplyr::tibble(task = task, time = time))

  if (!is.null(indicationCohort)) {
    # summariseIndication
    task <- "summariseIndication"
    benchmarkMessage(task)
    t0 <- Sys.time()
    suppressMessages(
      cdm[[mainCohort]] |>
        summariseIndication(
          indicationWindow = list(c(-Inf, 0), c(-7, 7)),
          indicationCohortName = indicationCohort
        )
    )
    time <- as.numeric(Sys.time() - t0)
    result <- result |>
      dplyr::union_all(dplyr::tibble(task = task, time = time))
  }

  # summariseDrugRestart
  task <- "summariseDrugRestart"
  benchmarkMessage(task)
  t0 <- Sys.time()
  suppressMessages(
    cdm[[mainCohort]] |>
      summariseDrugRestart(switchCohortTable = altCohort)
  )
  time <- as.numeric(Sys.time() - t0)
  result <- result |>
    dplyr::union_all(dplyr::tibble(task = task, time = time))

  # summarisePPC
  task <- "summariseProportionOfPatientsCovered"
  benchmarkMessage(task)
  t0 <- Sys.time()
  suppressMessages(
    cdm[[mainCohort]] |>
      summariseProportionOfPatientsCovered()
  )
  time <- as.numeric(Sys.time() - t0)
  result <- result |>
    dplyr::union_all(dplyr::tibble(task = task, time = time))

  # summariseTreatment
  task <- "summariseTreatment"
  benchmarkMessage(task)
  t0 <- Sys.time()
  suppressMessages(
    cdm[[mainCohort]] |>
      summariseTreatment(
        treatmentCohortName = altCohort,
        window = list(c(-Inf, -1), c(0, 0), c(1, Inf))
      )
  )
  time <- as.numeric(Sys.time() - t0)
  result <- result |>
    dplyr::union_all(dplyr::tibble(task = task, time = time))

  # dropping created tables
  task <- "drop created tables"
  benchmarkMessage(task)
  t0 <- Sys.time()
  omopgenerics::dropSourceTable(cdm = cdm, name = dplyr::starts_with(prefix))
  time <- as.numeric(Sys.time() - t0)
  result <- result |>
    dplyr::union_all(dplyr::tibble(task = task, time = time))

  # create result object
  result <- result |>
    omopgenerics::uniteGroup(cols = "task") |>
    omopgenerics::uniteStrata() |>
    omopgenerics::uniteAdditional() |>
    dplyr::rename(estimate_value = "time") |>
    dplyr::mutate(
      result_id = 1L,
      cdm_name = omopgenerics::cdmName(cdm),
      variable_name = "overall",
      variable_level = "overall",
      estimate_name = "time_seconds",
      estimate_type = "numeric",
      estimate_value = sprintf("%.2f", .data$estimate_value)
    ) |>
    omopgenerics::newSummarisedResult(settings = dplyr::tibble(
      result_id = 1L,
      result_type = "benchmark_drug_utilisation",
      package_name = "DrugUtilisation",
      package_version = pkgVersion(),
      person_n = as.character(numberRecords(cdm$person)),
      ingredient = ingredient,
      alternative_ingredient = paste0(alternativeIngredient, collapse = "; "),
      source_type = omopgenerics::sourceType(cdm)
    ))

  return(result)
}

benchmarkMessage <- function(msg, nm = NULL) {
  date <- format(Sys.time(), "%d-%m-%Y %H:%M:%S")
  msg <- paste0("{.pkg {date}} Benchmark ", msg) |>
    rlang::set_names(nm = nm)
  cli::cli_inform(msg)
}
