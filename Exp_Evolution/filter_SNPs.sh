
module load GATK
module load java

GENOME=/shared/stajichlab/projects/Hortaea_werneckii/assemblies/Hw2/Hw2.fasta
java -Xmx2g -jar GenomeAnalysisTK.jar \
   -R $GENOME 
   -T SelectVariants \
   --variant ALL.gatk.snp.hardfilter.vcf \
   -o ALL.gatk.snp.selected.vcf 
   --excludeFiltered
