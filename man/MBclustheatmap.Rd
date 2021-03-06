% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DIscBIO-generic-MBclustheatmap.R
\name{MBclustheatmap}
\alias{MBclustheatmap}
\alias{MBclustheatmap,DISCBIO-method}
\title{Plotting the Model-based clusters in a heatmap representation of the
  cell-to-cell distances}
\usage{
MBclustheatmap(object, hmethod = "single", plot = TRUE, quiet = FALSE)

\S4method{MBclustheatmap}{DISCBIO}(object, hmethod = "single", plot = TRUE, quiet = FALSE)
}
\arguments{
\item{object}{\code{DISCBIO} class object.}

\item{hmethod}{Agglomeration method used for determining the cluster order
from hierarchical clustering of the cluster medoids. This should be one of
"ward.D", "ward.D2", "single", "complete", "average". Default is "single".}

\item{plot}{if `TRUE`, plots the heatmap; otherwise, just prints cclmo}

\item{quiet}{if `TRUE`, intermediary output is suppressed}
}
\value{
Unless otherwise specified, a heatmap and a vector of the underlying
  cluster order.
}
\description{
This functions plots a heatmap of the distance matrix grouped
  by clusters. Individual clusters are highlighted with rainbow colors along
  the x and y-axes.
}
\examples{
sc <- DISCBIO(valuesG1msReduced)
sc <- NoiseFiltering(sc, export=FALSE)
sc <- Normalizedata(
    sc, mintotal=1000, minexpr=0, minnumber=0, maxexpr=Inf, downsample=FALSE,
    dsn=1, rseed=17000
)
sc <- FinalPreprocessing(sc, GeneFlitering="NoiseF", export=FALSE)
sc <- Exprmclust(sc,K = 2)
sc <- comptsneMB(sc, rseed=15555)
sc <- Clustexp(sc, cln=3)
sc <- MB_Order(sc, export = FALSE)
MBclustheatmap(sc, hmethod="single")
}
