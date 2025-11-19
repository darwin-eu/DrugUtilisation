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
#> # A tibble: 10 × 5
#>    cohort_definition_id subject_id cohort_start_date cohort_end_date
#>  *                <int>      <int> <date>            <date>         
#>  1                    2          1 2015-11-27        2016-02-06     
#>  2                    3          2 1994-11-19        1996-02-27     
#>  3                    2          3 2001-10-14        2001-11-03     
#>  4                    3          4 2011-06-19        2018-05-19     
#>  5                    1          5 2022-11-09        2022-11-17     
#>  6                    2          6 2011-12-14        2012-06-21     
#>  7                    1          7 2020-07-28        2020-11-03     
#>  8                    1          8 1982-02-14        1983-01-17     
#>  9                    1          9 2021-04-07        2021-05-31     
#> 10                    1         10 2021-03-13        2021-04-14     
#> # ℹ 1 more variable: drug_restart_inf <chr>
# }
```
