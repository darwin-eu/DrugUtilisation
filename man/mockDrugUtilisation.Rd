% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/mockDrugUtilisation.R
\name{mockDrugUtilisation}
\alias{mockDrugUtilisation}
\title{It creates a mock database for testing DrugUtilisation package}
\usage{
mockDrugUtilisation(
  con = NULL,
  writeSchema = NULL,
  numberIndividuals = 10,
  seed = NULL,
  ...
)
}
\arguments{
\item{con}{A DBIConnection object to a database. If NULL a new duckdb
connection will be used.}

\item{writeSchema}{A schema with writing permissions to copy there the cdm
tables.}

\item{numberIndividuals}{Number of individuals in the mock cdm.}

\item{seed}{Seed for the random numbers. If NULL no seed is used.}

\item{...}{Tables to use as basis to create the mock. If some tables are
provided they will be used to construct the cdm object.}
}
\value{
A cdm reference with the mock tables
}
\description{
It creates a mock database for testing DrugUtilisation package
}
\examples{
\donttest{
cdm <- mockDrugUtilisation()

cdm
}

}
