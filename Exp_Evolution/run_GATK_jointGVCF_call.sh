#PBS -q js -l nodes=1:ppn=32,mem=128gb -q js -N GATK.GVCFGeno -j oe -o GATK.GVCFGeno.log
MEM=64
CPU=1
if [ $PBS_NUM_PPN ]; then
 CPU=$PBS_NUM_PPN
fi

module load java
module load gatk/3.4-46
module load picard
GENOME=../assemblies/Hw2/Hw2.fasta
INDIR=Variants/gvcf
OUT=Variants/Hw.unfilt.vcf
b=`basename $GENOME .fasta`
dir=`dirname $GENOME`

N=`ls $INDIR/*.g.vcf | perl -p -e 's/\n/ /; s/(\S+)/-V $1/'`
echo $N

java -Xmx${MEM}g -jar $GATK -T GenotypeGVCFs -R $GENOME $N -o $OUT -nt $CPU

