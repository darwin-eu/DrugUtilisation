
<!-- README.md is generated from README.Rmd. Please edit that file -->

# DrugUtilisation

<!-- badges: start -->

[![R-CMD-check](https://github.com/darwin-eu/DrugUtilisation/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/darwin-eu/DrugUtilisation/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/darwin-eu/DrugUtilisation/branch/main/graph/badge.svg)](https://app.codecov.io/gh/darwin-eu/DrugUtilisation?branch=main)
<!-- badges: end -->

## WARNING: This package is under development.

- [addDailyDose](https://github.com/darwin-eu/DrugUtilisation/blob/main/R/addDailyDose.R)
  function has been only tested for tablets. Do not use for other type of drugs.

- Some of the functions that are currently part of this package may be
  deprecated in the near future or moved to other under development
  packages.

- [Cohort
  building](https://github.com/darwin-eu/DrugUtilisation/blob/main/R/generateDrugUtilisationCohort.R)
  based on drug concept sets or ingredients worked for previous studies.

- It is recommended to write to the
  [authors](https://github.com/darwin-eu/DrugUtilisation/blob/main/DESCRIPTION) of
  the package before using it.

- Estimated time for final release: **June 2023**.

## Package overview

DrugUtilisation contains functions to instantiate and characterize the
cohorts used in a Drug Utilisation Study in the OMOP common data model.

## Package installation

You can install the this version of DrugUtilisation using the folowing
command:

``` r
install.packages("remotes")
remotes::install_github("darwin-eu/DrugUtilisation")
```

When working with DrugUtilisation, you will use CDMConnector to manage
your connection to the database. If you don´t already have this
installed you can install it from
[CRAN](https://CRAN.R-project.org/package=CDMConnector).

``` r
install.packages("CDMConnector")
```

## Example

First, we need to create a cdm reference for the data we´ll be using.
Here we´ll generate an example with simulated data, but to see how you
would set this up for your database please consult the CDMConnector
package [connection
examples](https://darwin-eu.github.io/CDMConnector/articles/DBI_connection_examples.html).

``` r
library(CDMConnector)
library(DrugUtilisation)

# We first need to create a cdm_reference
cdm <- mockDrugUtilisation()
# and this is what this example data looks like
head(cdm$person)
head(cdm$observation_period)
head(cdm$drug_exposure)
head(cdm$drug_strength)
```

To create, instantiate and characterize the drug utilisation cohorts we
have to specify an ingredient (ingredientConceptId):

``` r
cdm$my_cohort <- generateDrugUtilisationCohort(
  cdm = cdm,
  ingredientConceptId = 1
)
```

Or a concept set. Concept sets are specified as json files. We can point
to a folder that contains one or more concept sets or to a specific
concept set.

``` r
library(dplyr)
cdm[["my_cohort"]] <- generateDrugUtilisationCohort(
  cdm = cdm,
  conceptSetPath = here("FolderWithJsonFiles")
)
```

We can get indications for our drug cohorts using getIndication
function:

``` r
# instantiate indication cohorts
indicationCohorts <- readCohortSet(path = here("IndicationCohorts"))
cdm <- generateCohortSet(
  cdm = cdm,
  cohortSet = indicationCohorts,
  cohortTableName = "indications",
  overwrite = TRUE
)
# get indications
indicationList <- getIndication(
  cdm = cdm,
  targetCohortName = "my_cohort",
  indicationCohortName = "indications",
  indicationDefinitionSet = indicationCohorts,
  indicationGap = c(0, 7, 30, NA),
  unknownIndicationTables = c("condition_occurrence", "observation")
)
```

We can stratify our cohort using getStratification function:

``` r
cdm$strata <- getStratification(
  cdm = cdm,
  targetCohortName = "my_cohort",
  sex = "Female",
  ageGroup = list(c(0, 49), c(50, 150), c(0, 150)),
  indicationTable = indicationList,
)
stratification <- attr(cdm$strata, "cohortSet")
```

We can obtain the dosage information for a certain drug utilisation
cohort as:

``` r
cdm$dose_table <- getDoseInformation(
  cdm = cdm,
  dusCohortName = "strata",
  ingredientConceptId = 745466,
  gapEra = 30,
  eraJoinMode = "Previous",
  overlapMode = "Previous",
  sameIndexMode = "Sum", 
  imputeDuration = "eliminate",
  imputeDailyDose = "eliminate",
  durationRange = c(1, NA),
  dailyDoseRange = c(0, NA)
)
```

**Note that this function has only been tested for tablets.**

Summarise dose and indication data using:

``` r
doseIndicationSummary <- summariseDoseIndicationTable(
  cdm = cdm,
  strataCohortName = "strata",
  doseTableName = "dose_table",
  indicationList = indicationList,
  estimates = c("min", "max", "q25", "q75", "median", "mean", "std"),
  variables = variables,
  minimumCellCounts = minimum_counts
)
```

Do a large scale characterization of the specified cohorts:

``` r
lsc <- largeScaleCharacterization(
  cdm = cdm,
  targetCohortName = "strata",
  minimumCellCount = minimum_counts
)
```

Characterize a cohort:

``` r
# general condition cohorts should be instantiated first
tableCharacteristics <- getTableOne(
  cdm = cdm,
  targetCohortName = "strata",
  targetCohortId = NULL,
  ageGroups = list(c(0, 49), c(50, 150), c(0, 150)),
  windowVisitOcurrence = c(-365, 0),
  conditionsTableName = general_conditions_table_name,
  conditionsSet = generalConditionsCohorts,
  conditionsWindow = c(NA, 0),
  minimumCellCount = minimum_counts
)
```
