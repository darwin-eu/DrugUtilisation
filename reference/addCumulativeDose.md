# To add a new column with the cumulative dose. To add multiple columns use `addDrugUtilisation()` for efficiency.

To add a new column with the cumulative dose. To add multiple columns
use
[`addDrugUtilisation()`](https://darwin-eu.github.io/DrugUtilisation/reference/addDrugUtilisation.md)
for efficiency.

## Usage

``` r
addCumulativeDose(
  cohort,
  ingredientConceptId,
  conceptSet = NULL,
  indexDate = "cohort_start_date",
  censorDate = "cohort_end_date",
  restrictIncident = TRUE,
  nameStyle = "cumulative_dose_{concept_name}_{ingredient}",
  name = NULL
)
```

## Arguments

- cohort:

  A cohort_table object.

- ingredientConceptId:

  Ingredient OMOP concept that we are interested for the study.

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
  addCumulativeDose(ingredientConceptId = 1125315) |>
  glimpse()
#> Rows: 6
#> Columns: 5
#> $ cohort_definition_id                                   <int> 1, 1, 1, 1, 1, 1
#> $ subject_id                                             <int> 1, 2, 5, 6, 8, …
#> $ cohort_start_date                                      <date> 2021-11-30, 198…
#> $ cohort_end_date                                        <date> 2021-12-04, 20…
#> $ cumulative_dose_ingredient_1125315_descendants_1125315 <dbl> 20000, 15000, …
# }
```
