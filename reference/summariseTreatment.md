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
  mutuallyExclusive = FALSE
)
```

## Arguments

- cohort:

  A cohort_table object.

- window:

  Time window over which to summarise the treatments.

- treatmentCohortName:

  Name of a cohort in the cdm that contains the treatments of interest.

- cohortId:

  A cohort definition id to restrict by. If NULL, all cohorts will be
  included.

- treatmentCohortId:

  Cohort definition id of interest from treatmentCohortName.

- strata:

  A list of variables to stratify results. These variables must have
  been added as additional columns in the cohort table.

- indexDate:

  Name of a column that indicates the date to start the analysis.

- censorDate:

  Name of a column that indicates the date to stop the analysis, if NULL
  end of individuals observation is used.

- mutuallyExclusive:

  Whether to include mutually exclusive treatments or not.

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
