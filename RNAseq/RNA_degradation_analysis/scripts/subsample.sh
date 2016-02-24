module load samtools/1.3
for file in bam/*.bam
do
 name=`basename $file`
 samtools view -s 0.001 -b $file > bam2/$name
done
