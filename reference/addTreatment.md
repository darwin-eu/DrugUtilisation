# Add a variable indicating individuals medications

Add a variable to a drug cohort indicating their presence of a
medication cohort in a specified time window.

## Usage

``` r
addTreatment(
  cohort,
  treatmentCohortName,
  treatmentCohortId = NULL,
  window = list(c(0, 0)),
  indexDate = "cohort_start_date",
  censorDate = NULL,
  mutuallyExclusive = TRUE,
  nameStyle = NULL,
  name = NULL
)
```

## Arguments

- cohort:

  A cohort_table object.

- treatmentCohortName:

  Name of treatment cohort table

- treatmentCohortId:

  target cohort Id to add treatment

- window:

  time window of interests.

- indexDate:

  Name of a column that indicates the date to start the analysis.

- censorDate:

  Name of a column that indicates the date to stop the analysis, if NULL
  end of individuals observation is used.

- mutuallyExclusive:

  Whether to consider mutually exclusive categories (one column per
  window) or not (one column per window and treatment).

- nameStyle:

  Name style for the treatment columns. By default:
  'treatment\_{window_name}' (mutuallyExclusive = TRUE),
  'treatment\_{window_name}\_{cohort_name}' (mutuallyExclusive = FALSE).

- name:

  Name of the new computed cohort table, if NULL a temporary table will
  be created.

## Value

The original table with a variable added that summarises the
individual´s indications.

## Examples

``` r
# \donttest{
library(DrugUtilisation)
library(dplyr, warn.conflicts = FALSE)

cdm <- mockDrugUtilisation(numberIndividuals = 50)

cdm <- generateIngredientCohortSet(cdm = cdm,
                                   name = "drug_cohort",
                                   ingredient = "acetaminophen")
#> ℹ Subsetting drug_exposure table
#> ℹ Checking whether any record needs to be dropped.
#> ℹ Collapsing overlaping records.
#> ℹ Collapsing records with gapEra = 1 days.

cdm <- generateIngredientCohortSet(cdm = cdm,
                                   name = "treatments",
                                   ingredient = c("metformin", "simvastatin"))
#> ℹ Subsetting drug_exposure table
#> ℹ Checking whether any record needs to be dropped.
#> ℹ Collapsing overlaping records.
#> ℹ Collapsing records with gapEra = 1 days.

cdm$drug_cohort |>
  addTreatment("treatments", window = list(c(0, 0), c(1, 30), c(31, 60))) |>
  glimpse()
#> ℹ Intersect with medications table (treatments).
#> ℹ Collapse medications to mutually exclusive categories
#> Rows: 36
#> Columns: 7
#> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
#> $ subject_id           <int> 2, 3, 5, 6, 7, 8, 10, 11, 12, 13, 14, 15, 15, 16,…
#> $ cohort_start_date    <date> 2013-04-15, 2021-09-19, 2009-04-27, 2018-01-21, …
#> $ cohort_end_date      <date> 2018-07-25, 2022-11-28, 2013-09-12, 2020-03-12, …
#> $ medication_0_to_0    <chr> "simvastatin", "untreated", "untreated", "untreat…
#> $ medication_1_to_30   <chr> "simvastatin", "untreated", "untreated", "untreat…
#> $ medication_31_to_60  <chr> "simvastatin", "untreated", "untreated", "untreat…
# }
```
