module load bedtools
perl -e'print "chr\tstart\tend\tgene_interval\tscore\tstrand\tSalt0_1\tSalt0_2\tSalt10_1\tSalt10_2\tSalt20_1\tSalt20_2\n"'  > multicov_header.tab
cat multicov_header.tab > Hw2.maker_genes_only.5windows.multicov
bedtools multicov -D -split -bams bam/*.bam -bed Hw2.maker_genes_only.5windows_stranded.bed >> Hw2.maker_genes_only.5windows.multicov
