
#PBS -l nodes=1:ppn=8,mem=4gb -N cuffquant.Hw -j oe 

module load cufflinks/2.2.1

DIR=/bigdata/stajichlab/shared/projects/Hortaea/Hortaea_werneckii/RNAseq/aln/v20160306
BASE=/bigdata/stajichlab/shared/projects/Hortaea
GENOMEDIR=$BASE/Hortaea_werneckii/assemblies/Hw2/bowtie_index
GENOME=Hw2
GFF=$BASE/Hortaea_werneckii/annotation/Hw2.maker.MTedit_simple.v20160306.gff3
CPU=$PBS_NP
if [ ! $CPU ]; then
 CPU=2
fi

N=$PBS_ARRAYID
if [ ! $N ]; then
 N=$1
fi

FILE=`ls -1 $DIR/*.bam | head -n $N | tail -n 1`
SAMPLE=`basename $FILE .bam`

if [ ! -d $SAMPLE.cuffquant ]; then
cuffquant -o $SAMPLE.cuffquant -p $CPU -u $GFF $FILE
fi 
echo "work done"
