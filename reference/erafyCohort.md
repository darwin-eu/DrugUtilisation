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
#>  1                    1          1 1987-02-17        1991-07-08     
#>  2                    1          4 2022-10-13        2022-10-16     
#>  3                    1          6 2022-09-03        2022-09-13     
#>  4                    1          8 2021-07-31        2021-08-01     
#>  5                    1          9 2000-05-25        2013-02-24     
#>  6                    2          2 2009-06-22        2011-05-06     
#>  7                    2          5 2013-02-01        2013-04-20     
#>  8                    3          3 2022-03-11        2022-03-16     
#>  9                    3          7 1999-09-23        1999-11-27     
#> 10                    3         10 2022-08-02        2022-08-06     

settings(cdm$cohort2)
#> # A tibble: 3 × 3
#>   cohort_definition_id cohort_name gap_era
#>                  <int> <glue>      <chr>  
#> 1                    1 cohort_1_30 30     
#> 2                    2 cohort_2_30 30     
#> 3                    3 cohort_3_30 30     

# }
```
