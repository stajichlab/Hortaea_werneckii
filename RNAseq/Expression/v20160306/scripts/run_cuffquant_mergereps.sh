
#PBS -l nodes=1:ppn=8,mem=4gb -N cuffquant.Hw -j oe 

module load cufflinks/2.2.1

BASE=/bigdata/stajichlab/shared/projects/Hortaea/Hortaea_werneckii
ALN=$BASE/RNAseq/aln/v20160306
GENOMEDIR=$BASE/assemblies/Hw2/bowtie_index
GENOME=Hw2
GFF=$BASE/annotation/Hw2.maker.MTedit_simple.v20160306.gff3
CPU=$PBS_NP
if [ ! $CPU ]; then
 CPU=2
fi

N=$PBS_ARRAYID
if [ ! $N ]; then
 N=$1
fi

SAMPLES=$BASE/RNAseq/samples
SAMPLE=`sed -n ${N}p $SAMPLES`

if [ ! -d $SAMPLE.cuffquant ]; then
 cuffquant -o $SAMPLE.cuffquant -p $CPU -u $GFF $ALN/$SAMPLE.bam
fi 

