
#PBS -l nodes=1:ppn=8,mem=4gb -N cuffquant.Hw -j oe 

module load cufflinks/2.2.1

DIR=/shared/stajichlab/projects/Hortaea_werneckii/RNAseq/aln/merged
CPU=$PBS_NP
if [ ! $CPU ]; then
 CPU=2
fi

N=$PBS_ARRAYID
if [ ! $N ]; then
 N=$1
fi

SAMPLES=/shared/stajichlab/projects/Hortaea_werneckii/RNAseq/samples
SAMPLE=`head -n $N $SAMPLES | tail -n 1`
GFF=Hw2.maker_genes.gff3

if [ ! -d $SAMPLE.cuffquant ]; then
 cuffquant -o $SAMPLE.cuffquant -p $CPU -u $GFF $DIR/$SAMPLE.bam
fi 

