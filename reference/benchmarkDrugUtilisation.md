# Run benchmark of drug utilisation cohort generation

Run benchmark of drug utilisation cohort generation

## Usage

``` r
benchmarkDrugUtilisation(
  cdm,
  ingredient = "acetaminophen",
  alternativeIngredient = c("ibuprofen", "aspirin", "diclofenac"),
  indicationCohort = NULL
)
```

## Arguments

- cdm:

  A `cdm_reference` object.

- ingredient:

  Name of ingredient to benchmark.

- alternativeIngredient:

  Name of ingredients to use as alternative treatments.

- indicationCohort:

  Name of a cohort in the cdm_reference object to use as indicatiomn.

## Value

A summarise_result object.

## Examples

``` r
# \donttest{
library(DrugUtilisation)
library(omock)

cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")
#> ℹ Reading GiBleed tables.
#> ℹ Adding drug_strength table.
#> ℹ Creating local <cdm_reference> object.
#> ℹ Inserting <cdm_reference> into duckdb.

timings <- benchmarkDrugUtilisation(cdm)
#> 28-01-2026 15:54:28 Benchmark get necessary concepts
#> 28-01-2026 15:54:28 Benchmark generateDrugUtilisation
#> 28-01-2026 15:54:32 Benchmark generateDrugUtilisation with numberExposures and
#> daysPrescribed
#> 28-01-2026 15:54:37 Benchmark require
#> 28-01-2026 15:54:40 Benchmark generateIngredientCohortSet
#> 28-01-2026 15:54:46 Benchmark summariseDrugUtilisation
#> 28-01-2026 15:54:54 Benchmark summariseDrugRestart
#> 28-01-2026 15:54:57 Benchmark summariseProportionOfPatientsCovered
#> 28-01-2026 15:55:03 Benchmark summariseTreatment
#> 28-01-2026 15:55:08 Benchmark drop created tables

timings
#> # A tibble: 10 × 13
#>    result_id cdm_name group_name group_level            strata_name strata_level
#>        <int> <chr>    <chr>      <chr>                  <chr>       <chr>       
#>  1         1 GiBleed  task       get necessary concepts overall     overall     
#>  2         1 GiBleed  task       generateDrugUtilisati… overall     overall     
#>  3         1 GiBleed  task       generateDrugUtilisati… overall     overall     
#>  4         1 GiBleed  task       require                overall     overall     
#>  5         1 GiBleed  task       generateIngredientCoh… overall     overall     
#>  6         1 GiBleed  task       summariseDrugUtilisat… overall     overall     
#>  7         1 GiBleed  task       summariseDrugRestart   overall     overall     
#>  8         1 GiBleed  task       summariseProportionOf… overall     overall     
#>  9         1 GiBleed  task       summariseTreatment     overall     overall     
#> 10         1 GiBleed  task       drop created tables    overall     overall     
#> # ℹ 7 more variables: variable_name <chr>, variable_level <chr>,
#> #   estimate_name <chr>, estimate_type <chr>, estimate_value <chr>,
#> #   additional_name <chr>, additional_level <chr>
# }
```
