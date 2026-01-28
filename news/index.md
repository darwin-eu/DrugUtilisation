# Changelog

## DrugUtilisation 1.1.0

- Export
  [`addDailyDose()`](https://darwin-eu.github.io/DrugUtilisation/reference/addDailyDose.md)
  function by [@catalamarti](https://github.com/catalamarti) in
  [\#749](https://github.com/darwin-eu/DrugUtilisation/issues/749)

## DrugUtilisation 1.0.5

CRAN release: 2025-11-19

- Explictly copy data into the database using insertTable by
  [@ablack3](https://github.com/ablack3) in
  [\#727](https://github.com/darwin-eu/DrugUtilisation/issues/727)
- Correct as.numeric of datediff by
  [@catalamarti](https://github.com/catalamarti) in
  [\#731](https://github.com/darwin-eu/DrugUtilisation/issues/731)
- Add style argument in tables and figures by
  [@catalamarti](https://github.com/catalamarti) in
  [\#734](https://github.com/darwin-eu/DrugUtilisation/issues/734)
- Call libraries explicitly in vignettes by
  [@catalamarti](https://github.com/catalamarti) in
  [\#739](https://github.com/darwin-eu/DrugUtilisation/issues/739)
- Include in vignette how to use days prescribed by
  [@catalamarti](https://github.com/catalamarti) in
  [\#743](https://github.com/darwin-eu/DrugUtilisation/issues/743)
- tests edge case by [@catalamarti](https://github.com/catalamarti) in
  [\#744](https://github.com/darwin-eu/DrugUtilisation/issues/744)
- Support local datasets and standardise testing by
  [@catalamarti](https://github.com/catalamarti) in
  [\#736](https://github.com/darwin-eu/DrugUtilisation/issues/736)
- Review mock data vignette by
  [@catalamarti](https://github.com/catalamarti) in
  [\#745](https://github.com/darwin-eu/DrugUtilisation/issues/745)
- add plotIndication params by [@ginberg](https://github.com/ginberg) in
  [\#740](https://github.com/darwin-eu/DrugUtilisation/issues/740)
- add type and style as NULL to use default values by
  [@catalamarti](https://github.com/catalamarti) in
  [\#747](https://github.com/darwin-eu/DrugUtilisation/issues/747)

## DrugUtilisation 1.0.4

CRAN release: 2025-07-02

- Fix plotDrugUtilisation combining different cdm_name by
  [@catalamarti](https://github.com/catalamarti)

## DrugUtilisation 1.0.3

CRAN release: 2025-06-03

- Skip some tests for regression in duckdb by
  [@catalamarti](https://github.com/catalamarti)

## DrugUtilisation 1.0.2

CRAN release: 2025-05-13

- Add examples of atc and ingredient documentation by
  [@catalamarti](https://github.com/catalamarti)
- Add summariseTreatment input information in vignette by
  [@KimLopezGuell](https://github.com/KimLopezGuell)
- Drug restart documentation by
  [@KimLopezGuell](https://github.com/KimLopezGuell)
- Add drug utilisation documentation by
  [@KimLopezGuell](https://github.com/KimLopezGuell)
- Update equation daily dose vignette by
  [@KimLopezGuell](https://github.com/KimLopezGuell)
- Compatibility with omopgenerics 1.2.0 by
  [@catalamarti](https://github.com/catalamarti)
- Homogenise examples by [@catalamarti](https://github.com/catalamarti)

## DrugUtilisation 1.0.1

CRAN release: 2025-04-15

- lifecycle stable by [@catalamarti](https://github.com/catalamarti)
- Correct settings to not be NA by
  [@catalamarti](https://github.com/catalamarti)
- add .options argument by
  [@catalamarti](https://github.com/catalamarti)

## DrugUtilisation 1.0.0

CRAN release: 2025-03-27

- Stable release.
- plotPPC between 0 and 100% by
  [@catalamarti](https://github.com/catalamarti)
- add observation_period_id in erafy by
  [@catalamarti](https://github.com/catalamarti)
- use window_name as factor in plotTreatment/Indication by
  [@catalamarti](https://github.com/catalamarti)
- remove lifecycle tags 1.0.0 by
  [@catalamarti](https://github.com/catalamarti)
- use mockDisconnect in all tests by
  [@catalamarti](https://github.com/catalamarti)
- Change default of tables to hide all settings by
  [@catalamarti](https://github.com/catalamarti)
- Test validateNameStyle by
  [@catalamarti](https://github.com/catalamarti)
- update requirePriorDrugWashout to \<= to align with
  IncidencePrevalence by [@catalamarti](https://github.com/catalamarti)

## DrugUtilisation 0.8.3

CRAN release: 2025-03-20

- Add +1L to initialExposureDuration to calculate duration as
  `end - start + 1` by [@catalamarti](https://github.com/catalamarti)

## DrugUtilisation 0.8.2

CRAN release: 2025-01-16

- Fix snowflake edge case with duplicated prescriptions by
  [@catalamarti](https://github.com/catalamarti)

## DrugUtilisation 0.8.1

CRAN release: 2024-12-19

- Arguments recorded in summarise\* functions by
  [@catalamarti](https://github.com/catalamarti)
- Improved performance of addIndication, addTreatment,
  summariseIndication, summariseTreatment by
  [@catalamarti](https://github.com/catalamarti)

## DrugUtilisation 0.8.0

CRAN release: 2024-12-10

### New features

- Add argument … to generateATC/IngredientCohortSet by
  [@catalamarti](https://github.com/catalamarti)
- benchmarkDrugUtilisation to test all functions by
  [@MimiYuchenGuo](https://github.com/MimiYuchenGuo)
- Add confidence intervals to PPC by
  [@catalamarti](https://github.com/catalamarti)
- Export erafyCohort by [@catalamarti](https://github.com/catalamarti)
- Add numberExposures and daysPrescribed to generate functions by
  [@catalamarti](https://github.com/catalamarti)
- Add subsetCohort and subsetCohortId arguments to cohort creation
  functions by [@catalamarti](https://github.com/catalamarti)
- New function: addDrugRestart by
  [@catalamarti](https://github.com/catalamarti)
- Add initialExposureDuration by
  [@catalamarti](https://github.com/catalamarti)
- add cohortId to summarise\* functions by
  [@catalamarti](https://github.com/catalamarti)
- addDaysPrescribed by [@catalamarti](https://github.com/catalamarti)
- plotDrugUtilisation by [@catalamarti](https://github.com/catalamarti)

### Minor updates

- Account for omopgenerics 0.4.0 by
  [@catalamarti](https://github.com/catalamarti)
- Add messages about dropped records in cohort creation by
  [@catalamarti](https://github.com/catalamarti)
- Refactor of table functions following visOmopResults 0.5.0 release by
  [@catalamart](https://github.com/catalamart)
- Cast settings to characters by
  [@catalamarti](https://github.com/catalamarti)
- checkVersion utility function for tables and plots by
  [@catalamarti](https://github.com/catalamarti)
- Deprecation warnings to errors for deprecated arguments in
  geenrateDrugUtilisation by
  [@catalamarti](https://github.com/catalamarti)
- Add message if too many indications by
  [@catalamarti](https://github.com/catalamarti)
- not treated -\> untreated by
  [@catalamarti](https://github.com/catalamarti)
- warn overwrite columns by
  [@catalamarti](https://github.com/catalamarti)
- Use omopgenerics assert function by
  [@catalamarti](https://github.com/catalamarti)
- add documentation helpers for consistent argument documentation by
  [@catalamarti](https://github.com/catalamarti)
- exposedTime -\> daysExposed by
  [@catalamarti](https://github.com/catalamarti)
- Fix cast warning in mock by
  [@catalamarti](https://github.com/catalamarti)
- test addDaysPrescribed by
  [@catalamarti](https://github.com/catalamarti)
- refactor plots to use visOmopResults plot tools by
  [@catalamarti](https://github.com/catalamarti)

### Bug fix

- allow integer64 in sampleSize by
  [@catalamarti](https://github.com/catalamarti)

## DrugUtilisation 0.7.0

CRAN release: 2024-07-29

- Deprecate dose specific functions: `addDailyDose`, `addRoute`,
  `stratifyByUnit`.

- Deprecate drug use functions: `addDrugUse`, `summariseDrugUse`.

- Rename `dailyDoseCoverage` -\> `summariseDoseCoverage`.

- Refactor of `addIndication` to create a categorical variable per
  window.

- New functionality `summariseProportionOfPatientsCovered`,
  `tableProportionOfPatientsCovered` and
  `plotProportionOfPatientsCovered`.

- Create `require*` functions.

- New functionality `summariseDrugRestart`, `tableDrugRestart` and
  `plotDrugRestart`.

- New functionality `addDrugUtilisation`, `summariseDrugUtilisation` and
  `tableDrugUtilisation`
