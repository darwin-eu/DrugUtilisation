# To add a new column with the cumulative quantity. To add multiple columns use `addDrugUtilisation()` for efficiency.

To add a new column with the cumulative quantity. To add multiple
columns use
[`addDrugUtilisation()`](https://darwin-eu.github.io/DrugUtilisation/reference/addDrugUtilisation.md)
for efficiency.

## Usage

``` r
addCumulativeQuantity(
  cohort,
  conceptSet,
  indexDate = "cohort_start_date",
  censorDate = "cohort_end_date",
  restrictIncident = TRUE,
  nameStyle = "cumulative_quantity_{concept_name}",
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
  addCumulativeQuantity(conceptSet = codelist) |>
  glimpse()
#> Rows: 8
#> Columns: 5
#> $ cohort_definition_id                  <int> 1, 1, 1, 1, 1, 1, 1, 1
#> $ subject_id                            <int> 2, 2, 3, 6, 6, 7, 8, 9
#> $ cohort_start_date                     <date> 2022-02-13, 2022-01-05, 1991-10-…
#> $ cohort_end_date                       <date> 2022-02-13, 2022-02-07, 1999-08-…
#> $ cumulative_quantity_161_acetaminophen <dbl> 50, 20, 90, 90, 1, 30, 30, 50
# }
```
