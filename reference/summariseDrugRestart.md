# Summarise the drug restart for each follow-up period of interest.

Summarise the drug restart for each follow-up period of interest.

## Usage

``` r
summariseDrugRestart(
  cohort,
  cohortId = NULL,
  switchCohortTable,
  switchCohortId = NULL,
  strata = list(),
  followUpDays = Inf,
  censorDate = NULL,
  incident = TRUE,
  restrictToFirstDiscontinuation = TRUE
)
```

## Arguments

- cohort:

  A cohort_table object.

- cohortId:

  A cohort definition id to restrict by. If NULL, all cohorts will be
  included.

- switchCohortTable:

  A cohort table in the cdm that contains possible alternative
  treatments.

- switchCohortId:

  The cohort ids to be used from switchCohortTable. If NULL all cohort
  definition ids are used.

- strata:

  A list of variables to stratify results. These variables must have
  been added as additional columns in the cohort table.

- followUpDays:

  A vector of number of days to follow up. It can be multiple values.

- censorDate:

  Name of a column that indicates the date to stop the analysis, if NULL
  end of individuals observation is used.

- incident:

  Whether the switch treatment has to be incident (start after
  discontinuation) or not (it can start before the discontinuation and
  last till after).

- restrictToFirstDiscontinuation:

  Whether to consider only the first discontinuation episode or all of
  them.

## Value

A summarised_result object with the percentages of restart, switch and
not exposed per follow-up period given.

## Examples

``` r
# \donttest{
library(DrugUtilisation)

cdm <- mockDrugUtilisation()

conceptlist <- list(acetaminophen = 1125360, metformin = c(1503297, 1503327))
cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
                                        name = "switch_cohort",
                                        conceptSet = conceptlist)
#> ℹ Subsetting drug_exposure table
#> ℹ Checking whether any record needs to be dropped.
#> ℹ Collapsing overlaping records.
#> ℹ Collapsing records with gapEra = 1 days.

result <- cdm$cohort1 |>
  summariseDrugRestart(switchCohortTable = "switch_cohort")
#> Warning: There was 1 warning in `dplyr::summarise()`.
#> ℹ In argument: `cohort_start_date = min(.data$cohort_start_date, na.rm =
#>   TRUE)`.
#> Caused by warning in `min.default()`:
#> ! no non-missing arguments to min; returning Inf

tableDrugRestart(result)
#> cdm_name, cohort_name, variable_name, follow_up_days, censor_date,
#> cohort_table_name, incident, restrict_to_first_discontinuation, and
#> switch_cohort_table are missing in `columnOrder`, will be added last.


  

```

CDM name

DUS MOCK

Treatment

Estimate name

Cohort name

cohort_1

cohort_2

cohort_3

Drug restart till end of observation

restart

N (%)

0 (0.00 %)

0 (0.00 %)

0 (0.00 %)

switch

N (%)

0 (0.00 %)

0 (0.00 %)

1 (16.67 %)

restart and switch

N (%)

0 (0.00 %)

0 (0.00 %)

0 (0.00 %)

untreated

N (%)

1 (100.00 %)

3 (100.00 %)

5 (83.33 %)

\# }
