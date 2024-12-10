
#' Helper for consistent documentation of `result`.
#'
#' @param result A summarised_result object.
#'
#' @name resultDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `table`.
#'
#' @param type Type of table. Check supported types with
#' `visOmopResults::tableType()`.
#' @param header Columns to use as header. See options with
#' `availableTableColumns(result)`.
#' @param groupColumn Columns to group by. See options with
#' `availableTableColumns(result)`.
#' @param hide Columns to hide from the visualisation. See options with
#' `availableTableColumns(result)`.
#'
#' @name tableDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `plot`.
#'
#' @param facet Columns to facet by. See options with
#' `availablePlotColumns(result)`. Formula is also allowed to specify rows and
#' columns.
#' @param colour Columns to color by. See options with
#' `availablePlotColumns(result)`.
#'
#' @name plotDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `cohort`.
#'
#' @param cohort A cohort_table object.
#'
#' @name cohortDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `cohortId`.
#'
#' @param cohortId A cohort definition id to restrict by. If NULL, all cohorts
#' will be included.
#'
#' @name cohortIdDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `strata`.
#'
#' @param strata A list of variables to stratify results. These variables
#' must have been added as additional columns in the cohort table.
#'
#' @name strataDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `numberExposures`.
#'
#' @param numberExposures Whether to include 'number_exposures' (number of drug
#' exposure records between indexDate and censorDate).
#'
#' @name numberExposuresDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `daysPrescribed`.
#'
#' @param daysPrescribed Whether to include 'days_prescribed' (number of days
#' prescribed used to create each era).
#'
#' @name daysPrescribedDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `add`/`summariseDrugUtilisation`
#' functions.
#'
#' @param numberExposures Whether to include 'number_exposures' (number of drug
#' exposure records between indexDate and censorDate).
#' @param numberEras Whether to include 'number_eras' (number of continuous
#' exposure episodes between indexDate and censorDate).
#' @param daysExposed Whether to include 'days_exposed' (number of days that the
#' individual is in a continuous exposure episode, including allowed treatment
#' gaps, between indexDate and censorDate; sum of the length of the different
#' drug eras).
#' @param daysPrescribed Whether to include 'days_prescribed' (sum of the number
#' of days for each prescription that contribute in the analysis).
#' @param timeToExposure Whether to include 'time_to_exposure' (number of days
#' between indexDate and the first episode).
#' @param initialExposureDuration Whether to include 'initial_exposure_duration'
#' (number of prescribed days of the first drug exposure record).
#' @param initialQuantity Whether to include 'initial_quantity' (quantity of the
#' first drug exposure record).
#' @param cumulativeQuantity Whether to include 'cumulative_quantity' (sum of
#' the quantity of the different exposures considered in the analysis).
#' @param initialDailyDose Whether to include 'initial_daily_dose_\{unit\}'
#' (daily dose of the first considered prescription).
#' @param cumulativeDose Whether to include 'cumulative_dose_\{unit\}' (sum of
#' the cumulative dose of the analysed drug exposure records).
#' @param exposedTime deprecated.
#'
#' @name drugUtilisationDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `gapEra`.
#'
#' @param gapEra Number of days between two continuous exposures to be
#' considered in the same era.
#'
#' @name gapEraDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `conceptSet`.
#'
#' @param conceptSet List of concepts to be included.
#'
#' @name conceptSetDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `ingredientConceptId`.
#'
#' @param ingredientConceptId Ingredient OMOP concept that we are interested for
#' the study.
#'
#' @name ingredientConceptIdDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `indexDate`.
#'
#' @param indexDate Name of a column that indicates the date to start the
#' analysis.
#'
#' @name indexDateDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `censorDate`.
#'
#' @param censorDate Name of a column that indicates the date to stop the
#' analysis, if NULL end of individuals observation is used.
#'
#' @name censorDateDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `nameStyle`.
#'
#' @param nameStyle Character string to specify the nameStyle of the new columns.
#'
#' @name nameStyleDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `name` for computed tables.
#'
#' @param name Name of the new computed cohort table, if NULL a temporary table
#' will be created.
#'
#' @name compNameDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `name` for new cohorts.
#'
#' @param name Name of the new cohort table, it must be a length 1 character
#' vector.
#'
#' @name newNameDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `restrictIncident`.
#'
#' @param restrictIncident Whether to include only incident prescriptions in the
#' analysis. If FALSE all prescriptions that overlap with the study period will
#' be included.
#'
#' @name restrictIncidentDoc
#' @keywords internal
NULL

#' Helper for consistent documentation of `cdm`.
#'
#' @param cdm A `cdm_reference` object.
#'
#' @name cdmDoc
#' @keywords internal
NULL
