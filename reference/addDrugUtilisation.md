# Add new columns with drug use related information

Add new columns with drug use related information

## Usage

``` r
addDrugUtilisation(
  cohort,
  gapEra,
  conceptSet = NULL,
  ingredientConceptId = NULL,
  indexDate = "cohort_start_date",
  censorDate = "cohort_end_date",
  restrictIncident = TRUE,
  numberExposures = TRUE,
  numberEras = TRUE,
  daysExposed = TRUE,
  daysPrescribed = TRUE,
  timeToExposure = TRUE,
  initialExposureDuration = TRUE,
  initialQuantity = TRUE,
  cumulativeQuantity = TRUE,
  initialDailyDose = TRUE,
  cumulativeDose = TRUE,
  nameStyle = "{value}_{concept_name}_{ingredient}",
  name = NULL
)
```

## Arguments

- cohort:

  A cohort_table object.

- gapEra:

  Number of days between two continuous exposures to be considered in
  the same era.

- conceptSet:

  List of concepts to be included.

- ingredientConceptId:

  Ingredient OMOP concept that we are interested for the study.

- indexDate:

  Name of a column that indicates the date to start the analysis.

- censorDate:

  Name of a column that indicates the date to stop the analysis, if NULL
  end of individuals observation is used.

- restrictIncident:

  Whether to include only incident prescriptions in the analysis. If
  FALSE all prescriptions that overlap with the study period will be
  included.

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

- nameStyle:

  Character string to specify the nameStyle of the new columns.

- name:

  Name of the new computed cohort table, if NULL a temporary table will
  be created.

## Value

The same cohort with the added columns.

## Examples

``` r
# \donttest{
library(DrugUtilisation)
library(CodelistGenerator)
library(dplyr, warn.conflicts = FALSE)

cdm <- mockDrugUtilisation()
codelist <- getDrugIngredientCodes(cdm = cdm, name = "acetaminophen")

cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
                                        name = "dus_cohort",
                                        conceptSet = codelist)
#> ℹ Subsetting drug_exposure table
#> ℹ Checking whether any record needs to be dropped.
#> ℹ Collapsing overlaping records.
#> ℹ Collapsing records with gapEra = 1 days.
cdm$dus_cohort |>
  addDrugUtilisation(ingredientConceptId = 1125315, gapEra = 30) |>
  glimpse()
#> Rows: 9
#> Columns: 14
#> $ cohort_definition_id                                                <int> 1,…
#> $ subject_id                                                          <int> 1,…
#> $ cohort_start_date                                                   <date> 2…
#> $ cohort_end_date                                                     <date> 2…
#> $ number_exposures_ingredient_1125315_descendants                     <int> 1,…
#> $ time_to_exposure_ingredient_1125315_descendants                     <int> 0,…
#> $ cumulative_quantity_ingredient_1125315_descendants                  <dbl> 90…
#> $ initial_quantity_ingredient_1125315_descendants                     <dbl> 90…
#> $ initial_exposure_duration_ingredient_1125315_descendants            <int> 19…
#> $ number_eras_ingredient_1125315_descendants                          <int> 1,…
#> $ days_exposed_ingredient_1125315_descendants                         <int> 19…
#> $ days_prescribed_ingredient_1125315_descendants                      <int> 19…
#> $ cumulative_dose_milligram_ingredient_1125315_descendants_1125315    <dbl> 45…
#> $ initial_daily_dose_milligram_ingredient_1125315_descendants_1125315 <dbl> 22…
# }
```
