#PBS -l nodes=1:ppn=1,mem=1gb,walltime=2:00:00 -j oe -N sickle
module load sickle
SAMPLEFILE=samples.info
QUAL=20

LINE=$PBS_ARRAYID

if [ ! $LINE ]; then
 LINE=$1
fi

if [ ! $LINE ]; then 
 echo "Need a number via PBS_ARRAYID or cmdline"
 exit
fi

ROW=`head -n $LINE $SAMPLEFILE | tail -n 1`
SAMPLE=`echo "$ROW" | awk '{print $1}'`
READ1=`echo "$ROW" | awk '{print $2}'`
READ2=`echo "$ROW" | awk '{print $3}'`

echo "SAMPLE=$SAMPLE"
echo "R1=$READ1 R2=$READ2"
#DIR=`dirname $READ1`
DIR=Sample

sickle pe -f $DIR/$READ1 -r $DIR/$READ2 -o $DIR/$SAMPLE.1.fq -p $DIR/$SAMPLE.2.fq -s $DIR/$SAMPLE.single.fq -t sanger -l 50 -q 20
