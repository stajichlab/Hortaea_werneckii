#PBS -l nodes=1:ppn=4 -q js -j oe -N gmap
module load gmap

GENOMEDIR=/shared/stajichlab/projects/Hortaea_werneckii/assemblies/Hw2/gsnap_index
GENOME=Hw2

CPU=1
if [ $PBS_PPN ]; then
 CPU=$PBS_PPN;
fi

LISTFILE=trimlist

if [ ! -f $LISTFILE ]; then
 ls *_1.fq > $LISTFILE
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

gsnap -t $CPU --read-group-id=$SAMPLE  --read-group-library=$TYPE --read-group-name=$SAMPLE"_"$TYPE -N 1 --use-splicing=Hw2.maker_introns.iit --gmap-mode=pairsearch,indel_knownsplice -D $GENOMEDIR -d $GENOME --pairmax-rna=2000 --format=sam  $PAIR1 $PAIR2 > $SAMPLE"_"$TYPE.sam
