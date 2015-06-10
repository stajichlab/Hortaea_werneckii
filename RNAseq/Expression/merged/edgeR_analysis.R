library(edgeR)
x <- read.delim("cuffnorm_combined/genes.count_table",row.names="tracking_id")
dim(x)
newx <- x[,c(5,6,1,2,3,4)]
# group <- factor(c(1,1,2,2,3,3,));
samplenames <- c("Salt_0","Salt_0","Salt_10","Salt_10","Salt_20","Salt_20")
head(x)
head(newx)
y <- DGEList(counts=newx,group=factor(samplenames))
pdf("Hw_edgeR.pdf")
dim(y)
y.full <- y
apply(y$counts, 2, sum)
keep <- rowSums(cpm(y)>100) >= 2
y <- y[keep,]
dim(y)

y$samples$lib.size <- colSums(y$counts)
y$samples

y <- calcNormFactors(y)

plotMDS(y, method="bcv", col=as.numeric(y$samples$group))
legend("topright", as.character(unique(y$samples$group)), col=1:3, pch=20)

d1 <- estimateCommonDisp(y, verbose=T)
d1 <- estimateTagwiseDisp(d1)
names(d1)

plotBCV(d1)

meanVarPlot <- plotMeanVar(d1 , show.raw.vars=TRUE ,
                           show.tagwise.vars=TRUE ,
                           show.binned.common.disp.vars=FALSE ,
                           show.ave.raw.vars=FALSE ,
                           #dispersion.method = "qcml",
                           NBline = TRUE ,
                           nbins = 100 ,
                           pch = 16 ,
                           xlab ="Mean Expression (Log10 Scale)" ,
                           ylab = "Variance (Log10 Scale)" ,
                           main = "Mean-Variance Plot" )



design.mat <- model.matrix(~ 0 + y$samples$group)
colnames(design.mat) <- levels(y$samples$group)
d2 <- estimateGLMCommonDisp(y,design.mat)
d2 <- estimateGLMTrendedDisp(d2,design.mat, method="power")

# You can change method to "auto", "bin.spline", "power", "spline", "bin.loess".
# The default is "auto" which chooses "bin.spline" when > 200 tags and "power" otherwise.
d2 <- estimateGLMTagwiseDisp(d2,design.mat)
plotBCV(d2)


et12 <- exactTest(d1, pair=c(1,2))
et13 <- exactTest(d1, pair=c(1,3))
et23 <- exactTest(d1, pair=c(2,3))
toptags <- topTags(et12,n=1500,adjust.method="BH", sort.by="PValue")
colnames(toptags)
write.csv(toptags,file="toptags_0vs10.csv")

toptags <- topTags(et13,n=1500, adjust.method="BH", sort.by="PValue")
write.csv(toptags,file="toptags_0vs20.csv")

toptags <- topTags(et23,n=150,adjust.method="BH", sort.by="PValue")
write.csv(toptags,file="toptags_10vs20.csv")

de1 <- decideTestsDGE(et12, adjust.method="BH", p.value=0.05)
summary(de1)

de1 <- decideTestsDGE(et13, adjust.method="BH", p.value=0.05)
summary(de1)

de1 <- decideTestsDGE(et23, adjust.method="BH", p.value=0.05)
summary(de1)

de1tags12 <- rownames(d1)[as.logical(de1)] 
plotSmear(et12, de.tags=de1tags12,main="Salt 0 vs 10")
abline(h = c(-2, 2), col = "blue")


de1tags13 <- rownames(d1)[as.logical(de1)] 
plotSmear(et13, de.tags=de1tags13,main="Salt 0 vs 20")
abline(h = c(-2, 2), col = "blue")

de1tags23 <- rownames(d1)[as.logical(de1)] 
plotSmear(et23, de.tags=de1tags23,main="Salt 10 vs 20")
abline(h = c(-2, 2), col = "blue")


fit <- glmFit(d2, design.mat)

lrt12 <- glmLRT(fit, contrast=c(1,-1,0))
lrt13 <- glmLRT(fit, contrast=c(1,0,-1))
lrt23 <- glmLRT(fit, contrast=c(0,1,-1))
toptags <- topTags(lrt12, n=1500)
write.csv(toptags,file="toptags_glm_0vs10.csv")
toptags <- topTags(lrt13, n=1500)
write.csv(toptags,file="toptags_glm_0vs20.csv")
toptags <- topTags(lrt23, n=1500)
write.csv(toptags,file="toptags_glm_10vs20.csv")

de2 <- decideTestsDGE(lrt12, adjust.method="BH", p.value = 0.05)
de2tags12 <- rownames(d2)[as.logical(de2)]
plotSmear(lrt12, de.tags=de2tags12,main="GLM Salt 0 vs 10")
abline(h = c(-2, 2), col = "blue")

de3 <- decideTestsDGE(lrt13, adjust.method="BH", p.value = 0.05)
de2tags13 <- rownames(d2)[as.logical(de3)]
plotSmear(lrt13, de.tags=de2tags13,main="GLM Salt 0 vs 20")
abline(h = c(-2, 2), col = "blue")

de4 <- decideTestsDGE(lrt23, adjust.method="BH", p.value = 0.05)
de2tags23 <- rownames(d2)[as.logical(de4)]
plotSmear(lrt23, de.tags=de2tags23,main="GLM Salt 10 vs 20")
abline(h = c(-2, 2), col = "blue")
