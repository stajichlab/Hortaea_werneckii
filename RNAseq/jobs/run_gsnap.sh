#PBS -l nodes=1:ppn=2 -q js -j oe -N gmap
module load gmap/2015.09.10
GENOMEDIR=/bigdata/stajichlab/shared/projects/Hortaea/Hortaea_werneckii/assemblies/Hw2/gsnap_index
GENOME=Hw2
SEQDIR=/bigdata/stajichlab/shared/projects/Hortaea/raw_data/RNASeq
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
#if [ ! -f $OUTDIR/${SAMPLE}_${TYPE}.sam ]; then
 gsnap --failed-input=${SAMPLE}_${TYPE}.fails -t $CPU  --use-shared-memory=0 --gunzip --read-group-id=$SAMPLE  --read-group-library=$TYPE --read-group-name=$SAMPLE"_"$TYPE -N 1 --use-splicing=$GENOMEDIR/Hw2.v20160306.introns.iit --gmap-mode=pairsearch,indel_knownsplice -D $GENOMEDIR -d $GENOME --pairmax-rna=2000 --format=sam  $SEQDIR/$PAIR1.gz $SEQDIR/$PAIR2.gz > $OUTDIR/${SAMPLE}_${TYPE}.sam
#fi
