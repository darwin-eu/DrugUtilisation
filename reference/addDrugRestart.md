# Add drug restart information as a column per follow-up period of interest.

Add drug restart information as a column per follow-up period of
interest.

## Usage

``` r
addDrugRestart(
  cohort,
  switchCohortTable,
  switchCohortId = NULL,
  followUpDays = Inf,
  censorDate = NULL,
  incident = TRUE,
  nameStyle = "drug_restart_{follow_up_days}"
)
```

## Arguments

- cohort:

  A cohort_table object.

- switchCohortTable:

  A cohort table in the cdm that contains possible alternative
  treatments.

- switchCohortId:

  The cohort ids to be used from switchCohortTable. If NULL all cohort
  definition ids are used.

- followUpDays:

  A vector of number of days to follow up. It can be multiple values.

- censorDate:

  Name of a column that indicates the date to stop the analysis, if NULL
  end of individuals observation is used.

- incident:

  Whether the switch treatment has to be incident (start after
  discontinuation) or not (it can start before the discontinuation and
  last till after).

- nameStyle:

  Character string to specify the nameStyle of the new columns.

## Value

The cohort table given with additional columns with information on the
restart, switch and not exposed per follow-up period of interest.

## Examples

``` r
# \donttest{
library(DrugUtilisation)

cdm <- mockDrugUtilisation()

conceptlist <- list(acetaminophen = 1125360, metformin = c(1503297, 1503327))
cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
                                        name = "switch_cohort",
                                        conceptSet = conceptlist)
#> ℹ Subsetting drug_exposure table
#> ℹ Checking whether any record needs to be dropped.
#> ℹ Collapsing overlaping records.
#> ℹ Collapsing records with gapEra = 1 days.

cdm$cohort1 |>
  addDrugRestart(switchCohortTable = "switch_cohort")
#> Warning: There was 1 warning in `dplyr::summarise()`.
#> ℹ In argument: `cohort_start_date = min(.data$cohort_start_date, na.rm =
#>   TRUE)`.
#> Caused by warning in `min.default()`:
#> ! no non-missing arguments to min; returning Inf
#> Warning: There was 1 warning in `dplyr::summarise()`.
#> ℹ In argument: `switch_start = min(.data$switch_start, na.rm = TRUE)`.
#> Caused by warning in `min.default()`:
#> ! no non-missing arguments to min; returning Inf
#> # A tibble: 10 × 5
#>    cohort_definition_id subject_id cohort_start_date cohort_end_date
#>  *                <int>      <int> <date>            <date>         
#>  1                    3          1 2012-12-12        2014-07-14     
#>  2                    1          2 2019-11-08        2019-11-11     
#>  3                    2          3 2016-03-20        2016-03-24     
#>  4                    2          4 1975-03-24        1977-01-14     
#>  5                    2          5 2021-05-21        2021-07-16     
#>  6                    1          6 2016-02-20        2018-11-15     
#>  7                    2          7 1996-09-27        1998-07-26     
#>  8                    3          8 2012-11-25        2013-03-14     
#>  9                    2          9 2006-03-30        2016-11-10     
#> 10                    1         10 1989-01-14        1995-02-10     
#> # ℹ 1 more variable: drug_restart_inf <chr>
# }
```
