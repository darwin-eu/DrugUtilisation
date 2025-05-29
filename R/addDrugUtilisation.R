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

#' Add new columns with drug use related information
#'
#' @inheritParams cohortDoc
#' @inheritParams gapEraDoc
#' @inheritParams conceptSetDoc
#' @inheritParams ingredientConceptIdDoc
#' @inheritParams indexDateDoc
#' @inheritParams censorDateDoc
#' @inheritParams restrictIncidentDoc
#' @inheritParams drugUtilisationDoc
#' @inheritParams nameStyleDoc
#' @inheritParams compNameDoc
#'
#' @return The same cohort with the added columns.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(CodelistGenerator)
#' library(dplyr, warn.conflicts = FALSE)
#'
#' cdm <- mockDrugUtilisation()
#' codelist <- getDrugIngredientCodes(cdm = cdm, name = "acetaminophen")
#'
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "dus_cohort",
#'                                         conceptSet = codelist)
#' cdm$dus_cohort |>
#'   addDrugUtilisation(ingredientConceptId = 1125315, gapEra = 30) |>
#'   glimpse()
#' }
#'
addDrugUtilisation <- function(cohort,
                               gapEra,
                               conceptSet = NULL,
                               ingredientConceptId = NULL,
                               indexDate = "cohort_start_date",
                               censorDate = "cohort_end_date",
                               restrictIncident = TRUE,
                               numberExposures = TRUE,
                               numberEras = TRUE,
                               daysExposed = TRUE,
                               daysPrescribed = TRUE,
                               timeToExposure = TRUE,
                               initialExposureDuration = TRUE,
                               initialQuantity = TRUE,
                               cumulativeQuantity = TRUE,
                               initialDailyDose = TRUE,
                               cumulativeDose = TRUE,
                               nameStyle = "{value}_{concept_name}_{ingredient}",
                               name = NULL) {
  cohort |>
    addDrugUseInternal(
      indexDate = indexDate,
      censorDate = censorDate,
      conceptSet = conceptSet,
      ingredientConceptId = ingredientConceptId,
      restrictIncident = restrictIncident,
      numberExposures = numberExposures,
      numberEras = numberEras,
      daysExposed = daysExposed,
      daysPrescribed = daysPrescribed,
      timeToExposure = timeToExposure,
      initialExposureDuration = initialExposureDuration,
      initialQuantity = initialQuantity,
      cumulativeQuantity = cumulativeQuantity,
      initialDailyDose = initialDailyDose,
      cumulativeDose = cumulativeDose,
      gapEra = gapEra,
      nameStyle = nameStyle,
      name = name
    )
}

#' To add a new column with the number of exposures. To add multiple columns use
#' `addDrugUtilisation()` for efficiency.
#'
#' @inheritParams cohortDoc
#' @inheritParams conceptSetDoc
#' @inheritParams indexDateDoc
#' @inheritParams censorDateDoc
#' @inheritParams restrictIncidentDoc
#' @inheritParams nameStyleDoc
#' @inheritParams compNameDoc
#'
#' @return The same cohort with the added columns.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(CodelistGenerator)
#' library(dplyr, warn.conflicts = FALSE)
#'
#' cdm <- mockDrugUtilisation()
#' codelist <- getDrugIngredientCodes(cdm = cdm, name = "acetaminophen")
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "dus_cohort",
#'                                         conceptSet = codelist)
#'
#' cdm$dus_cohort |>
#'   addNumberExposures(conceptSet = codelist) |>
#'   glimpse()
#' }
#'
addNumberExposures <- function(cohort,
                               conceptSet,
                               indexDate = "cohort_start_date",
                               censorDate = "cohort_end_date",
                               restrictIncident = TRUE,
                               nameStyle = "number_exposures_{concept_name}",
                               name = NULL) {
  conceptSet <- validateConceptSet(conceptSet)
  cohort |>
    addDrugUseInternal(
      indexDate = indexDate,
      censorDate = censorDate,
      conceptSet = conceptSet,
      ingredientConceptId = NULL,
      restrictIncident = restrictIncident,
      numberExposures = TRUE,
      numberEras = FALSE,
      daysExposed = FALSE,
      daysPrescribed = FALSE,
      timeToExposure = FALSE,
      initialExposureDuration = FALSE,
      initialQuantity = FALSE,
      cumulativeQuantity = FALSE,
      initialDailyDose = FALSE,
      cumulativeDose = FALSE,
      gapEra = 0,
      nameStyle = nameStyle,
      name = name
    )
}

#' To add a new column with the days prescribed. To add multiple columns use
#' `addDrugUtilisation()` for efficiency.
#'
#' @inheritParams cohortDoc
#' @inheritParams conceptSetDoc
#' @inheritParams indexDateDoc
#' @inheritParams censorDateDoc
#' @inheritParams restrictIncidentDoc
#' @inheritParams nameStyleDoc
#' @inheritParams compNameDoc
#'
#' @return The same cohort with the added columns.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(CodelistGenerator)
#' library(dplyr, warn.conflicts = FALSE)
#'
#' cdm <- mockDrugUtilisation()
#' codelist <- getDrugIngredientCodes(cdm = cdm, name = "acetaminophen")
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "dus_cohort",
#'                                         conceptSet = codelist)
#'
#' cdm$dus_cohort |>
#'   addDaysPrescribed(conceptSet = codelist) |>
#'   glimpse()
#' }
#'
addDaysPrescribed <- function(cohort,
                              conceptSet,
                              indexDate = "cohort_start_date",
                              censorDate = "cohort_end_date",
                              restrictIncident = TRUE,
                              nameStyle = "days_prescribed_{concept_name}",
                              name = NULL) {
  conceptSet <- validateConceptSet(conceptSet)
  cohort |>
    addDrugUseInternal(
      indexDate = indexDate,
      censorDate = censorDate,
      conceptSet = conceptSet,
      ingredientConceptId = NULL,
      restrictIncident = restrictIncident,
      numberExposures = FALSE,
      numberEras = FALSE,
      daysExposed = FALSE,
      daysPrescribed = TRUE,
      timeToExposure = FALSE,
      initialExposureDuration = FALSE,
      initialQuantity = FALSE,
      cumulativeQuantity = FALSE,
      initialDailyDose = FALSE,
      cumulativeDose = FALSE,
      gapEra = 0,
      nameStyle = nameStyle,
      name = name
    )
}

#' To add a new column with the cumulative dose. To add multiple columns use
#' `addDrugUtilisation()` for efficiency.
#'
#' @inheritParams cohortDoc
#' @inheritParams ingredientConceptIdDoc
#' @inheritParams conceptSetDoc
#' @inheritParams indexDateDoc
#' @inheritParams censorDateDoc
#' @inheritParams restrictIncidentDoc
#' @inheritParams nameStyleDoc
#' @inheritParams compNameDoc
#'
#' @return The same cohort with the added column.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(CodelistGenerator)
#' library(dplyr, warn.conflicts = FALSE)
#'
#' cdm <- mockDrugUtilisation()
#' codelist <- getDrugIngredientCodes(cdm = cdm, name = "acetaminophen")
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "dus_cohort",
#'                                         conceptSet = codelist)
#'
#' cdm$dus_cohort |>
#'   addCumulativeDose(ingredientConceptId = 1125315) |>
#'   glimpse()
#' }
#'
addCumulativeDose <- function(cohort,
                              ingredientConceptId,
                              conceptSet = NULL,
                              indexDate = "cohort_start_date",
                              censorDate = "cohort_end_date",
                              restrictIncident = TRUE,
                              nameStyle = "cumulative_dose_{concept_name}_{ingredient}",
                              name = NULL) {
  cohort |>
    addDrugUseInternal(
      indexDate = indexDate,
      censorDate = censorDate,
      conceptSet = conceptSet,
      ingredientConceptId = ingredientConceptId,
      restrictIncident = restrictIncident,
      numberExposures = FALSE,
      numberEras = FALSE,
      daysExposed = FALSE,
      daysPrescribed = FALSE,
      timeToExposure = FALSE,
      initialExposureDuration = FALSE,
      initialQuantity = FALSE,
      cumulativeQuantity = FALSE,
      initialDailyDose = FALSE,
      cumulativeDose = TRUE,
      gapEra = 0,
      nameStyle = nameStyle,
      name = name
    )
}

#' To add a new column with the initial daily dose. To add multiple columns use
#' `addDrugUtilisation()` for efficiency.
#'
#' @inheritParams cohortDoc
#' @inheritParams ingredientConceptIdDoc
#' @inheritParams conceptSetDoc
#' @inheritParams indexDateDoc
#' @inheritParams censorDateDoc
#' @inheritParams restrictIncidentDoc
#' @inheritParams nameStyleDoc
#' @inheritParams compNameDoc
#'
#' @return The same cohort with the added column.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(CodelistGenerator)
#' library(dplyr, warn.conflicts = FALSE)
#'
#' cdm <- mockDrugUtilisation()
#' codelist <- getDrugIngredientCodes(cdm = cdm, name = "acetaminophen")
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "dus_cohort",
#'                                         conceptSet = codelist)
#'
#' cdm$dus_cohort |>
#'   addInitialDailyDose(ingredientConceptId = 1125315) |>
#'   glimpse()
#' }
#'
addInitialDailyDose <- function(cohort,
                                ingredientConceptId,
                                conceptSet = NULL,
                                indexDate = "cohort_start_date",
                                censorDate = "cohort_end_date",
                                restrictIncident = TRUE,
                                nameStyle = "initial_daily_dose_{concept_name}_{ingredient}",
                                name = NULL) {
  cohort |>
    addDrugUseInternal(
      indexDate = indexDate,
      censorDate = censorDate,
      conceptSet = conceptSet,
      ingredientConceptId = ingredientConceptId,
      restrictIncident = restrictIncident,
      numberExposures = FALSE,
      numberEras = FALSE,
      daysExposed = FALSE,
      daysPrescribed = FALSE,
      timeToExposure = FALSE,
      initialExposureDuration = FALSE,
      initialQuantity = FALSE,
      cumulativeQuantity = FALSE,
      initialDailyDose = TRUE,
      cumulativeDose = FALSE,
      gapEra = 0,
      nameStyle = nameStyle,
      name = name
    )
}

#' To add a new column with the cumulative quantity. To add multiple columns use
#' `addDrugUtilisation()` for efficiency.
#'
#' @inheritParams cohortDoc
#' @inheritParams conceptSetDoc
#' @inheritParams indexDateDoc
#' @inheritParams censorDateDoc
#' @inheritParams restrictIncidentDoc
#' @inheritParams nameStyleDoc
#' @inheritParams compNameDoc
#'
#' @return The same cohort with the added column.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(CodelistGenerator)
#' library(dplyr, warn.conflicts = FALSE)
#'
#' cdm <- mockDrugUtilisation()
#' codelist <- getDrugIngredientCodes(cdm = cdm, name = "acetaminophen")
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "dus_cohort",
#'                                         conceptSet = codelist)
#'
#' cdm$dus_cohort |>
#'   addCumulativeQuantity(conceptSet = codelist) |>
#'   glimpse()
#' }
#'
addCumulativeQuantity <- function(cohort,
                                  conceptSet,
                                  indexDate = "cohort_start_date",
                                  censorDate = "cohort_end_date",
                                  restrictIncident = TRUE,
                                  nameStyle = "cumulative_quantity_{concept_name}",
                                  name = NULL) {
  conceptSet <- validateConceptSet(conceptSet)
  cohort |>
    addDrugUseInternal(
      indexDate = indexDate,
      censorDate = censorDate,
      conceptSet = conceptSet,
      ingredientConceptId = NULL,
      restrictIncident = restrictIncident,
      numberExposures = FALSE,
      numberEras = FALSE,
      daysExposed = FALSE,
      daysPrescribed = FALSE,
      timeToExposure = FALSE,
      initialExposureDuration = FALSE,
      initialQuantity = FALSE,
      cumulativeQuantity = TRUE,
      initialDailyDose = FALSE,
      cumulativeDose = FALSE,
      gapEra = 0,
      nameStyle = nameStyle,
      name = name
    )
}

#' To add a new column with the initial quantity. To add multiple columns use
#' `addDrugUtilisation()` for efficiency.
#'
#' @inheritParams cohortDoc
#' @inheritParams conceptSetDoc
#' @inheritParams indexDateDoc
#' @inheritParams censorDateDoc
#' @inheritParams restrictIncidentDoc
#' @inheritParams nameStyleDoc
#' @inheritParams compNameDoc
#'
#' @return The same cohort with the added column.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(CodelistGenerator)
#' library(dplyr, warn.conflicts = FALSE)
#'
#' cdm <- mockDrugUtilisation()
#' codelist <- getDrugIngredientCodes(cdm = cdm, name = "acetaminophen")
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "dus_cohort",
#'                                         conceptSet = codelist)
#'
#' cdm$dus_cohort |>
#'   addInitialQuantity(conceptSet = codelist) |>
#'   glimpse()
#' }
#'
addInitialQuantity <- function(cohort,
                               conceptSet,
                               indexDate = "cohort_start_date",
                               censorDate = "cohort_end_date",
                               restrictIncident = TRUE,
                               nameStyle = "initial_quantity_{concept_name}",
                               name = NULL) {
  conceptSet <- validateConceptSet(conceptSet)
  cohort |>
    addDrugUseInternal(
      indexDate = indexDate,
      censorDate = censorDate,
      conceptSet = conceptSet,
      ingredientConceptId = NULL,
      restrictIncident = restrictIncident,
      numberExposures = FALSE,
      numberEras = FALSE,
      daysExposed = FALSE,
      daysPrescribed = FALSE,
      timeToExposure = FALSE,
      initialExposureDuration = FALSE,
      initialQuantity = TRUE,
      cumulativeQuantity = FALSE,
      initialDailyDose = FALSE,
      cumulativeDose = FALSE,
      gapEra = 0,
      nameStyle = nameStyle,
      name = name
    )
}

#' To add a new column with the time to exposure. To add multiple columns use
#' `addDrugUtilisation()` for efficiency.
#'
#' @inheritParams cohortDoc
#' @inheritParams conceptSetDoc
#' @inheritParams indexDateDoc
#' @inheritParams censorDateDoc
#' @inheritParams restrictIncidentDoc
#' @inheritParams nameStyleDoc
#' @inheritParams compNameDoc
#'
#' @return The same cohort with the added column.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(CodelistGenerator)
#' library(dplyr, warn.conflicts = FALSE)
#'
#' cdm <- mockDrugUtilisation()
#' codelist <- getDrugIngredientCodes(cdm = cdm, name = "acetaminophen")
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "dus_cohort",
#'                                         conceptSet = codelist)
#'
#' cdm$dus_cohort |>
#'   addTimeToExposure(conceptSet = codelist) |>
#'   glimpse()
#' }
#'
addTimeToExposure <- function(cohort,
                              conceptSet,
                              indexDate = "cohort_start_date",
                              censorDate = "cohort_end_date",
                              restrictIncident = TRUE,
                              nameStyle = "time_to_exposure_{concept_name}",
                              name = NULL) {
  conceptSet <- validateConceptSet(conceptSet)
  cohort |>
    addDrugUseInternal(
      indexDate = indexDate,
      censorDate = censorDate,
      conceptSet = conceptSet,
      ingredientConceptId = NULL,
      restrictIncident = restrictIncident,
      numberExposures = FALSE,
      numberEras = FALSE,
      daysExposed = FALSE,
      daysPrescribed = FALSE,
      timeToExposure = TRUE,
      initialExposureDuration = FALSE,
      initialQuantity = FALSE,
      cumulativeQuantity = FALSE,
      initialDailyDose = FALSE,
      cumulativeDose = FALSE,
      gapEra = 0,
      nameStyle = nameStyle,
      name = name
    )
}

#' To add a new column with the days exposed. To add multiple columns use
#' `addDrugUtilisation()` for efficiency.
#'
#' @inheritParams cohortDoc
#' @inheritParams conceptSetDoc
#' @inheritParams gapEraDoc
#' @inheritParams indexDateDoc
#' @inheritParams censorDateDoc
#' @inheritParams restrictIncidentDoc
#' @inheritParams nameStyleDoc
#' @inheritParams compNameDoc
#'
#' @return The same cohort with the added column.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(CodelistGenerator)
#' library(dplyr, warn.conflicts = FALSE)
#'
#' cdm <- mockDrugUtilisation()
#' codelist <- getDrugIngredientCodes(cdm = cdm, name = "acetaminophen")
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "dus_cohort",
#'                                         conceptSet = codelist)
#'
#' cdm$dus_cohort |>
#'   addDaysExposed(conceptSet = codelist, gapEra = 1) |>
#'   glimpse()
#' }
#'
addDaysExposed <- function(cohort,
                           conceptSet,
                           gapEra,
                           indexDate = "cohort_start_date",
                           censorDate = "cohort_end_date",
                           restrictIncident = TRUE,
                           nameStyle = "days_exposed_{concept_name}",
                           name = NULL) {
  conceptSet <- validateConceptSet(conceptSet)
  cohort |>
    addDrugUseInternal(
      indexDate = indexDate,
      censorDate = censorDate,
      conceptSet = conceptSet,
      ingredientConceptId = NULL,
      restrictIncident = restrictIncident,
      numberExposures = FALSE,
      numberEras = FALSE,
      daysExposed = TRUE,
      daysPrescribed = FALSE,
      timeToExposure = FALSE,
      initialExposureDuration = FALSE,
      initialQuantity = FALSE,
      cumulativeQuantity = FALSE,
      initialDailyDose = FALSE,
      cumulativeDose = FALSE,
      gapEra = gapEra,
      nameStyle = nameStyle,
      name = name
    )
}

#' To add a new column with the duration of the first exposure.
#' To add multiple columns use `addDrugUtilisation()` for efficiency.
#'
#' @inheritParams cohortDoc
#' @inheritParams conceptSetDoc
#' @inheritParams indexDateDoc
#' @inheritParams censorDateDoc
#' @inheritParams restrictIncidentDoc
#' @inheritParams nameStyleDoc
#' @inheritParams compNameDoc
#'
#' @return The same cohort with the added column.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(CodelistGenerator)
#' library(dplyr, warn.conflicts = FALSE)
#'
#' cdm <- mockDrugUtilisation()
#' codelist <- getDrugIngredientCodes(cdm = cdm, name = "acetaminophen")
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "dus_cohort",
#'                                         conceptSet = codelist)
#'
#' cdm$dus_cohort |>
#'   addInitialExposureDuration(conceptSet = codelist) |>
#'   glimpse()
#' }
#'
addInitialExposureDuration <- function(cohort,
                                       conceptSet,
                                       indexDate = "cohort_start_date",
                                       censorDate = "cohort_end_date",
                                       restrictIncident = TRUE,
                                       nameStyle = "initial_exposure_duration_{concept_name}",
                                       name = NULL) {
  conceptSet <- validateConceptSet(conceptSet)
  cohort |>
    addDrugUseInternal(
      indexDate = indexDate,
      censorDate = censorDate,
      conceptSet = conceptSet,
      ingredientConceptId = NULL,
      restrictIncident = restrictIncident,
      numberExposures = FALSE,
      numberEras = FALSE,
      daysExposed = FALSE,
      daysPrescribed = FALSE,
      timeToExposure = FALSE,
      initialExposureDuration = TRUE,
      initialQuantity = FALSE,
      cumulativeQuantity = FALSE,
      initialDailyDose = FALSE,
      cumulativeDose = FALSE,
      gapEra = 0,
      nameStyle = nameStyle,
      name = name
    )
}

#' To add a new column with the number of eras. To add multiple columns use
#' `addDrugUtilisation()` for efficiency.
#'
#' @inheritParams cohortDoc
#' @inheritParams conceptSetDoc
#' @inheritParams gapEraDoc
#' @inheritParams indexDateDoc
#' @inheritParams censorDateDoc
#' @inheritParams restrictIncidentDoc
#' @inheritParams nameStyleDoc
#' @inheritParams compNameDoc
#'
#' @return The same cohort with the added column.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(CodelistGenerator)
#' library(dplyr, warn.conflicts = FALSE)
#'
#' cdm <- mockDrugUtilisation()
#' codelist <- getDrugIngredientCodes(cdm = cdm, name = "acetaminophen")
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "dus_cohort",
#'                                         conceptSet = codelist)
#'
#' cdm$dus_cohort |>
#'   addNumberEras(conceptSet = codelist, gapEra = 1) |>
#'   glimpse()
#' }
#'
addNumberEras <- function(cohort,
                          conceptSet,
                          gapEra,
                          indexDate = "cohort_start_date",
                          censorDate = "cohort_end_date",
                          restrictIncident = TRUE,
                          nameStyle = "number_eras_{concept_name}",
                          name = NULL) {
  conceptSet <- validateConceptSet(conceptSet)
  cohort |>
    addDrugUseInternal(
      indexDate = indexDate,
      censorDate = censorDate,
      conceptSet = conceptSet,
      ingredientConceptId = NULL,
      restrictIncident = restrictIncident,
      numberExposures = FALSE,
      numberEras = TRUE,
      daysExposed = FALSE,
      daysPrescribed = FALSE,
      timeToExposure = FALSE,
      initialExposureDuration = FALSE,
      initialQuantity = FALSE,
      cumulativeQuantity = FALSE,
      initialDailyDose = FALSE,
      cumulativeDose = FALSE,
      gapEra = gapEra,
      nameStyle = nameStyle,
      name = name
    )
}

addDrugUseInternal <- function(x,
                               indexDate,
                               censorDate,
                               conceptSet,
                               ingredientConceptId,
                               restrictIncident,
                               numberExposures,
                               numberEras,
                               daysExposed,
                               daysPrescribed,
                               timeToExposure,
                               initialExposureDuration,
                               initialQuantity,
                               cumulativeQuantity,
                               initialDailyDose,
                               cumulativeDose,
                               gapEra,
                               name,
                               nameStyle,
                               call = parent.frame()) {
  # initial checks
  omopgenerics::assertCharacter(indexDate, call = call)
  omopgenerics::assertCharacter(censorDate, call = call)
  omopgenerics::assertTable(x, class = "cdm_table", columns = c(indexDate, censorDate), call = call)
  omopgenerics::assertNumeric(ingredientConceptId, integerish = TRUE, null = TRUE, call = call)
  cdm <- omopgenerics::cdmReference(x)
  if (is.null(conceptSet)) {
    if (is.null(ingredientConceptId)) {
      cli::cli_abort("`ingredientConceptId` or `conceptSet` must be provided.", call = call)
    } else {
      # https://github.com/darwin-eu-dev/omopgenerics/issues/618
      # conceptSet <- purrr::map(ingredientConceptId, \(x) {
      #   dplyr::tibble(concept_id = x, excluded = FALSE, descendants = TRUE, mapped = FALSE)
      # }) |>
      #   rlang::set_names(paste0("ingredient_", ingredientConceptId, "_descendants")) |>
      #   omopgenerics::newConceptSetExpression()
      conceptSet <- purrr::map(ingredientConceptId, \(x) {
        cdm[["concept_ancestor"]] |>
          dplyr::filter(.data$ancestor_concept_id %in% .env$x) |>
          dplyr::pull("descendant_concept_id") |>
          as.integer()
      }) |>
        rlang::set_names(paste0("ingredient_", ingredientConceptId, "_descendants")) |>
        omopgenerics::newCodelist()
    }
  }
  conceptSet <- validateConceptSet(conceptSet, call = call)
  omopgenerics::assertLogical(restrictIncident, length = 1, call = call)
  omopgenerics::assertLogical(numberExposures, length = 1, call = call)
  omopgenerics::assertLogical(numberEras, length = 1, call = call)
  omopgenerics::assertLogical(daysExposed, length = 1, call = call)
  omopgenerics::assertLogical(daysPrescribed, length = 1, call = call)
  omopgenerics::assertLogical(timeToExposure, length = 1, call = call)
  omopgenerics::assertLogical(initialQuantity, length = 1, call = call)
  omopgenerics::assertLogical(cumulativeQuantity, length = 1, call = call)
  omopgenerics::assertLogical(initialDailyDose, length = 1, call = call)
  omopgenerics::assertLogical(cumulativeDose, length = 1, call = call)
  omopgenerics::assertLogical(initialExposureDuration, length = 1, call = call)
  omopgenerics::assertNumeric(gapEra, integerish = TRUE, min = 0, length = 1, call = call)
  nValues <- sum(c(
    numberExposures, numberEras, daysExposed, timeToExposure, initialQuantity,
    cumulativeQuantity, initialDailyDose, cumulativeDose,
    initialExposureDuration
  ))
  nameStyle <- validateNameStyle(nameStyle, ingredientConceptId, conceptSet, nValues, call)
  name <- omopgenerics::validateNameArgument(name, null = TRUE, call = call, validation = "warning")
  nameStyle <- gsub("{value}", "{.value}", x = nameStyle, fixed = TRUE)
  nameStyleI <- noIngredientNameStyle(nameStyle)

  if ((initialDailyDose | cumulativeDose) & is.null(ingredientConceptId)) {
    "{.strong ingredientConceptId} can not be NULL for dose calculations" |>
      cli::cli_abort(call = call)
  }
  tablePrefix <- omopgenerics::tmpPrefix()

  nm1 <- omopgenerics::uniqueTableName(tablePrefix)
  cdm <- omopgenerics::insertTable(
    cdm = cdm, name = nm1, table = conceptSetTibble(conceptSet), temporary = F
  )

  id <- omopgenerics::getPersonIdentifier(x)
  idFuture <- omopgenerics::uniqueId(exclude = colnames(x))

  xdates <- x |>
    dplyr::select(dplyr::all_of(c(id, indexDate, censorDate))) |>
    dplyr::distinct() |>
    PatientProfiles::addFutureObservation(
      indexDate = indexDate,
      futureObservationName = idFuture,
      futureObservationType = "date",
      name = omopgenerics::uniqueTableName(tablePrefix)
    )
  if (is.null(censorDate)) {
    cols <- c(id, indexDate)
    censorDate <- idFuture
  } else {
    xdates <- xdates |>
      dplyr::mutate(!!censorDate := dplyr::if_else(
        is.na(.data[[censorDate]]),
        .data[[idFuture]],
        .data[[censorDate]]
      )) |>
      dplyr::select(-dplyr::all_of(idFuture))
    cols <- c(id, indexDate, censorDate)
  }

  drugData <- xdates |>
    dplyr::inner_join(
      cdm$drug_exposure |>
        dplyr::inner_join(cdm[[nm1]], by = "drug_concept_id") |>
        dplyr::select(
          !!id := "person_id", "drug_exposure_start_date",
          "drug_exposure_end_date", "quantity", "drug_concept_id",
          "concept_name"
        ),
      by = id
    ) |>
    dplyr::mutate("drug_exposure_end_date" = dplyr::if_else(
      is.na(.data$drug_exposure_end_date),
      .data$drug_exposure_start_date,
      .data$drug_exposure_end_date
    )) |>
    dplyr::filter(
      .data$drug_exposure_start_date <= .data$drug_exposure_end_date
    )
  if (restrictIncident) {
    drugData <- drugData |>
      dplyr::filter(
        .data$drug_exposure_start_date >= .data[[indexDate]] &
          .data$drug_exposure_start_date <= .data[[censorDate]]
      )
  } else {
    drugData <- drugData |>
      dplyr::filter(
        .data$drug_exposure_start_date <= .data[[censorDate]] &
          .data$drug_exposure_end_date >= .data[[indexDate]]
      )
  }
  drugData <- drugData |>
    dplyr::compute(
      name = omopgenerics::uniqueTableName(tablePrefix), temporary = FALSE
    )

  if (cumulativeQuantity | numberExposures | timeToExposure) {
    qs <- c(
      "as.integer(dplyr::n())",
      "min(.data$drug_exposure_start_date, na.rm = TRUE)",
      "as.numeric(sum(.data$quantity, na.rm = TRUE))"
    ) |>
      rlang::parse_exprs() |>
      rlang::set_names(c(
        "number_exposures", "time_to_exposure", "cumulative_quantity"
      ))
    qs <- qs[c(numberExposures, timeToExposure, cumulativeQuantity)]
    toJoin <- drugData |>
      dplyr::group_by(dplyr::across(dplyr::all_of(c(cols, "concept_name")))) %>%
      dplyr::summarise(!!!qs, .groups = "drop")
    if (timeToExposure) {
      toJoin <- toJoin %>%
        dplyr::mutate("time_to_exposure" = dplyr::if_else(
          .data$time_to_exposure <= .data[[indexDate]],
          0L,
          as.integer(!!CDMConnector::datediff(start = indexDate, end = "time_to_exposure"))
        ))
    }
    x <- x |>
      dplyr::left_join(
        toJoin |>
          tidyr::pivot_wider(
            names_from = "concept_name",
            names_glue = nameStyleI,
            values_from = dplyr::all_of(names(qs))
          ),
        by = cols,
        suffix = c(".to_drop", "")
      ) |>
      dplyr::mutate(dplyr::across(
        dplyr::contains(c("number_exposures", "cumulative_quantity")),
        ~ dplyr::coalesce(.x, 0L)
      )) |>
      compute2(name)
  }

  if (initialQuantity | initialExposureDuration) {
    qs <- c(
      "as.numeric(sum(.data$quantity, na.rm = TRUE))",
      "max(as.integer(local(CDMConnector::datediff(
        start = 'drug_exposure_start_date', end = 'drug_exposure_end_date'
      ))) + 1L, na.rm = TRUE)"
    ) |>
      rlang::parse_exprs() |>
      rlang::set_names(c("initial_quantity", "initial_exposure_duration"))
    qs <- qs[c(initialQuantity, initialExposureDuration)]
    x <- x |>
      dplyr::left_join(
        drugData |>
          dplyr::group_by(dplyr::across(dplyr::all_of(c(cols, "concept_name")))) |>
          dplyr::filter(.data$drug_exposure_start_date == min(.data$drug_exposure_start_date, na.rm = TRUE)) %>%
          dplyr::summarise(!!!qs, .groups = "drop") |>
          tidyr::pivot_wider(
            names_from = "concept_name",
            names_glue = nameStyleI,
            values_from = dplyr::all_of(names(qs))
          ),
        by = cols,
        suffix = c(".to_drop", "")
      ) |>
      dplyr::mutate(dplyr::across(
        dplyr::contains("initial_quantity"), ~ dplyr::coalesce(.x, 0L)
      )) |>
      compute2(name)
  }

  if (numberEras | daysExposed) {
    toJoin <- drugData |>
      erafy(
        start = "drug_exposure_start_date",
        end = "drug_exposure_end_date",
        group = c(cols, "concept_name"),
        gap = gapEra
      )
    if (daysExposed) {
      toJoin <- toJoin |>
        dplyr::mutate(
          "drug_exposure_start_date" = dplyr::if_else(
            .data$drug_exposure_start_date <= .data[[indexDate]],
            .data[[indexDate]], .data$drug_exposure_start_date
          ),
          "drug_exposure_end_date" = dplyr::if_else(
            .data$drug_exposure_end_date >= .data[[censorDate]],
            .data[[censorDate]], .data$drug_exposure_end_date
          )
        ) %>%
        dplyr::mutate("exposed_time" = as.integer(!!CDMConnector::datediff(
          start = "drug_exposure_start_date",
          end = "drug_exposure_end_date",
          interval = "day"
        )) + 1L)
    }
    qs <- c(
      "as.integer(dplyr::n())",
      "as.integer(sum(.data$exposed_time, na.rm = TRUE))"
    ) |>
      rlang::parse_exprs() |>
      rlang::set_names(c("number_eras", "days_exposed"))
    qs <- qs[c(numberEras, daysExposed)]
    x <- x |>
      dplyr::left_join(
        toJoin |>
          dplyr::group_by(dplyr::across(dplyr::all_of(c(cols, "concept_name")))) |>
          dplyr::summarise(!!!qs, .groups = "drop") |>
          tidyr::pivot_wider(
            names_from = "concept_name",
            names_glue = nameStyleI,
            values_from = dplyr::all_of(names(qs))
          ),
        by = cols,
        suffix = c(".to_drop", "")
      ) |>
      dplyr::mutate(dplyr::across(
        dplyr::contains(names(qs)), ~ dplyr::coalesce(.x, 0L)
      )) |>
      compute2(name)
  }

  if (initialDailyDose | cumulativeDose | daysPrescribed) {
    if (!cumulativeDose & !daysPrescribed) {
      drugData <- drugData |>
        dplyr::group_by(dplyr::across(dplyr::all_of(c(cols, "concept_name")))) |>
        dplyr::filter(
          .data$drug_exposure_start_date == min(
            .data$drug_exposure_start_date,
            na.rm = TRUE
          ) |
            .data$drug_exposure_start_date <= .data[[indexDate]]
        ) |>
        dplyr::ungroup()
    }
    drugData <- drugData |>
      dplyr::mutate(
        "start_contribution" = dplyr::if_else(
          .data[[indexDate]] <= .data$drug_exposure_start_date,
          .data$drug_exposure_start_date,
          .data[[indexDate]]
        ),
        "end_contribution" = dplyr::if_else(
          .data[[censorDate]] >= .data$drug_exposure_end_date,
          .data$drug_exposure_end_date,
          .data[[censorDate]]
        )
      ) %>%
      dplyr::mutate("exposure_duration" = as.integer(!!CDMConnector::datediff(
        start = "start_contribution", end = "end_contribution"
      )) + 1L) |>
      dplyr::select(-c("start_contribution", "end_contribution")) |>
      dplyr::compute(
        name = omopgenerics::uniqueTableName(tablePrefix), temporary = FALSE
      )

    if (daysPrescribed) {
      x <- x |>
        dplyr::left_join(
          drugData |>
            dplyr::group_by(dplyr::across(dplyr::all_of(c(cols, "concept_name")))) |>
            dplyr::summarise(
              "days_prescribed" = as.integer(sum(.data$exposure_duration, na.rm = TRUE)),
              .groups = "drop"
            ) |>
            tidyr::pivot_wider(
              names_from = "concept_name",
              names_glue = nameStyleI,
              values_from = "days_prescribed"
            ),
          by = cols,
          suffix = c(".to_drop", "")
        ) |>
        dplyr::mutate(dplyr::across(
          dplyr::contains("days_prescribed"), ~ dplyr::coalesce(.x, 0L)
        )) |>
        compute2(name)
    }

    for (k in seq_along(ingredientConceptId)) {
      nameStyleI <- ingredientNameStyle(nameStyle, ingredientConceptId[k])
      nm <- omopgenerics::uniqueTableName(tablePrefix)
      toJoin <- drugData |>
        .addDailyDose(ingredientConceptId = ingredientConceptId[k], name = nm) |>
        dplyr::filter(!is.na(.data$daily_dose) & !is.na(.data$unit))
      if (cumulativeDose) {
        x <- x |>
          dplyr::left_join(
            toJoin |>
              dplyr::group_by(dplyr::across(dplyr::all_of(c(cols, "concept_name", "unit")))) |>
              dplyr::summarise(
                "cumulative_dose" = sum(.data$daily_dose * .data$exposure_duration, na.rm = TRUE),
                .groups = "drop"
              ) |>
              tidyr::pivot_wider(
                names_from = c("concept_name", "unit"),
                names_glue = nameStyleI,
                values_from = "cumulative_dose"
              ),
            by = cols,
            suffix = c(".to_drop", "")
          ) |>
          dplyr::mutate(dplyr::across(
            dplyr::contains("cumulative_dose"), ~ dplyr::coalesce(.x, 0)
          )) |>
          compute2(name)
      }
      if (initialDailyDose) {
        if (cumulativeDose | daysPrescribed) {
          toJoin <- toJoin |>
            dplyr::group_by(dplyr::across(dplyr::all_of(c(cols, "concept_name")))) |>
            dplyr::filter(
              .data$drug_exposure_start_date == min(
                .data$drug_exposure_start_date,
                na.rm = TRUE
              ) |
                .data$drug_exposure_start_date <= .data[[indexDate]]
            ) |>
            dplyr::ungroup()
        }
        x <- x |>
          dplyr::left_join(
            toJoin |>
              dplyr::group_by(dplyr::across(dplyr::all_of(c(cols, "concept_name", "unit")))) |>
              dplyr::summarise(
                "initial_daily_dose" = sum(.data$daily_dose, na.rm = TRUE),
                .groups = "drop"
              ) |>
              tidyr::pivot_wider(
                names_from = c("concept_name", "unit"),
                names_glue = nameStyleI,
                values_from = "initial_daily_dose"
              ),
            by = cols,
            suffix = c(".to_drop", "")
          ) |>
          dplyr::mutate(dplyr::across(
            dplyr::contains("initial_daily_dose"), ~ dplyr::coalesce(.x, 0)
          )) |>
          compute2(name)
      }
      omopgenerics::dropSourceTable(cdm = cdm, name = nm)
    }
  }

  cols <- colnames(x) |>
    purrr::keep(\(x) endsWith(x, ".to_drop"))
  if (length(cols) > 0) {
    originalCol <- substr(cols, 1, nchar(cols)-8)
    cli::cli_warn("{.var {originalCol}} column{?s} overwritten.")
    x <- x |>
      dplyr::select(!dplyr::all_of(cols))
  }

  omopgenerics::dropSourceTable(cdm = cdm, name = dplyr::starts_with(tablePrefix))

  return(x)
}
compute2 <- function(x, name) {
  x <- x |>
    dplyr::rename_all(tolower)
  if (is.null(name)) {
    x <- x |> dplyr::compute()
  } else {
    x <- x |> dplyr::compute(name = name, temporary = FALSE)
  }
  return(x)
}

noIngredientNameStyle <- function(x) {
  x <- gsub("_{ingredient}", "", x, fixed = TRUE)
  x <- gsub("{ingredient}_", "", x, fixed = TRUE)
  return(x)
}
ingredientNameStyle <- function(x, ing) {
  x <- gsub("{ingredient}", as.character(ing), x, fixed = TRUE)
  x <- gsub("{.value}", "{.value}_{unit}", x, fixed = TRUE)
  return(x)
}
conceptSetTibble <- function(conceptSet) {
  purrr::map(conceptSet, dplyr::as_tibble) |>
    dplyr::bind_rows(.id = "concept_name") |>
    dplyr::rename("drug_concept_id" = "value")
}
