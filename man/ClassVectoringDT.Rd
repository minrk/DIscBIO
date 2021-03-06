% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DIscBIO-generic-ClassVectoringDT.R
\name{ClassVectoringDT}
\alias{ClassVectoringDT}
\alias{ClassVectoringDT,DISCBIO-method}
\title{Generating a class vector to be used for the decision tree analysis.}
\usage{
ClassVectoringDT(
  object,
  Clustering = "K-means",
  K,
  First = "CL1",
  Second = "CL2",
  sigDEG,
  quiet = FALSE
)

\S4method{ClassVectoringDT}{DISCBIO}(
  object,
  Clustering = "K-means",
  K,
  First = "CL1",
  Second = "CL2",
  sigDEG,
  quiet = FALSE
)
}
\arguments{
\item{object}{\code{DISCBIO} class object.}

\item{Clustering}{Clustering has to be one of the following: ["K-means",
"MB"]. Default is "K-means"}

\item{K}{A numeric value of the number of clusters.}

\item{First}{A string vector showing the first target cluster.  Default is
"CL1"}

\item{Second}{A string vector showing the second target cluster.  Default is
"CL2"}

\item{sigDEG}{A data frame of the differentially expressed genes (DEGs)
generated by running "DEGanalysis()" or "DEGanalysisM()".}

\item{quiet}{If `TRUE`, suppresses intermediary output}
}
\value{
A data frame.
}
\description{
This function generates a class vector for the input dataset so
  the decision tree analysis can be implemented afterwards.
}
\examples{
sc <- DISCBIO(valuesG1msReduced)
sc <- NoiseFiltering(sc, percentile=0.9, CV=0.2, export=FALSE)
sc <- Normalizedata(
    sc, mintotal=1000, minexpr=0, minnumber=0, maxexpr=Inf, downsample=FALSE,
    dsn=1, rseed=17000
)
sc <- FinalPreprocessing(sc, GeneFlitering="NoiseF", export=FALSE)
sc <- Clustexp(sc, cln=2) # K-means clustering
sc <- comptSNE(sc, rseed=15555)
cdiff <- DEGanalysis2clust(
    sc, Clustering="K-means", K=2, fdr=.2, name="Name", First="CL1",
    Second="CL2", export=FALSE
)
DATAforDT <- ClassVectoringDT(
    sc, Clustering="K-means", K=2, First="CL1", Second="CL2", cdiff[[1]]
)
str(DATAforDT)
}
