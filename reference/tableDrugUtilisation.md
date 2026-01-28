# Format a drug_utilisation object into a visual table.

Format a drug_utilisation object into a visual table.

## Usage

``` r
tableDrugUtilisation(
  result,
  header = c("cdm_name"),
  groupColumn = c("cohort_name", strataColumns(result)),
  type = NULL,
  hide = c("variable_level", "censor_date", "cohort_table_name", "gap_era", "index_date",
    "restrict_incident"),
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

A table with a formatted version of summariseIndication() results.

## Examples

``` r
# \donttest{
library(DrugUtilisation)
library(CodelistGenerator)

cdm <- mockDrugUtilisation()
codelist <- getDrugIngredientCodes(cdm = cdm, name = "acetaminophen")
cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
                                        name = "dus_cohort",
                                        conceptSet = codelist)
#> ℹ Subsetting drug_exposure table
#> ℹ Checking whether any record needs to be dropped.
#> ℹ Collapsing overlaping records.
#> ℹ Collapsing records with gapEra = 1 days.

drugUse <- cdm$dus_cohort |>
  summariseDrugUtilisation(ingredientConceptId = 1125315)

tableDrugUtilisation(drugUse)
#> cdm_name, cohort_name, variable_level, censor_date, cohort_table_name, gap_era,
#> index_date, and restrict_incident are missing in `columnOrder`, will be added
#> last.


  


Concept set
```

Ingredient

Variable name

Estimate name

CDM name

DUS MOCK

161_acetaminophen

overall

overall

number records

N

8

number subjects

N

7

ingredient_1125315_descendants

overall

number exposures

missing N (%)

0 (0.00 %)

Mean (SD)

1.38 (0.74)

Median (Q25 - Q75)

1 (1 - 1)

time to exposure

missing N (%)

0 (0.00 %)

Mean (SD)

0.00 (0.00)

Median (Q25 - Q75)

0 (0 - 0)

cumulative quantity

missing N (%)

0 (0.00 %)

Mean (SD)

69.38 (52.74)

Median (Q25 - Q75)

65.00 (25.00 - 100.00)

initial quantity

missing N (%)

0 (0.00 %)

Mean (SD)

54.38 (40.57)

Median (Q25 - Q75)

42.50 (22.50 - 100.00)

initial exposure duration

missing N (%)

0 (0.00 %)

Mean (SD)

735.88 (534.20)

Median (Q25 - Q75)

570 (316 - 1,148)

number eras

missing N (%)

0 (0.00 %)

Mean (SD)

1.00 (0.00)

Median (Q25 - Q75)

1 (1 - 1)

days exposed

missing N (%)

0 (0.00 %)

Mean (SD)

897.00 (824.30)

Median (Q25 - Q75)

570 (316 - 1,246)

days prescribed

missing N (%)

0 (0.00 %)

Mean (SD)

1,011.00 (1,029.66)

Median (Q25 - Q75)

570 (450 - 1,246)

acetaminophen

cumulative dose milligram

missing N (%)

0 (0.00 %)

Mean (SD)

374,125.00 (411,480.41)

Median (Q25 - Q75)

192,000.00 (40,500.00 - 702,750.00)

initial daily dose milligram

missing N (%)

0 (0.00 %)

Mean (SD)

719.27 (755.78)

Median (Q25 - Q75)

432.04 (43.18 - 1,540.32)

\# }
