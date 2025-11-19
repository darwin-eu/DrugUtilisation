# Summarise proportion Of patients covered

Gives the proportion of patients still in observation who are in the
cohort on any given day following their first cohort entry. This is
known as the “proportion of patients covered” (PPC) method for assessing
treatment persistence.

## Usage

``` r
summariseProportionOfPatientsCovered(
  cohort,
  cohortId = NULL,
  strata = list(),
  followUpDays = NULL
)
```

## Arguments

- cohort:

  A cohort_table object.

- cohortId:

  A cohort definition id to restrict by. If NULL, all cohorts will be
  included.

- strata:

  A list of variables to stratify results. These variables must have
  been added as additional columns in the cohort table.

- followUpDays:

  Number of days to follow up individuals for. If NULL the maximum
  amount of days from an individuals first cohort start date to their
  last cohort end date will be used

## Value

A summarised result

## Examples

``` r
# \donttest{
library(DrugUtilisation)

cdm <- mockDrugUtilisation(numberIndividuals = 100)

result <- cdm$cohort1 |>
  summariseProportionOfPatientsCovered(followUpDays = 365)
#> Getting PPC for cohort cohort_1
#> Collecting cohort into memory
#> Geting PPC over 365 days following first cohort entry
#>  -- getting PPC for ■■■■■■■■■■■                      119 of 365 days
#>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  365 of 365 days
#> Getting PPC for cohort cohort_2
#> Collecting cohort into memory
#> Geting PPC over 365 days following first cohort entry
#>  -- getting PPC for ■■■■■■■■■■■                      116 of 365 days
#>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  365 of 365 days
#> Getting PPC for cohort cohort_3
#> Collecting cohort into memory
#> Geting PPC over 365 days following first cohort entry
#>  -- getting PPC for ■■■■■■■■■■■                      117 of 365 days
#>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  365 of 365 days

tidy(result)
#> # A tibble: 1,098 × 11
#>    cdm_name cohort_name variable_name variable_level time  outcome_count
#>    <chr>    <chr>       <chr>         <chr>          <chr>         <int>
#>  1 DUS MOCK cohort_1    overall       overall        0                44
#>  2 DUS MOCK cohort_1    overall       overall        1                43
#>  3 DUS MOCK cohort_1    overall       overall        2                43
#>  4 DUS MOCK cohort_1    overall       overall        3                43
#>  5 DUS MOCK cohort_1    overall       overall        4                43
#>  6 DUS MOCK cohort_1    overall       overall        5                43
#>  7 DUS MOCK cohort_1    overall       overall        6                42
#>  8 DUS MOCK cohort_1    overall       overall        7                41
#>  9 DUS MOCK cohort_1    overall       overall        8                40
#> 10 DUS MOCK cohort_1    overall       overall        9                40
#> # ℹ 1,088 more rows
#> # ℹ 5 more variables: denominator_count <int>, ppc <dbl>, ppc_lower <dbl>,
#> #   ppc_upper <dbl>, cohort_table_name <chr>
# }
```
