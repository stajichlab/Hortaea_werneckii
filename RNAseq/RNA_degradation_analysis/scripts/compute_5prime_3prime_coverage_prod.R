
library(systemPipeR)
library(Rsamtools)
library(GenomicAlignments)
library(BiocParallel)
library(systemPipeRdata); library(GenomicFeatures); library(rtracklayer);

txdb <- loadDb("./Hw2.MAKER.sqlite")
grl <- transcriptsBy(txdb, "gene")
#, use.names=TRUE)
#multicoreParam <- MulticoreParam(workers=16);
#register(multicoreParam); registered()
dir = "bam"
targets <- read.delim("targets.txt", sep="\t",comment.char = "#")
filenames <- file.path(dir, paste0(targets$SampleName, ".bam"))
bfl <- BamFileList(filenames)

## countg <- bplapply(bfl, function(x) featureCoverage
##                       (x,grl=grl[1:4], resizereads=NULL,
##                        readlengthrange=NULL, Nbins=5,
##                        method=mean, fixedmatrix=FALSE,
##                        resizefeatures=TRUE, upstream=20, downstream=20))

## rownames(countg)
## colnames(countg)
## targets$SampleLong

## write.table(countg, "results/countGenes.csv",
##             col.names=NA, quote=FALSE, sep=",")

fcov <- featureCoverage(bfl, grl=grl, resizereads=NULL,
                        readlengthrange=NULL, Nbins=5, method=mean,
                        fixedmatrix=FALSE,
                        resizefeatures=TRUE, upstream=20, downstream=20,
                        outfile="results/geneCoverageProd.csv", overwrite=TRUE)
