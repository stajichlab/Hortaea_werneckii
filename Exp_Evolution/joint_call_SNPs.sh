#PBS -q js -l nodes=1:ppn=2,mem=64gb -q js -N GATK.GVCFGeno -j oe -o GATK.GVCFGeno.log

module load java
module load GATK/3.3.0
module load picard
GENOME=/shared/stajichlab/projects/Hortaea_werneckii/assemblies/Hw2/Hw2.fasta
b=`basename $GENOME .fa`
dir=`dirname $GENOME`

N=`ls *.GVCF | perl -p -e 's/\n/ /; s/(\S+)/-V $1/'`
echo $N

java -Xmx64g -jar $GATK -T GenotypeGVCFs -R $GENOME $N -o Hw.all.vcf

