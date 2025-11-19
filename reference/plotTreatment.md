# Generate a custom ggplot2 from a summarised_result object generated with summariseTreatment function.

Generate a custom ggplot2 from a summarised_result object generated with
summariseTreatment function.

## Usage

``` r
plotTreatment(
  result,
  x = "variable_level",
  position = "stack",
  facet = cdm_name + cohort_name ~ window_name,
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
result <- cdm$cohort1 |>
  summariseTreatment(
    treatmentCohortName = "cohort2",
    window = list(c(0, 30), c(31, 365))
  )

plotTreatment(result)

plotTreatment(result, x = "cohort_name", facet = "window_name")
} # }
```
