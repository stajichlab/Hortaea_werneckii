library(knitr)
library(systemPipeR)
library(Rsamtools)
library(GenomicAlignments)
library(BiocParallel)
library(systemPipeRdata); library(GenomicFeatures); library(rtracklayer);
fa<-indexFa("Hw2.fasta")
idx <- scanFaIndex(fa)
r<-ranges(idx)
length(r)
circ <- rep(FALSE,length(r))
chrominfo <- data.frame(chrom = seqnames(idx), length=end(r),
                        is_circular = circ )

annoDB <- makeTxDbFromGFF("Hw2.maker_genes.gff3",
    format="gff3",
    organism="Hortaea werneckii",
    dataSource="UCR_UBC",
    chrominfo = chrominfo);

saveDb(annoDB, file="Hw2.MAKER.sqlite")
