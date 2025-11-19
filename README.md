
<!-- README.md is generated from README.Rmd. Please edit that file -->

# DrugUtilisation <img src="man/figures/logo.png" align="right" height="200"/>

[![CRANstatus](https://www.r-pkg.org/badges/version/DrugUtilisation)](https://CRAN.R-project.org/package=DrugUtilisation)
[![codecov.io](https://codecov.io/github/darwin-eu/DrugUtilisation/coverage.svg?branch=main)](https://app.codecov.io/github/darwin-eu/DrugUtilisation?branch=main)
[![R-CMD-check](https://github.com/darwin-eu/DrugUtilisation/workflows/R-CMD-check/badge.svg)](https://github.com/darwin-eu/DrugUtilisation/actions)
[![Lifecycle:stable](https://img.shields.io/badge/lifecycle-stable-brightgreen.svg)](https://lifecycle.r-lib.org/articles/stages.html#stable)

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
library(dplyr)
library(CDMConnector)

cdm <- mockDrugUtilisation(numberIndividual = 100, source = "duckdb")
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
cdm$dus_cohort |>
  requireIsFirstDrugEntry() |>
  requireObservationBeforeDrug(days = 30)
#> # Source:   table<dus_cohort> [?? x 4]
#> # Database: DuckDB v1.3.1 [root@Darwin 24.6.0:R 4.4.1/:memory:]
#>    cohort_definition_id subject_id cohort_start_date cohort_end_date
#>                   <int>      <int> <date>            <date>         
#>  1                    1         13 2007-07-19        2007-11-19     
#>  2                    1         29 2014-10-16        2017-08-02     
#>  3                    1         83 2020-04-14        2020-08-04     
#>  4                    1         14 2020-09-17        2020-09-20     
#>  5                    1         23 1993-05-24        1996-06-23     
#>  6                    1         25 2021-10-17        2021-10-22     
#>  7                    1         69 2004-12-06        2005-02-04     
#>  8                    1         74 2020-08-07        2020-08-09     
#>  9                    1         93 2021-03-21        2021-08-15     
#> 10                    1         26 2019-03-08        2021-06-02     
#> # ℹ more rows
```

### Indications of acetaminophen users

Now we´ve created our cohort we could first summarise the indications of
the cohort. These indications will always be cohorts, so we first need
to create them. Here we create two indication cohorts, one for headache
and the other for influenza.

``` r
indications <- list(headache = 378253, influenza = 4266367)
cdm <- generateConceptCohortSet(
  cdm = cdm,
  conceptSet = indications,
  name = "indications_cohort"
)
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
#> ℹ Intersect with indications table (indications_cohort)
#> ℹ Summarising indications.
indication_summary |> glimpse()
#> Rows: 12
#> Columns: 13
#> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
#> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
#> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
#> $ group_level      <chr> "acetaminophen", "acetaminophen", "acetaminophen", "a…
#> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ variable_name    <chr> "Indication from 30 days before to the index date", "…
#> $ variable_level   <chr> "headache", "headache", "influenza", "influenza", "he…
#> $ estimate_name    <chr> "count", "percentage", "count", "percentage", "count"…
#> $ estimate_type    <chr> "integer", "percentage", "integer", "percentage", "in…
#> $ estimate_value   <chr> "10", "17.5438596491228", "11", "19.2982456140351", "…
#> $ additional_name  <chr> "window_name", "window_name", "window_name", "window_…
#> $ additional_level <chr> "-30 to 0", "-30 to 0", "-30 to 0", "-30 to 0", "-30 …
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
drug_utilisation_summary |> glimpse()
#> Rows: 72
#> Columns: 13
#> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
#> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
#> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
#> $ group_level      <chr> "acetaminophen", "acetaminophen", "acetaminophen", "a…
#> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ variable_name    <chr> "number records", "number subjects", "number exposure…
#> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ estimate_name    <chr> "count", "count", "q25", "median", "q75", "mean", "sd…
#> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
#> $ estimate_value   <chr> "57", "57", "1", "1", "1", "1.19298245614035", "0.515…
#> $ additional_name  <chr> "overall", "overall", "concept_set", "concept_set", "…
#> $ additional_level <chr> "overall", "overall", "ingredient_1125315_descendants…
table(drug_utilisation_summary$variable_name)
#> 
#>    cumulative dose milligram          cumulative quantity 
#>                            7                            7 
#>                 days exposed              days prescribed 
#>                            7                            7 
#> initial daily dose milligram    initial exposure duration 
#>                            7                            7 
#>             initial quantity                  number eras 
#>                            7                            7 
#>             number exposures               number records 
#>                            7                            1 
#>              number subjects             time to exposure 
#>                            1                            7
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
#> Rows: 84
#> Columns: 13
#> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2,…
#> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
#> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
#> $ group_level      <chr> "acetaminophen", "acetaminophen", "acetaminophen", "a…
#> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ variable_name    <chr> "Indication from 30 days before to the index date", "…
#> $ variable_level   <chr> "headache", "headache", "influenza", "influenza", "he…
#> $ estimate_name    <chr> "count", "percentage", "count", "percentage", "count"…
#> $ estimate_type    <chr> "integer", "percentage", "integer", "percentage", "in…
#> $ estimate_value   <chr> "10", "17.5438596491228", "11", "19.2982456140351", "…
#> $ additional_name  <chr> "window_name", "window_name", "window_name", "window_…
#> $ additional_level <chr> "-30 to 0", "-30 to 0", "-30 to 0", "-30 to 0", "-30 …
```

## Further analyses

There are many more drug-related analyses that we could have done with
this acetaminophen cohort using the DrugUtilisation package. Please see
the package website for more details.
