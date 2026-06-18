# Plot discontinuation

Plot discontinuation

## Usage

``` r
plotDiscontinuationAsSurvival(
  result,
  facet = "cohort_name",
  colour = c("variable_name", strataColumns(result)),
  ribbon = TRUE,
  style = NULL
)
```

## Arguments

- result:

  A summarised_result object.

- facet:

  Columns to facet by. See options with `availablePlotColumns(result)`.
  Formula is also allowed to specify rows and columns.

- colour:

  Columns to color by. See options with `availablePlotColumns(result)`.

- ribbon:

  Whether to plot a ribbon with the confidence intervals.

- style:

  Visual theme to apply. Character, or `NULL`. If a character, this may
  be either the name of a built-in style (see `plotStyle()`), or a path
  to a `.yml` file that defines a custom style. If NULL, the function
  will use the explicit default style, unless a global style option is
  set (see
  [`visOmopResults::setGlobalPlotOptions()`](https://darwin-eu.github.io/visOmopResults/reference/setGlobalPlotOptions.html))
  or a `_brand.yml` file is present (in that order). Refer to the
  **visOmopResults** package vignette on styles to learn more.

## Value

Plot probability to continue the drug over over time

## Examples

``` r
# \donttest{
library(DrugUtilisation)

cdm <- mockDrugUtilisation()

result <- cdm$cohort1 |>
  summariseDiscontinuationAsSurvival(followUpDays = 365)
#> ℹ Calculating discontinuation for cohort_1.
#> ℹ Subsetting table to cohort of interest.
#> ℹ Preparing discontinuation (outcome) cohort.
#> ℹ Estimate single event survival for cohort: cohort_1 and outcome:
#>   discontinuation_of_cohort_1.
#> - Getting survival for target cohort 'cohort_1' and outcome cohort
#> 'discontinuation_of_cohort_1'
#> Getting overall estimates
#> `eventgap`, `outcome_washout`, `censor_on_cohort_exit`, `follow_up_days`, and
#> `minimum_survival_days` casted to character.
#> ✔ Discontinuation analysis for cohort_1 completed in 2s.
#> ℹ Calculating discontinuation for cohort_2.
#> ℹ Subsetting table to cohort of interest.
#> ℹ Preparing discontinuation (outcome) cohort.
#> ℹ Estimate single event survival for cohort: cohort_2 and outcome:
#>   discontinuation_of_cohort_2.
#> - Getting survival for target cohort 'cohort_2' and outcome cohort
#> 'discontinuation_of_cohort_2'
#> Getting overall estimates
#> `eventgap`, `outcome_washout`, `censor_on_cohort_exit`, `follow_up_days`, and
#> `minimum_survival_days` casted to character.
#> ✔ Discontinuation analysis for cohort_2 completed in 1s.
#> ℹ Calculating discontinuation for cohort_3.
#> ℹ Subsetting table to cohort of interest.
#> ℹ Preparing discontinuation (outcome) cohort.
#> ℹ Estimate single event survival for cohort: cohort_3 and outcome:
#>   discontinuation_of_cohort_3.
#> - Getting survival for target cohort 'cohort_3' and outcome cohort
#> 'discontinuation_of_cohort_3'
#> Getting overall estimates
#> `eventgap`, `outcome_washout`, `censor_on_cohort_exit`, `follow_up_days`, and
#> `minimum_survival_days` casted to character.
#> ✔ Discontinuation analysis for cohort_3 completed in 1s.

plotDiscontinuationAsSurvival(result)

# }
```
