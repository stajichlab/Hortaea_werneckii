#PBS -l nodes=1:ppn=2 -q js -j oe -N merge
module load samtools
TARGETDIR=aln/v20160306
JOB=$PBS_ARRAYID
if [ ! $JOB ]; then
 # take from CMDLINE
 JOB=$1
fi

if [ ! $JOB ]; then
 echo "need to provide a job ID on cmdline or via -t option in qsub"
 exit
fi
cd $TARGETDIR
SAMPLE=`ls *.list | sed -n ${JOB}p`
BASE=`basename $SAMPLE .list`
if [ ! -f $BASE.bam ]; then
 samtools merge -h ${BASE}_L001/accepted_hits.bam -b $SAMPLE $BASE.bam
fi
