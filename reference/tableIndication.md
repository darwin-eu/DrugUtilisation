# Create a table showing indication results

Create a table showing indication results

## Usage

``` r
tableIndication(
  result,
  header = c("cdm_name", "cohort_name", strataColumns(result)),
  groupColumn = "variable_name",
  hide = c("window_name", "mutually_exclusive", "unknown_indication_table",
    "censor_date", "cohort_table_name", "index_date", "indication_cohort_name"),
  type = NULL,
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

- hide:

  Columns to hide from the visualisation. See options with
  `availableTableColumns(result)`.

- type:

  Character string specifying the desired output table format. See
  [`visOmopResults::tableType()`](https://darwin-eu.github.io/visOmopResults/reference/tableType.html)
  for supported table types. If type = `NULL`, global options (set via
  [`visOmopResults::setGlobalTableOptions()`](https://darwin-eu.github.io/visOmopResults/reference/setGlobalTableOptions.html))
  will be used if available; otherwise, a default 'gt' table is created.

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

A table with a formatted version of summariseIndication() results.

## Examples

``` r
# \donttest{
library(DrugUtilisation)

cdm <- mockDrugUtilisation()

result <- cdm$cohort1 |>
  summariseIndication(
    indicationCohortName = "cohort2",
    indicationWindow = list(c(-30, 0)),
    unknownIndicationTable = "condition_occurrence"
  )
#> ℹ Intersect with indications table (cohort2)
#> ℹ Summarising indications.

tableIndication(result)
#> cdm_name, cohort_name, variable_name, window_name, censor_date,
#> cohort_table_name, index_date, indication_cohort_name, mutually_exclusive, and
#> unknown_indication_table are missing in `columnOrder`, will be added last.


  

```

CDM name

DUS MOCK

Indication

Estimate name

Cohort name

cohort_1

cohort_2

cohort_3

Indication from 30 days before to the index date

cohort_1

N (%)

0 (0.00 %)

0 (0.00 %)

2 (40.00 %)

cohort_2

N (%)

1 (50.00 %)

0 (0.00 %)

0 (0.00 %)

cohort_3

N (%)

1 (50.00 %)

0 (0.00 %)

1 (20.00 %)

cohort_1 and cohort_2

N (%)

0 (0.00 %)

0 (0.00 %)

0 (0.00 %)

cohort_1 and cohort_3

N (%)

0 (0.00 %)

0 (0.00 %)

0 (0.00 %)

cohort_2 and cohort_3

N (%)

0 (0.00 %)

0 (0.00 %)

0 (0.00 %)

cohort_1 and cohort_2 and cohort_3

N (%)

0 (0.00 %)

0 (0.00 %)

0 (0.00 %)

unknown

N (%)

0 (0.00 %)

0 (0.00 %)

0 (0.00 %)

none

N (%)

0 (0.00 %)

3 (100.00 %)

2 (40.00 %)

not in observation

N (%)

0 (0.00 %)

0 (0.00 %)

0 (0.00 %)

\# }
