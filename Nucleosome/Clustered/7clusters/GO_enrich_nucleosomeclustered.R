library("AnnotationDbi")
library("GSEABase")
library("GOstats")

allgenes <- read.csv("all_genes.txt",
	 header=F,stringsAsFactors=F,sep=" ",quote="")
universe <- allgenes$V1

head(universe)

godat <- read.table("../../../annotation/Domains/Hw2.GO.tab",header=F);
goframeData <- data.frame(godat$V1, godat$V2, godat$V3)
goFrame <- GOFrame(goframeData,organism="Hortaea werneckii")
goAllFrame=GOAllFrame(goFrame)

gsc <- GeneSetCollection(goAllFrame, setType = GOCollection())

clusters <- read.table("7clustered_FPKM_compiled.tsv.gz",
                       header=F,sep="\t",stringsAsFactors=F, quote="")

max <- max(clusters$V2)
max

for ( i in 0:max ) {
 genes <- subset(clusters$V1, clusters$V2 == i)
 head(genes)

 params <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",
                              geneSetCollection=gsc,
                              geneIds = genes,
                              universeGeneIds = universe,
                              ontology = "MF",
                              pvalueCutoff = 0.05,
                              conditional = FALSE,
                              testDirection = "over")
 
 OverMF <- hyperGTest(params)
 summary(OverMF)
 prefix <- paste("CL",i,sep='')

 filename <- paste(prefix,"_OverMF_enrich.csv",sep='')
 write.csv(summary(OverMF),filename)

 paramsCC <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",
                                geneSetCollection=gsc,
                                geneIds = genes,
                                universeGeneIds = universe,
                                ontology = "CC",
                                pvalueCutoff = 0.05,
                                conditional = FALSE,
                                testDirection = "over")

 OverCC <- hyperGTest(paramsCC)
 summary(OverCC)
 OverCC
 filename <- paste(prefix,"_OverCC_enrich.csv",sep='')
 write.csv(summary(OverCC),filename)

 paramsBP <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",
                                geneSetCollection=gsc,
                                geneIds = genes,
                                universeGeneIds = universe,
                                ontology = "BP",
                                pvalueCutoff = 0.05,
                                conditional = FALSE,
                                testDirection = "over")
 
 OverBP <- hyperGTest(paramsBP)
 summary(OverBP)
 OverBP
 filename <- paste(prefix,"_OverBP_enrich.csv",sep='')
 write.csv(summary(OverBP),filename)
}

