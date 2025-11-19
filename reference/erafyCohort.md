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
#>  1                    1          9 2016-07-16        2020-07-04     
#>  2                    2          1 2022-08-07        2022-08-17     
#>  3                    2          4 2022-03-11        2022-04-08     
#>  4                    2          8 1990-05-01        2012-08-16     
#>  5                    2         10 1988-03-04        1988-03-05     
#>  6                    3          2 2008-07-19        2009-03-26     
#>  7                    3          3 2022-06-06        2022-06-26     
#>  8                    3          5 2007-03-06        2013-02-17     
#>  9                    3          6 2017-11-10        2018-06-02     
#> 10                    3          7 2021-06-05        2021-11-03     

settings(cdm$cohort2)
#> # A tibble: 3 × 3
#>   cohort_definition_id cohort_name gap_era
#>                  <int> <glue>      <chr>  
#> 1                    1 cohort_1_30 30     
#> 2                    2 cohort_2_30 30     
#> 3                    3 cohort_3_30 30     

# }
```
