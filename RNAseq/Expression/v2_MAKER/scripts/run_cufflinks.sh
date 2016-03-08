
#PBS -l nodes=1:ppn=8,mem=4gb -N cufflinks.Bd -j oe 

module load cufflinks/2.2.1

CPU=$PBS_NP
if [ ! $CPU ]; then
 CPU=2
fi

N=$PBS_ARRAYID
if [ ! $N ]; then
 N=$1
fi


GENOME=index/batrachochytrium_dendrobatidis_1_supercontigs
GFF=batrachochytrium_dendrobatidis_1_transcripts.gtf
SAMPLE1=Bd_Sporangia_R1.tophat_out/accepted_hits.bam,Bd_Sporangia_R2.tophat_out/accepted_hits.bam,Bd_Sporangia_R3.tophat_out/accepted_hits.bam
SAMPLE2=Bd_Zoospore_R1.tophat_out/accepted_hits.bam,Bd_Zoospore_R2.tophat_out/accepted_hits.bam,Bd_Zoospore_R3.tophat_out/accepted_hits.bam

cuffquant -o cuffquant -p $CPU -u $GFF $SAMPLE1 $SAMPLE2
 
echo "work done"
