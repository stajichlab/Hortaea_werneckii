module load bedtools
for file in aln_src/merged/*.bam
do
f=`basename $file .bam`
if [ ! -f coverage/$f.bg ]; then
 bedtools genomecov -bg -ibam $file -split > coverage/$f.bg 
fi
if [ ! -f coverage/$f.bed ]; then
  bedtools genomecov -dz -ibam $file -split > coverage/$f.bed
fi
done
