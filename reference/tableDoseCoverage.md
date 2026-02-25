# Format a dose_coverage object into a visual table.

Format a dose_coverage object into a visual table.

## Usage

``` r
tableDoseCoverage(
  result,
  header = c("variable_name", "estimate_name"),
  groupColumn = c("cdm_name", "ingredient_name"),
  type = NULL,
  hide = c("variable_level", "sample_size"),
  style = NULL,
  .options = list()
)
```

## Arguments

- result:

  A summarised_result object.

- header:

  Columns to use as header. See options with
  `availableTableColumns(result)`.

- groupColumn:

  Columns to group by. See options with `availableTableColumns(result)`.

- type:

  Character string specifying the desired output table format. See
  [`visOmopResults::tableType()`](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)
  for supported table types. If type = `NULL`, global options (set via
  [`visOmopResults::setGlobalTableOptions()`](https://darwin-eu.github.io/visOmopResults/reference/setGlobalTableOptions.html))
  will be used if available; otherwise, a default 'gt' table is created.

- hide:

  Columns to hide from the visualisation. See options with
  `availableTableColumns(result)`.

- style:

  Defines the visual formatting of the table. This argument can be
  provided in one of the following ways:

  1.  **Pre-defined style**: Use the name of a built-in style (e.g.,
      "darwin"). See
      [`visOmopResults::tableStyle()`](https://darwin-eu.github.io/visOmopResults/reference/tableStyle.html)
      for available options.

  2.  **YAML file path**: Provide the path to an existing .yml file
      defining a new style.

  3.  **List of custome R code**: Supply a block of custom R code or a
      named list describing styles for each table section. This code
      must be specific to the selected table type.

  If style = `NULL`, the function will use global options (see
  [`visOmopResults::setGlobalTableOptions()`](https://darwin-eu.github.io/visOmopResults/reference/setGlobalTableOptions.html))
  or an existing `_brand.yml` file (if found); otherwise, the default
  style is applied. For more details, see the *Styles* vignette in
  **visOmopResults** website.

- .options:

  A named list with additional formatting options.
  [`visOmopResults::tableOptions()`](https://darwin-eu.github.io/visOmopResults/reference/tableOptions.html)
  shows allowed arguments and their default values.

## Value

A table with a formatted version of summariseDrugCoverage() results.

## Examples

``` r
# \donttest{
library(DrugUtilisation)

cdm <- mockDrugUtilisation()

result <- summariseDoseCoverage(cdm, 1125315)
#> ℹ The following estimates will be calculated:
#> • daily_dose: count_missing, percentage_missing, mean, sd, q25, median, q75
#> ! Table is collected to memory as not all requested estimates are supported on
#>   the database side
#> → Start summary of data, at 2026-02-25 23:40:37.424675
#> ✔ Summary finished, at 2026-02-25 23:40:37.815409

tableDoseCoverage(result)
#> cdm_name, ingredient_name, variable_name, variable_level, estimate_name, and
#> sample_size are missing in `columnOrder`, will be added last.


  

```

Variable name

number records

Missing dose

daily_dose

Unit

Route

Pattern id

Estimate name

N

N (%)

Mean (SD)

Median (Q25 - Q75)

DUS MOCK; acetaminophen

overall

overall

overall

17

0 (0.00 %)

2,532.24 (5,298.38)

43.90 (8.83 - 1,600.00)

milligram

overall

overall

17

0 (0.00 %)

2,532.24 (5,298.38)

43.90 (8.83 - 1,600.00)

oral

overall

5

0 (0.00 %)

170.09 (340.06)

13.94 (11.34 - 43.90)

topical

overall

12

0 (0.00 %)

3,516.47 (6,099.02)

943.97 (8.16 - 4,362.38)

oral

9

5

0 (0.00 %)

170.09 (340.06)

13.94 (11.34 - 43.90)

topical

18

7

0 (0.00 %)

6,021.43 (7,115.26)

4,192.14 (1,429.21 - 6,800.18)

9

5

0 (0.00 %)

9.54 (10.31)

6.14 (3.11 - 8.83)

\# }
