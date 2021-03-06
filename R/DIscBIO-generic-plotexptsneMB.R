#' @title Highlighting gene expression in Model-based clustering in the t-SNE
#'   map
#' @description The t-SNE map representation can also be used to analyze
#'   expression of a gene or a group of genes, to investigate cluster specific
#'   gene expression patterns
#' @param object \code{DISCBIO} class object.
#' @param g  Individual gene name or vector with a group of gene names
#'   corresponding to a subset of valid row names of the \code{ndata} slot of
#'   the \code{DISCBIO} object.
#' @param n String of characters representing the title of the plot. Default is
#'   NULL and the first element of \code{g} is chosen.
#' @return t-SNE plot for one particular gene
#' @examples
#' sc <- DISCBIO(valuesG1msReduced)
#' sc <- NoiseFiltering(sc, percentile=0.9, CV=0.2, export=FALSE)
#' sc <- Normalizedata(
#'     sc, mintotal=1000, minexpr=0, minnumber=0, maxexpr=Inf, downsample=FALSE,
#'     dsn=1, rseed=17000
#' )
#' sc <- FinalPreprocessing(sc, GeneFlitering="NoiseF", export=FALSE)
#' sc <- Exprmclust(sc, K=3)
#' sc <- comptsneMB(sc, rseed=15555)
#' sc <- Clustexp(sc, cln=3)
#' sc <- MB_Order(sc, export = FALSE)
#' g <- 'ENSG00000001460'
#' plotexptsneMB(sc, g)
setGeneric("plotexptsneMB", function(object, g, n = NULL)
    standardGeneric("plotexptsneMB"))

#' @export
#' @rdname plotexptsneMB
setMethod(
    "plotexptsneMB",
    signature = "DISCBIO",
    definition = function(object, g, n = NULL) {
        if (length(object@MBtsne) == 0)
            stop("run comptsneMB before plotexptsneMB")
        if (length(intersect(g, rownames(object@ndata))) < length(unique(g)))
            stop(
                "second argument does not correspond to set of rownames",
                "slot ndata of SCseq object"
            )
        if (is.null(n))
            n <- g[1]
        l <- apply(object@ndata[g, ] - .1, 2, sum) + .1

        mi <- min(l, na.rm = TRUE)
        ma <- max(l, na.rm = TRUE)
        ColorRamp <-
            colorRampPalette(rev(brewer.pal(n = 7, name = "RdYlBu")))(100)
        ColorLevels <- seq(mi, ma, length = length(ColorRamp))
        v <- round((l - mi) / (ma - mi) * 99 + 1, 0)
        layout(
            matrix(
                data = c(1, 3, 2, 4),
                nrow = 2,
                ncol = 2
            ),
            widths = c(5, 1, 5, 1),
            heights = c(5, 1, 1, 1)
        )
        par(mar = c(3, 5, 2.5, 2))
        plot(
            object@MBtsne,
            xlab = "Dim 1",
            ylab = "Dim 2",
            main = n,
            pch = 20,
            cex = 0,
            col = "grey",
            las = 1
        )
        for (k in 1:length(v)) {
            points(
                object@MBtsne[k, 1],
                object@MBtsne[k, 2],
                col = ColorRamp[v[k]],
                pch = 20,
                cex = 1.5
            )
        }
        par(mar = c(3, 2.5, 2.5, 2))
        image(
            1,
            ColorLevels,
            matrix(
                data = ColorLevels,
                ncol = length(ColorLevels),
                nrow = 1
            ),
            col = ColorRamp,
            xlab = "",
            ylab = "",
            las = 1,
            xaxt = "n"
        )
        layout(1)
    }
)