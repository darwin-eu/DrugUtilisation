# Generate a set of drug cohorts based on drug ingredients

Adds a new cohort table to the cdm reference with individuals who have
drug exposure records with the specified drug ingredient. Cohort start
and end dates will be based on drug record start and end dates,
respectively. Records that overlap or have fewer days between them than
the specified gap era will be concatenated into a single cohort entry.

## Usage

``` r
generateIngredientCohortSet(
  cdm,
  name,
  ingredient = NULL,
  gapEra = 1,
  subsetCohort = NULL,
  subsetCohortId = NULL,
  numberExposures = FALSE,
  daysPrescribed = FALSE,
  ...
)
```

## Arguments

- cdm:

  A `cdm_reference` object.

- name:

  Name of the new cohort table, it must be a length 1 character vector.

- ingredient:

  Accepts both vectors and named lists of ingredient names. For a vector
  input, e.g., c("acetaminophen", "codeine"), it generates a cohort
  table with descendant concept codes for each ingredient, assigning
  unique cohort_definition_id. For a named list input, e.g., list(
  "test_1" = c("simvastatin", "acetaminophen"), "test_2" = "metformin"),
  it produces a cohort table based on the structure of the input, where
  each name leads to a combined set of descendant concept codes for the
  specified ingredients, creating distinct cohort_definition_id for each
  named group.

- gapEra:

  Number of days between two continuous exposures to be considered in
  the same era.

- subsetCohort:

  Cohort table to subset.

- subsetCohortId:

  Cohort definition IDs to use from `subsetCohort`.

- numberExposures:

  Whether to include 'number_exposures' (number of drug exposure records
  between indexDate and censorDate).

- daysPrescribed:

  Whether to include 'days_prescribed' (number of days prescribed used
  to create each era).

- ...:

  Arguments to be passed to
  [`CodelistGenerator::getDrugIngredientCodes()`](https://darwin-eu.github.io/CodelistGenerator/reference/getDrugIngredientCodes.html).

## Value

The function returns the cdm reference provided with the addition of the
new cohort table.

## Examples

``` r
# \donttest{
library(DrugUtilisation)
library(dplyr, warn.conflicts = FALSE)

cdm <- mockDrugUtilisation()

cdm <- generateIngredientCohortSet(cdm = cdm,
                                   ingredient = "acetaminophen",
                                   name = "acetaminophen")
#> ℹ Subsetting drug_exposure table
#> ℹ Checking whether any record needs to be dropped.
#> ℹ Collapsing overlaping records.
#> ℹ Collapsing records with gapEra = 1 days.

cdm$acetaminophen |>
  glimpse()
#> Rows: 3
#> Columns: 4
#> $ cohort_definition_id <int> 1, 1, 1
#> $ subject_id           <int> 2, 8, 8
#> $ cohort_start_date    <date> 2010-12-02, 2006-05-06, 1994-10-03
#> $ cohort_end_date      <date> 2012-08-07, 2009-02-08, 2005-03-18
# }
```
