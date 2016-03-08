
#PBS -l nodes=1:ppn=8,mem=4gb -N cuffquant.Hw -j oe 

module load cufflinks/2.2.1

DIR=/shared/stajichlab/projects/Hortaea_werneckii/RNAseq/aln
CPU=$PBS_NP
if [ ! $CPU ]; then
 CPU=2
fi

N=$PBS_ARRAYID
if [ ! $N ]; then
 N=$1
fi

FILE=`ls -1 $DIR/*.bam | head -n $N | tail -n 1`
GFF=Hw2.maker_genes.gff3
SAMPLE=`basename $FILE .bam`

if [ ! -d $SAMPLE.cuffquant ]; then
 cuffquant -o $SAMPLE.cuffquant -p $CPU -u $GFF $FILE
fi 
echo "work done"
