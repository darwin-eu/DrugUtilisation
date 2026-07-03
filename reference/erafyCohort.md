# Erafy a cohort_table collapsing records separated gapEra days or less.

Erafy a cohort_table collapsing records separated gapEra days or less.

## Usage

``` r
erafyCohort(
  cohort,
  gapEra,
  cohortId = NULL,
  nameStyle = "{cohort_name}_{gap_era}",
  name = omopgenerics::tableName(cohort)
)
```

## Arguments

- cohort:

  A cohort_table object.

- gapEra:

  Number of days between two continuous exposures to be considered in
  the same era.

- cohortId:

  A cohort definition id to restrict by. If NULL, all cohorts will be
  included.

- nameStyle:

  String to create the new names of cohorts. Must contain
  '{cohort_name}' if more than one cohort is present and '{gap_era}' if
  more than one gapEra is provided.

- name:

  Name of the new cohort table, it must be a length 1 character vector.

## Value

A cohort_table object.

## Examples

``` r
# \donttest{
library(DrugUtilisation)

cdm <- mockDrugUtilisation()

cdm$cohort2 <- cdm$cohort1 |>
  erafyCohort(gapEra = 30, name = "cohort2")

cdm$cohort2
#> # A tibble: 10 × 4
#>    cohort_definition_id subject_id cohort_start_date cohort_end_date
#>  *                <int>      <int> <date>            <date>         
#>  1                    1          1 2019-03-13        2019-04-29     
#>  2                    1          6 2021-08-31        2021-09-17     
#>  3                    1          7 2003-04-17        2003-05-21     
#>  4                    2          3 2017-02-27        2018-05-28     
#>  5                    2          5 2021-08-16        2021-12-21     
#>  6                    2          8 2019-10-22        2019-12-28     
#>  7                    2          9 2021-04-10        2021-04-10     
#>  8                    3          2 2019-03-15        2019-04-18     
#>  9                    3          4 2012-12-03        2013-05-04     
#> 10                    3         10 1990-11-07        1992-06-28     

settings(cdm$cohort2)
#> # A tibble: 3 × 3
#>   cohort_definition_id cohort_name gap_era
#>                  <int> <glue>      <chr>  
#> 1                    1 cohort_1_30 30     
#> 2                    2 cohort_2_30 30     
#> 3                    3 cohort_3_30 30     

# }
```
