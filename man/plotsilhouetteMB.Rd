% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DIscBIO-generic-plotsilhouetteMB.R
\name{plotsilhouetteMB}
\alias{plotsilhouetteMB}
\alias{plotsilhouetteMB,DISCBIO-method}
\title{Silhouette Plot for Model-based clustering}
\usage{
plotsilhouetteMB(object, K)

\S4method{plotsilhouetteMB}{DISCBIO}(object, K)
}
\arguments{
\item{object}{\code{DISCBIO} class object.}

\item{K}{A numeric value of the number of clusters}
}
\value{
A silhouette plot
}
\description{
The silhouette provides a representation of how well each point
  is represented by its cluster in comparison to the closest neighboring
  cluster. It computes for each point the difference between the average
  similarity to all points in the same cluster and to all points in the
  closest neighboring cluster. This difference it normalize such that it can
  take values between -1 and 1 with higher values reflecting better
  representation of a point by its cluster.
}
\examples{
sc<- DISCBIO(valuesG1msReduced)
sc<-NoiseFiltering(sc,percentile=0.9, CV=0.2)
sc<-Normalizedata(sc, mintotal=1000, minexpr=0, minnumber=0, maxexpr=Inf,
downsample=FALSE, dsn=1, rseed=17000)
sc<-FinalPreprocessing(sc,GeneFlitering="NoiseF",export = FALSE)
sc <- Exprmclust(sc,K =2,reduce = TRUE,quiet = TRUE)
plotsilhouetteMB(sc,K=2)
}
