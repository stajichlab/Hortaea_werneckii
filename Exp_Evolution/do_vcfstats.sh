module load vcftools

if [ -f ALL.gatk.snp.pass.vcf ]; then
 # compress and index
bgzip ALL.gatk.snp.pass.vcf
tabix ALL.gatk.snp.pass.vcf.gz
fi
vcf-stats ALL.gatk.snp.pass.vcf.gz > ALL.gatk.snp.pass.vcfstats
