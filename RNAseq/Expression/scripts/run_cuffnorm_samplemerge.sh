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

SAMPLES=/shared/stajichlab/projects/Hortaea_werneckii/RNAseq/samples

LABELS=""
CMDLINE=""
for sample in `cat $SAMPLES`
do
N=`echo $sample | perl -p -e 's/\n//g'`
#FILES=`ls -1 -d $sample*.cuffquant/abundances.cxb | perl -e 's/\s+/,/'`
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

GFF=Hw2.maker_genes.gff3



#echo "-L $LABELS $CMDLINE"
cuffnorm -p $CPU -o cuffnorm_combined -L $LABELS $GFF $CMDLINE
