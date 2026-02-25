# Plot the results of `summariseDrugUtilisation`

Plot the results of `summariseDrugUtilisation`

## Usage

``` r
plotDrugUtilisation(
  result,
  variable = "number exposures",
  plotType = "barplot",
  facet = strataColumns(result),
  colour = "cohort_name",
  style = NULL
)
```

## Arguments

- result:

  A summarised_result object.

- variable:

  Variable to plot. See `unique(result$variable_name)` for options.

- plotType:

  Must be a choice between: 'scatterplot', 'barplot', 'densityplot', and
  'boxplot'.

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
# \donttest{
library(DrugUtilisation)
library(PatientProfiles)
library(dplyr, warn.conflicts = FALSE)

cdm <- mockDrugUtilisation(numberIndividuals = 100)
codes <- list(aceta = c(1125315, 1125360, 2905077, 43135274))
cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
                                        name = "cohort",
                                        conceptSet = codes)
#> ℹ Subsetting drug_exposure table
#> ℹ Checking whether any record needs to be dropped.
#> ℹ Collapsing overlaping records.
#> ℹ Collapsing records with gapEra = 1 days.

result <- cdm$cohort |>
  addSex() |>
  summariseDrugUtilisation(
    strata = "sex",
    ingredientConceptId = 1125315,
    estimates = c("min", "q25", "median", "q75", "max", "density")
  )

result |>
  filter(estimate_name == "median") |>
  plotDrugUtilisation(
    variable = "days prescribed",
    plotType = "barplot"
  )


result |>
  plotDrugUtilisation(
    variable = "days exposed",
    facet = cohort_name ~ cdm_name,
    colour = "sex",
    plotType = "boxplot"
  )


result |>
  plotDrugUtilisation(
    variable = "cumulative dose milligram",
    plotType = "densityplot",
    facet = "cohort_name",
    colour = "sex"
  )


# }
```
