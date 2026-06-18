# Generate a set of drug cohorts based on given concepts

Adds a new cohort table to the cdm reference with individuals who have
drug exposure records with the specified concepts. Cohort start and end
dates will be based on drug record start and end dates, respectively.
Records that overlap or have fewer days between them than the specified
gap era will be concatenated into a single cohort entry.

## Usage

``` r
generateDrugUtilisationCohortSet(
  cdm,
  name,
  conceptSet,
  gapEra = 1,
  subsetCohort = NULL,
  subsetCohortId = NULL,
  numberExposures = FALSE,
  daysPrescribed = FALSE
)
```

## Arguments

- cdm:

  A `cdm_reference` object.

- name:

  Name of the new cohort table, it must be a length 1 character vector.

- conceptSet:

  List of concepts to be included.

- gapEra:

  Number of days between two continuous exposures to be considered in
  the same era.

- subsetCohort:

  Cohort table to subset.

- subsetCohortId:

  Cohort id to subset.

- numberExposures:

  Whether to include 'number_exposures' (number of drug exposure records
  between indexDate and censorDate).

- daysPrescribed:

  Whether to include 'days_prescribed' (number of days prescribed used
  to create each era).

## Value

The function returns the cdm reference provided with the addition of the
new cohort table.

## Examples

``` r
# \donttest{
library(DrugUtilisation)
library(CodelistGenerator)
library(dplyr, warn.conflicts = FALSE)

cdm <- mockDrugUtilisation()

druglist <- getDrugIngredientCodes(cdm = cdm,
                                   name = c("acetaminophen", "metformin"),
                                   nameStyle = "{concept_name}")

cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
                                        name = "drug_cohorts",
                                        conceptSet = druglist,
                                        gapEra = 30,
                                        numberExposures = TRUE,
                                        daysPrescribed = TRUE)
#> ℹ Subsetting drug_exposure table
#> ℹ Checking whether any record needs to be dropped.
#> ℹ Collapsing overlaping records.
#> ℹ Collapsing records with gapEra = 30 days.

cdm$drug_cohorts |>
  glimpse()
#> Rows: 15
#> Columns: 6
#> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2
#> $ subject_id           <int> 1, 2, 3, 4, 5, 7, 9, 10, 1, 2, 2, 6, 9, 9, 10
#> $ cohort_start_date    <date> 2016-07-06, 2018-02-06, 2017-10-11, 2017-05-08, 2…
#> $ cohort_end_date      <date> 2016-08-26, 2019-08-17, 2017-10-23, 2017-09-23, 2…
#> $ number_exposures     <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 1
#> $ days_prescribed      <int> 52, 558, 13, 139, 1, 299, 95, 295, 307, 101, 138…
# }
```
