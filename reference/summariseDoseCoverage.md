# Check coverage of daily dose computation in a sample of the cdm for selected concept sets and ingredient

Check coverage of daily dose computation in a sample of the cdm for
selected concept sets and ingredient

## Usage

``` r
summariseDoseCoverage(
  cdm,
  ingredientConceptId,
  estimates = c("count_missing", "percentage_missing", "mean", "sd", "q25", "median",
    "q75"),
  sampleSize = NULL
)
```

## Arguments

- cdm:

  A `cdm_reference` object.

- ingredientConceptId:

  Ingredient OMOP concept that we are interested for the study.

- estimates:

  Estimates to obtain.

- sampleSize:

  Maximum number of records of an ingredient to estimate dose coverage.
  If an ingredient has more, a random sample equal to `sampleSize` will
  be considered. If NULL, all records will be used.

## Value

The function returns information of the coverage of computeDailyDose.R
for the selected ingredients and concept sets

## Examples

``` r
# \donttest{
library(DrugUtilisation)

cdm <- mockDrugUtilisation()

summariseDoseCoverage(cdm = cdm, ingredientConceptId = 1125315)
#> ℹ The following estimates will be calculated:
#> • daily_dose: count_missing, percentage_missing, mean, sd, q25, median, q75
#> ! Table is collected to memory as not all requested estimates are supported on
#>   the database side
#> → Start summary of data, at 2026-02-26 08:36:43.405192
#> ✔ Summary finished, at 2026-02-26 08:36:43.809425
#> # A tibble: 56 × 13
#>    result_id cdm_name group_name      group_level   strata_name strata_level
#>        <int> <chr>    <chr>           <chr>         <chr>       <chr>       
#>  1         1 DUS MOCK ingredient_name acetaminophen overall     overall     
#>  2         1 DUS MOCK ingredient_name acetaminophen overall     overall     
#>  3         1 DUS MOCK ingredient_name acetaminophen overall     overall     
#>  4         1 DUS MOCK ingredient_name acetaminophen overall     overall     
#>  5         1 DUS MOCK ingredient_name acetaminophen overall     overall     
#>  6         1 DUS MOCK ingredient_name acetaminophen overall     overall     
#>  7         1 DUS MOCK ingredient_name acetaminophen overall     overall     
#>  8         1 DUS MOCK ingredient_name acetaminophen overall     overall     
#>  9         1 DUS MOCK ingredient_name acetaminophen unit        milligram   
#> 10         1 DUS MOCK ingredient_name acetaminophen unit        milligram   
#> # ℹ 46 more rows
#> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
#> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
#> #   additional_name <chr>, additional_level <chr>
# }
```
