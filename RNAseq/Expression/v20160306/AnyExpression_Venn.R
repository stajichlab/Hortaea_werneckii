library(RColorBrewer)
library(VennDiagram)
#library(venneuler)
fpkm <- read.table("FPKM.sum.tab",header=T,sep="\t",row.names=1)
summary(fpkm)
Salt0noexp  <- subset(fpkm,fpkm$Sample_0.1_0 < 1 | fpkm$Sample_0.2_0 < 1)
Salt10noexp <- subset(fpkm,fpkm$Sample_10.1_0 < 1 | fpkm$Sample_10.2_0 < 1)
Salt20noexp <- subset(fpkm,fpkm$Sample_20.1_0 < 1 | fpkm$Sample_20.2_0 < 1)
summary(Salt0noexp)
summary(Salt10noexp)
summary(Salt20noexp)

Salt0exp  <- subset(fpkm,fpkm$Sample_0.1_0 >= 1 | fpkm$Sample_0.2_0 >= 1)
Salt10exp <- subset(fpkm,fpkm$Sample_10.1_0 >= 1 | fpkm$Sample_10.2_0 >= 1)
Salt20exp <- subset(fpkm,fpkm$Sample_20.1_0 >= 1 | fpkm$Sample_20.2_0 >= 1)

length(rownames(Salt0exp))
length(rownames(Salt10exp))
length(rownames(Salt20exp))
#rownames(Salt0exp)

i12 <- intersect(rownames(Salt0exp),rownames(Salt10exp))
i13 <- intersect(rownames(Salt0exp),rownames(Salt20exp))
i23 <- intersect(rownames(Salt10exp),rownames(Salt20exp))
iall <- intersect(intersect(rownames(Salt0exp),rownames(Salt10exp)),rownames(Salt20exp))

# unique in Salt0
#setdiff(Salt0exp,)
pdf("SaltGenesExpressed.pdf")

venn.in <- list()
totlen = length(rownames(fpkm))
draw.triple.venn(area1  = length(rownames(Salt0exp)),
                 area2  = length(rownames(Salt10exp)),
                 area3  = length(rownames(Salt20exp)),
                 n12 = length(i12),
                 n13 = length(i13),
                 n23 = length(i23),
                 n123 = length(iall),
                 category = c("Salt0","Salt10","Salt20"),
                 fill    = c("red","blue","yellow"),
                 lty =1, 
                 cat.cex = 1.5,
                 alpha = .9,
                 labelcol ="black",
                 fontfamily="sans",
                 euler.d = TRUE,
                 scaled = TRUE
                 )

i12 <- intersect(rownames(Salt0noexp),rownames(Salt10noexp))
i13 <- intersect(rownames(Salt0noexp),rownames(Salt20noexp))
i23 <- intersect(rownames(Salt10noexp),rownames(Salt20noexp))
iall <- intersect(intersect(rownames(Salt0noexp),rownames(Salt10noexp)),rownames(Salt20noexp))

pdf("SaltGenesNoExpressed.pdf")
draw.triple.venn(area1  = length(rownames(Salt0noexp)),
                 area2  = length(rownames(Salt10noexp)),
                 area3  = length(rownames(Salt20noexp)),
                 n12 = length(i12),
                 n13 = length(i13),
                 n23 = length(i23),
                 n123 = length(iall),
                 category = c("Salt0","Salt10","Salt20"),
                 fill    = c("red","blue","yellow"),
                 lty =1,
                 cat.cex = 1.5,
                 alpha = .9,
                 labelcol ="black",
                 fontfamily="sans",
                 euler.d = TRUE,
                 scaled = TRUE
                 )

#v <- venneuler(c(A= length(rownames(Salt0exp)) / totlen,
#                 B=length(rownames(Salt10exp)) / totlen,
#                 C=length(rownames(Salt20exp)) / totlen,
#                 "A&B"=length(i12) / totlen,
#                 "A&C"=length(i13) / totlen,
#                 "B&C"=length(i23) / totlen,
#                 "A&B&C"=length(iall))/totlen)
#plot(v)
