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
#>  1                    1          2 2014-05-07        2014-05-11     
#>  2                    1          5 2010-02-18        2010-02-24     
#>  3                    1          9 2017-12-09        2018-04-22     
#>  4                    1         10 2020-03-17        2020-03-20     
#>  5                    2          1 2013-01-17        2013-05-24     
#>  6                    2          3 2008-03-28        2010-10-07     
#>  7                    2          4 2022-07-11        2022-08-09     
#>  8                    2          6 1997-07-21        2001-03-12     
#>  9                    3          7 2014-03-08        2014-07-08     
#> 10                    3          8 2022-01-24        2022-01-26     

settings(cdm$cohort2)
#> # A tibble: 3 × 3
#>   cohort_definition_id cohort_name gap_era
#>                  <int> <glue>      <chr>  
#> 1                    1 cohort_1_30 30     
#> 2                    2 cohort_2_30 30     
#> 3                    3 cohort_3_30 30     

# }
```
