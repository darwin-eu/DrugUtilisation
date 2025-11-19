# To add a new column with the number of exposures. To add multiple columns use `addDrugUtilisation()` for efficiency.

To add a new column with the number of exposures. To add multiple
columns use
[`addDrugUtilisation()`](https://darwin-eu.github.io/DrugUtilisation/reference/addDrugUtilisation.md)
for efficiency.

## Usage

``` r
addNumberExposures(
  cohort,
  conceptSet,
  indexDate = "cohort_start_date",
  censorDate = "cohort_end_date",
  restrictIncident = TRUE,
  nameStyle = "number_exposures_{concept_name}",
  name = NULL
)
```

## Arguments

- cohort:

  A cohort_table object.

- conceptSet:

  List of concepts to be included.

- indexDate:

  Name of a column that indicates the date to start the analysis.

- censorDate:

  Name of a column that indicates the date to stop the analysis, if NULL
  end of individuals observation is used.

- restrictIncident:

  Whether to include only incident prescriptions in the analysis. If
  FALSE all prescriptions that overlap with the study period will be
  included.

- nameStyle:

  Character string to specify the nameStyle of the new columns.

- name:

  Name of the new computed cohort table, if NULL a temporary table will
  be created.

## Value

The same cohort with the added columns.

## Examples

``` r
# \donttest{
library(DrugUtilisation)
library(CodelistGenerator)
library(dplyr, warn.conflicts = FALSE)

cdm <- mockDrugUtilisation()
codelist <- getDrugIngredientCodes(cdm = cdm, name = "acetaminophen")
cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
                                        name = "dus_cohort",
                                        conceptSet = codelist)
#> ℹ Subsetting drug_exposure table
#> ℹ Checking whether any record needs to be dropped.
#> ℹ Collapsing overlaping records.
#> ℹ Collapsing records with gapEra = 1 days.

cdm$dus_cohort |>
  addNumberExposures(conceptSet = codelist) |>
  glimpse()
#> Rows: 9
#> Columns: 5
#> $ cohort_definition_id               <int> 1, 1, 1, 1, 1, 1, 1, 1, 1
#> $ subject_id                         <int> 1, 1, 2, 4, 6, 7, 8, 9, 10
#> $ cohort_start_date                  <date> 2005-10-18, 1996-03-24, 2013-10-25,…
#> $ cohort_end_date                    <date> 2011-10-01, 2003-12-08, 2013-10-26,…
#> $ number_exposures_161_acetaminophen <int> 1, 1, 1, 1, 2, 1, 1, 1, 1
# }
```
