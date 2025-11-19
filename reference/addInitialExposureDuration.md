# To add a new column with the duration of the first exposure. To add multiple columns use `addDrugUtilisation()` for efficiency.

To add a new column with the duration of the first exposure. To add
multiple columns use
[`addDrugUtilisation()`](https://darwin-eu.github.io/DrugUtilisation/reference/addDrugUtilisation.md)
for efficiency.

## Usage

``` r
addInitialExposureDuration(
  cohort,
  conceptSet,
  indexDate = "cohort_start_date",
  censorDate = "cohort_end_date",
  restrictIncident = TRUE,
  nameStyle = "initial_exposure_duration_{concept_name}",
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

The same cohort with the added column.

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
  addInitialExposureDuration(conceptSet = codelist) |>
  glimpse()
#> Rows: 5
#> Columns: 5
#> $ cohort_definition_id                        <int> 1, 1, 1, 1, 1
#> $ subject_id                                  <int> 2, 3, 3, 5, 8
#> $ cohort_start_date                           <date> 2005-12-06, 2010-04-17, 20…
#> $ cohort_end_date                             <date> 2014-04-12, 2010-06-20, 20…
#> $ initial_exposure_duration_161_acetaminophen <int> 3050, 65, 943, 25, 180
# }
```
