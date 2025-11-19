# Function to create a tibble with the patterns from current drug strength table

Function to create a tibble with the patterns from current drug strength
table

## Usage

``` r
patternTable(cdm)
```

## Arguments

- cdm:

  A `cdm_reference` object.

## Value

The function creates a tibble with the different patterns found in the
table, plus a column of potentially valid and invalid combinations.

## Examples

``` r
# \donttest{
library(DrugUtilisation)

cdm <- mockDrugUtilisation()

patternTable(cdm)
#> # A tibble: 5 × 12
#>   pattern_id formula_name            validity number_concepts number_ingredients
#>        <dbl> <chr>                   <chr>              <dbl>              <dbl>
#> 1          9 fixed amount formulati… pattern…               7                  4
#> 2         18 concentration formulat… pattern…               1                  1
#> 3         24 concentration formulat… pattern…               1                  1
#> 4         40 concentration formulat… pattern…               1                  1
#> 5         NA NA                      no patt…               4                  4
#> # ℹ 7 more variables: number_records <dbl>, amount_numeric <dbl>,
#> #   amount_unit_concept_id <dbl>, numerator_numeric <dbl>,
#> #   numerator_unit_concept_id <dbl>, denominator_numeric <dbl>,
#> #   denominator_unit_concept_id <dbl>
# }
```
