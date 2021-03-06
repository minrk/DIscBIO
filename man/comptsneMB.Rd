% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DIscBIO-generic-comptsneMB.R
\name{comptsneMB}
\alias{comptsneMB}
\alias{comptsneMB,DISCBIO-method}
\title{Computing tSNE for Model-based clustering}
\usage{
comptsneMB(object, rseed = 15555, quiet = FALSE)

\S4method{comptsneMB}{DISCBIO}(object, rseed = 15555, quiet = FALSE)
}
\arguments{
\item{object}{\code{DISCBIO} class object.}

\item{rseed}{Integer number. Random seed to to yield exactly reproducible
maps across different runs. Default is 15555.}

\item{quiet}{if `TRUE`, suppresses intermediate output}
}
\value{
The DISCBIO-class object input with the MBtsne slot filled.
}
\description{
This function is used to compute the t-Distributed Stochastic
  Neighbor Embedding (t-SNE).
}
\examples{
sc <- DISCBIO(valuesG1msReduced)
sc <- NoiseFiltering(sc, percentile=0.9, CV=0.2, export=FALSE)
sc <- Normalizedata(
    sc, mintotal=1000, minexpr=0, minnumber=0, maxexpr=Inf, downsample=FALSE,
    dsn=1, rseed=17000
)
sc <- FinalPreprocessing(sc, GeneFlitering="NoiseF", export=FALSE)
sc <- Exprmclust(sc)
sc <- comptsneMB(sc, rseed=15555, quiet = TRUE)
print(sc@MBtsne)
}
