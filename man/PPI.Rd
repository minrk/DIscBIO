% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PPI.R
\name{PPI}
\alias{PPI}
\title{Defining protein-protein interactions (PPI) over a list of genes,}
\usage{
PPI(data, FileName, species = "9606")
}
\arguments{
\item{data}{A gene list.}

\item{FileName}{A string vector showing the name to be used to save the
resulted table.}

\item{species}{The taxonomy name/id. Default is "9606" for Homo sapiens.}
}
\value{
A TSV file stored in the user's file system and its corresponding
  `data.frame` object in R.
}
\description{
This function uses STRING-api. The outcome of STRING analysis
  will be stored in tab separated values (TSV) files.
}
\examples{
\dontrun{
sc <- DISCBIO(valuesG1msReduced)
sc <- NoiseFiltering(sc, percentile=0.9, CV=0.2)
sc <- Normalizedata(
    sc, mintotal=1000, minexpr=0, minnumber=0, maxexpr=Inf, downsample=FALSE,
    dsn=1, rseed=17000
)
sc <- FinalPreprocessing(sc, GeneFlitering="NoiseF")
sc <- Clustexp(sc, cln=3) # K-means clustering
sc <- comptSNE(sc, rseed=15555)
dff <- DEGanalysis2clust(sc, Clustering="K-means", K=3, fdr=0.1, name="Name")
DEGs <- dff[[2]][1, 6]
data <- read.csv(file=paste0(DEGs),head=TRUE,sep=",")
data <- data[,3]
FileName <- paste0(DEGs)
PPI(data, FileName)
}
}
