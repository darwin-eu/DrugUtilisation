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
  name = NULL,
  restrictIncident = FALSE
)
```

## Arguments

- cohort:

  A cohort_table object.

- treatmentCohortName:

  Name of the cohort table containing the treatments of interest.

- treatmentCohortId:

  Cohort definition IDs of the treatments of interest. If `NULL`, all
  cohorts in `treatmentCohortName` are included.

- window:

  Time windows over which to identify treatments.

- indexDate:

  Name of a column that indicates the date to start the analysis.

- censorDate:

  Name of a column that indicates the date to stop the analysis, if NULL
  end of individuals observation is used.

- mutuallyExclusive:

  Whether intersections should be mutually exclusive. If `TRUE`, cohort
  combinations are reported as mutually exclusive categories; if
  `FALSE`, each cohort is reported independently.

- nameStyle:

  Name style for the treatment columns. By default:
  'treatment\_{window_name}' (mutuallyExclusive = TRUE),
  'treatment\_{window_name}\_{cohort_name}' (mutuallyExclusive = FALSE).

- name:

  Name of the new computed cohort table, if NULL a temporary table will
  be created.

- restrictIncident:

  Whether to include only target cohort records that start during the
  analysis period. If `FALSE`, all target cohort records that overlap
  with the study period will be included.

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
#> Rows: 44
#> Columns: 7
#> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1…
#> $ subject_id           <int> 1, 3, 4, 4, 6, 7, 9, 11, 13, 13, 14, 15, 15, 15, …
#> $ cohort_start_date    <date> 2019-01-14, 1963-11-08, 1985-01-30, 1978-02-13, …
#> $ cohort_end_date      <date> 2019-09-05, 1965-06-23, 1989-01-06, 1983-06-24, …
#> $ medication_0_to_0    <chr> "untreated", "untreated", "metformin and simvasta…
#> $ medication_1_to_30   <chr> "untreated", "untreated", "metformin and simvasta…
#> $ medication_31_to_60  <chr> "untreated", "untreated", "metformin", "untreated…
# }
```
