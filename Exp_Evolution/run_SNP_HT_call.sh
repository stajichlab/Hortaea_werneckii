#PBS -q js -l nodes=1:ppn=32,mem=96gb -q js -N GATK -j oe -o GATK.log

module load java
module load gatk/3.4-46
module load picard

MEM=96
TEMP=/scratch
INDIR=Aln/bam
OUTDIR=Variants/gvcf

if [ ! -d $OUTDIR ]; then
 mkdir -p $OUTDIR
fi
GENOME=../assemblies/Hw2/Hw2.fasta
b=`basename $GENOME .fasta`
dir=`dirname $GENOME`

if [ ! -f $dir/$b.dict ]; then
 java -jar $PICARD CreateSequenceDictionary \
 R=$GENOME OUTPUT=$dir/$b.dict SPECIES="Hortaea werneckii" TRUNCATE_NAMES_AT_WHITESPACE=true
fi

if [ ! $PBS_ARRAYID ]; then
 PBS_ARRAYID=$1;
fi

if [ ! $PBS_ARRAYID ]; then
 echo "No ARRAYID"
 exit
fi

N=`ls $INDIR/*.realign.bam | sed -n ${PBS_ARRAYID}p`
O=`basename $N .realign.bam`

if [ ! -f $OUTDIR/$O.g.vcf ]; then
java -Djava.io.tmpdir=$TEMP -Xmx${MEM}g -jar $GATK -T HaplotypeCaller \
  -ERC GVCF -variant_index_type LINEAR -variant_index_parameter 128000 \
  -I $N -R $GENOME -ploidy 1 \
  -o $OUTDIR/$O.g.vcf -nct $PBS_NP
fi
