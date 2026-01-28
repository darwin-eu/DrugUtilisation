# Add a variable indicating individuals indications

Add a variable to a drug cohort indicating their presence in an
indication cohort in a specified time window. If an individual is not in
one of the indication cohorts, they will be considered to have an
unknown indication if they are present in one of the specified OMOP CDM
clinical tables. If they are neither in an indication cohort or a
clinical table they will be considered as having no observed indication.

## Usage

``` r
addIndication(
  cohort,
  indicationCohortName,
  indicationCohortId = NULL,
  indicationWindow = list(c(0, 0)),
  unknownIndicationTable = NULL,
  indexDate = "cohort_start_date",
  censorDate = NULL,
  mutuallyExclusive = TRUE,
  nameStyle = NULL,
  name = NULL
)
```

## Arguments

- cohort:

  A cohort_table object.

- indicationCohortName:

  Name of indication cohort table

- indicationCohortId:

  target cohort Id to add indication

- indicationWindow:

  time window of interests

- unknownIndicationTable:

  Tables to search unknown indications

- indexDate:

  Name of a column that indicates the date to start the analysis.

- censorDate:

  Name of a column that indicates the date to stop the analysis, if NULL
  end of individuals observation is used.

- mutuallyExclusive:

  Whether to consider mutually exclusive categories (one column per
  window) or not (one column per window and indication).

- nameStyle:

  Name style for the indications. By default:
  'indication\_{window_name}' (mutuallyExclusive = TRUE),
  'indication\_{window_name}\_{cohort_name}' (mutuallyExclusive =
  FALSE).

- name:

  Name of the new computed cohort table, if NULL a temporary table will
  be created.

## Value

The original table with a variable added that summarises the
individual´s indications.

## Examples

``` r
# \donttest{
library(DrugUtilisation)
library(dplyr, warn.conflicts = FALSE)
library(CDMConnector)

cdm <- mockDrugUtilisation(source = "duckdb")

indications <- list(headache = 378253, asthma = 317009)
cdm <- generateConceptCohortSet(cdm = cdm,
                                conceptSet = indications,
                                name = "indication_cohorts")

cdm <- generateIngredientCohortSet(cdm = cdm,
                                   name = "drug_cohort",
                                   ingredient = "acetaminophen")
#> ℹ Subsetting drug_exposure table
#> ℹ Checking whether any record needs to be dropped.
#> ℹ Collapsing overlaping records.
#> ℹ Collapsing records with gapEra = 1 days.

cdm$drug_cohort |>
  addIndication(
    indicationCohortName = "indication_cohorts",
    indicationWindow = list(c(0, 0)),
    unknownIndicationTable = "condition_occurrence"
  ) |>
  glimpse()
#> ℹ Intersect with indications table (indication_cohorts).
#> ℹ Getting unknown indications from condition_occurrence.
#> ℹ Collapse indications to mutually exclusive categories
#> Rows: ??
#> Columns: 5
#> Database: DuckDB 1.4.3 [unknown@Linux 6.11.0-1018-azure:R 4.5.2/:memory:]
#> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1
#> $ subject_id           <int> 1, 2, 3, 5, 7, 8, 9
#> $ cohort_start_date    <date> 1997-01-09, 2009-06-27, 1998-07-30, 1992-01-18, 2…
#> $ cohort_end_date      <date> 2002-10-05, 2010-12-13, 1999-11-07, 1993-02-12, 2…
#> $ indication_0_to_0    <chr> "none", "asthma and headache", "asthma", "none",…
# }
```
