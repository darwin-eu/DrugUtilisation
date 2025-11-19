# Copyright 2024 DARWIN EU (C)
#
# This file is part of DrugUtilisation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#' Generate a custom ggplot2 from a summarised_result object generated with
#' summariseTreatment function.
#'
#' @inheritParams resultDoc
#' @inheritParams plotDoc
#'
#' @return A ggplot2 object.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(DrugUtilisation)
#'
#' cdm <- mockDrugUtilisation()
#' result <- cdm$cohort1 |>
#'   summariseTreatment(
#'     treatmentCohortName = "cohort2",
#'     window = list(c(0, 30), c(31, 365))
#'   )
#'
#' plotTreatment(result)
#'
#' plotTreatment(result, x = "cohort_name", facet = "window_name")
#' }
#'
plotTreatment <- function(result,
                          x = "variable_level",
                          position = "stack",
                          facet = cdm_name + cohort_name ~ window_name,
                          colour = "variable_level",
                          style = NULL) {
  lab <- getLabel(x = x, def = "Treatment")
  barPlotInternal(
    result = result,
    resultType = "summarise_treatment",
    x = x,
    position = position,
    flipCoordinates = identical(x, "variable_level"),
    facet = facet,
    colour = colour,
    lab = lab,
    style = style
  )
}

#' Generate a custom ggplot2 from a summarised_result object generated with
#' summariseDrugRestart() function.
#'
#' @inheritParams resultDoc
#' @inheritParams plotDoc
#'
#' @return A ggplot2 object.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' library(DrugUtilisation)
#'
#' cdm <- mockDrugUtilisation()
#'
#' conceptlist <- list("a" = 1125360, "b" = c(1503297, 1503327))
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "switch_cohort",
#'                                         conceptSet = conceptlist)
#'
#' result <- cdm$cohort1 |>
#'   summariseDrugRestart(switchCohortTable = "switch_cohort")
#'
#' plotDrugRestart(result)
#'
#' plotDrugRestart(result, x = "cohort_name", facet = "follow_up_days")
#' }
#'
plotDrugRestart <- function(result,
                            x = "variable_level",
                            position = "stack",
                            facet = cdm_name + cohort_name ~ follow_up_days,
                            colour = "variable_level",
                            style = NULL) {
  lab <- getLabel(x = x, def = "Event")
  barPlotInternal(
    result = result,
    resultType = "summarise_drug_restart",
    x = x,
    position = position,
    flipCoordinates = identical(x, "variable_level"),
    facet = facet,
    colour = colour,
    lab = lab,
    style = style
  )
}

#' Generate a plot visualisation (ggplot2) from the output of
#' summariseIndication
#'
#' @inheritParams resultDoc
#' @inheritParams plotDoc
#'
#' @return A ggplot2 object
#'
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(CDMConnector)
#'
#' cdm <- mockDrugUtilisation(source = "duckdb")
#'
#' indications <- list(headache = 378253, asthma = 317009)
#' cdm <- generateConceptCohortSet(cdm = cdm,
#'                                 conceptSet = indications,
#'                                 name = "indication_cohorts")
#'
#' cdm <- generateIngredientCohortSet(cdm = cdm,
#'                                    name = "drug_cohort",
#'                                    ingredient = "acetaminophen")
#'
#' result <- cdm$drug_cohort |>
#'   summariseIndication(
#'     indicationCohortName = "indication_cohorts",
#'     unknownIndicationTable = "condition_occurrence",
#'     indicationWindow = list(c(-Inf, 0), c(-365, 0))
#'   )
#'
#' plotIndication(result)
#'
#' plotIndication(result, x = "window_name", facet = NULL)
#' }
#'
plotIndication <- function(result,
                           x = "variable_level",
                           position = "stack",
                           facet = cdm_name + cohort_name ~ window_name,
                           colour = "variable_level",
                           style = NULL) {
  lab <- getLabel(x = x, def = "Indication")
  barPlotInternal(
    result = result,
    resultType = "summarise_indication",
    x = x,
    position = position,
    flipCoordinates = identical(x = x, y = "variable_level"),
    facet = facet,
    colour = colour,
    lab = lab,
    style = style
  )
}

#' Plot the results of `summariseDrugUtilisation`
#'
#' @inheritParams resultDoc
#' @param variable Variable to plot. See `unique(result$variable_name)` for
#' options.
#' @param plotType Must be a choice between: 'scatterplot', 'barplot',
#' 'densityplot', and 'boxplot'.
#' @inheritParams plotDoc
#'
#' @return A ggplot2 object.
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#' library(PatientProfiles)
#' library(dplyr, warn.conflicts = FALSE)
#'
#' cdm <- mockDrugUtilisation(numberIndividuals = 100)
#' codes <- list(aceta = c(1125315, 1125360, 2905077, 43135274))
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "cohort",
#'                                         conceptSet = codes)
#'
#' result <- cdm$cohort |>
#'   addSex() |>
#'   summariseDrugUtilisation(
#'     strata = "sex",
#'     ingredientConceptId = 1125315,
#'     estimates = c("min", "q25", "median", "q75", "max", "density")
#'   )
#'
#' result |>
#'   filter(estimate_name == "median") |>
#'   plotDrugUtilisation(
#'     variable = "days prescribed",
#'     plotType = "barplot"
#'   )
#'
#' result |>
#'   plotDrugUtilisation(
#'     variable = "days exposed",
#'     facet = cohort_name ~ cdm_name,
#'     colour = "sex",
#'     plotType = "boxplot"
#'   )
#'
#' result |>
#'   plotDrugUtilisation(
#'     variable = "cumulative dose milligram",
#'     plotType = "densityplot",
#'     facet = "cohort_name",
#'     colour = "sex"
#'   )
#'
#' }
#'
plotDrugUtilisation <- function(result,
                                variable = "number exposures",
                                plotType = "barplot",
                                facet = strataColumns(result),
                                colour = "cohort_name",
                                style = NULL) {
  rlang::check_installed("visOmopResults", version = "1.2.0")
  rlang::check_installed("ggplot2")

  # initial checks
  result <- omopgenerics::validateResultArgument(result)
  result <- result |>
    dplyr::filter(!.data$variable_name %in% c("number records", "number subjects"))
  omopgenerics::assertChoice(variable, unique(result$variable_name), length = 1)
  omopgenerics::assertChoice(plotType, c("barplot", "boxplot", "densityplot", "scatterplot"))

  # subset variable
  result <- result |>
    dplyr::filter(.data$variable_name == .env$variable)

  # check estimates
  estimates <- unique(result$estimate_name)
  if (plotType %in% c("barplot", "scatterplot")) {
    if (length(estimates) > 1) {
      "Only one estimate allowed for {.pkg plotType = '{plotType}'}, multiple estimates in data: {.var {estimates}}." |>
        cli::cli_abort()
    }
    vars <- getVariables(result)
    x <- vars[!vars %in% asCharacterFacet(facet)]
    if (length(x) == 0) {
      result <- result |>
        omopgenerics::tidy() |>
        dplyr::mutate(x = "")
      x <- "x"
      xlab <- ""
    } else {
      xlab <- paste0(x, collapse = "; ")
    }
    if (plotType == "barplot") {
      p <- visOmopResults::barPlot(
        result = result,
        x = correctX(x),
        y = estimates,
        facet = facet,
        colour = colour,
        label = vars,
        style = style
      )
    } else {
      p <- visOmopResults::scatterPlot(
        result = result,
        x = correctX(x),
        y = estimates,
        line = FALSE,
        point = TRUE,
        ribbon = FALSE,
        ymin = NULL,
        ymax = NULL,
        facet = facet,
        colour = colour,
        label = vars,
        group = vars,
        style = style
      )
    }
    ylab <- paste0(variable, " (", estimates, ")")
  } else if (plotType == "densityplot") {
    if (!all(c("density_x", "density_y") %in% estimates)) {
      "'density_x' and 'density_y' must be present for {.pkg plotType = '{plotType}'}." |>
        cli::cli_abort()
    }
    result <- result |>
      dplyr::filter(.data$estimate_name %in% c("density_x", "density_y"))
    p <- visOmopResults::scatterPlot(
      result = result,
      x = "density_x",
      y = "density_y",
      line = TRUE,
      point = FALSE,
      ribbon = FALSE,
      ymin = NULL,
      ymax = NULL,
      facet = facet,
      colour = colour,
      style = style
    )
    xlab <- variable
    ylab <- "Density"
  } else if (plotType == "boxplot") {
    est <- c("min", "q25", "median", "q75", "max")
    if (!all(est %in% estimates)) {
      "{.var {est}} must be present for {.pkg plotType = '{plotType}'}." |>
        cli::cli_abort()
    }
    result <- result |>
      dplyr::filter(.data$estimate_name %in% .env$est)
    vars <- getVariables(result)
    x <- vars[!vars %in% asCharacterFacet(facet)]
    if (length(x) == 0) {
      result <- result |>
        omopgenerics::tidy() |>
        dplyr::mutate(x = "")
      x <- "x"
      xlab <- ""
    } else {
      xlab <- paste0(x, collapse = "; ")
    }
    p <- visOmopResults::boxPlot(
      result = result,
      x = correctX(x),
      facet = facet,
      colour = colour,
      ymin = "min",
      lower = "q25",
      middle = "median",
      upper = "q75",
      ymax = "max",
      label = vars,
      style = style
    )
    ylab <- variable
  }

  p <- p +
    ggplot2::xlab(label = xlab) +
    ggplot2::ylab(label = ylab)

  return(p)
}
asCharacterFacet <- function(facet) {
  as.character(facet) |>
    strsplit(split = " + ", fixed = TRUE) |>
    purrr::flatten_chr() |>
    purrr::keep(\(x) !x %in% c(".", "~"))
}
correctX <- function(x) { # issue in visOmopResults
  if (length(x) == 0) return(NULL)
  return(x)
}

#' Plot proportion of patients covered
#'
#' @inheritParams resultDoc
#' @inheritParams plotDoc
#' @param ribbon Whether to plot a ribbon with the confidence intervals.
#'
#' @return Plot of proportion Of patients covered over time
#' @export
#'
#' @examples
#' \donttest{
#' library(DrugUtilisation)
#'
#' cdm <- mockDrugUtilisation()
#'
#' cdm <- generateDrugUtilisationCohortSet(cdm = cdm,
#'                                         name = "my_cohort",
#'                                         conceptSet = list(drug_of_interest = c(1503297, 1503327)))
#'
#' result <- cdm$my_cohort |>
#'   summariseProportionOfPatientsCovered(followUpDays = 365)
#'
#' plotProportionOfPatientsCovered(result)
#' }
#'
plotProportionOfPatientsCovered <- function(result,
                                            facet = "cohort_name",
                                            colour = strataColumns(result),
                                            ribbon = TRUE,
                                            style = NULL) {
  rlang::check_installed("ggplot2", reason = "for plot functions")
  rlang::check_installed("scales", reason = "for plot functions")

  result <- omopgenerics::validateResultArgument(result)
  omopgenerics::assertLogical(ribbon, length = 1)

  workingResult <- result |>
    omopgenerics::filterSettings(
      .data$result_type == "summarise_proportion_of_patients_covered"
    ) |>
    dplyr::filter(stringr::str_starts(.data$estimate_name, "ppc"))

  if (nrow(workingResult) == 0) {
    cli::cli_warn("No PPC results found")
    return(visOmopResults::emptyPlot(style = style, type = "ggplot"))
  }

  checkVersion(result)

  workingResult <- workingResult|>
    dplyr::mutate(estimate_value = as.numeric(.data$estimate_value) / 100) |>
    omopgenerics::tidy() |>
    dplyr::mutate(time = as.numeric(.data$time)) |>
    dplyr::select(!dplyr::all_of(c("variable_name", "variable_level")))

  group <- colnames(workingResult) |>
    purrr::keep(\(x) !x %in% c("time", "ppc", "ppc_lower", "ppc_upper"))

  workingResult <- workingResult |>
    uniteColumn(group, "group_vars") |>
    uniteColumn(colour, "colour_vars")

  p <- ggplot2::ggplot(
    data = workingResult,
    mapping = ggplot2::aes(
      x = .data$time, y = .data$ppc, group = .data$group_vars,
      colour = .data$colour_vars, ymin = .data$ppc_lower,
      ymax = .data$ppc_upper, fill = .data$colour_vars
    )
  ) +
    ggplot2::geom_line()

  if (ribbon) {
    p <- p +
      ggplot2::geom_ribbon(alpha = 0.3, show.legend = FALSE, linewidth = 0)
  }

  p <- p +
    ggplot2::labs(
      y = "Proportion of patients covered (PPC)",
      x = "Time (days)",
      colour = paste0(colour, collapse = "; ")
    ) +
    ggplot2::theme_bw() +
    ggplot2::theme(legend.position = "top") +
    ggplot2::scale_y_continuous(
      labels = scales::percent_format(accuracy = 0.1),
      limits = c(0, 1)
    )

  if (rlang::is_bare_formula(facet)) {
    notPresent <- facet |>
      as.character() |>
      purrr::keep(\(x) x != "~") |>
      purrr::map(\(x) stringr::str_split_1(x, pattern = stringr::fixed(" + "))) |>
      purrr::flatten_chr() |>
      purrr::keep(\(x) x != ".") |>
      purrr::keep(\(x) !x %in% colnames(workingResult)) |>
      unique()
    if (length(notPresent) > 0) {
      cli::cli_abort("{.var {notPresent}} not present in data.")
    }
    p <- p +
      ggplot2::facet_grid(facet)
  } else if (!is.null(facet)) {
    mes <- "`facet` must point to columns in `result`"
    if (!is.character(facet)) cli::cli_abort(message = mes)
    if (any(!facet %in% colnames(workingResult))) cli::cli_abort(message = mes)
    p <- p +
      ggplot2::facet_wrap(facets = facet)
  }

  # add style
  p <- p +
    visOmopResults::themeVisOmop(style = style)

  return(p)
}

uniteColumn <- function(x, cols, name, call = parent.frame()) {
  nm <- gsub("_vars", "", name)
  mes <- glue::glue("`{nm}` must point to columns in `result`")
  if (!is.character(cols) && !is.null(cols)) {
    cli::cli_abort(message = mes, call = call)
  }
  if (any(!cols %in% colnames(x))) cli::cli_abort(message = mes, call = call)

  if (length(cols) == 0) {
    x <- dplyr::mutate(x, !!name := "")
  } else {
    x <- x |>
      tidyr::unite(col = !!name, dplyr::all_of(cols), sep = "; ", remove = FALSE)
  }
  return(x)
}
getLabel <- function(x, def) {
  if (identical(x, "variable_level")) {
    lab <- def
  } else if (is.character(x) & length(x) == 1) {
    lab <- x |>
      stringr::str_replace_all(pattern = "_", replacement = " ") |>
      stringr::str_to_sentence()
  } else {
    lab <- ""
  }
  return(lab)
}
barPlotInternal <- function(result,
                            resultType,
                            x = "variable_level",
                            position = "stack",
                            flipCoordinates = TRUE,
                            facet,
                            colour,
                            lab,
                            style,
                            call = parent.frame()) {
  rlang::check_installed("ggplot2")
  rlang::check_installed("visOmopResults", version = "1.2.0")

  result <- omopgenerics::validateResultArgument(result, call = call)

  result <- result |>
    omopgenerics::filterSettings(.data$result_type == .env$resultType) |>
    dplyr::filter(.data$estimate_name == "percentage")

  if (nrow(result) == 0) {
    cli::cli_warn(c("!" = "There are no results to plot, returning empty plot"))
    return(visOmopResults::emptyPlot(type = "ggplot", style = style))
  }

  checkVersion(result)

  # to display order accordingly
  lev <- result$variable_level |>
    unique() |>
    rev()
  result <- result |>
    dplyr::mutate(variable_level = factor(.data$variable_level, levels = lev)) |>
    omopgenerics::tidy() |>
    dplyr::select(!"variable_name")
  label <- result |>
    dplyr::select(!c("percentage", "variable_level")) |>
    as.list() |>
    purrr::map(unique) |>
    purrr::keep(\(x) length(x) > 1) |>
    names()

  if ("window_name" %in% colnames(result)) {
    windows <- unique(result$window_name) |>
      rlang::set_names() |>
      purrr::map(\(x) {
        x <- stringr::str_split(string = x, pattern = " to ") |>
          unlist() |>
          as.numeric() |>
          suppressWarnings()
        dplyr::tibble(min = x[1], max = x[2])
      }) |>
      dplyr::bind_rows(.id = "window_name") |>
      dplyr::arrange(.data$min, .data$max) |>
      dplyr::pull("window_name")
    result <- result |>
      dplyr::mutate(window_name = factor(.data$window_name, levels = windows))
  }

  plot <- visOmopResults::barPlot(
    result = result,
    x = x,
    y = "percentage",
    position = position,
    facet = facet,
    colour = colour,
    label = label,
    style = style
  ) +
    ggplot2::theme(legend.position = "top") +
    ggplot2::ylim(c(0, 100.5)) +
    ggplot2::labs(colour = "", fill = "", y = "Percentage (%)", x = lab)

  if (flipCoordinates) {
    plot <- plot +
      ggplot2::coord_flip()
  }

  return(plot)
}
getVariables <- function(res) {
  res |>
    dplyr::select(!c("estimate_name", "estimate_type", "estimate_value")) |>
    dplyr::distinct() |>
    omopgenerics::splitAll() |>
    omopgenerics::addSettings() |>
    dplyr::select(!"result_id") |>
    as.list() |>
    purrr::map(unique) |>
    purrr::keep(\(x) length(x) > 1) |>
    names()
}
