library("AnnotationDbi")
library("GSEABase")
library("GOstats")

allgenes <- read.table("cuffnorm_combined/genes.attr_table",
	 header=T,stringsAsFactors=F,sep="\t",quote="")
#summary(allgenes)

universe <- allgenes$tracking_id
head(universe)

# problem matching mode of this before
# this should be go-slimmed so more meaningful
godat <- read.table("Hw2.yeastmap.GO.tab",header=F);
goframeData <- data.frame(godat$V1, godat$V2, godat$V3)

goFrame <- GOFrame(goframeData,organism="Hortaea werneckii")
goAllFrame=GOAllFrame(goFrame)

gsc <- GeneSetCollection(goAllFrame, setType = GOCollection())

goSet<- function(genelist, setname) {
  types = c("MF","BP","CC")
  tstdir = c("over","under")

  for (type in types ) {
    for (direc in tstdir ) {
      params <- GSEAGOHyperGParams(name="My Custom GSEA based annot Params",
                                   geneSetCollection=gsc,
                                   geneIds = genelist,
                                   universeGeneIds = universe,
                                   ontology = type,
                                   pvalueCutoff = 0.05,
                                   conditional = FALSE,
                                   testDirection = direc)

      res <- hyperGTest(params)
      summary(res)
      file=sprintf("%s/%s%s_enrich.csv",setname,direc,type)
      write.csv(summary(res),file)
    }
  }

}
fpkm <- read.table("FPKM.sum.tab",header=T,sep="\t",row.names=1)
summary(fpkm)
Salt0noexp  <- subset(fpkm,fpkm$Sample_0.1_0 < 1 & fpkm$Sample_0.2_0 < 1)
Salt10noexp <- subset(fpkm,fpkm$Sample_10.1_0 < 1 & fpkm$Sample_10.2_0 < 1)
Salt20noexp <- subset(fpkm,fpkm$Sample_20.1_0 < 1 & fpkm$Sample_20.2_0 < 1)

Salt0exp  <- subset(fpkm,fpkm$Sample_0.1_0 >= 1 & fpkm$Sample_0.2_0 >= 1)
Salt10exp <- subset(fpkm,fpkm$Sample_10.1_0 >= 1 & fpkm$Sample_10.2_0 >= 1)
Salt20exp <- subset(fpkm,fpkm$Sample_20.1_0 >= 1 & fpkm$Sample_20.2_0 >= 1)

i12 <- intersect(rownames(Salt0exp),rownames(Salt10exp))
i13 <- intersect(rownames(Salt0exp),rownames(Salt20exp))
i23 <- intersect(rownames(Salt10exp),rownames(Salt20exp))
iall <- intersect(intersect(i12,i13),i23)

# unique in Salt0
s0only <- setdiff(setdiff(rownames(Salt0exp),rownames(Salt10exp)),rownames(Salt20exp))
s10only <- setdiff(setdiff(rownames(Salt10exp),rownames(Salt0exp)),rownames(Salt20exp))
s20only <- setdiff(setdiff(rownames(Salt20exp),rownames(Salt0exp)),rownames(Salt10exp))
length(s0only)
length(s10only)
length(s20only)

write.table(s0only, "onlyExpIn0_yeastSlim/genes.txt",col.names=F,quote=F,row.names=F)
write.table(s10only, "onlyExpIn10_yeastSlim/genes.txt",col.names=F,quote=F,row.names=F)
write.table(s20only, "onlyExpIn20_yeastSlim/genes.txt",col.names=F,quote=F,row.names=F)

s0.10only <- setdiff(i12,rownames(Salt20exp))
s0.20only <- setdiff(i13,rownames(Salt10exp))
s10.20only <- setdiff(i23,rownames(Salt0exp))
length(s0.10only)
length(s0.20only)
length(s10.20only)

write.table(s0.10only, "onlyExpIn0_10_yeastSlim/genes.txt",
            col.names=F,quote=F,row.names=F)
write.table(s0.20only, "onlyExpIn0_20_yeastSlim/genes.txt",
            col.names=F,quote=F,row.names=F)
write.table(s10.20only, "onlyExpIn10_20_yeastSlim/genes.txt",
            col.names=F,quote=F,row.names=F)

# GO Enrichment

#goSet(s0only,"onlyExpIn0_yeastSlim")
#goSet(s10only,"onlyExpIn10_yeastSlim")
#goSet(s20only,"onlyExpIn20_yeastSlim")

#goSet(s0.10only,"onlyExpIn0_10_yeastSlim")
#goSet(s0.20only,"onlyExpIn0_20_yeastSlim")
#goSet(s10.20only,"onlyExpIn10_20_yeastSlim")


# === not Slim ==
write.table(s0only, "onlyExpIn0/genes.txt",col.names=F,quote=F,row.names=F)
write.table(s10only, "onlyExpIn10/genes.txt",col.names=F,quote=F,row.names=F)
write.table(s20only, "onlyExpIn20/genes.txt",col.names=F,quote=F,row.names=F)

write.table(s0.10only, "onlyExpIn0_10/genes.txt",
            col.names=F,quote=F,row.names=F)
write.table(s0.20only, "onlyExpIn0_20/genes.txt",
            col.names=F,quote=F,row.names=F)
write.table(s10.20only, "onlyExpIn10_20/genes.txt",
            col.names=F,quote=F,row.names=F)

godat <- read.table("Hw2.go",header=F);
goframeData <- data.frame(godat$V3, godat$V2, godat$V1)

goFrame <- GOFrame(goframeData,organism="Hortaea werneckii")
goAllFrame=GOAllFrame(goFrame)

gsc <- GeneSetCollection(goAllFrame, setType = GOCollection())



goSet(s0only,"onlyExpIn0")
goSet(s10only,"onlyExpIn10")
goSet(s20only,"onlyExpIn20")

goSet(s0.10only,"onlyExpIn0_10")
goSet(s0.20only,"onlyExpIn0_20")
goSet(s10.20only,"onlyExpIn10_20")
