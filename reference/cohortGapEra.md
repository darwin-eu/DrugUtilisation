# Get the gapEra used to create a cohort

Get the gapEra used to create a cohort

## Usage

``` r
cohortGapEra(cohort, cohortId = NULL)
```

## Arguments

- cohort:

  A `cohort_table` object.

- cohortId:

  Integer vector refering to cohortIds from cohort. If NULL all cohort
  definition ids in settings will be used.

## Value

gapEra values for the specific cohortIds

## Examples

``` r
# \donttest{
library(DrugUtilisation)
library(CodelistGenerator)

cdm <- mockDrugUtilisation()

druglist <- getDrugIngredientCodes(cdm = cdm,
                                   name = c("acetaminophen", "metformin"))

cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
                                        name = "drug_cohorts",
                                        conceptSet = druglist,
                                        gapEra = 100)
#> ℹ Subsetting drug_exposure table
#> ℹ Checking whether any record needs to be dropped.
#> ℹ Collapsing overlaping records.
#> ℹ Collapsing records with gapEra = 100 days.

cohortGapEra(cdm$drug_cohorts)
#> [1] 100 100
# }
```
