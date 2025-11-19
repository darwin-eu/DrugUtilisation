# To add a new column with the days exposed. To add multiple columns use `addDrugUtilisation()` for efficiency.

To add a new column with the days exposed. To add multiple columns use
[`addDrugUtilisation()`](https://darwin-eu.github.io/DrugUtilisation/reference/addDrugUtilisation.md)
for efficiency.

## Usage

``` r
addDaysExposed(
  cohort,
  conceptSet,
  gapEra,
  indexDate = "cohort_start_date",
  censorDate = "cohort_end_date",
  restrictIncident = TRUE,
  nameStyle = "days_exposed_{concept_name}",
  name = NULL
)
```

## Arguments

- cohort:

  A cohort_table object.

- conceptSet:

  List of concepts to be included.

- gapEra:

  Number of days between two continuous exposures to be considered in
  the same era.

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
  addDaysExposed(conceptSet = codelist, gapEra = 1) |>
  glimpse()
#> Rows: 10
#> Columns: 5
#> $ cohort_definition_id           <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
#> $ subject_id                     <int> 1, 2, 3, 3, 4, 4, 5, 8, 8, 8
#> $ cohort_start_date              <date> 1997-04-04, 2018-04-26, 2022-03-31, 202…
#> $ cohort_end_date                <date> 2018-11-05, 2019-10-02, 2022-05-22, 202…
#> $ days_exposed_161_acetaminophen <int> 7886, 525, 53, 10, 113, 387, 751, 7, 1…
# }
```
