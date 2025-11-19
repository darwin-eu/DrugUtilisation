# Getting drug utilisation related information of subjects in a cohort

## Introduction

The DrugUtilisation package includes a range of functions that add
drug-related information of subjects in OMOP CDM tables and cohort
tables. Essentially, there are two functionalities: `add` and
`summarise`. While the first return patient-level information on drug
usage, the second returns aggregate estimates of it. In this vignette,
we will explore these functions and provide some examples for its usage.

## Set up

### Mock data

For this vignette we will use mock data contained in the DrugUtilisation
package. This mock dataset contains cohorts, we will take “cohort1” as
the cohort table of interest from which we want to study drug usage of
acetaminophen.

``` r
library(DrugUtilisation)
library(dplyr, warn.conflicts = FALSE)
library(CodelistGenerator)
library(PatientProfiles)

cdm <- mockDrugUtilisation(numberIndividual = 200, source = "duckdb")

cdm$cohort1 |>
  glimpse()
#> Rows: ??
#> Columns: 4
#> Database: DuckDB 1.4.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.2/:memory:]
#> $ cohort_definition_id <int> 3, 1, 1, 3, 3, 2, 1, 3, 2, 3, 3, 1, 2, 3, 2, 2, 1…
#> $ subject_id           <int> 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15…
#> $ cohort_start_date    <date> 2004-08-15, 2015-06-19, 2001-07-26, 2008-06-25, …
#> $ cohort_end_date      <date> 2005-04-10, 2017-10-21, 2001-12-07, 2012-03-22, …
```

### Drug codes

Since we want to characterise *acetaminophen* and *simvastatin* usage
for subjects in cohort1, we first have to get the codelist with
CodelistGenerator:

``` r
drugConcepts <- getDrugIngredientCodes(cdm = cdm, name = c("acetaminophen", "simvastatin"))
```

## Add drug utilisation information

### addNumberExposures()

With the function
**[`addNumberExposures()`](https://darwin-eu.github.io/DrugUtilisation/reference/addNumberExposures.md)**
we can get how many exposures to acetaminophen each patient in our
cohort had during a certain time. There are 2 thing to keep in mind when
using this function:

- **Time period of interest:** The `indexDate` and `censorDate`
  arguments refer to the time-period in which we are interested to
  compute the number of exposure to acetaminophen. The refer to date
  columns in the cohort table, and by default this are
  “cohort_start_date” and “cohort_end_date” respectively.

- **Incident or prevalent events?** Do we want to consider only those
  exposures to the drug of interest starting during the time-period
  (`restrictIncident = TRUE`), or do we also want to take into account
  those that started before but underwent for at least some time during
  the follow-up period considered (`restrictIncident = FALSE`)?

In what follows we add a column in the cohort table, with the number of
incident exposures during the time patients are in the cohort:

``` r
cohort <- addNumberExposures(
  cohort = cdm$cohort1, # cohort with the population of interest
  conceptSet = drugConcepts, # concepts of the drugs of interest
  indexDate = "cohort_start_date",
  censorDate = "cohort_end_date",
  restrictIncident = TRUE,
  nameStyle = "number_exposures_{concept_name}",
  name = NULL
)

cohort |>
  glimpse()
#> Rows: ??
#> Columns: 6
#> Database: DuckDB 1.4.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.2/:memory:]
#> $ cohort_definition_id               <int> 3, 2, 1, 2, 3, 1, 3, 2, 1, 2, 3, 1,…
#> $ subject_id                         <int> 1, 6, 7, 9, 10, 12, 14, 15, 17, 20,…
#> $ cohort_start_date                  <date> 2004-08-15, 2012-07-24, 2013-06-10…
#> $ cohort_end_date                    <date> 2005-04-10, 2012-08-10, 2013-08-26…
#> $ number_exposures_161_acetaminophen <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
#> $ number_exposures_36567_simvastatin <int> 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,…
```

### addNumberEras()

This function works like the previous one, but calculates the **number
of eras** instead of exposures. The difference between these two is
given by the `gapEra` argument: consecutive drug exposures separated by
less than the days specified in `gapEra`, are collapsed together into
the same era.

Next we compute the number of eras, considering a gap of 3 days.

Additionally, we use the argument `nameStyle` so the new columns are
only identified by the concept name, instead of using the prefix
“number_eras\_” set by default.

``` r
cohort <- addNumberEras(
  cohort = cdm$cohort1, # cohort with the population of interest
  conceptSet = drugConcepts, # concepts of the drugs of interest
  indexDate = "cohort_start_date",
  censorDate = "cohort_end_date",
  gapEra = 3,
  restrictIncident = TRUE,
  nameStyle = "{concept_name}",
  name = NULL
)

cohort |>
  glimpse()
#> Rows: ??
#> Columns: 6
#> Database: DuckDB 1.4.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.2/:memory:]
#> $ cohort_definition_id <int> 3, 2, 1, 2, 3, 1, 3, 2, 1, 2, 3, 1, 3, 3, 3, 1, 1…
#> $ subject_id           <int> 1, 6, 7, 9, 10, 12, 14, 15, 17, 20, 21, 22, 23, 2…
#> $ cohort_start_date    <date> 2004-08-15, 2012-07-24, 2013-06-10, 2017-11-04, …
#> $ cohort_end_date      <date> 2005-04-10, 2012-08-10, 2013-08-26, 2018-02-24, …
#> $ `36567_simvastatin`  <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ `161_acetaminophen`  <int> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
```

### daysExposed

This argument set to TRUE will add a column specifying the time in days
a person has been exposed to the drug of interest. Take note that
`gapEra` and `restrictIncident` will be taken into account for this
calculation:

1.  **Drug eras:** exposed time will be based on drug eras according to
    `gapEra`.

2.  **Incident exposures:** if `restrictIncident = TRUE`, exposed time
    will consider only those drug exposures starting after indexDate,
    while if `restrictIncident = FALSE`, exposures that started before
    indexDate and ended afterwards will also be taken into account.

The subfunction to get only this information is
[`addDaysExposed()`](https://darwin-eu.github.io/DrugUtilisation/reference/addDaysExposed.md).

### daysPrescribed

Similarly to the previous one, this argument adds a column with the
number of days the individual is prescribed with the drug of interest,
if set to TRUE. This number is calculated by adding up the days for all
prescriptions that contribute to the analysis. In this case,
`restrictIncident` will influence the calculation as follows: if set to
TRUE, drug prescriptions will only be counted if happening after index
date; if FALSE, all prescriptions will contribute to the sum.

The subfunction to get only this information is
[`addDaysPrescribed()`](https://darwin-eu.github.io/DrugUtilisation/reference/addDaysPrescribed.md).

### timeToExposure

If set to TRUE, a column will be added that shows the number of days
until the first exposure occurring within the considered time window.
Notice that the value of `restrictIncident` will be taken into account:
if TRUE, the time to the first incident exposure during the time
interval is measured; otherwise, exposures that start before the
`indexDate` and end afterwards will be considered (in these cases, time
to exposure is 0).

The subfunction to get only this information is
[`addTimeToExposure()`](https://darwin-eu.github.io/DrugUtilisation/reference/addTimeToExposure.md).

### initialExposureDuration

This argument will add a column with information on the number of days
of the first prescription of the drug. If `restrictIncident = TRUE`,
this first drug exposure record after index date will be selected.
Otherwise, the first record ever will be the one contributing this
number.

The subfunction to get only this information is
[`addInitialExposureDuration()`](https://darwin-eu.github.io/DrugUtilisation/reference/addInitialExposureDuration.md).

### initialQuantity and cumulativeQuantity

These, if TRUE, will add a column each specifying which was the initial
quantity prescribed at the start of the first exposure considered
(`initialQuantity`), and the cumulative quantity taken throughout the
exposures in the considered time-window (`cumulativeQuantity`).

Quantities are measured at conceptSet level not ingredient. Notice that
for both measures `restrictIncident` is considered, while `gapEra` is
used for the `cumulative quantity`.

The subfunctions to get this information are
[`addInitialQuantity()`](https://darwin-eu.github.io/DrugUtilisation/reference/addInitialQuantity.md)
and
[`addCumulativeQuantity()`](https://darwin-eu.github.io/DrugUtilisation/reference/addCumulativeQuantity.md)
respectively.

### initialDailyDose and cumulativeDose

If `initialDailyDose` is TRUE, a column will be add specifying for each
of the ingredients in a conceptSet which was the initial daily dose
given. The `cumulativeDose` will measure for each ingredient the total
dose taken throughout the exposures considered in the time-window.
Recall that `restrictIncident` is considered in these calculations, and
that the cumulative dose also considers `gapEra`.

The subfunctions to get this information are
[`addInitialDailyDose()`](https://darwin-eu.github.io/DrugUtilisation/reference/addInitialDailyDose.md)
and
[`addCumulativeDose()`](https://darwin-eu.github.io/DrugUtilisation/reference/addCumulativeDose.md)
respectively.

### addDrugUtilisation()

All the explained **`add`** functions are subfunctions of the more
comprehensive
**[`addDrugUtilisation()`](https://darwin-eu.github.io/DrugUtilisation/reference/addDrugUtilisation.md)**.
This broader function computes multiple drug utilization metrics.

``` r
addDrugUtilisation(
  cohort,
  indexDate = "cohort_start_date",
  censorDate = "cohort_end_date",
  ingredientConceptId = NULL,
  conceptSet = NULL,
  restrictIncident = TRUE,
  gapEra = 1,
  numberExposures = TRUE,
  numberEras = TRUE,
  daysExposed = TRUE,
  daysPrescribed = TRUE,
  timeToExposure = TRUE,
  initialExposureDuration = TRUE,
  initialQuantity = TRUE,
  cumulativeQuantity = TRUE,
  initialDailyDose = TRUE,
  cumulativeDose = TRUE,
  nameStyle = "{value}_{concept_name}_{ingredient}",
  name = NULL
)
```

- Using
  [`addDrugUtilisation()`](https://darwin-eu.github.io/DrugUtilisation/reference/addDrugUtilisation.md)
  is recommended when multiple parameters are needed, as it is more
  computationally efficient than chaining the different subfunctions.

- If `conceptSet` is NULL, it will be produced from descendants of given
  ingredients.

- `nameStyle` argument allows customisation of the names of the new
  columns added by the function, following the glue package style.

- By default it returns a temporal table, but if `name` is not NULL a
  permanent table with the defined name will be computed in the
  database.

### Use case

In what follows we create a permanent table “drug_utilisation_example”
in the database with the information on dosage and quantity of the
ingredients 1125315 (acetaminophen) and 1503297 (metformin). We are
interested in exposures happening from cohort end date, until the end of
the patient’s observation data. Additionally, we define an exposure era
using a gap of 7 days, and we only consider incident exposures during
that time.

``` r
cdm$drug_utilisation_example <- cdm$cohort1 |>
  # add end of current observation date with the package PatientProfiels
  addFutureObservation(futureObservationType = "date") |>
  # add the targeted drug utilisation measures
  addDrugUtilisation(
    indexDate = "cohort_end_date",
    censorDate = "future_observation",
    ingredientConceptId = c(1125315, 1503297),
    conceptSet = NULL,
    restrictIncident = TRUE,
    gapEra = 7,
    numberExposures = FALSE,
    numberEras = FALSE,
    daysExposed = FALSE,
    daysPrescribed = FALSE,
    timeToExposure = FALSE,
    initialExposureDuration = FALSE,
    initialQuantity = TRUE,
    cumulativeQuantity = TRUE,
    initialDailyDose = TRUE,
    cumulativeDose = TRUE,
    nameStyle = "{value}_{concept_name}_{ingredient}",
    name = "drug_utilisation_example"
  )

cdm$drug_utilisation_example |>
  glimpse()
#> Rows: ??
#> Columns: 13
#> Database: DuckDB 1.4.2 [unknown@Linux 6.11.0-1018-azure:R 4.5.2/:memory:]
#> $ cohort_definition_id                                                <int> 3,…
#> $ subject_id                                                          <int> 1,…
#> $ cohort_start_date                                                   <date> 2…
#> $ cohort_end_date                                                     <date> 2…
#> $ future_observation                                                  <date> 2…
#> $ cumulative_quantity_ingredient_1125315_descendants                  <dbl> 0,…
#> $ cumulative_quantity_ingredient_1503297_descendants                  <dbl> 0,…
#> $ initial_quantity_ingredient_1503297_descendants                     <dbl> 0,…
#> $ initial_quantity_ingredient_1125315_descendants                     <dbl> 0,…
#> $ cumulative_dose_milligram_ingredient_1125315_descendants_1125315    <dbl> 0,…
#> $ initial_daily_dose_milligram_ingredient_1125315_descendants_1125315 <dbl> 0,…
#> $ cumulative_dose_milligram_ingredient_1503297_descendants_1503297    <dbl> 0,…
#> $ initial_daily_dose_milligram_ingredient_1503297_descendants_1503297 <dbl> 0,…
```

## Summarise drug utilisation information

The information given by
[`addDrugUtilisation()`](https://darwin-eu.github.io/DrugUtilisation/reference/addDrugUtilisation.md)
or its sub-functions is at patient level. If we are interested in
aggregated estimates for these measure we can use
[`summariseDrugUtilisation()`](https://darwin-eu.github.io/DrugUtilisation/reference/summariseDrugUtilisation.md).

### summariseDrugUtilisation()

This function will provide the desired estimates (set in the argument
`estimates`) of the targeted drug utilisation measures. Similar to
[`addDrugUtilisation()`](https://darwin-eu.github.io/DrugUtilisation/reference/addDrugUtilisation.md),
by setting TRUE or FALSE each of the drug utilisation measures, the user
can choose which measures to obtain.

``` r
duResults <- summariseDrugUtilisation(
  cohort = cdm$cohort1,
  strata = list(),
  estimates = c(
    "q25", "median", "q75", "mean", "sd", "count_missing",
    "percentage_missing"
  ),
  indexDate = "cohort_start_date",
  censorDate = "cohort_end_date",
  ingredientConceptId = c(1125315, 1503297),
  conceptSet = NULL,
  restrictIncident = TRUE,
  gapEra = 7,
  numberExposures = TRUE,
  numberEras = TRUE,
  daysExposed = TRUE,
  daysPrescribed = TRUE,
  timeToExposure = TRUE,
  initialExposureDuration = TRUE,
  initialQuantity = TRUE,
  cumulativeQuantity = TRUE,
  initialDailyDose = TRUE,
  cumulativeDose = TRUE
)

duResults |>
  glimpse()
#> Rows: 426
#> Columns: 13
#> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
#> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
#> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
#> $ group_level      <chr> "cohort_1", "cohort_1", "cohort_1", "cohort_1", "coho…
#> $ strata_name      <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ strata_level     <chr> "overall", "overall", "overall", "overall", "overall"…
#> $ variable_name    <chr> "number records", "number subjects", "number exposure…
#> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ estimate_name    <chr> "count", "count", "q25", "median", "q75", "mean", "sd…
#> $ estimate_type    <chr> "integer", "integer", "integer", "integer", "integer"…
#> $ estimate_value   <chr> "66", "66", "0", "0", "0", "0.196969696969697", "0.50…
#> $ additional_name  <chr> "overall", "overall", "concept_set", "concept_set", "…
#> $ additional_level <chr> "overall", "overall", "ingredient_1503297_descendants…
```

As seen below, the result of this function is a `summarised_result`
object. For more information on these class of objects see
`omopgenerics` package.

Additionally, the `strata` argument will provide the estimates for
different stratifications defined by columns in the cohort. For
instance, we can add a column indicating the sex, and another indicating
if the subject is older than 50, and use those to stratify by sex and
age, together and separately as follows:

``` r
duResults <- cdm$cohort1 |>
  # add age and sex
  addDemographics(
    age = TRUE,
    ageGroup = list("<=50" = c(0, 50), ">50" = c(51, 150)),
    sex = TRUE,
    priorObservation = FALSE,
    futureObservation = FALSE
  ) |>
  # drug utilisation
  summariseDrugUtilisation(
    strata = list("age_group", "sex", c("age_group", "sex")),
    estimates = c("mean", "sd", "count_missing", "percentage_missing"),
    indexDate = "cohort_start_date",
    censorDate = "cohort_end_date",
    ingredientConceptId = c(1125315, 1503297),
    conceptSet = NULL,
    restrictIncident = TRUE,
    gapEra = 7,
    numberExposures = TRUE,
    numberEras = TRUE,
    daysExposed = TRUE,
    daysPrescribed = TRUE,
    timeToExposure = TRUE,
    initialExposureDuration = TRUE,
    initialQuantity = TRUE,
    cumulativeQuantity = TRUE,
    initialDailyDose = TRUE,
    cumulativeDose = TRUE
  )

duResults |>
  glimpse()
#> Rows: 1,968
#> Columns: 13
#> $ result_id        <int> 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,…
#> $ cdm_name         <chr> "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS MOCK", "DUS …
#> $ group_name       <chr> "cohort_name", "cohort_name", "cohort_name", "cohort_…
#> $ group_level      <chr> "cohort_1", "cohort_1", "cohort_1", "cohort_1", "coho…
#> $ strata_name      <chr> "age_group", "age_group", "age_group", "age_group", "…
#> $ strata_level     <chr> "<=50", "<=50", "<=50", "<=50", "<=50", "<=50", "<=50…
#> $ variable_name    <chr> "number records", "number subjects", "number exposure…
#> $ variable_level   <chr> NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, NA, N…
#> $ estimate_name    <chr> "count", "count", "mean", "sd", "count_missing", "per…
#> $ estimate_type    <chr> "integer", "integer", "numeric", "numeric", "integer"…
#> $ estimate_value   <chr> "63", "63", "0.158730158730159", "0.447442524921401",…
#> $ additional_name  <chr> "overall", "overall", "concept_set", "concept_set", "…
#> $ additional_level <chr> "overall", "overall", "ingredient_1503297_descendants…
```

The estimates obtained in this last part correspond to the mean (`mean`)
and standard deviation (`sd`) of those that had information on dose and
quantity, and the number (`count_missing`) (and percentage
(`percentage_missing`)) of subjects with missing information.

### tableDrugUtilisation()

Results from
[`summariseDrugUtilisation()`](https://darwin-eu.github.io/DrugUtilisation/reference/summariseDrugUtilisation.md)
can be nicely visualised in a tabular format using the function
[`tableDrugUtilisation()`](https://darwin-eu.github.io/DrugUtilisation/reference/tableDrugUtilisation.md).

``` r
tableDrugUtilisation(duResults)
#> cdm_name, cohort_name, age_group, sex, variable_level, censor_date,
#> cohort_table_name, gap_era, index_date, and restrict_incident are missing in
#> `columnOrder`, will be added last.
#> ℹ <median> (<q25> - <q75>) has not been formatted.
```

[TABLE]
