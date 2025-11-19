# Generate a custom ggplot2 from a summarised_result object generated with summariseDrugRestart() function.

Generate a custom ggplot2 from a summarised_result object generated with
summariseDrugRestart() function.

## Usage

``` r
plotDrugRestart(
  result,
  x = "variable_level",
  position = "stack",
  facet = cdm_name + cohort_name ~ follow_up_days,
  colour = "variable_level",
  style = NULL
)
```

## Arguments

- result:

  A summarised_result object.

- x:

  Variable to plot on x-axis

- position:

  Position of bars, can be either `dodge` or `stack`

- facet:

  Columns to facet by. See options with `availablePlotColumns(result)`.
  Formula is also allowed to specify rows and columns.

- colour:

  Columns to color by. See options with `availablePlotColumns(result)`.

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

A ggplot2 object.

## Examples

``` r
if (FALSE) { # \dontrun{
library(DrugUtilisation)

cdm <- mockDrugUtilisation()

conceptlist <- list("a" = 1125360, "b" = c(1503297, 1503327))
cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
                                        name = "switch_cohort",
                                        conceptSet = conceptlist)

result <- cdm$cohort1 |>
  summariseDrugRestart(switchCohortTable = "switch_cohort")

plotDrugRestart(result)

plotDrugRestart(result, x = "cohort_name", facet = "follow_up_days")
} # }
```
