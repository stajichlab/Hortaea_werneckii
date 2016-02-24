#PBS -l nodes=1:ppn=16 -q js -j oe -N sambamba
module load sambamba
numThreads=16
readFraction=0.01
seed==121
for file in bam/*.bam
do
 name=`basename $file`
 sambamba view -t $numThreads -s $readFraction -f bam --subsampling-seed=$seed $file  -o bam3/$name
done
