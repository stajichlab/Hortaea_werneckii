#PBS -l nodes=1:ppn=2,mem=16gb -q js -N IPR.Hw -j oe
module load iprscan
module load coils 
N=$PBS_ARRAYID
DIR=split
PREFIX=Hw2
if [ ! $N ]; then
  N=$1
fi
if [ ! $N ]; then
 echo "need a jobid by cmdline or PBS_ARRAYID"
 exit;
fi
if [ ! -f $DIR/$PREFIX.$N.IPROUT.tsv ];
then
time interproscan.sh -t p -pathways -goterms -i $DIR/$PREFIX.$N -b $DIR/$PREFIX.$N.IPROUT
fi
