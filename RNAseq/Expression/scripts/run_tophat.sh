#PBS -l nodes=1:ppn=4 -N tophat -j oe 
#PBS -l mem=4g -q batch

module load tophat

GENOME=/shared/stajichlab/projects/Hortaea_werneckii/assemblies/Hw2/Hw2
GFF=Hw2.maker_genes.gff3
SAMPLEFILE=/shared/stajichlab/projects/Hortaea_werneckii/RNAseq/samples
DIR=/shared/stajichlab/projects/Hortaea_werneckii/RNAseq/reads
CPU=$PBS_NP

if [ ! $CPU ]; then 
 CPU=2
fi

N=$PBS_ARRAYID

if [ ! $N ]; then
 N=$1
fi

if [ ! $N ]; then
 echo "Need a number either with qsub -t N or run_tophat N"
 exit
fi

FILE=`ls $DIR | grep _1\.fq\.gz | head -n $N | tail -n 1`
R1=$DIR/$FILE
R2=`echo $R1 | perl -p -e 's/_1\.fq/_2.fq/'`

SAMPLE=`echo $R1 | perl -p -e 's/(Sample_\d+\.\d+).+/$1/'`
echo "tophat  --b2-very-sensitive -G $GFF -p $CPU --rg-id $ID --rg-sample $SAMPLE --rg-center UCR --rg-platform ILLUMINA -o $SAMPLE.tophat_out $GENOME $R1 $R2"

tophat  --b2-very-sensitive -G $GFF -p $CPU --rg-id $ID --rg-sample $SAMPLE --rg-center UCR \
 --rg-platform ILLUMINA -o $SAMPLE.tophat_out $GENOME $R1 $R2

echo "Done"
