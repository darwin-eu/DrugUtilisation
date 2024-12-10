# DrugUtilisation 0.8.0

* Account for omopgenerics 0.4.0 by @catalamarti
* Add argument ... to generateATC/IngredientCohortSet by @catalamarti
* benchmarkDrugUtilisation to test all functions by @MimiYuchenGuo
* Add messages about dropped records in cohort creation by @catalamarti
* Refactor of table functions following visOmopResults 0.5.0 release by @catalamart
* Add confidence intervals to PPC by @catalamarti
* Cast settings to characters by @catalamarti
* checkVersion utility function for tables and plots by @catalamarti
* Export erafyCohort by @catalamarti
* Deprecation warnings to errors for deprecated arguments in geenrateDrugUtilisation by @catalamarti
* Add numberExposures and daysPrescribed to generate functions by @catalamarti
* Add subsetCohort and subsetCohortId arguments to cohort creation functions by @catalamarti
* New function: addDrugRestart by @catalamarti
* Add initialExposureDuration by @catalamarti
* Add message if too many indications by @catalamarti
* not treated -> untreated by @catalamarti
* warn overwrite columns by @catalamarti
* Use omopgenerics assert function by @catalamarti
* add documentation helpers for consistent argument documentation by @catalamarti
* allow integer64 in sampleSize by @catalamarti
* add cohortId to summarise* functions by @catalamarti
* Fix cast warning in mock by @catalamarti
* addDaysPrescribed by @catalamarti
* exposedTime -> daysExposed by @catalamarti
* test addDaysPrescribed by @catalamarti
* plotDrugUtilisation by @catalamarti
* refactor plots to use visOmopResults plot tools by @catalamarti

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
