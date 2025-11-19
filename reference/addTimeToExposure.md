# To add a new column with the time to exposure. To add multiple columns use `addDrugUtilisation()` for efficiency.

To add a new column with the time to exposure. To add multiple columns
use
[`addDrugUtilisation()`](https://darwin-eu.github.io/DrugUtilisation/reference/addDrugUtilisation.md)
for efficiency.

## Usage

``` r
addTimeToExposure(
  cohort,
  conceptSet,
  indexDate = "cohort_start_date",
  censorDate = "cohort_end_date",
  restrictIncident = TRUE,
  nameStyle = "time_to_exposure_{concept_name}",
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
  addTimeToExposure(conceptSet = codelist) |>
  glimpse()
#> Rows: 7
#> Columns: 5
#> $ cohort_definition_id               <int> 1, 1, 1, 1, 1, 1, 1
#> $ subject_id                         <int> 1, 2, 3, 6, 7, 9, 10
#> $ cohort_start_date                  <date> 2021-03-14, 2022-04-02, 2022-04-15,…
#> $ cohort_end_date                    <date> 2021-05-30, 2022-05-28, 2022-04-17,…
#> $ time_to_exposure_161_acetaminophen <int> 0, 0, 0, 0, 0, 0, 0
# }
```
