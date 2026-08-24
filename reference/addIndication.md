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
  name = NULL,
  restrictIncident = FALSE
)
```

## Arguments

- cohort:

  A cohort_table object.

- indicationCohortName:

  Name of the cohort table containing potential indications.

- indicationCohortId:

  Cohort definition IDs of the indications of interest. If `NULL`, all
  cohorts in `indicationCohortName` are included.

- indicationWindow:

  Time windows over which to identify indications.

- unknownIndicationTable:

  Tables in the OMOP CDM to search for unknown indications.

- indexDate:

  Name of a column that indicates the date to start the analysis.

- censorDate:

  Name of a column that indicates the date to stop the analysis, if NULL
  end of individuals observation is used.

- mutuallyExclusive:

  Whether intersections should be mutually exclusive. If `TRUE`, cohort
  combinations are reported as mutually exclusive categories; if
  `FALSE`, each cohort is reported independently.

- nameStyle:

  Name style for the indications. By default:
  'indication\_{window_name}' (mutuallyExclusive = TRUE),
  'indication\_{window_name}\_{cohort_name}' (mutuallyExclusive =
  FALSE).

- name:

  Name of the new computed cohort table, if NULL a temporary table will
  be created.

- restrictIncident:

  Whether to include only target cohort records that start during the
  analysis period. If `FALSE`, all target cohort records that overlap
  with the study period will be included.

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
#> duckdb keeps downloaded extensions and secrets in a temporary directory:
#> ℹ /tmp/RtmpYAPvel/duckdb
#> This is removed when the R session ends.
#> • Extensions are re-downloaded each session.
#> • Secrets are lost.
#> ℹ Run duckdb(shared_home = TRUE) (or create ~/.duckdb) to keep them (suitable for most users).
#> ℹ Run duckdb(shared_home = FALSE) to accept the temporary directory (and silence this message).
#> ℹ See ?duckdb_storage for details and alternatives.

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
#> $ cohort_definition_id <int> 1, 1, 1, 1, 1, 1, 1, 1, 1
#> $ subject_id           <int> 2, 3, 4, 5, 7, 9, 10, 4, 9
#> $ cohort_start_date    <date> 2021-09-19, 2001-07-03, 2021-07-19, 1986-02-13, 2…
#> $ cohort_end_date      <date> 2022-04-17, 2010-03-03, 2021-07-23, 1986-05-19, 2…
#> $ indication_0_to_0    <chr> "none", "none", "asthma", "headache", "none", "n…
# }
```
