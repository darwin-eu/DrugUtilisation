
<!-- README.md is generated from README.Rmd. Please edit that file -->

# DrugUtilisation <img src="man/figures/logo.png" align="right" height="200"/>

[![CRANstatus](https://www.r-pkg.org/badges/version/DrugUtilisation)](https://CRAN.R-project.org/package=DrugUtilisation)
[![codecov.io](https://codecov.io/github/darwin-eu/DrugUtilisation/coverage.svg?branch=main)](https://app.codecov.io/github/darwin-eu/DrugUtilisation?branch=main)
[![R-CMD-check](https://github.com/darwin-eu/DrugUtilisation/workflows/R-CMD-check/badge.svg)](https://github.com/darwin-eu/DrugUtilisation/actions)
[![Lifecycle:Experimental](https://img.shields.io/badge/Lifecycle-Experimental-339999)](https://lifecycle.r-lib.org/articles/stages.html)

## Package overview

DrugUtilisation contains functions to instantiate and characterise drug
cohorts in data mapped to the OMOP Common Data Model. The package
supports:

- Creation of drug cohorts

- Identification of indications for those in a drug cohort

- Summarising drug utilisation among a cohort in terms of duration,
  quantity, and dose

- Description of treatment adherence based on proportion of patients
  covered

- Detailing treatment restart and switching after an initial treatment
  discontinuation

## Example usage

First, we need to create a cdm reference for the data we´ll be using.
Here we generate an example with simulated data, but to see how you
would set this up for your database please consult the CDMConnector
package [connection
examples](https://darwin-eu.github.io/CDMConnector/articles/a04_DBI_connection_examples.html).

``` r
library(DrugUtilisation)
library(CDMConnector)
library(omopgenerics)
library(dplyr)

cdm <- mockDrugUtilisation(numberIndividual = 100)
```

### Create a cohort of acetaminophen users

To generate the cohort of acetaminophen users we will use
`generateIngredientCohortSet`, concatenating any records with fewer than
7 days between them. We then filter our cohort records to only include
the first record per person and require that they have at least 30 days
observation in the database prior to their drug start date.

``` r
cdm <- generateIngredientCohortSet(
  cdm = cdm,
  name = "dus_cohort",
  ingredient = "acetaminophen",
  gapEra = 7
)
#> Warning: ! `codelist` contains numeric values, they are casted to integers.
cdm$dus_cohort |>
  requireIsFirstDrugEntry() |>
  requireObservationBeforeDrug(days = 30)
#> # Source:   table<main.dus_cohort> [?? x 4]
#> # Database: DuckDB v1.1.0 [root@Darwin 24.0.0:R 4.4.1/:memory:]
#>    cohort_definition_id subject_id cohort_start_date cohort_end_date
#>                   <int>      <int> <date>            <date>         
#>  1                    1          1 2021-08-22        2022-01-20     
#>  2                    1          2 2003-04-08        2006-03-14     
#>  3                    1          4 1971-04-20        1971-08-01     
#>  4                    1          5 2010-10-12        2017-10-23     
#>  5                    1          6 2019-06-04        2019-11-06     
#>  6                    1          7 2011-11-30        2012-03-22     
#>  7                    1          8 1993-03-18        1996-08-09     
#>  8                    1         10 2009-08-21        2010-02-21     
#>  9                    1         11 2022-03-27        2022-07-13     
#> 10                    1         14 2010-12-27        2012-10-26     
#> # ℹ more rows
```

### Indications of acetaminophen users

Now we´ve created our cohort we could first summarise the indications of
the cohort. These indications will always be cohorts, so we first need
to create them. Here we create two indication cohorts, one for headache
and the other for influenza.

``` r
indications <- list(headache = 378253, influenza = 4266367)
cdm <- generateConceptCohortSet(cdm,
  conceptSet = indications,
  name = "indications_cohort"
)
#> Warning: ! 3 casted column in indications_cohort (cohort_attrition) as do not match
#>   expected column type:
#> • `reason_id` from numeric to integer
#> • `excluded_records` from numeric to integer
#> • `excluded_subjects` from numeric to integer
#> Warning: ! 1 casted column in indications_cohort (cohort_codelist) as do not match
#>   expected column type:
#> • `concept_id` from numeric to integer
```

We can summarise the indication results using the `summariseIndication`
function:

``` r
indication_summary <- cdm$dus_cohort |>
  summariseIndication(
    indicationCohortName = "indications_cohort",
    unknownIndicationTable = "condition_occurrence",
    indicationWindow = list(c(-30, 0))
  )
#> Getting specified indications
#> Creating indication summary variables
#> Getting unknown indications
#> Summarising indication results
indication_summary |> glimpse()
#> Rows: 12
#> Columns: 13
#> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
#> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
#> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
#> $ group_level      <chr> "161_acetaminophen", "161_acetaminophen", "161_acetam…
#> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ variable_name    <chr> "number records", "number subjects", "Indication from…
#> $ variable_level   <chr> NA, NA, "headache", "headache", "influenza", "influen…
#> $ estimate_name    <chr> "count", "count", "count", "percentage", "count", "pe…
#> $ estimate_type    <chr> "integer", "integer", "integer", "percentage", "integ…
#> $ estimate_value   <chr> "61", "61", "1", "1.63934426229508", "0", "0", "0", "…
#> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…
```

### Drug use

We can quickly obtain a summary of drug utilisation among our cohort,
with various measures calculated for a provided ingredient concept (in
this case the concept for acetaminophen).

``` r
drug_utilisation_summary <- cdm$dus_cohort |>
  summariseDrugUtilisation(
    ingredientConceptId = 1125315,
    gapEra = 7
  )
#> Warning: ! `codelist` contains numeric values, they are casted to integers.
drug_utilisation_summary |> glimpse()
#> Rows: 58
#> Columns: 13
#> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
#> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
#> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
#> $ group_level      <chr> "161_acetaminophen", "161_acetaminophen", "161_acetam…
#> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ variable_name    <chr> "number records", "number subjects", "number exposure…
#> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ estimate_name    <chr> "count", "count", "q25", "median", "q75", "mean", "sd…
#> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
#> $ estimate_value   <chr> "61", "61", "1", "1", "1", "1.22950819672131", "0.528…
#> $ additional_name  <chr> "overall", "overall", "concept_set", "concept_set", "…
#> $ additional_level <chr> "overall", "overall", "ingredient_1125315_descendants…
table(drug_utilisation_summary$variable_name)
#> 
#>     cumulative dose cumulative quantity        exposed time  initial daily dose 
#>                   7                   7                   7                   7 
#>    initial quantity         number eras    number exposures      number records 
#>                   7                   7                   7                   1 
#>     number subjects    time to exposure 
#>                   1                   7
```

### Combine and share results

Now we can combine our results and suppress any counts less than 5 so
that they are ready to be shared.

``` r
results <- bind(
  indication_summary,
  drug_utilisation_summary
) |>
  suppress(minCellCount = 5)
results |> glimpse()
#> Rows: 70
#> Columns: 13
#> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2,…
#> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
#> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
#> $ group_level      <chr> "161_acetaminophen", "161_acetaminophen", "161_acetam…
#> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ variable_name    <chr> "number records", "number subjects", "Indication from…
#> $ variable_level   <chr> NA, NA, "headache", "headache", "influenza", "influen…
#> $ estimate_name    <chr> "count", "count", "count", "percentage", "count", "pe…
#> $ estimate_type    <chr> "integer", "integer", "integer", "percentage", "integ…
#> $ estimate_value   <chr> "61", "61", NA, NA, "0", "0", "0", "0", NA, NA, "57",…
#> $ additional_name  <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ additional_level <chr> "overall", "overall", "overall", "overall", "overall"…
```

## Further analyses

There are many more drug-related analyses that we could have done with
this acetaminophen cohort using the DrugUtilisation package. Please see
the package website for more details.
