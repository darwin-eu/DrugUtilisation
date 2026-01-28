# Create mock data to test DrugUtilisation package

``` r
library(DrugUtilisation)
library(dplyr, warn.conflicts = FALSE)
```

## Introduction

In this vignette we will see how to use
[`mockDrugUtilisation()`](https://darwin-eu.github.io/DrugUtilisation/reference/mockDrugUtilisation.md)
function to create mock data. This function is predominantly used in
this package’s unit testing.

For example, one could use the default parameters to create a mock cdm
reference like so:

``` r
cdm <- mockDrugUtilisation()
```

As you can see this creates a local (in memory) cdm reference object:

``` r
cdm
#> 
#> ── # OMOP CDM reference (local) of DUS MOCK ────────────────────────────────────
#> • omop tables: concept, concept_ancestor, concept_relationship,
#> condition_occurrence, drug_exposure, drug_strength, observation,
#> observation_period, person, visit_occurrence
#> • cohort tables: cohort1, cohort2
#> • achilles tables: -
#> • other tables: -
```

This will then populate several omop tables (for example, `person`,
`concept` and `visit_occurrence`) and two cohorts in the cdm reference.

``` r
cdm$person |>
  glimpse()
#> Rows: 10
#> Columns: 18
#> $ person_id                   <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
#> $ gender_concept_id           <int> 8507, 8507, 8532, 8507, 8507, 8532, 8507, …
#> $ year_of_birth               <int> 2018, 1954, 1973, 1951, 2011, 2004, 1992, …
#> $ day_of_birth                <int> 27, 3, 11, 17, 28, 10, 11, 5, 1, 12
#> $ birth_datetime              <date> 2018-10-27, 1954-02-03, 1973-03-11, 1951-0…
#> $ race_concept_id             <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ ethnicity_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ location_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ provider_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ care_site_id                <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ month_of_birth              <int> 10, 2, 3, 9, 8, 6, 6, 8, 8, 2
#> $ person_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ gender_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ gender_source_concept_id    <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ race_source_value           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ race_source_concept_id      <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ ethnicity_source_value      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ ethnicity_source_concept_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA

cdm$person |>
  tally()
#> # A tibble: 1 × 1
#>       n
#>   <int>
#> 1    10

cdm$concept |>
  glimpse()
#> Rows: 38
#> Columns: 10
#> $ concept_id       <int> 8505, 8507, 8532, 8576, 8587, 8718, 9202, 9551, 9655,…
#> $ concept_name     <chr> "hour", "MALE", "FEMALE", "milligram", "milliliter", …
#> $ domain_id        <chr> "Unit", "Gender", "Gender", "Unit", "Unit", "Unit", "…
#> $ vocabulary_id    <chr> "UCUM", "Gender", "Gender", "UCUM", "UCUM", "UCUM", "…
#> $ concept_class_id <chr> "Unit", "Gender", "Gender", "Unit", "Unit", "Unit", "…
#> $ standard_concept <chr> "S", "S", "S", "S", "S", "S", "S", "S", "S", NA, "S",…
#> $ concept_code     <chr> "h", "M", "F", "mg", "mL", "[iU]", "OP", "10*-3.eq", …
#> $ valid_start_date <date> 1-01-19, 1-01-19, 1-01-19, 1-01-19, 1-01-19, 1-01-19…
#> $ valid_end_date   <date> 31-12-20, 31-12-20, 31-12-20, 31-12-20, 31-12-20, 31…
#> $ invalid_reason   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…

cdm$concept |>
  tally()
#> # A tibble: 1 × 1
#>       n
#>   <int>
#> 1    38

cdm$visit_occurrence |>
  glimpse()
#> Rows: 48
#> Columns: 17
#> $ visit_occurrence_id           <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 1…
#> $ person_id                     <int> 1, 2, 3, 3, 3, 3, 4, 4, 4, 6, 6, 6, 6, 7…
#> $ visit_concept_id              <int> 9202, 9202, 9202, 9202, 9202, 9202, 9202…
#> $ visit_start_date              <date> 2021-10-27, 1988-08-10, 1994-01-24, 199…
#> $ visit_end_date                <date> 2021-12-16, 1991-08-30, 2001-10-12, 200…
#> $ visit_type_concept_id         <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0…
#> $ visit_start_datetime          <date> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ visit_end_datetime            <date> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA,…
#> $ provider_id                   <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ care_site_id                  <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ visit_source_value            <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ visit_source_concept_id       <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ admitting_source_concept_id   <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ admitting_source_value        <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ discharge_to_concept_id       <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ discharge_to_source_value     <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …
#> $ preceding_visit_occurrence_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, …

cdm$visit_occurrence |>
  tally()
#> # A tibble: 1 × 1
#>       n
#>   <int>
#> 1    48

cdm$cohort1 |>
  glimpse()
#> Rows: 10
#> Columns: 4
#> $ cohort_definition_id <int> 2, 1, 1, 3, 1, 1, 1, 2, 3, 2
#> $ subject_id           <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
#> $ cohort_start_date    <date> 2021-10-30, 2019-08-31, 1996-01-16, 2000-06-05, 2…
#> $ cohort_end_date      <date> 2021-12-02, 2020-11-30, 1999-03-23, 2017-04-08, 2…

cdm$cohort1 |>
  tally()
#> # A tibble: 1 × 1
#>       n
#>   <int>
#> 1    10

cdm$cohort2 |>
  glimpse()
#> Rows: 10
#> Columns: 4
#> $ cohort_definition_id <int> 3, 2, 2, 1, 2, 2, 1, 2, 2, 2
#> $ subject_id           <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
#> $ cohort_start_date    <date> 2021-11-15, 1988-12-24, 1990-10-29, 2004-09-25, 2…
#> $ cohort_end_date      <date> 2021-11-24, 1993-03-08, 1993-09-13, 2013-08-10, 2…

cdm$cohort2 |>
  tally()
#> # A tibble: 1 × 1
#>       n
#>   <int>
#> 1    10
```

### Insert to `duckdb`

By default as we have seen the generated mock data is locally stored in
memory which is not a realistic situation in some cases. So inserting
this cdm_reference to a database is quite useful in terms to simulate a
real situation. You can insert the local cdm to another source
(e.g. duckdb, postgres, sql server, arrow…) using the function
[`omopgenerics::insertCdmTo()`](https://darwin-eu.github.io/omopgenerics/reference/insertCdmTo.html).
Alternatively you can use the `source` argument to insert the cdm to a
*DuckDB* database:

``` r
cdm <- mockDrugUtilisation(source = "duckdb")
cdm
#> 
#> ── # OMOP CDM reference (duckdb) of DUS MOCK ───────────────────────────────────
#> • omop tables: concept, concept_ancestor, concept_relationship,
#> condition_occurrence, drug_exposure, drug_strength, observation,
#> observation_period, person, visit_occurrence
#> • cohort tables: cohort1, cohort2
#> • achilles tables: -
#> • other tables: -
```

### Setting seeds

The user can also set the seed to control the randomness within the
data.

``` r
set.seed(seed = 1)
cdm <- mockDrugUtilisation(source = "duckdb")
cdm$person |>
  glimpse()
#> Rows: ??
#> Columns: 18
#> Database: DuckDB 1.4.3 [unknown@Linux 6.11.0-1018-azure:R 4.5.2/:memory:]
#> $ person_id                   <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
#> $ gender_concept_id           <int> 8507, 8532, 8507, 8507, 8532, 8507, 8507, …
#> $ year_of_birth               <int> 2008, 2000, 1970, 2003, 1956, 1986, 1986, …
#> $ day_of_birth                <int> 5, 21, 26, 11, 20, 20, 13, 9, 11, 1
#> $ birth_datetime              <date> 2008-12-05, 2000-11-21, 1970-11-26, 2003-0…
#> $ race_concept_id             <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ ethnicity_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ location_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ provider_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ care_site_id                <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ month_of_birth              <int> 12, 11, 11, 2, 4, 1, 2, 12, 3, 5
#> $ person_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ gender_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ gender_source_concept_id    <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ race_source_value           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ race_source_concept_id      <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ ethnicity_source_value      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ ethnicity_source_concept_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
```

If we would run it again the result will be different:

``` r
cdm <- mockDrugUtilisation(source = "duckdb")
cdm$person |>
  glimpse()
#> Rows: ??
#> Columns: 18
#> Database: DuckDB 1.4.3 [unknown@Linux 6.11.0-1018-azure:R 4.5.2/:memory:]
#> $ person_id                   <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
#> $ gender_concept_id           <int> 8507, 8532, 8532, 8532, 8532, 8507, 8532, …
#> $ year_of_birth               <int> 1985, 1979, 1962, 1997, 1956, 2010, 1950, …
#> $ day_of_birth                <int> 20, 5, 20, 9, 12, 19, 2, 23, 27, 25
#> $ birth_datetime              <date> 1985-04-20, 1979-02-05, 1962-12-20, 1997-1…
#> $ race_concept_id             <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ ethnicity_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ location_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ provider_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ care_site_id                <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ month_of_birth              <int> 4, 2, 12, 10, 8, 1, 11, 11, 3, 11
#> $ person_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ gender_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ gender_source_concept_id    <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ race_source_value           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ race_source_concept_id      <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ ethnicity_source_value      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ ethnicity_source_concept_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
```

But if we set the same seed again, the result would be the same than
initially:

``` r
set.seed(seed = 1)
cdm <- mockDrugUtilisation(source = "duckdb")
cdm$person |>
  glimpse()
#> Rows: ??
#> Columns: 18
#> Database: DuckDB 1.4.3 [unknown@Linux 6.11.0-1018-azure:R 4.5.2/:memory:]
#> $ person_id                   <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10
#> $ gender_concept_id           <int> 8507, 8532, 8507, 8507, 8532, 8507, 8507, …
#> $ year_of_birth               <int> 2008, 2000, 1970, 2003, 1956, 1986, 1986, …
#> $ day_of_birth                <int> 5, 21, 26, 11, 20, 20, 13, 9, 11, 1
#> $ birth_datetime              <date> 2008-12-05, 2000-11-21, 1970-11-26, 2003-0…
#> $ race_concept_id             <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ ethnicity_concept_id        <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ location_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ provider_id                 <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ care_site_id                <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ month_of_birth              <int> 12, 11, 11, 2, 4, 1, 2, 12, 3, 5
#> $ person_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ gender_source_value         <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ gender_source_concept_id    <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ race_source_value           <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ race_source_concept_id      <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ ethnicity_source_value      <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
#> $ ethnicity_source_concept_id <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA
```

This can be quite useful to generate the same cdm_reference object.

### Create bigger mock

By default the generated mock contains only 10 individuals and small
tables size:

``` r
lapply(cdm, \(x) x |> tally() |> pull())
#> $person
#> [1] 10
#> 
#> $observation_period
#> [1] 10
#> 
#> $visit_occurrence
#> [1] 47
#> 
#> $condition_occurrence
#> [1] 11
#> 
#> $drug_exposure
#> [1] 36
#> 
#> $observation
#> [1] 16
#> 
#> $concept
#> [1] 38
#> 
#> $concept_relationship
#> [1] 37
#> 
#> $concept_ancestor
#> [1] 44
#> 
#> $drug_strength
#> [1] 14
#> 
#> $cohort1
#> [1] 10
#> 
#> $cohort2
#> [1] 10
```

You can change that using the `numberIndividual` argument to generate
more individuals and records:

``` r
cdm <- mockDrugUtilisation(numberIndividual = 100, source = "duckdb")
```

This will ensure that the `person` table will define 100 mock
individuals:

``` r
cdm$person |>
  tally()
#> # Source:   SQL [?? x 1]
#> # Database: DuckDB 1.4.3 [unknown@Linux 6.11.0-1018-azure:R 4.5.2/:memory:]
#>       n
#>   <dbl>
#> 1   100
```

As a consequence of this, the generated tables will have more rows
compared to the initial ones:

``` r
lapply(cdm, \(x) x |> tally() |> pull())
#> $person
#> [1] 100
#> 
#> $observation_period
#> [1] 100
#> 
#> $visit_occurrence
#> [1] 515
#> 
#> $condition_occurrence
#> [1] 201
#> 
#> $drug_exposure
#> [1] 314
#> 
#> $observation
#> [1] 192
#> 
#> $concept
#> [1] 38
#> 
#> $concept_relationship
#> [1] 37
#> 
#> $concept_ancestor
#> [1] 44
#> 
#> $drug_strength
#> [1] 14
#> 
#> $cohort1
#> [1] 100
#> 
#> $cohort2
#> [1] 100
```

### Creat mock data by customising tables

#### Customise omop tables

As we saw previously, the omop tables are automatically populated in
[`mockDrugUtilisation()`](https://darwin-eu.github.io/DrugUtilisation/reference/mockDrugUtilisation.md).
However, the user can customise these tables. For example, to customise
`drug_exposure` table, one could do the following:

``` r
cdm <- mockDrugUtilisation(
  drug_exposure = tibble(
    drug_exposure_id = 1:3,
    person_id = c(1, 1, 1),
    drug_concept_id = c(2, 3, 4),
    drug_exposure_start_date = as.Date(c(
      "2000-01-01", "2000-01-10", "2000-02-20"
    )),
    drug_exposure_end_date = as.Date(c(
      "2000-02-10", "2000-03-01", "2000-02-20"
    )),
    quantity = c(41, 52, 1),
    drug_type_concept_id = 0
  ),
  source = "duckdb"
)
```

``` r
cdm$drug_exposure |>
  glimpse()
#> Rows: ??
#> Columns: 23
#> Database: DuckDB 1.4.3 [unknown@Linux 6.11.0-1018-azure:R 4.5.2/:memory:]
#> $ drug_exposure_id             <int> 1, 2, 3
#> $ person_id                    <int> 1, 1, 1
#> $ drug_concept_id              <int> 2, 3, 4
#> $ drug_exposure_start_date     <date> 2000-01-01, 2000-01-10, 2000-02-20
#> $ drug_exposure_end_date       <date> 2000-02-10, 2000-03-01, 2000-02-20
#> $ quantity                     <dbl> 41, 52, 1
#> $ drug_type_concept_id         <int> 0, 0, 0
#> $ drug_exposure_start_datetime <date> NA, NA, NA
#> $ drug_exposure_end_datetime   <date> NA, NA, NA
#> $ verbatim_end_date            <date> NA, NA, NA
#> $ stop_reason                  <chr> NA, NA, NA
#> $ refills                      <int> NA, NA, NA
#> $ days_supply                  <int> NA, NA, NA
#> $ sig                          <chr> NA, NA, NA
#> $ route_concept_id             <int> NA, NA, NA
#> $ lot_number                   <chr> NA, NA, NA
#> $ provider_id                  <int> NA, NA, NA
#> $ visit_occurrence_id          <int> NA, NA, NA
#> $ visit_detail_id              <int> NA, NA, NA
#> $ drug_source_value            <chr> NA, NA, NA
#> $ drug_source_concept_id       <int> NA, NA, NA
#> $ route_source_value           <chr> NA, NA, NA
#> $ dose_unit_source_value       <chr> NA, NA, NA
```

However, one needs to be vigilant that the customised omop table is
implicitly dependent on other omop tables. For example, the
`drug_exposure_start_date` of someone in the `drug_exposure` table
should lie within that person’s `observation_period_start_date` and
`observation_period_end_date`.

One could also modify other omop tables including `person`, `concept`,
`concept_ancestor`, `drug_strength`, `observation_period`,
`condition_occurrence`, `observation`, and `concept_relationship` in a
similar fashion.

#### Customise cohorts

Similarly, cohort tables can also be customised.

``` r
cdm <- mockDrugUtilisation(
  observation_period = tibble(
    observation_period_id = 1,
    person_id = 1:2,
    observation_period_start_date = as.Date("1900-01-01"),
    observation_period_end_date = as.Date("2100-01-01"),
    period_type_concept_id = 0
  ),
  cohort1 = tibble(
    cohort_definition_id = 1,
    subject_id = c(1, 1, 2),
    cohort_start_date = as.Date(c("2000-01-01", "2001-01-01", "2000-01-01")),
    cohort_end_date = as.Date(c("2000-03-01", "2001-03-01", "2000-03-01"))
  ),
  source = "duckdb"
)
```

``` r
cdm$cohort1 |>
  glimpse()
#> Rows: ??
#> Columns: 4
#> Database: DuckDB 1.4.3 [unknown@Linux 6.11.0-1018-azure:R 4.5.2/:memory:]
#> $ cohort_definition_id <int> 1, 1, 1
#> $ subject_id           <int> 1, 1, 2
#> $ cohort_start_date    <date> 2000-01-01, 2001-01-01, 2000-01-01
#> $ cohort_end_date      <date> 2000-03-01, 2001-03-01, 2000-03-01
```
