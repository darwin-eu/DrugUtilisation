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
#' `r lifecycle::badge("defunct")`
#'
#' @param cohort Cohort in the cdm
#' @param cdm deprecated
#' @param ingredientConceptId Ingredient OMOP concept that we are interested for
#' the study. It is a compulsory input, no default value is provided.
#' @param conceptSet List of concepts to be included. If NULL all the
#' descendants of ingredient concept id will be used.
#' @param duration Whether to add duration related columns.
#' @param quantity Whether to add quantity related columns.
#' @param dose Whether to add dose related columns.
#' @param gapEra Number of days between two continuous exposures to be
#' considered in the same era.
#' @param eraJoinMode How two different continuous exposures are joined in an
#' era. There are four options:
#' "zero" the exposures are joined considering that the period between both
#' continuous exposures the subject is treated with a daily dose of zero. The
#' time between both exposures contributes to the total exposed time.
#' "join" the exposures are joined considering that the period between both
#' continuous exposures the subject is treated with a daily dose of zero. The
#' time between both exposures does not contribute to the total exposed time.
#' "previous" the exposures are joined considering that the period between both
#' continuous exposures the subject is treated with the daily dose of the
#' previous subexposure. The time between both exposures contributes to the
#' total exposed time.
#' "subsequent" the exposures are joined considering that the period between
#' both continuous exposures the subject is treated with the daily dose of the
#' subsequent subexposure. The time between both exposures contributes to the
#' total exposed time.
#' @param overlapMode How the overlapping between two exposures that do not
#' start on the same day is solved inside a subexposure. There are five possible
#'  options:
#' "previous" the considered daily_dose is the one of the earliest exposure.
#' "subsequent" the considered daily_dose is the one of the new exposure that
#' starts in that subexposure.
#' "minimum" the considered daily_dose is the minimum of all of the exposures in
#' the subexposure.
#' "maximum" the considered daily_dose is the maximum of all of the exposures in
#' the subexposure.
#' "sum" the considered daily_dose is the sum of all the exposures present in
#' the subexposure.
#' @param sameIndexMode How the overlapping between two exposures that start on
#' the same day is solved inside a subexposure. There are three possible options:
#' "minimum" the considered daily_dose is the minimum of all of the exposures in
#' the subexposure.
#' "maximum" the considered daily_dose is the maximum of all of the exposures in
#' the subexposure.
#' "sum" the considered daily_dose is the sum of all the exposures present in
#' the subexposure.
#' @param imputeDuration Whether/how the duration should be imputed
#' "none", "median", "mean", "mode" or a number
#' @param imputeDailyDose Whether/how the daily_dose should be imputed
#' "none", "median", "mean", "mode" or a number
#' @param durationRange Range between the duration must be comprised. It should
#' be a numeric vector of length two, with no NAs and the first value should be
#' equal or smaller than the second one. It must not be NULL if imputeDuration
#' is not "none". If NULL no restrictions are applied.
#' @param dailyDoseRange Range between the daily_dose must be comprised. It
#' should be a numeric vector of length two, with no NAs and the first value
#' should be equal or smaller than the second one. It must not be NULL if
#' imputeDailyDose is not "none". If NULL no restrictions are applied.
#'
#' @return The same cohort with the added columns.
#'
#' @export
#'
addDrugUse <- function(cohort,
                       cdm = lifecycle::deprecated(),
                       ingredientConceptId,
                       conceptSet = NULL,
                       duration = TRUE,
                       quantity = TRUE,
                       dose = TRUE,
                       gapEra = 0,
                       eraJoinMode = "zero",
                       overlapMode = "sum",
                       sameIndexMode = "sum",
                       imputeDuration = "none",
                       imputeDailyDose = "none",
                       durationRange = c(1, Inf),
                       dailyDoseRange = c(0, Inf)) {
  lifecycle::deprecate_stop(
    when = "0.7.0",
    what = "DrugUtilisation::addDrugUse()",
    with = "DrugUtilisation::addDrugUtilisation()"
  )
}
