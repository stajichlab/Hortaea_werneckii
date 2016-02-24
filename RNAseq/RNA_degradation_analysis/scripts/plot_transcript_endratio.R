library(ggplot2);
transcripts <- read.table("multicov_saltRPKM.dat",header=T,sep="\t");
pdf("5prime_3prime_saltRPKM.pdf")
ggplot(transcripts,aes(log(COUNT5PRIME),log(COUNT3PRIME))) + geom_point(aes(colour = factor(TREATMENT)),alpha=1/5) + ggtitle("FPKM of 5' and 3' expression (normalized and log transformed)") + xlab(" log(5' FPKM)") + ylab("log(3' FPKM)")

ggplot(transcripts,aes(COUNT5PRIME,COUNT3PRIME)) + geom_point(aes(colour = factor(TREATMENT)),alpha=1/5) + ggtitle("FPKM of 5' and 3' expression (normalized)") + xlab("5' FPKM") + ylab("3' FPKM")
