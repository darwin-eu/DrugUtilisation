# Generate a set of drug cohorts based on ATC classification

Adds a new cohort table to the cdm reference with individuals who have
drug exposure records that belong to the specified Anatomical
Therapeutic Chemical (ATC) classification. Cohort start and end dates
will be based on drug record start and end dates, respectively. Records
that overlap or have fewer days between them than the specified gap era
will be concatenated into a single cohort entry.

## Usage

``` r
generateAtcCohortSet(
  cdm,
  name,
  atcName = NULL,
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

- atcName:

  Names of ATC classification of interest.

- gapEra:

  Number of days between two continuous exposures to be considered in
  the same era. Records that have fewer days between them than this gap
  will be concatenated into the same cohort record.

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

- ...:

  Arguments to be passed to
  [`CodelistGenerator::getATCCodes()`](https://darwin-eu.github.io/CodelistGenerator/reference/getATCCodes.html).

## Value

The function returns the cdm reference provided with the addition of the
new cohort table.

## Examples

``` r
# \donttest{
library(DrugUtilisation)
library(dplyr, warn.conflicts = FALSE)

cdm <- mockDrugUtilisation()

cdm <- generateAtcCohortSet(cdm = cdm,
                            atcName = "alimentary tract and metabolism",
                            name = "drugs")
#> ℹ Subsetting drug_exposure table
#> ℹ Checking whether any record needs to be dropped.
#> Warning: cohort_name must be snake case and have less than 100 characters, the following
#> cohorts will be renamed:
#> • alimentary tract and metabolism -> alimentary_tract_and_metabolism
#> ℹ Collapsing records with gapEra = 1 days.

cdm$drugs |>
  glimpse()
#> Rows: 0
#> Columns: 6
#> $ cohort_definition_id <int> 
#> $ subject_id           <int> 
#> $ cohort_start_date    <date> 
#> $ cohort_end_date      <date> 
#> $ number_exposures     <int> 
#> $ days_prescribed      <int> 
# }
```
