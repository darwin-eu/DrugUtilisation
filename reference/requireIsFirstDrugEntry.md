# Restrict cohort to only the first cohort record per subject

Filter the cohort table keeping only the first cohort record per
subject.

## Usage

``` r
requireIsFirstDrugEntry(
  cohort,
  cohortId = NULL,
  name = omopgenerics::tableName(cohort)
)
```

## Arguments

- cohort:

  A cohort_table object.

- cohortId:

  A cohort definition id to restrict by. If NULL, all cohorts will be
  included.

- name:

  Name of the new cohort table, it must be a length 1 character vector.

## Value

The cohort table having applied the first entry requirement.

## Examples

``` r
# \donttest{
library(DrugUtilisation)
library(dplyr, warn.conflicts = FALSE)

cdm <- mockDrugUtilisation()

cdm$cohort1 <- cdm$cohort1 |>
  requireIsFirstDrugEntry()

attrition(cdm$cohort1) |>
  glimpse()
#> Rows: 6
#> Columns: 7
#> $ cohort_definition_id <int> 1, 1, 2, 2, 3, 3
#> $ number_records       <int> 5, 5, 3, 3, 2, 2
#> $ number_subjects      <int> 5, 5, 3, 3, 2, 2
#> $ reason_id            <int> 1, 2, 1, 2, 1, 2
#> $ reason               <chr> "Initial qualifying events", "require is the firs…
#> $ excluded_records     <int> 0, 0, 0, 0, 0, 0
#> $ excluded_subjects    <int> 0, 0, 0, 0, 0, 0
# }
```
