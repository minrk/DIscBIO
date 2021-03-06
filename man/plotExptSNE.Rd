% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DIscBIO-generic-plotExptSNE.R
\name{plotExptSNE}
\alias{plotExptSNE}
\alias{plotExptSNE,DISCBIO-method}
\title{Highlighting gene expression in K-means clustering in the t-SNE map}
\usage{
plotExptSNE(object, g, n = NULL)

\S4method{plotExptSNE}{DISCBIO}(object, g, n = NULL)
}
\arguments{
\item{object}{\code{DISCBIO} class object.}

\item{g}{Individual gene name or vector with a group of gene names
corresponding to a subset of valid row names of the \code{ndata} slot of
the \code{DISCBIO} object.}

\item{n}{String of characters representing the title of the plot. Default is
NULL and the first element of \code{g} is chosen.}
}
\value{
t-SNE plot for one particular gene
}
\description{
The t-SNE map representation can also be used to analyze
  expression of a gene or a group of genes, to investigate cluster specific
  gene expression patterns
}
\examples{
sc <- DISCBIO(valuesG1msReduced)
sc <- Clustexp(sc, cln=3, quiet=TRUE) # K-means clustering
sc <- comptSNE(sc, rseed=15555, quiet=TRUE)
g <- 'ENSG00000001460'
plotExptSNE(sc, g)
}
