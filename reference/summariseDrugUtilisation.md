# This function is used to summarise the dose utilisation table over multiple cohorts.

This function is used to summarise the dose utilisation table over
multiple cohorts.

## Usage

``` r
summariseDrugUtilisation(
  cohort,
  cohortId = NULL,
  strata = list(),
  estimates = c("q25", "median", "q75", "mean", "sd", "count_missing",
    "percentage_missing"),
  ingredientConceptId = NULL,
  conceptSet = NULL,
  indexDate = "cohort_start_date",
  censorDate = "cohort_end_date",
  restrictIncident = TRUE,
  gapEra = 1,
  numberExposures = TRUE,
  numberEras = TRUE,
  daysExposed = TRUE,
  daysPrescribed = TRUE,
  timeToExposure = TRUE,
  initialExposureDuration = TRUE,
  initialQuantity = TRUE,
  cumulativeQuantity = TRUE,
  initialDailyDose = TRUE,
  cumulativeDose = TRUE
)
```

## Arguments

- cohort:

  A cohort_table object.

- cohortId:

  A cohort definition id to restrict by. If NULL, all cohorts will be
  included.

- strata:

  A list of variables to stratify results. These variables must have
  been added as additional columns in the cohort table.

- estimates:

  Estimates that we want for the columns.

- ingredientConceptId:

  Ingredient OMOP concept that we are interested for the study.

- conceptSet:

  List of concepts to be included.

- indexDate:

  Name of a column that indicates the date to start the analysis.

- censorDate:

  Name of a column that indicates the date to stop the analysis, if NULL
  end of individuals observation is used.

- restrictIncident:

  Whether to include only incident prescriptions in the analysis. If
  FALSE all prescriptions that overlap with the study period will be
  included.

- gapEra:

  Number of days between two continuous exposures to be considered in
  the same era.

- numberExposures:

  Whether to include 'number_exposures' (number of drug exposure records
  between indexDate and censorDate).

- numberEras:

  Whether to include 'number_eras' (number of continuous exposure
  episodes between indexDate and censorDate).

- daysExposed:

  Whether to include 'days_exposed' (number of days that the individual
  is in a continuous exposure episode, including allowed treatment gaps,
  between indexDate and censorDate; sum of the length of the different
  drug eras).

- daysPrescribed:

  Whether to include 'days_prescribed' (sum of the number of days for
  each prescription that contribute in the analysis).

- timeToExposure:

  Whether to include 'time_to_exposure' (number of days between
  indexDate and the first episode).

- initialExposureDuration:

  Whether to include 'initial_exposure_duration' (number of prescribed
  days of the first drug exposure record).

- initialQuantity:

  Whether to include 'initial_quantity' (quantity of the first drug
  exposure record).

- cumulativeQuantity:

  Whether to include 'cumulative_quantity' (sum of the quantity of the
  different exposures considered in the analysis).

- initialDailyDose:

  Whether to include 'initial_daily_dose\_{unit}' (daily dose of the
  first considered prescription).

- cumulativeDose:

  Whether to include 'cumulative_dose\_{unit}' (sum of the cumulative
  dose of the analysed drug exposure records).

## Value

A summary of drug utilisation stratified by cohort_name and strata_name

## Examples

``` r
# \donttest{
library(DrugUtilisation)
library(CodelistGenerator)

cdm <- mockDrugUtilisation()
cdm <- generateIngredientCohortSet(cdm = cdm,
                                   ingredient = "acetaminophen",
                                   name = "dus_cohort")
#> ℹ Subsetting drug_exposure table
#> ℹ Checking whether any record needs to be dropped.
#> ℹ Collapsing overlaping records.
#> ℹ Collapsing records with gapEra = 1 days.

cdm$dus_cohort |>
  summariseDrugUtilisation(ingredientConceptId = 1125315)
#> # A tibble: 72 × 13
#>    result_id cdm_name group_name  group_level   strata_name strata_level
#>        <int> <chr>    <chr>       <chr>         <chr>       <chr>       
#>  1         1 DUS MOCK cohort_name acetaminophen overall     overall     
#>  2         1 DUS MOCK cohort_name acetaminophen overall     overall     
#>  3         1 DUS MOCK cohort_name acetaminophen overall     overall     
#>  4         1 DUS MOCK cohort_name acetaminophen overall     overall     
#>  5         1 DUS MOCK cohort_name acetaminophen overall     overall     
#>  6         1 DUS MOCK cohort_name acetaminophen overall     overall     
#>  7         1 DUS MOCK cohort_name acetaminophen overall     overall     
#>  8         1 DUS MOCK cohort_name acetaminophen overall     overall     
#>  9         1 DUS MOCK cohort_name acetaminophen overall     overall     
#> 10         1 DUS MOCK cohort_name acetaminophen overall     overall     
#> # ℹ 62 more rows
#> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
#> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
#> #   additional_name <chr>, additional_level <chr>
# }
```
