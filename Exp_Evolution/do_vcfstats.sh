#PBS -j oe -l nodes=1:ppn=1,mem=2gb 
module load vcftools
FILE=Hw.selected.vcf
if [ -f $FILE ]; then
 # compress and index
 if [ ! -f $FILE.gz ]; then
  bgzip $FILE
  tabix $FILE.gz
 fi
 vcf-stats $FILE.gz > $FILE.vcfstats
fi
