# This function is used to summarise treatments received

This function is used to summarise treatments received

## Usage

``` r
summariseTreatment(
  cohort,
  window,
  treatmentCohortName,
  cohortId = NULL,
  treatmentCohortId = NULL,
  strata = list(),
  indexDate = "cohort_start_date",
  censorDate = NULL,
  mutuallyExclusive = FALSE,
  inObservation = TRUE
)
```

## Arguments

- cohort:

  A cohort_table object.

- window:

  Time windows over which to identify treatments.

- treatmentCohortName:

  Name of the cohort table containing the treatments of interest.

- cohortId:

  A cohort definition id to restrict by. If NULL, all cohorts will be
  included.

- treatmentCohortId:

  Cohort definition IDs of the treatments of interest. If `NULL`, all
  cohorts in `treatmentCohortName` are included.

- strata:

  A list of variables to stratify results. These variables must have
  been added as additional columns in the cohort table.

- indexDate:

  Name of a column that indicates the date to start the analysis.

- censorDate:

  Name of a column that indicates the date to stop the analysis, if NULL
  end of individuals observation is used.

- mutuallyExclusive:

  Whether intersections should be mutually exclusive. If `TRUE`, cohort
  combinations are reported as mutually exclusive categories; if
  `FALSE`, each cohort is reported independently.

- inObservation:

  Whether to restrict the analysis to individuals in observation. If
  `TRUE`, individuals not in observation are excluded. If `FALSE`, they
  are included as a separate category.

## Value

A summary of treatments stratified by cohort_name and strata_name

## Examples

``` r
# \donttest{
library(DrugUtilisation)

cdm <- mockDrugUtilisation()
cdm$cohort1 |>
  summariseTreatment(
    treatmentCohortName = "cohort2",
    window = list(c(0, 30), c(31, 365))
  )
#> ℹ Intersect with medications table (cohort2)
#> ℹ Summarising medications.
# }
```
