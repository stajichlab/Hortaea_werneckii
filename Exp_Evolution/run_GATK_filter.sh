#PBS -l nodes=1:ppn=1,mem=16gb  -N Hw.filt -j oe
MEM=16
module load gatk/3.4-46
module load java

INFILE=Variants/Hw.unfilt.vcf
FILTERED=Variants/Hw.filt.vcf
SELECTED=Variants/Hw.selected.vcf
GENOME=../assemblies/Hw2/Hw2.fasta
SNPONLY=Variants/Hw.SNPONLY.vcf
INDELONLY=Variants/Hw.INDELONLY.vcf

if [ ! -f $FILTERED ]; then
java -Xmx3g -jar $GATK \
-T VariantFiltration -o $FILTERED \
--variant $INFILE -R $GENOME \
--clusterWindowSize 10  -filter "QD<2.0" -filterName QualByDepth \
-filter "MQ<=40.0" -filterName MapQual \
-filter "QUAL<100" -filterName QScore \
-filter "SOR > 4.0" -filterName StrandOddsRatio \
-filter "FS>60.0" -filterName FisherStrandBias 
fi

if [ ! -f $SELECTED ]; then
java -Xmx${MEM}g -jar $GATK \
   -R $GENOME \
   -T SelectVariants \
   --variant $FILTERED \
   -o $SELECTED \
   -env \
   -ef \
   --excludeFiltered
fi
if [ ! -f $SNPONLY ]; then
java -Xmx${MEM}g -jar $GATK \
   -R $GENOME \
   -T SelectVariants \
   --variant $SELECTED \
   -o $SNPONLY \
   --excludeFiltered  \
   -selectType SNP #-selectType MNP 
fi

if [ ! -f $INDELONLY ]; then
java -Xmx${MEM}g -jar $GATK \
   -R $GENOME \
   -T SelectVariants \
   --variant $SELECTED \
   -o $INDELONLY \
   --excludeFiltered  \
  -selectType INDEL -selectType MIXED -selectType MNP
fi

