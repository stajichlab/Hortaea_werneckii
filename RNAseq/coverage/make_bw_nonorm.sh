#PBS -l nodes=1:ppn=1,mem=2gb,walltime=2:00:00 -j oe
module load kent
module load bedtools
for file in *.bg
do
 b=`basename $file .bg`
 if [ ! -f $b.bw ]; then
  bedGraphToBigWig $file chrom.sizes $b.bw
 fi
done
