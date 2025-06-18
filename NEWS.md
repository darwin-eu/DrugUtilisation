# DrugUtilisation 1.0.3

* Skip some tests for regression in duckdb by @catalamarti

# DrugUtilisation 1.0.2

* Add examples of atc and ingredient documentation by @catalamarti
* Add summariseTreatment input information in vignette by @KimLopezGuell
* Drug restart documentation by @KimLopezGuell
* Add drug utilisation documentation by @KimLopezGuell
* Update equation daily dose vignette by @KimLopezGuell
* Compatibility with omopgenerics 1.2.0 by @catalamarti
* Homogenise examples by @catalamarti

# DrugUtilisation 1.0.1

* lifecycle stable by @catalamarti
* Correct settings to not be NA by @catalamarti 
* add .options argument by @catalamarti 

# DrugUtilisation 1.0.0

* Stable release.
* plotPPC between 0 and 100% by @catalamarti
* add observation_period_id in erafy by @catalamarti
* use window_name as factor in plotTreatment/Indication by @catalamarti
* remove lifecycle tags 1.0.0 by @catalamarti
* use mockDisconnect in all tests by @catalamarti
* Change default of tables to hide all settings by @catalamarti
* Test validateNameStyle by @catalamarti
* update requirePriorDrugWashout to <= to align with IncidencePrevalence by @catalamarti

# DrugUtilisation 0.8.3

* Add +1L to initialExposureDuration to calculate duration as `end - start + 1` by @catalamarti

# DrugUtilisation 0.8.2

* Fix snowflake edge case with duplicated prescriptions by @catalamarti

# DrugUtilisation 0.8.1

* Arguments recorded in summarise* functions by @catalamarti
* Improved performance of addIndication, addTreatment, summariseIndication, summariseTreatment by @catalamarti

# DrugUtilisation 0.8.0

## New features
* Add argument ... to generateATC/IngredientCohortSet by @catalamarti
* benchmarkDrugUtilisation to test all functions by @MimiYuchenGuo
* Add confidence intervals to PPC by @catalamarti
* Export erafyCohort by @catalamarti
* Add numberExposures and daysPrescribed to generate functions by @catalamarti
* Add subsetCohort and subsetCohortId arguments to cohort creation functions by @catalamarti
* New function: addDrugRestart by @catalamarti
* Add initialExposureDuration by @catalamarti
* add cohortId to summarise* functions by @catalamarti
* addDaysPrescribed by @catalamarti
* plotDrugUtilisation by @catalamarti

## Minor updates
* Account for omopgenerics 0.4.0 by @catalamarti
* Add messages about dropped records in cohort creation by @catalamarti
* Refactor of table functions following visOmopResults 0.5.0 release by @catalamart
* Cast settings to characters by @catalamarti
* checkVersion utility function for tables and plots by @catalamarti
* Deprecation warnings to errors for deprecated arguments in geenrateDrugUtilisation by @catalamarti
* Add message if too many indications by @catalamarti
* not treated -> untreated by @catalamarti
* warn overwrite columns by @catalamarti
* Use omopgenerics assert function by @catalamarti
* add documentation helpers for consistent argument documentation by @catalamarti
* exposedTime -> daysExposed by @catalamarti
* Fix cast warning in mock by @catalamarti
* test addDaysPrescribed by @catalamarti
* refactor plots to use visOmopResults plot tools by @catalamarti

## Bug fix
* allow integer64 in sampleSize by @catalamarti

# DrugUtilisation 0.7.0

* Deprecate dose specific functions: `addDailyDose`, `addRoute`, 
  `stratifyByUnit`.
  
* Deprecate drug use functions: `addDrugUse`, `summariseDrugUse`.

* Rename `dailyDoseCoverage` -> `summariseDoseCoverage`.

* Refactor of `addIndication` to create a categorical variable per window.

* New functionality `summariseProportionOfPatientsCovered`,
  `tableProportionOfPatientsCovered` and `plotProportionOfPatientsCovered`.

* Create `require*` functions.

* New functionality `summariseDrugRestart`, `tableDrugRestart` and 
  `plotDrugRestart`.

* New functionality `addDrugUtilisation`, `summariseDrugUtilisation` and 
  `tableDrugUtilisation`
