% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/retrieveBiomart.R
\name{retrieveBiomart}
\alias{retrieveBiomart}
\title{Retrieve data from BioMart}
\usage{
retrieveBiomart(gene_name, quiet = FALSE, max_tries = 3)
}
\arguments{
\item{gene_name}{gene signature}

\item{quiet}{if `TRUE`, suppresses messages}

\item{max_tries}{maximum number of times the function will try to reach the
database}
}
\value{
data.frame resulting from a successful call to getBM.
}
\description{
uses functions from the biomaRt package to retrieve dataframes
  from the BioMart Database
}
\details{
Since the BioMart database is not always accessible, this function
  envelops the requests to the database in a set of tryCatch functions to
  allow for multiple queries and easier feedback to the end user
}
