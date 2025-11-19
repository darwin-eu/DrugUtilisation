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
#> ℹ The following estimates will be computed:
#> • daily_dose: count_missing, percentage_missing, mean, sd, q25, median, q75
#> ! Table is collected to memory as not all requested estimates are supported on
#>   the database side
#> → Start summary of data, at 2025-11-19 22:49:40.289803
#> ✔ Summary finished, at 2025-11-19 22:49:40.741889

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

6

0 (0.00 %)

4,099.38 (6,328.95)

1,207.45 (529.36 - 4,407.37)

milligram

overall

overall

6

0 (0.00 %)

4,099.38 (6,328.95)

1,207.45 (529.36 - 4,407.37)

topical

overall

6

0 (0.00 %)

4,099.38 (6,328.95)

1,207.45 (529.36 - 4,407.37)

18

5

0 (0.00 %)

4,916.50 (6,712.81)

1,371.43 (1,043.48 - 5,419.35)

9

1

0 (0.00 %)

–

13.79 (13.79 - 13.79)

\# }
