#PBS -l nodes=1:ppn=1,mem=16gb -q js -j oe -N realign
module load java
module load GATK

N=$PBS_ARRAYID
if [ ! $N ]; then
 N=$1
fi

if [ ! $N ]; then 
 echo  "need arrayid or cmdline integer"
 exit
fi

temp=/tmp
dir=bam
bam=`head -n $N bamfiles | tail -n 1`
prefix=`basename $bam`
GENOME=/shared/stajichlab/projects/Hortaea_werneckii/assemblies/Hw2/Hw2.fasta
## Identify intervals around variants
if [ ! -e $dir/$prefix.realign.bam ]; then
java -Xmx16g -Djava.io.tmpdir=$temp -jar $GATK \
       -T RealignerTargetCreator \
       -R $GENOME \
       -o $dir/$prefix.gatk.intervals \
       -I $dir/$bam

## Realign based on these intervals
java -Xmx16g -Djava.io.tmpdir=$temp -jar $GATK \
       -T IndelRealigner \
       -R $GENOME \
       -targetIntervals $dir/$prefix.gatk.intervals \
       -I $dir/$bam \
       -o $dir/$prefix.realign.bam
fi
