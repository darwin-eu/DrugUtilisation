# Restrict cohort to only cohort records with a given amount of time since the last cohort record ended

Filter the cohort table keeping only the cohort records for which the
required amount of time has passed since the last cohort entry ended for
that individual.

## Usage

``` r
requirePriorDrugWashout(
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

  The number of days required to have passed since the last cohort
  record finished. Any records with fewer days than this will be
  dropped. Note that setting days to Inf will lead to the same result as
  that from using the `requireIsFirstDrugEntry` function (with only an
  individual´s first cohort record kept).

- cohortId:

  A cohort definition id to restrict by. If NULL, all cohorts will be
  included.

- name:

  Name of the new cohort table, it must be a length 1 character vector.

## Value

The cohort table having applied the washout requirement.

## Examples

``` r
# \donttest{
library(DrugUtilisation)
library(dplyr, warn.conflicts = FALSE)

cdm <- mockDrugUtilisation()

cdm$cohort1 <- cdm$cohort1 |>
  requirePriorDrugWashout(days = 90)

attrition(cdm$cohort1) |>
  glimpse()
#> Rows: 6
#> Columns: 7
#> $ cohort_definition_id <int> 1, 1, 2, 2, 3, 3
#> $ number_records       <int> 3, 3, 1, 1, 6, 6
#> $ number_subjects      <int> 3, 3, 1, 1, 6, 6
#> $ reason_id            <int> 1, 2, 1, 2, 1, 2
#> $ reason               <chr> "Initial qualifying events", "require prior use d…
#> $ excluded_records     <int> 0, 0, 0, 0, 0, 0
#> $ excluded_subjects    <int> 0, 0, 0, 0, 0, 0
# }
```
