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
intersectUp

length(intersectDn)
intersectDn

upgenes = list("0M" = et10.0GenesUp,
  "20M" = et10.20GenesUp)

plot.new()
venn_plot <- venn.diagram(upgenes,
                          filename = "venn_up.tiff",
                          fill = c("red", "blue"), 
                          cat.cex = 1.5)
downgenes = list("0M" = et10.0GenesDn,
  "20M" = et10.20GenesDn)

venn_plot <- venn.diagram(downgenes,
                          filename = "venn_dn.tiff",
                          fill = c("red", "blue"), 
                          cat.cex = 1.5)


