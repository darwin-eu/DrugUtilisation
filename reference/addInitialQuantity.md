# To add a new column with the initial quantity. To add multiple columns use `addDrugUtilisation()` for efficiency.

To add a new column with the initial quantity. To add multiple columns
use
[`addDrugUtilisation()`](https://darwin-eu.github.io/DrugUtilisation/reference/addDrugUtilisation.md)
for efficiency.

## Usage

``` r
addInitialQuantity(
  cohort,
  conceptSet,
  indexDate = "cohort_start_date",
  censorDate = "cohort_end_date",
  restrictIncident = TRUE,
  nameStyle = "initial_quantity_{concept_name}",
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
  addInitialQuantity(conceptSet = codelist) |>
  glimpse()
#> Rows: 7
#> Columns: 5
#> $ cohort_definition_id               <int> 1, 1, 1, 1, 1, 1, 1
#> $ subject_id                         <int> 1, 3, 4, 4, 5, 6, 7
#> $ cohort_start_date                  <date> 2021-08-15, 2012-01-22, 2008-10-04,…
#> $ cohort_end_date                    <date> 2022-05-30, 2014-06-10, 2008-12-19,…
#> $ initial_quantity_161_acetaminophen <dbl> 30, 25, 40, 35, 10, 30, 25
# }
```
