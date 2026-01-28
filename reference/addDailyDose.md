# Add daily dose to `drug_exposure` like table

Add daily dose to `drug_exposure` like table

## Usage

``` r
addDailyDose(x, ingredientConceptId, name = NULL)
```

## Arguments

- x:

  A `cdm_table` class table with at least `drug_concept_id`,
  `drug_exposure_start_date`, `drug_exposure_end_date` and `quantity` as
  columns.

- ingredientConceptId:

  Ingredient OMOP concept that we are interested for the study.

- name:

  Name of the new generated table, if `NULL` a temporary table will be
  generated.

## Value

A `cdm_table` with two new columns 'daily_dose' and 'unit'.
