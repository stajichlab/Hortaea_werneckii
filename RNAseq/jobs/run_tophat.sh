#PBS -l nodes=1:ppn=8 -q js -j oe -N tophat -o tophat
module load tophat
module load bowtie2
BASE=/bigdata/stajichlab/shared/projects/Hortaea
GENOMEDIR=$BASE/Hortaea_werneckii/assemblies/Hw2/bowtie_index
GENOME=Hw2
GFF=$BASE/Hortaea_werneckii/annotation/Hw2.maker.MTedit_simple.v20160306.gff3
SEQDIR=$BASE/raw_data/RNASeq
OUTDIR=aln/v20160306
CPU=1
if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi
echo $PBS_PPN
LISTFILE=$SEQDIR/trimlist

if [ ! -f $LISTFILE ]; then
 pushd $SEQDIR
 ls *_1.fq > $LISTFILE
 popd
fi

JOB=$PBS_ARRAYID
if [ ! $JOB ]; then
 # take from CMDLINE
 JOB=$1
fi

if [ ! $JOB ]; then
 echo "need to provide a job ID on cmdline or via -t option in qsub"
 exit
fi

PAIR1=`head -n $JOB $LISTFILE | tail -n 1`
PAIR2=`echo $PAIR1 | perl -p -e 's/_1.fq/_2.fq/'`

TYPE=`echo $PAIR1 | perl -p -e 's/\S+_(L\d+)_\S+/$1/'`
SAMPLE=`echo $PAIR1 | perl -p -e 's/(\S+)_L\d+_\S+/$1/'`

echo "TYPE is $TYPE SAMPLE is $SAMPLE"
if [ ! -f $OUTDIR/${SAMPLE}_${TYPE}/accepted_hits.bam ]; then
 tophat -o $OUTDIR/${SAMPLE}_${TYPE} -i 20 -I 1500 -G $GFF -p $CPU --library-type fr-firststrand $GENOMEDIR/$GENOME $SEQDIR/$PAIR1.gz $SEQDIR/$PAIR2.gz 
fi
