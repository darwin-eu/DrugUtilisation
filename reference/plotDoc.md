# Helper for consistent documentation of `plot`.

Helper for consistent documentation of `plot`.

## Arguments

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
