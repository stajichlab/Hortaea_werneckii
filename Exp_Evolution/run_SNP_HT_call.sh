#PBS -q js -l nodes=1:ppn=32,mem=96gb -q js -N GATK -j oe -o GATK.log

module load java
module load GATK/3.3.0
module load picard
GENOME=/shared/stajichlab/projects/Hortaea_werneckii/assemblies/Hw2/Hw2.fasta
b=`basename $GENOME .fa`
dir=`dirname $GENOME`

if [ ! -f $dir/$b.dict ]; then
 java -jar $PICARD/CreateSequenceDictionary.jar \
 R=$GENOME OUTPUT=$dir/$b.dict
fi

if [ ! $PBS_ARRAYID ]; then
 PBS_ARRAYID=1;
fi

N=`ls bam/*.realign.bam |head -n $PBS_ARRAYID | tail -n 1`
O=`basename $N .realign.bam`

if [ ! -f $O.GVCF ]; then
java -Djava.io.tmpdir=/tmp -Xmx64g -jar $GATK -T HaplotypeCaller \
  -ERC GVCF -variant_index_type LINEAR -variant_index_parameter 128000 \
  -I $N -R $GENOME \
  -o $O.GVCF -nct $PBS_NP
fi
