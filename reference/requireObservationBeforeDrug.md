# Restrict cohort to only cohort records with the given amount of prior observation time in the database

Filter the cohort table keeping only the cohort records for which the
individual has the required observation time in the database prior to
their cohort start date.

## Usage

``` r
requireObservationBeforeDrug(
  cohort,
  days,
  cohortId = NULL,
  name = omopgenerics::tableName(cohort)
)
```

## Arguments

- cohort:

  A cohort_table object.

- days:

  Number of days of prior observation required before cohort start date.
  Any records with fewer days will be dropped.

- cohortId:

  A cohort definition id to restrict by. If NULL, all cohorts will be
  included.

- name:

  Name of the new cohort table, it must be a length 1 character vector.

## Value

The cohort table having applied the prior observation requirement.

## Examples

``` r
# \donttest{
library(DrugUtilisation)
library(dplyr, warn.conflicts = FALSE)

cdm <- mockDrugUtilisation()

cdm$cohort1 <- cdm$cohort1 |>
  requireObservationBeforeDrug(days = 365)

attrition(cdm$cohort1) |>
  glimpse()
#> Rows: 6
#> Columns: 7
#> $ cohort_definition_id <int> 1, 1, 2, 2, 3, 3
#> $ number_records       <int> 6, 3, 1, 1, 3, 2
#> $ number_subjects      <int> 6, 3, 1, 1, 3, 2
#> $ reason_id            <int> 1, 2, 1, 2, 1, 2
#> $ reason               <chr> "Initial qualifying events", "require prior obser…
#> $ excluded_records     <int> 0, 3, 0, 0, 0, 1
#> $ excluded_subjects    <int> 0, 3, 0, 0, 0, 1
# }
```
