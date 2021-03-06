% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DIscBIO-generic-PlotmclustMB.R
\name{PlotmclustMB}
\alias{PlotmclustMB}
\alias{PlotmclustMB,DISCBIO-method}
\title{Plotting the Model-based clusters in PCA.}
\usage{
PlotmclustMB(object)

\S4method{PlotmclustMB}{DISCBIO}(object)
}
\arguments{
\item{object}{\code{DISCBIO} class object.}
}
\value{
A plot of the PCA.
}
\description{
Plot the model-based clustering results
}
\examples{
sc <- DISCBIO(valuesG1msReduced)
sc <- NoiseFiltering(sc, percentile=0.9, CV=0.2, export=FALSE)
sc <- Normalizedata(
    sc, mintotal=1000, minexpr=0, minnumber=0, maxexpr=Inf, downsample=FALSE,
    dsn=1, rseed=17000
)
sc <- FinalPreprocessing(sc, GeneFlitering="NoiseF", export=FALSE)
sc <- Exprmclust(sc, K=2)
PlotmclustMB(sc)
}
