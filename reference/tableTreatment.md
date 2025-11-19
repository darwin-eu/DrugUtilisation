# Format a summarised_treatment result into a visual table.

Format a summarised_treatment result into a visual table.

## Usage

``` r
tableTreatment(
  result,
  header = c("cdm_name", "cohort_name"),
  groupColumn = "variable_name",
  type = NULL,
  hide = c("window_name", "mutually_exclusive", "censor_date", "cohort_table_name",
    "index_date", "treatment_cohort_name"),
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

A table with a formatted version of summariseTreatment() results.

## Examples

``` r
# \donttest{
library(DrugUtilisation)

cdm <- mockDrugUtilisation()

result <- cdm$cohort1 |>
  summariseTreatment(
    treatmentCohortName = "cohort2",
    window = list(c(0, 30), c(31, 365))
  )
#> ℹ Intersect with medications table (cohort2)
#> ℹ Summarising medications.

tableTreatment(result)
#> cdm_name, cohort_name, variable_name, window_name, censor_date,
#> cohort_table_name, index_date, mutually_exclusive, and treatment_cohort_name
#> are missing in `columnOrder`, will be added last.


  

```

CDM name

DUS MOCK

Treatment

Estimate name

Cohort name

cohort_1

cohort_2

cohort_3

Medication from index date to 30 days after

cohort_1

N (%)

1 (50.00 %)

0 (0.00 %)

3 (60.00 %)

cohort_2

N (%)

0 (0.00 %)

1 (33.33 %)

0 (0.00 %)

cohort_3

N (%)

0 (0.00 %)

0 (0.00 %)

1 (20.00 %)

untreated

N (%)

1 (50.00 %)

2 (66.67 %)

1 (20.00 %)

not in observation

N (%)

0 (0.00 %)

0 (0.00 %)

0 (0.00 %)

Medication from 31 days after to 365 days after the index date

cohort_1

N (%)

1 (50.00 %)

1 (33.33 %)

3 (60.00 %)

cohort_2

N (%)

0 (0.00 %)

1 (33.33 %)

0 (0.00 %)

cohort_3

N (%)

0 (0.00 %)

0 (0.00 %)

1 (20.00 %)

untreated

N (%)

1 (50.00 %)

1 (33.33 %)

1 (20.00 %)

not in observation

N (%)

0 (0.00 %)

0 (0.00 %)

0 (0.00 %)

\# }
