# Format a drug_restart object into a visual table.

Format a drug_restart object into a visual table.

## Usage

``` r
tableDrugRestart(
  result,
  header = c("cdm_name", "cohort_name"),
  groupColumn = "variable_name",
  type = NULL,
  hide = c("censor_date", "restrict_to_first_discontinuation", "follow_up_days",
    "cohort_table_name", "incident", "switch_cohort_table"),
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

A table with a formatted version of summariseDrugRestart() results.

## Examples

``` r
# \donttest{
library(DrugUtilisation)

cdm <- mockDrugUtilisation()

conceptlist <- list(acetaminophen = 1125360, metformin = c(1503297, 1503327))
cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
                                        name = "switch_cohort",
                                        conceptSet = conceptlist)
#> ℹ Subsetting drug_exposure table
#> ℹ Checking whether any record needs to be dropped.
#> ℹ Collapsing overlaping records.
#> ℹ Collapsing records with gapEra = 1 days.

result <- cdm$cohort1 |>
  summariseDrugRestart(switchCohortTable = "switch_cohort")
#> Warning: There was 1 warning in `dplyr::summarise()`.
#> ℹ In argument: `cohort_start_date = min(.data$cohort_start_date, na.rm =
#>   TRUE)`.
#> Caused by warning in `min.default()`:
#> ! no non-missing arguments to min; returning Inf

tableDrugRestart(result)
#> cdm_name, cohort_name, variable_name, follow_up_days, censor_date,
#> cohort_table_name, incident, restrict_to_first_discontinuation, and
#> switch_cohort_table are missing in `columnOrder`, will be added last.


  

```

CDM name

DUS MOCK

Treatment

Estimate name

Cohort name

cohort_1

cohort_2

cohort_3

Drug restart till end of observation

restart

N (%)

0 (0.00 %)

0 (0.00 %)

0 (0.00 %)

switch

N (%)

1 (100.00 %)

1 (25.00 %)

0 (0.00 %)

restart and switch

N (%)

0 (0.00 %)

0 (0.00 %)

0 (0.00 %)

untreated

N (%)

0 (0.00 %)

3 (75.00 %)

5 (100.00 %)

\# }
