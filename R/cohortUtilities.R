#' Add a line in the attrition table. If the table does not exist it is created
#'
#' @param x A table in the cdm with at lest: 'cohort_definition_id' and
#' subject_id'
#' @param attrition An attrition table. If NULL a new attrition table is created.
#' @param reason A character with the name of the reason.
#'
#' @return The function returns the 'cdm' object with the created tables as
#' references of the object.
#' @export
#'
#' @examples
computeCohortAttrition <- function(x,
                                   cdm,
                                   attrition = NULL,
                                   reason = "Qualifying initial events") {
  checkInputs(
    x = x, cdm = cdm, attrition = attrition, reason = reason
  )
  attrition <- addAttritionLine(x, cdm, attrition, reason) %>%
    computeTable(cdm)
  return(attrition)
}

#' @noRd
addAttritionLine <- function(cohort, cdm, attrition, reason) {
  if (is.null(attrition)) {
    attrition <- countAttrition(cohort, reason, 1)
  } else {
    id <- attrition %>% dplyr::pull("reason_id") %>% max()
    attrition <- attrition %>%
      dplyr::union_all(countAttrition(cohort, reason, id + 1)) %>%
      addExcludedCounts()
  }
  return(attrition)
}

#' @noRd
countAttrition <- function(cohort, reason, id) {
  if (id == 1) {
    num <- 0
  } else {
    num <- as.numeric(NA)
  }
  attrition <- cohort %>%
    dplyr::group_by(.data$cohort_definition_id) %>%
    dplyr::summarise(
      number_records = dplyr::n(),
      number_subjects = dplyr::n_distinct(.data$subject_id),
      .groups = "drop"
    ) %>%
    dplyr::mutate(
      reason_id = .env$id, reason = .env$reason, excluded_records = .env$num,
      excluded_subjects = .env$num
    )
  return(attrition)
}

#' @noRd
addExcludedCounts <- function(attrition) {
  attrition %>%
    dplyr::group_by(.data$cohort_definition_id) %>%
    dbplyr::window_order(.data$reason_id) %>%
    dplyr::mutate(
      excluded_records = dplyr::if_else(
        is.na(.data$excluded_records),
        dplyr::lag(.data$number_records) - .data$number_records,
        .data$excluded_records
      ),
      excluded_subjects = dplyr::if_else(
        is.na(.data$excluded_subjects),
        dplyr::lag(.data$number_subjects) - .data$number_subjects,
        .data$excluded_subjects
      )
    ) %>%
    dbplyr::window_order() %>%
    dplyr::ungroup()
}

#' Computes the cohortCount attribute for a certain table
#'
#' @param x A table in the cdm with at lest: 'cohort_definition_id' and
#' subject_id'
#' @param cdm A cdm_reference object
#' @param name Name of the generated table
#'
#' @return A reference to a table in the database with the cohortCount
#'
#' @export
#'
#' @examples
computeCohortCount <- function(x,
                               cdm) {
  x %>%
    dplyr::group_by(.data$cohort_definition_id) %>%
    dplyr::summarise(
      number_records = dplyr::n(),
      number_subjects = dplyr::n_distinct(.data$subject_id),
      .groups = "drop"
    ) %>%
    computeTable(cdm)
}

#' @noRd
conceptSetFromConceptSetList <- function(conceptSetList) {
  cohortSet <- dplyr::tibble(cohort_name = names(conceptSetList)) %>%
    dplyr::mutate(cohort_definition_id = dplyr::row_number()) %>%
    dplyr::select("cohort_definition_id", "cohort_name")
  conceptSet <- purrr::map(conceptSetList, dplyr::as_tibble) %>%
    dplyr::bind_rows(.id = "cohort_name") %>%
    dplyr::rename("concept_id" =  "value") %>%
    dplyr::inner_join(cohortSet, by = "cohort_name") %>%
    dplyr::select(-"cohort_name")
  attr(conceptSet, "cohort_set") <- cohortSet
  return(conceptSet)
}

#' @noRd
subsetTables <- function(cdm, conceptSet, domains = NULL) {
  conceptSet <- cdm$concept %>%
    dplyr::select("concept_id", "domain_id") %>%
    dplyr::right_join(
      conceptSet %>%
        dplyr::select("cohort_definition_id", "concept_id"),
      by = "concept_id",
      copy = TRUE
    ) %>%
    computeTable(cdm)
  if (is.null(domains)) {
    domains <- conceptSet %>%
      dplyr::select("domain_id") %>%
      dplyr::distinct() %>%
      dplyr::pull()
  }
  cohort <- emptyCohort(cdm)
  if (!any(domains %in% domainInformation$domain_id)) {
    cli::cli_alert_warning(paste0(
      "All concepts domain_id (",
      paste(domains, collapse = ", "),
      ") not supported, generated cohort is empty. The supported domain_id are: ",
      paste(domainInformation$domain_id, collapse = ", "),
      "."
    ))
    return(cohort)
  }
  if (length(domains[!(domains %in% domainInformation$domain_id)]) > 0) {
    cli::cli_alert_warning(paste(
      "concepts with domain_id:",
      paste(
        domains[!(domains %in% domainInformation$domain_id)], collapse = ", "
      ),
      "are not going to be instantiated. The supported domain_id are: ",
      paste(domainInformation$domain_id, collapse = ", "),
      "."
    ))
  }
  for (domain in domains) {
    concepts <- conceptSet %>%
      dplyr::filter(.data$domain_id == .env$domain) %>%
      dplyr::select(-"domain_id")
    cohort <- cohort %>%
      dplyr::union_all(
        concepts %>%
          dplyr::inner_join(
            cdm[[getTableName(domain)]] %>%
              dplyr::select(
                "concept_id" = !!getConceptName(domain),
                "subject_id" = "person_id",
                "cohort_start_date" = !!getStartName(domain),
                "cohort_end_date" = !!getEndName(domain)
              ),
            by = "concept_id"
          ) %>%
          dplyr::select(
            "cohort_definition_id", "subject_id", "cohort_start_date",
            "cohort_end_date"
          )
      ) %>%
      computeTable(cdm)
  }
  return(cohort)
}

#' @noRd
getConceptName <- function(domain) {
  domainInformation$concept_id_name[domainInformation$domain_id == domain]
}

#' @noRd
getTableName <- function(domain) {
  domainInformation$table_name[domainInformation$domain_id == domain]
}

#' @noRd
getStartName <- function(domain) {
  domainInformation$start_name[domainInformation$domain_id == domain]
}

#' @noRd
getEndName <- function(domain) {
  domainInformation$end_name[domainInformation$domain_id == domain]
}

#' @noRd
emptyCohort <- function(cdm, name = CDMConnector:::uniqueTableName()) {
  writePrefix <- attr(cdm, "write_prefix")
  writeSchema <- attr(cdm, "write_schema")
  con <- attr(cdm, "dbcon")
  if (!is.null(writePrefix)) {
    name <- CDMConnector:::inSchema(
      writeSchema, paste0(writePrefix, name), CDMConnector::dbms(con)
    )
    temporary <- FALSE
  } else {
    temporary <- TRUE
  }
  DBI::dbCreateTable(
    con,
    name,
    fields = c(
      cohort_definition_id = "INT",
      subject_id = "BIGINT",
      cohort_start_date = "DATE",
      cohort_end_date = "DATE"
    ),
    temporary = temporary
  )
  dplyr::tbl(con, name)
}

#' @noRd
requirePriorUseWashout <- function(cohort, cdm, washout) {
  cohort <- cohort %>%
    dplyr::group_by(.data$cohort_definition_id, .data$subject_id) %>%
    dbplyr::window_order(.data$cohort_start_date) %>%
    dplyr::mutate(id = dplyr::row_number()) %>%
    computeTable(cdm)
  cohort <- cohort %>%
    dplyr::left_join(
      cohort %>%
        dplyr::mutate(id = .data$id + 1) %>%
        dplyr::select(
          "cohort_definition_id", "subject_id", "id",
          "prior_date" = "cohort_end_date"
        ),
      by = c("cohort_definition_id", "subject_id", "id")
    ) %>%
    dplyr::mutate(
      prior_time = !!CDMConnector::datediff("prior_date", "cohort_start_date")
    ) %>%
    dplyr::filter(
      is.na(.data$prior_date) | .data$prior_time >= .env$washout
    ) %>%
    dplyr::select(-c("id", "prior_date", "prior_time")) %>%
    dbplyr::window_order() %>%
    dplyr::ungroup() %>%
    computeTable(cdm)
  return(cohort)
}

#' @noRd
trimCohortDateRange <- function(cohort, cdm, cohortDateRange) {
  modified <- 0
  if (!is.na(cohortDateRange[1])) {
    cohort <- cohort %>%
      dplyr::mutate(cohort_start_date = max(
        .data$cohort_start_date, !!cohortDateRange[1]
      ))
    modified <- 1
  }
  if (!is.na(cohortDateRange[2])) {
    cohort <- cohort %>%
      dplyr::mutate(cohort_start_date = min(
        .data$cohort_start_date, !!cohortDateRange[2]
      ))
    modified <- 1
  }
  if (modified == 1) {
    cohort <- cohort %>%
      dplyr::filter(.data$cohort_start_date <= .data$cohort_end_date) %>%
      computeTable(cdm)
  }
  return(cohort)
}

#' @noRd
insertTable <- function(x,
                        cdm,
                        name = CDMConnector::uniqueTableName(),
                        temporary = is.null(attr(cdm, "write_prefix"))) {
  con <- attr(cdm, "dbcon")
  name <- CDMConnector::inSchema(
    attr(cdm, "write_schema"),
    paste0(attr(cdm, "write_prefix"), name),
    CDMConnector::dbms(con)
  )
  DBI::dbWriteTable(con, name, x, temporary = temporary, overwrite = TRUE)
  dplyr::tbl(con, name)
}

#' @noRd
computeTable <- function(x,
                         cdm) {
  x %>%
    CDMConnector::computeQuery(
      name = paste0(attr(cdm, "write_prefix"), CDMConnector::uniqueTableName()),
      temporary = is.null(attr(cdm, "write_prefix")),
      schema = attr(cdm, "write_schema"),
      overwrite = TRUE
    )
}

#' @noRd
requireDaysPriorHistory <- function(x, cdm, daysPriorHistory) {
  if (!is.null(daysPriorHistory)) {
    x <- x %>%
      PatientProfiles::addPriorHistory(cdm) %>%
      dplyr::filter(.data$prior_history >= .env$daysPriorHistory) %>%
      dplyr::select(-"prior_history") %>%
      computeTable(cdm)
  }
  return(x)
}

#' @noRd
unionCohort <- function(x, gap) {
  x %>%
    dplyr::select(
      "cohort_definition_id",
      "subject_id",
      "date_event" = "cohort_start_date"
    ) %>%
    dplyr::mutate(date_id = -1) %>%
    dplyr::union_all(
      x %>%
        dplyr::mutate(
          date_event = as.Date(!!CDMConnector::dateadd(
            date = "cohort_end_date",
            number = gap
          )),
          date_id = 1
        ) %>%
        dplyr::select(
          "cohort_definition_id", "subject_id", "date_event", "date_id"
        )
    ) %>%
    dplyr::group_by(.data$cohort_definition_id, .data$subject_id) %>%
    dbplyr::window_order(.data$date_event, .data$date_id) %>%
    dplyr::mutate(cum_id = cumsum(.data$date_id)) %>%
    dplyr::filter(
      .data$cum_id == 0 || (.data$cum_id == -1 && .data$date_id == -1)
    ) %>%
    dplyr::mutate(
      name = dplyr::if_else(
        .data$date_id == -1, "cohort_start_date", "cohort_end_date"
      ),
      era_id = dplyr::if_else(
        .data$date_id == -1, 1, 0
      )
    ) %>%
    dplyr::mutate(era_id = cumsum(as.numeric(.data$era_id))) %>%
    dplyr::ungroup() %>%
    dbplyr::window_order() %>%
    dplyr::select(
      "cohort_definition_id", "subject_id", "era_id", "name", "date_event"
    ) %>%
    tidyr::pivot_wider(names_from = "name", values_from = "date_event") %>%
    dplyr::mutate(cohort_end_date = as.Date(!!CDMConnector::dateadd(
      date = "cohort_end_date",
      number = -gap
    ))) %>%
    dplyr::select(-"era_id") %>%
    computeTable(cdm)
}

#' @noRd
applySummariseMode <- function(cohort, cdm, summariseMode, fixedTime) {
  if (summariseMode == "FirstEra") {
    cohort <- cohort %>%
      dplyr::group_by(.data$cohort_definition_id, .data$subject_id) %>%
      dplyr::filter(
        .data$cohort_start_date == min(.data$cohort_start_date, na.rm = TRUE)
      ) %>%
      dplyr::ungroup() %>%
      computeTable(cdm)
  } else if (summariseMode == "FixedTime") {
    cohort <- cohort %>%
      dplyr::group_by(.data$cohort_definition_id, .data$subject_id) %>%
      dplyr::summarise(
        cohort_start_date = min(.data$cohort_start_date, na.rm = TRUE),
        .groups = "drop"
      ) %>%
      dplyr::mutate(cohort_end_date = !!CDMConnector::dateadd(
        "cohort_start_date",
        fixedTime - 1
      )) %>%
      computeTable(cdm)
  }
  return(cohort)
}

#' Impute or eliminate values under a certain conditions
#' @noRd
imputeVariable <- function(x, column, impute, range, imputeRound = FALSE) {
  # identify NA
  x <- x %>%
    dplyr::mutate(impute = dplyr::if_else(is.na(.data[[column]]), 1, 0))

  # identify < range[1]
  if (!is.infinite(range[1])) {
    x <- x %>%
      dplyr::mutate(impute = dplyr::if_else(
        .data$impute == 0, dplyr::if_else(.data[[column]] < !!range[1], 1, 0), 1
      ))
  }
  # identify > range[2]
  if (!is.infinite(range[2])) {
    x <- x %>%
      dplyr::mutate(impute = dplyr::if_else(
        .data$impute == 0, dplyr::if_else(.data[[column]] > !!range[2], 1, 0), 1
      ))
  }
  numberImputations <- x %>%
    dplyr::filter(.data$impute == 1) %>%
    dplyr::summarise(n = as.numeric(dplyr::n())) %>%
    dplyr::pull()
  if (numberImputations > 0) {
    # if impute is false then all values with impute = 1 are not considered
    if (impute == "eliminate") {
      x <- x %>%
        dplyr::filter(.data$impute == 0)
    } else {
      if (is.character(impute)) {
        values <- x %>%
          dplyr::filter(.data$impute == 0) %>%
          dplyr::pull(dplyr::all_of(column))
        impute <- switch(
          impute,
          "median" = stats::median(values),
          "mean" = mean(values),
          "quantile25" = stats::quantile(values, 0.25),
          "quantile75" = stats::quantile(values, 0.75),
        )
        if (imputeRound) {
          impute <- round(impute)
        }
      }
      x <- x %>%
        dplyr::mutate(!!column := dplyr::if_else(
          .data$impute == 1, .env$impute, .data[[column]]
        ))
    }
  }
  x <- x %>%
    dplyr::select(-"impute")
  attr(x, "numberImputations") <- numberImputations
  return(x)
}

#' @noRd
correctDuration <- function(x,
                            durationRange,
                            cdm,
                            start = "cohort_start_date",
                            end = "cohort_end_date") {
  # compute the number of days exposed according to:
  # duration = end - start + 1
  x <- x %>%
    dplyr::mutate(
      duration = !!CDMConnector::datediff(start = start, end = end) + 1
    )

  # impute or eliminate the exposures that duration does not fulfill the
  # conditions (<daysExposedRange[1]; >daysExposedRange[2])
  x <- imputeVariable(
    x = x,
    column = "duration",
    impute = imputeDuration,
    range = durationRange,
    imputeRound = TRUE
  )
  numberImputations <- attr(x, "numberImputations")
  x <- x %>%
    dplyr::mutate(days_to_add = as.integer(.data$duration - 1)) %>%
    dplyr::mutate(!!end := as.Date(
      !!CDMConnector::dateadd(date = start, number = "days_to_add")
    )) %>%
    dplyr::select(-c("duration", "days_to_add")) %>%
    computeTable(cdm)
  attr(x, "numberImputations") <- numberImputations
  return(x)
}

#' @noRd
getReferenceName <- function(tableRef) {
  checkInputs(tableRef = tableRef)
  x <- capture.output(dplyr::show_query(tableRef))
  x <- x[length(x)]
  x <- strsplit(x, "\\.")[[1]]
  name <- x[length(x)]
  return(name)
}