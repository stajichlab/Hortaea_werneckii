#PBS -l nodes=1:ppn=8,mem=32gb,walltime=48:00:00 -j oe -N bwa
module load bwa/0.7.12
module load samtools/1.2
module load java
module load picard

MEM=32
CPU=$PBS_NUM_PPN
SAMPLEFILE=samples.info
BWA=bwa
GENOMEIDX=../assemblies/Hw2/Hw2.fasta
OUTPUT=Aln/bam
QUAL=20

mkdir -p $OUTPUT

if [ ! $CPU ]; then
 CPU=1
fi

LINE=$PBS_ARRAYID

if [ ! $LINE ]; then
 LINE=$1
fi

if [ ! $LINE ]; then 
 echo "Need a number via PBS_ARRAYID or cmdline"
 exit
fi

ROW=`head -n $LINE $SAMPLEFILE | tail -n 1`
SAMPLE=`echo "$ROW" | awk '{print $1}'`
READ1=`echo "$ROW" | awk '{print $2}'`
READ2=`echo "$ROW" | awk '{print $3}'`
INDIR=`dirname $READ1`

echo "SAMPLE=$SAMPLE"
echo "R1=$READ1 R2=$READ2"
BARCODE=`basename $READ1 | perl -p -e 's/.+_([ACGT]+-[ACTG]+)_.+/$1/'`
echo "BARCODE=$BARCODE"

if [ ! -f $OUTPUT/$SAMPLE.DD.bam ]; then
 if [ ! -f $OUTPUT/$SAMPLE.sam ]; then
     time $BWA mem -t $CPU $GENOMEIDX $INDIR/$SAMPLE.1.fq.gz $INDIR/$SAMPLE.2.fq.gz > $OUTPUT/$SAMPLE.sam
 fi
 if [ ! -f $OUTPUT/$SAMPLE.RG.bam ]; then
     time java -jar $PICARD AddOrReplaceReadGroups I=$OUTPUT/$SAMPLE.sam O=$OUTPUT/$SAMPLE.RG.bam RGLB=$SAMPLE RGID=$SAMPLE RGSM=$SAMPLE RGPL=illumina RGPU=$BARCODE RGCN=UBC RGDS="$SAMPLE.1.fq $SAMPLE.2.fq" CREATE_INDEX=true SO=coordinate
 fi

time java -Xmx${MEM}g -jar $PICARD MarkDuplicates I=$OUTPUT/$SAMPLE.RG.bam O=$OUTPUT/$SAMPLE.DD.bam METRICS_FILE=$SAMPLE.dedup.metrics CREATE_INDEX=true VALIDATION_STRINGENCY=SILENT
fi

