# Create a table with discontinuation as survival results

Create a table with discontinuation as survival results

## Usage

``` r
tableDiscontinuationAsSurvival(
  result,
  header = c("cdm_name"),
  groupColumn = c("cohort_name", strataColumns(result)),
  type = NULL,
  gapSummary = TRUE,
  hide = c("variable_level"[!gapSummary], "competing_outcome", "estimate_gap",
    "event_gap", "follow_up_days", "cohort_survival_version"),
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

- gapSummary:

  Whether to include *Gap summary* statistics.

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
[`summariseDiscontinuationAsSurvival()`](https://darwin-eu.github.io/DrugUtilisation/reference/summariseDiscontinuationAsSurvival.md)
results.

## Examples

``` r
# \donttest{
library(DrugUtilisation)

cdm <- mockDrugUtilisation()

result <- summariseDiscontinuationAsSurvival(cdm$cohort1)
#> ℹ Calculating discontinuation for cohort_1.
#> ℹ Subsetting table to cohort of interest.
#> ℹ Preparing discontinuation (outcome) cohort.
#> ℹ Estimate single event survival for cohort: cohort_1 and outcome:
#>   discontinuation_of_cohort_1.
#> - Getting survival for target cohort 'cohort_1' and outcome cohort
#> 'discontinuation_of_cohort_1'
#> Getting overall estimates
#> `eventgap`, `outcome_washout`, `censor_on_cohort_exit`, `follow_up_days`, and
#> `minimum_survival_days` casted to character.
#> ✔ Discontinuation analysis for cohort_1 completed in 1s.
#> ℹ Calculating discontinuation for cohort_2.
#> ℹ Subsetting table to cohort of interest.
#> ℹ Preparing discontinuation (outcome) cohort.
#> ℹ Estimate single event survival for cohort: cohort_2 and outcome:
#>   discontinuation_of_cohort_2.
#> - Getting survival for target cohort 'cohort_2' and outcome cohort
#> 'discontinuation_of_cohort_2'
#> Getting overall estimates
#> `eventgap`, `outcome_washout`, `censor_on_cohort_exit`, `follow_up_days`, and
#> `minimum_survival_days` casted to character.
#> ✔ Discontinuation analysis for cohort_2 completed in 1s.
#> ℹ Calculating discontinuation for cohort_3.
#> ℹ Subsetting table to cohort of interest.
#> ℹ Preparing discontinuation (outcome) cohort.
#> ℹ Estimate single event survival for cohort: cohort_3 and outcome:
#>   discontinuation_of_cohort_3.
#> - Getting survival for target cohort 'cohort_3' and outcome cohort
#> 'discontinuation_of_cohort_3'
#> Getting overall estimates
#> `eventgap`, `outcome_washout`, `censor_on_cohort_exit`, `follow_up_days`, and
#> `minimum_survival_days` casted to character.
#> ✔ Discontinuation analysis for cohort_3 completed in 1s.

tableDiscontinuationAsSurvival(result)
#> cdm_name, cohort_name, cohort_survival_version, competing_outcome,
#> estimate_gap, event_gap, and follow_up_days are missing in `columnOrder`, will
#> be added last.


  


Variable name
```
