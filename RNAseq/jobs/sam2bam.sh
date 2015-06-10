#PBS -l nodes=1:ppn=4,mem=16gb -q js  -j oe -N sam2bam.HwRNASeq
#PBS -d /shared/stajichlab/projects/Hortaea_werneckii/RNAseq/aln
module load samtools/1.1
module load java
module load picard

LISTFILE=list

if [ ! -f $LISTFILE ]; then
 ls *.sam > $LISTFILE
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

IN=`head -n $JOB $LISTFILE | tail -n 1`
PREF=`basename $IN .sam`

if [ ! -f $PREF.unsrt.bam ]; then
#time java -jar $PICARD/SortSam.jar I=$IN O=$PREF.bam SO=coordinate
time samtools view -bS $IN > $PREF.unsrt.bam 
fi
if [ ! -f $PREF.bam ]; then
time samtools sort -@4 -m4G  $PREF.unsrt.bam $PREF
fi
