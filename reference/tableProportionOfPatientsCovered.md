# Create a table with proportion of patients covered results

Create a table with proportion of patients covered results

## Usage

``` r
tableProportionOfPatientsCovered(
  result,
  header = c("cohort_name", strataColumns(result)),
  groupColumn = "cdm_name",
  type = NULL,
  hide = c("variable_name", "variable_level", "cohort_table_name"),
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

A table with a formatted version of
summariseProportionOfPatientsCovered() results.

## Examples

``` r
# \donttest{
library(DrugUtilisation)

cdm <- mockDrugUtilisation()

cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
                                        name = "my_cohort",
                                        conceptSet = list(drug_of_interest = c(1503297, 1503327)))
#> ℹ Subsetting drug_exposure table
#> ℹ Checking whether any record needs to be dropped.
#> ℹ Collapsing overlaping records.
#> ℹ Collapsing records with gapEra = 1 days.

result <- cdm$my_cohort |>
  summariseProportionOfPatientsCovered(followUpDays = 365)
#> Getting PPC for cohort drug_of_interest
#> Collecting cohort into memory
#> Geting PPC over 365 days following first cohort entry
#>  -- getting PPC for ■■■■■■■■■■■■                     136 of 365 days
#>  -- getting PPC for ■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■■  365 of 365 days

tableProportionOfPatientsCovered(result)
#> cdm_name, cohort_name, variable_name, variable_level, and cohort_table_name are
#> missing in `columnOrder`, will be added last.
#> ℹ <ppc>% has not been formatted.
#> ℹ <ppc_lower>% has not been formatted.
#> ℹ <ppc_upper>% has not been formatted.


  


Time
```
