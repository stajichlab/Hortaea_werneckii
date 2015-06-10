#PBS -l nodes=1:ppn=2 -q js -j oe -N merge
module load samtools/1.1
JOB=$PBS_ARRAYID
if [ ! $JOB ]; then
 # take from CMDLINE
 JOB=$1
fi

if [ ! $JOB ]; then
 echo "need to provide a job ID on cmdline or via -t option in qsub"
 exit
fi

SAMPLE=`ls *.list | head -n $JOB | tail -n 1`
BASE=`basename $SAMPLE .list`
if [ ! -f $BASE.bam ]; then
 samtools merge -h $BASE"_L001.bam" -b $SAMPLE $BASE.bam
fi
