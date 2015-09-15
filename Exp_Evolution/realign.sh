#PBS -l nodes=1:ppn=1,mem=16gb -j oe -N realign
module load java
module load gatk/3.4-46
module load picard

N=$PBS_ARRAYID
if [ ! $N ]; then
 N=$1
fi

if [ ! $N ]; then 
 echo  "need arrayid or cmdline integer"
 exit
fi

dir=bam
bam=`head -n $N bamfiles | tail -n 1`
prefix=`basename $bam`
GENOME=../../assemblies/Hw2/Hw2.fasta
b=`basename $GENOME .fasta`
genomdir=`dirname $GENOME`
echo "b = $b; dir=$dir"
if [ ! -f $genomdir/$b.dict ]; then
 java -jar $PICARD CreateSequenceDictionary R=$GENOME O=$genomdir/$b.dict SPECIES="Hortaea werneckii" TRUNCATE_NAMES_AT_WHITESPACE=true
fi

## Identify intervals around variants
if [ ! -e $dir/$prefix.realign.bam ]; then
java -Xmx16g -jar $GATK \
       -T RealignerTargetCreator \
       -R $GENOME \
       -o $dir/$prefix.gatk.intervals \
       -I $dir/$bam

## Realign based on these intervals
java -Xmx16g -jar $GATK \
       -T IndelRealigner \
       -R $GENOME \
       -targetIntervals $dir/$prefix.gatk.intervals \
       -I $dir/$bam \
       -o $dir/$prefix.realign.bam
fi
