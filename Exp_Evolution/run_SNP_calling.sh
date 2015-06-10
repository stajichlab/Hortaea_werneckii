#PBS -q js -l nodes=1:ppn=16 -q highmem -N GATK -j oe -o GATK.log
module load java/1.8.0_25
module load samtools/1.1
module load GATK/3.3.0
module load picard

# in the config above we requested 16 procicessors on one node - (nodes=1:ppn=16) 

umask 0002 # let's make sure the umask is setup write so default permissions are easier for jason to see

GENOME=/shared/stajichlab/projects/Hortaea_werneckii/assemblies/Hw2/Hw2.fasta

if [ ! -f $GENOME.dict ]; then
java -jar $PICARD/CreateSequenceDictionary.jar \
R=$GENOME OUTPUT=$GENOME.dict

# This is probably unncessary but I can't remember if GATK likes genome/file.fa.dict or genome/file.dict
# so I am making both
b=`basename $GENOME .fa`
dir=`dirname $GENOME`
java -jar $PICARD/CreateSequenceDictionary.jar \
R=$GENOME OUTPUT=$dir/$b.dict

fi

# run the genotyper
java -Xmx3g -jar $GATK -T UnifiedGenotyper \
  -glm SNP -I All.combined.bam -R $GENOME \
  -o all_strains.GATK.vcf -nt $PBS_NP

# filter the VCF
java -Xmx3g -jar $GATK \
-T VariantFiltration -o all_strains.GATK.filtered.vcf \
--variant all_strains.GATK.vcf -R $GENOME \
--clusterWindowSize 10  -filter "QD<8.0" -filterName QualByDepth \
-filter "MQ<=30.0" -filterName MapQual \
-filter "QUAL<100" -filterName QScore \
-filter "MQ0>=10 && ((MQ0 / (1.0 * DP)) > 0.1)" -filterName MapQualRatio \
-filter "FS>60.0" -filterName FisherStrandBias \
-filter "HaplotypeScore > 13.0" -filterName HaplotypeScore >& output.filter.log
