#PBS -l nodes=1:ppn=1,mem=1gb -j oe -N bamindex
module load samtools/1.1
module load java
module load picard

for file in *.bam
do
# samtools index $file
 java -jar $PICARD/BuildBamIndex.jar INPUT=$file
done
