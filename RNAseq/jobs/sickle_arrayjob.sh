#PBS -l nodes=1:ppn=1 -N sickle -j oe
module load sickle

LISTFILE=list

if [ ! -f $LISTFILE ]; then
 ls */*_R1_001.fastq.gz > $LISTFILE
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
PAIR2=`echo $PAIR1 | perl -p -e 's/_R1/_R2/'`

TYPE=`echo $PAIR1 | perl -p -e 's/\S+_(L\d+)_\S+/$1/'`

echo "TYPE is $TYPE"

SAMPLE=`dirname $PAIR1`_$TYPE

echo "$PAIR1 $PAIR2 -> $SAMPLE"

sickle pe -f $PAIR1 -r $PAIR2 -t sanger -o $SAMPLE"_1.fq" -p $SAMPLE"_2.fq" -s $SAMPLE"_single.fq" -l 50
