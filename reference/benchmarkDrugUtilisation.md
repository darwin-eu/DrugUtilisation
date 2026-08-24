# Run benchmark of drug utilisation cohort generation

Run benchmark of drug utilisation cohort generation

## Usage

``` r
benchmarkDrugUtilisation(
  cdm,
  ingredient = "acetaminophen",
  alternativeIngredient = c("ibuprofen", "aspirin", "diclofenac"),
  indicationCohort = NULL,
  personSample = 1e+05
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

- personSample:

  Number of individuals to subset the cdm for the benchmark. If NULL no
  sample is applied.

## Value

A summarise_result object.

## Examples

``` r
# \donttest{
library(DrugUtilisation)
library(omock)

cdm <- mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")
#> ℹ Loading bundled GiBleed tables from package data.
#> ℹ Adding drug_strength table.
#> ℹ Creating local <cdm_reference> object.
#> ℹ Inserting <cdm_reference> into duckdb.
#> duckdb keeps downloaded extensions and secrets in a temporary directory:
#> ℹ /tmp/RtmpyJ0o4R/duckdb
#> This is removed when the R session ends.
#> • Extensions are re-downloaded each session.
#> • Secrets are lost.
#> ℹ Run duckdb(shared_home = TRUE) (or create ~/.duckdb) to keep them (suitable for most users).
#> ℹ Run duckdb(shared_home = FALSE) to accept the temporary directory (and silence this message).
#> ℹ See ?duckdb_storage for details and alternatives.

timings <- benchmarkDrugUtilisation(cdm)
#> 24-08-2026 09:41:21 Benchmark get necessary concepts
#> 24-08-2026 09:41:22 Benchmark generateDrugUtilisation
#> 24-08-2026 09:41:24 Benchmark generateDrugUtilisation with numberExposures and
#> daysPrescribed
#> 24-08-2026 09:41:27 Benchmark require
#> 24-08-2026 09:41:29 Benchmark generateIngredientCohortSet
#> 24-08-2026 09:41:33 Benchmark summariseDrugUtilisation
#> 24-08-2026 09:41:38 Benchmark summariseDrugRestart
#> 24-08-2026 09:41:40 Benchmark summariseProportionOfPatientsCovered
#> 24-08-2026 09:41:41 Benchmark summariseTreatment
#> 24-08-2026 09:41:45 Benchmark drop created tables

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
