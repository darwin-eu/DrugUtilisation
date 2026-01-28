# Restrict cohort to only cohort records within a certain date range

Filter the cohort table keeping only the cohort records for which the
specified index date is within a specified date range.

## Usage

``` r
requireDrugInDateRange(
  cohort,
  dateRange,
  indexDate = "cohort_start_date",
  cohortId = NULL,
  name = omopgenerics::tableName(cohort)
)
```

## Arguments

- cohort:

  A cohort_table object.

- dateRange:

  Date interval to consider. Any records with the index date outside of
  this range will be dropped.

- indexDate:

  The column containing the date that will be checked against the date
  range.

- cohortId:

  A cohort definition id to restrict by. If NULL, all cohorts will be
  included.

- name:

  Name of the new cohort table, it must be a length 1 character vector.

## Value

The cohort table having applied the date requirement.

## Examples

``` r
# \donttest{
library(DrugUtilisation)
library(dplyr, warn.conflicts = FALSE)

cdm <- mockDrugUtilisation()

cdm$cohort1 <- cdm$cohort1 |>
  requireDrugInDateRange(dateRange = as.Date(c("2020-01-01", NA)))

attrition(cdm$cohort1) |>
  glimpse()
#> Rows: 6
#> Columns: 7
#> $ cohort_definition_id <int> 1, 1, 2, 2, 3, 3
#> $ number_records       <int> 6, 0, 2, 0, 2, 0
#> $ number_subjects      <int> 6, 0, 2, 0, 2, 0
#> $ reason_id            <int> 1, 2, 1, 2, 1, 2
#> $ reason               <chr> "Initial qualifying events", "require cohort_star…
#> $ excluded_records     <int> 0, 6, 0, 2, 0, 2
#> $ excluded_subjects    <int> 0, 6, 0, 2, 0, 2
# }
```
