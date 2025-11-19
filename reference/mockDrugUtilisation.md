# It creates a mock database for testing DrugUtilisation package

It creates a mock database for testing DrugUtilisation package

## Usage

``` r
mockDrugUtilisation(
  numberIndividuals = 10,
  ...,
  source = "local",
  con = lifecycle::deprecated(),
  writeSchema = lifecycle::deprecated(),
  seed = lifecycle::deprecated()
)
```

## Arguments

- numberIndividuals:

  Number of individuals in the mock cdm.

- ...:

  Tables to use as basis to create the mock. If some tables are provided
  they will be used to construct the cdm object.

- source:

  Source for the mock cdm, it can either be 'local' or 'duckdb'.

- con:

  deprecated.

- writeSchema:

  deprecated.

- seed:

  deprecated.

## Value

A cdm reference with the mock tables

## Examples

``` r
# \donttest{
library(DrugUtilisation)

cdm <- mockDrugUtilisation()

cdm
#> 
#> ── # OMOP CDM reference (local) of DUS MOCK ────────────────────────────────────
#> • omop tables: concept, concept_ancestor, concept_relationship,
#> condition_occurrence, drug_exposure, drug_strength, observation,
#> observation_period, person, visit_occurrence
#> • cohort tables: cohort1, cohort2
#> • achilles tables: -
#> • other tables: -
# }
```
