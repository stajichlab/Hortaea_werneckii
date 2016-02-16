#PBS -l nodes=1:ppn=1,mem=2gb,walltime=2:00:00 -j oe
module load kent
module load bedtools
for file in *.norm.bg
do
 b=`basename $file .norm.bg`
 if [ ! -f $b.norm.bw ]; then
  bedGraphToBigWig $file chrom.sizes $b.norm.bw
 fi
done
