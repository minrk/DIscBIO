#' @title ClustDiffGenes
#' @description description
#' @param object \code{DISCBIO} class object.
#' @param K A numeric value of the number of clusters.
#' @param pValue A numeric value of the p-value. Default is 0.05.
#' @param fdr A numeric value of the false discovery rate. Default is 0.01.
#' @param export A logical vector that allows writing the final gene list in
#'   excel file. Default is TRUE.
#' @param quiet if `TRUE`, suppresses intermediate text output
#' @importFrom dplyr summarize
#' @importFrom stats pbinom median
#' @rdname KMClustDiffGenes
#' @return A list containing two tables.
#' @export
#' @examples
#' sc <- DISCBIO(valuesG1msReduced)
#' sc <- Clustexp(sc, cln=3, quiet=TRUE) # K-means clustering
#' KMClustDiffGenes(sc, K=3, fdr=.3, export=FALSE)
setGeneric("KMClustDiffGenes", function(object,
                                        K,
                                        pValue = 0.05,
                                        fdr = .01,
                                        export = TRUE,
                                        quiet = FALSE)
    standardGeneric("KMClustDiffGenes"))
#' @export
#' @rdname KMClustDiffGenes
setMethod(
    "KMClustDiffGenes",
    signature = "DISCBIO",
    definition = function(object,
                          K,
                          pValue,
                          fdr,
                          export = TRUE,
                          quiet = FALSE) {
        # Validation
        if (!is.numeric(fdr)) {
            stop("fdr has to be a number between 0 and 1")
        } else if (fdr < 0 | fdr > 1) {
            stop("fdr has to be a number between 0 and 1")
        }
        if (!is.numeric(pValue)) {
            stop("pValue has to be a number between 0 and 1")
        } else if (pValue < 0 | pValue > 1) {
            stop("pValue has to be a number between 0 and 1")
        }
        if (length(object@kmeans$kpart) == 0) {
            stop("run Clustexp before KMClustDiffGenes")
        }
        cdiff <- list()
        x     <- object@ndata
        y     <- object@expdata[, names(object@ndata)]
        part  <- object@kmeans$kpart
        binompval <- function(p, N, n) {
            pval   <- pbinom(n, round(N, 0), p, lower.tail = TRUE)
            pval[!is.na(pval) &
                     pval > 0.5] <- 1 - pval[!is.na(pval) & pval > 0.5]
            return(pval)
        }
        for (i in 1:max(part)) {
            if (sum(part == i) == 0)
                next
            m <- apply(x, 1, mean)
            n <-
                if (sum(part == i) > 1)
                    apply(x[, part == i], 1, mean)
            else
                x[, part == i]
            no <-
                if (sum(part == i) > 1)
                    median(apply(y[, part == i], 2, sum)) /
                    median(apply(x[, part == i], 2, sum))
            else
                sum(y[, part == i]) / sum(x[, part == i])
            m <- m * no
            n <- n * no
            pv <- binompval(m / sum(m), sum(n), n)
            d <-
                data.frame(
                    mean.all = m,
                    mean.cl = n,
                    fc = n / m,
                    pv = pv
                )[order(pv, decreasing = FALSE), ]
            cdiff[[i]] <- d[d$pv < pValue, ]
        }
        DEGsE <- c()
        DEGsS <- c()
        DEGsTable <- data.frame()

        for (n in 1:K) {
            if (length(cdiff[[n]][, 1]) == 0) {
                next
            }

            if (length(cdiff[[n]][, 1]) > 0) {
                p.adj <- p.adjust(cdiff[[n]][, 4], method = "bonferroni")
                out <- cbind(cdiff[[n]], p.adj)
                out <- subset(out, out[, 5] < fdr)
                if (length(out[, 1]) > 0) {
                    Regulation <- c()
                    for (i in 1:length(out[, 1])) {
                        if (out[i, 1] > out[i, 2]) {
                            Regulation[i] = "Down"
                        } else{
                            Regulation[i] = "Up"
                        }
                    }
                    out <- cbind(out, Regulation)
                    if (quiet) {
                        suppressMessages(
                            geneList <-
                                AnnotationDbi::select(
                                    org.Hs.eg.db,
                                    keys = keys(org.Hs.eg.db),
                                    columns = c("SYMBOL", "ENSEMBL")
                                )
                        )
                        GL <- c(1, "MTRNR2", "ENSG00000210082")
                        GL1 <- c(1, "MTRNR1", "ENSG00000211459")
                        geneList <- rbind(geneList, GL, GL1)
                    } else {
                        geneList <-
                            AnnotationDbi::select(
                                org.Hs.eg.db,
                                keys = keys(org.Hs.eg.db),
                                columns = c("SYMBOL", "ENSEMBL")
                            )
                        GL <- c(1, "MTRNR2", "ENSG00000210082")
                        GL1 <- c(1, "MTRNR1", "ENSG00000211459")
                        geneList <- rbind(geneList, GL, GL1)
                    }
                    genes <- rownames(out)
                    gene_list <- geneList[, 3]
                    idx_genes <- is.element(gene_list, genes)
                    genes2 <- geneList[idx_genes, ]
                    Final <- cbind(genes, out)

                    Final <-
                        merge(
                            Final,
                            genes2,
                            by.x = "genes",
                            by.y = "ENSEMBL",
                            all.x = TRUE
                        )
                    Final <- Final[!duplicated(Final[, 1]),]
                    Final[is.na(Final[, 9]), c(1, 9)] <-
                        Final[is.na(Final[, 9]), 1]
                    rownames(Final) <- Final[, 1]
                    Final[, 1] <- Final[, 9]
                    Final <- Final[, -9]
                    DEGsS <- c(DEGsS, Final[, 1])
                    DEGsE <-
                        c(DEGsE, as.character(rownames(Final)))
                    Up <- subset(Final, Final[, 7] == "Up")
                    Up <-
                        dplyr::select(Up,
                                      "Regulation",
                                      "genes",
                                      "pv",
                                      "mean.all",
                                      "mean.cl",
                                      "fc",
                                      "p.adj")
                    Up[, 3] <- rownames(Up)
                    Up[, 6] <- log2(Up[, 6])
                    Up[, 1] <- Up[, 2]
                    colnames(Up) <-
                        c(
                            "Genes",
                            "genes",
                            "E.genes",
                            "mean.all",
                            "mean.cl",
                            "log2.fc",
                            "p.adj"
                        )
                    if (export) {
                        write.csv(
                            Up, file = paste0("Up-DEG-cluster", n, ".csv")
                        )
                    }

                    Down <- subset(Final, Final[, 7] == "Down")
                    Down <-
                        dplyr::select(
                            Down,
                            "Regulation",
                            "genes",
                            "pv",
                            "mean.all",
                            "mean.cl",
                            "fc",
                            "p.adj"
                        )
                    Down[, 3] <- rownames(Down)
                    Down[, 6] <- log2(Down[, 6])
                    Down[, 1] <- Down[, 2]
                    colnames(Down) <-
                        c(
                            "Genes",
                            "genes",
                            "E.genes",
                            "mean.all",
                            "mean.cl",
                            "log2.fc",
                            "p.adj"
                        )
                    if (export) {
                        write.csv(Down,
                                  file = paste0("Down-DEG-cluster", n, ".csv"))
                    }

                    sigDEG <- cbind(DEGsE, DEGsS)
                    if (export) {
                        write.csv(sigDEG, file = "binomial-sigDEG.csv")
                    }

                    DEGsTable[n, 1] <- paste0("Cluster ", n)
                    DEGsTable[n, 2] <- "Remaining Clusters"
                    DEGsTable[n, 3] <- length(Up[, 1])
                    DEGsTable[n, 4] <-
                        paste0("Up-DEG-cluster", n, ".csv")
                    DEGsTable[n, 5] <- length(Down[, 1])
                    DEGsTable[n, 6] <-
                        paste0("Down-DEG-cluster", n, ".csv")
                }
            }
        }
        if (length(DEGsTable) > 0) {
            colnames(DEGsTable) <-
                c("Target Cluster",
                  "VS",
                  "Gene number",
                  "File name",
                  "Gene number",
                  "File name")
            if (export) {
                write.csv(DEGsTable, file = "binomial-DEGsTable.csv")
            }
            return(list(sigDEG, DEGsTable))
        } else{
            print(paste0("There are no DEGs with fdr=", fdr))
        }
    }
)