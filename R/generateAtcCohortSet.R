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

#' Generate a set of drug cohorts based on ATC classification
#'
#' @description
#' Adds a new cohort table to the cdm reference with individuals who have drug
#' exposure records that belong to the specified Anatomical Therapeutic Chemical
#' (ATC) classification. Cohort start and end dates will be based on drug record
#' start and end dates, respectively. Records that overlap or have fewer days
#' between them than the specified gap era will be concatenated into a single
#' cohort entry.
#'
#' @inheritParams cdmDoc
#' @inheritParams newNameDoc
#' @param atcName Names of ATC classification of interest.
#' @param gapEra Number of days between two continuous exposures to be
#' considered in the same era. Records that have fewer days between them than
#' this gap will be concatenated into the same cohort record.
#' @param subsetCohort Cohort table to subset.
#' @param subsetCohortId Cohort id to subset.
#' @inheritParams numberExposuresDoc
#' @inheritParams daysPrescribedDoc
#' @param ... Arguments to be passed to `CodelistGenerator::getATCCodes()`.
#'
#' @return The function returns the cdm reference provided with the addition of
#' the new cohort table.
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(dplyr, warn.conflicts = FALSE)
#'
#' cdm <- mockDrugUtilisation()
#'
#' cdm <- generateAtcCohortSet(cdm = cdm,
#'                             atcName = "alimentary tract and metabolism",
#'                             name = "drugs")
#'
#' cdm$drugs |>
#'   glimpse()
#' }
generateAtcCohortSet <- function(cdm,
                                 name,
                                 atcName = NULL,
                                 gapEra = 1,
                                 subsetCohort = NULL,
                                 subsetCohortId = NULL,
                                 numberExposures = FALSE,
                                 daysPrescribed = FALSE,
                                 ...) {
  generateSubFunctions(
    type = "atc",
    cdm = cdm,
    name = name,
    nam = atcName,
    gapEra = gapEra,
    subsetCohort = subsetCohort,
    subsetCohortId = subsetCohortId,
    numberExposures = numberExposures,
    daysPrescribed = daysPrescribed,
    ...
  )
}
