#PBS -l nodes=1:ppn=8,mem=4gb -N cuffnorm.Hw2 -j oe 

module load cufflinks/2.2.1

CPU=$PBS_NP
if [ ! $CPU ]; then
 CPU=2
fi

N=$PBS_ARRAYID
if [ ! $N ]; then
 N=$1
fi

BASE=/bigdata/stajichlab/shared/projects/Hortaea/Hortaea_werneckii
ALN=$BASE/RNAseq/aln/v20160306
GENOMEDIR=$BASE/assemblies/Hw2/bowtie_index
GENOME=Hw2
GFF=$BASE/annotation/Hw2.maker.MTedit_simple.v20160306.gff3
CPU=$PBS_NP

SAMPLES=$BASE/RNAseq/samples

LABELS=""
CMDLINE=""
for sample in `cat $SAMPLES`
do
N=`echo $sample | perl -p -e 's/\n//g'`
n=`ls -d $sample*.cuffquant/*.cxb`
FILES=`echo $n | perl -p -e 's/ /,/g'`
#echo $n
#echo $FILES

if [ "$LABELS" = "" ]; then
 LABELS=$sample
 CMDLINE=$FILES
else
 LABELS="$LABELS,$sample"
 CMDLINE="$CMDLINE $FILES"
fi

done

#echo "-L $LABELS $CMDLINE"
cuffnorm -p $CPU -o cuffnorm_combined -L $LABELS $GFF $CMDLINE
