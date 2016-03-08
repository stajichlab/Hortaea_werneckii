# read in the table

library(RColorBrewer)
library(VennDiagram)

# time 0 is 0%
# time 1 is 10%
# time 2 is 20%
# if 10% is normal we should be comparing everything against it

et10.0 <- read.csv("toptags_glm_10vs0.csv",header=T)
et0.20 <- read.csv("toptags_glm_0vs20.csv",header=T)
et10.20<- read.csv("toptags_glm_10vs20.csv",header=T)
cn <- colnames(et10.0)
cn[1] = "GENE"

colnames(et10.0) <- cn
colnames(et0.20) <- cn
colnames(et10.20) <- cn

et10.0GenesDn <- subset(et10.0$GENE,et10.0$FDR < 0.01 & et10.0$logFC >= 0)
et10.0GenesUp <- subset(et10.0$GENE,et10.0$FDR < 0.01 & et10.0$logFC < 0)
#et0.20GenesDn <- subset(et0.20$GENE,et0.20$FDR < 1e-05 & et0.20$logFC > 0 )
#et0.20GenesDn

et10.20GenesDn <- subset(et10.20$GENE,et10.20$FDR < 0.01 & et10.20$logFC >= 0)
et10.20GenesUp <- subset(et10.20$GENE,et10.20$FDR < 0.01 & et10.20$logFC < 0)

intersectUp <- intersect(et10.0GenesUp,et10.20GenesUp)
intersectDn <- intersect(et10.0GenesDn,et10.20GenesDn)
length(intersectUp)
head(intersectUp)

length(intersectDn)
head(intersectDn)

#upCommonGenes = list("0M" = et10.0GenesUp, "20M" = et10.20GenesUp)
#dnCommonGenes = list("0M" = et10.0GenesDn, "20M" = et10.20GenesDn)

setonlyUpin0 <- setdiff(et10.0GenesUp,et10.20GenesUp)
setonlyUpin20 <- setdiff(et10.20GenesUp,et10.0GenesUp)

setonlyDnin0 <- setdiff(et10.0GenesDn,et10.20GenesDn)
setonlyDnin20 <- setdiff(et10.20GenesDn,et10.0GenesDn)


write.table(intersectUp, "upCommon/genes.txt",col.names=F,quote=F,row.names=F)
write.table(intersectDn, "dnCommon/genes.txt",col.names=F,quote=F,row.names=F)

write.table(setonlyUpin0, "onlyUpIn0/genes.txt",col.names=F,quote=F,row.names=F)
write.table(setonlyUpin20, "onlyUpIn20/genes.txt",col.names=F,quote=F,row.names=F)

write.table(setonlyDnin0, "onlyDnIn0/genes.txt",col.names=F,quote=F,row.names=F)
write.table(setonlyDnin20, "onlyDnIn20/genes.txt",col.names=F,quote=F,row.names=F)

head(setonlyDnin0)

allgenes <- read.table("cuffnorm_combined/genes.attr_table",
	 header=T,stringsAsFactors=F,sep="\t",quote="")
#summary(allgenes)

universe <- allgenes$tracking_id
head(universe)

# problem matching mode of this before
mode(universe)
mode(intersectUp)
mode(intersectDn)
mode(setonlyUpin0)
mode(setonlyUpin20)
mode(setonlyDnin20)
mode(setonlyDnin0)



types = c("MF","BP","CC")
tstdir = c("over","under")
for (type in types ) {
  for (direc in tstdir ) {
      file=sprintf("%s/%s%s_enrich.csv","dnCommon",direc,type)
      file
    }
}

library("AnnotationDbi")
library("GSEABase")
library("GOstats")
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

goSet(intersectUp,"upCommon_yeastSlim")
goSet(intersectDn,"dnCommon_yeastSlim")
goSet(setonlyUpin0,"onlyUpIn0_yeastSlim")
goSet(setonlyUpin20,"onlyUpIn20_yeastSlim")
goSet(setonlyDnin0,"onlyDnIn0_yeastSlim")
goSet(setonlyDnin20,"onlyDnIn20_yeastSlim")



