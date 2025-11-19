
omock::downloadMockDataset(datasetName = "GiBleed", overwrite = FALSE)
dbToTest <- Sys.getenv("DB_TO_TEST", "duckdb")
copyCdm <- function(cdm) {
  prefix <- paste0("dus_", paste0(sample(letters, size = 3), collapse = ""))
  if (dbToTest == "duckdb") {
    to <- CDMConnector::dbSource(
      con = duckdb::dbConnect(drv = duckdb::duckdb(dbdir = ":memory:")),
      writeSchema = c(schema = "main", prefix = prefix)
    )
  } else if (dbToTest == "sql server") {
    to <- CDMConnector::dbSource(
      con = DBI::dbConnect(
        odbc::odbc(),
        Driver = "ODBC Driver 18 for SQL Server",
        Server = Sys.getenv("CDM5_SQL_SERVER_SERVER"),
        Database = Sys.getenv("CDM5_SQL_SERVER_CDM_DATABASE"),
        UID = Sys.getenv("CDM5_SQL_SERVER_USER"),
        PWD = Sys.getenv("CDM5_SQL_SERVER_PASSWORD"),
        TrustServerCertificate = "yes",
        Port = 1433
      ),
      writeSchema = c(
        schema = Sys.getenv("CDM5_SQL_SERVER_OHDSI_SCHEMA"),
        prefix = prefix
      )
    )
  } else if (dbToTest == "redshift") {
    to <- CDMConnector::dbSource(
      con = DBI::dbConnect(
        RPostgres::Redshift(),
        dbname = Sys.getenv("CDM5_REDSHIFT_DBNAME"),
        port = Sys.getenv("CDM5_REDSHIFT_PORT"),
        host = Sys.getenv("CDM5_REDSHIFT_HOST"),
        user = Sys.getenv("CDM5_REDSHIFT_USER"),
        password = Sys.getenv("CDM5_REDSHIFT_PASSWORD")
      ),
      writeSchema = c(
        schema = Sys.getenv("CDM5_REDSHIFT_SCRATCH_SCHEMA"),
        prefix = prefix
      )
    )
  } else if (dbToTest == "postgres") {
    # TODO
  } else if (dbToTest != "local") {
    cli::cli_abort(c(x = "Not supported dbToTest: {.pkg {dbToTest}}"))
  }

  if (dbToTest != "local") {
    cdm <- omopgenerics::insertCdmTo(cdm = cdm, to = to)
  }

  return(cdm)
}
dropCreatedTables <- function(cdm) {
  omopgenerics::dropSourceTable(cdm = cdm, name = dplyr::everything())
}
collectCohort <- function(cohort, id = NULL) {
  if (is.null(id)) id <- settings(cohort)$cohort_definition_id
  x <- cohort |>
    dplyr::filter(.data$cohort_definition_id %in% .env$id) |>
    dplyr::collect() |>
    dplyr::as_tibble()
  x <- x |>
    dplyr::arrange(dplyr::across(dplyr::all_of(colnames(x))))
  attr(x, "cohort_set") <- NULL
  attr(x, "cohort_attrition") <- NULL
  attr(x, "cohort_codelist") <- NULL
  return(x)
}
