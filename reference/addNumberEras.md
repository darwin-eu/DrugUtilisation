# To add a new column with the number of eras. To add multiple columns use `addDrugUtilisation()` for efficiency.

To add a new column with the number of eras. To add multiple columns use
[`addDrugUtilisation()`](https://darwin-eu.github.io/DrugUtilisation/reference/addDrugUtilisation.md)
for efficiency.

## Usage

``` r
addNumberEras(
  cohort,
  conceptSet,
  gapEra,
  indexDate = "cohort_start_date",
  censorDate = "cohort_end_date",
  restrictIncident = TRUE,
  nameStyle = "number_eras_{concept_name}",
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
  addNumberEras(conceptSet = codelist, gapEra = 1) |>
  glimpse()
#> Rows: 8
#> Columns: 5
#> $ cohort_definition_id          <int> 1, 1, 1, 1, 1, 1, 1, 1
#> $ subject_id                    <int> 1, 2, 3, 4, 5, 6, 8, 10
#> $ cohort_start_date             <date> 2021-06-27, 2009-06-12, 2010-06-23, 2020…
#> $ cohort_end_date               <date> 2022-09-25, 2009-12-08, 2018-11-22, 2020…
#> $ number_eras_161_acetaminophen <int> 1, 1, 1, 1, 1, 1, 1, 1
# }
```
