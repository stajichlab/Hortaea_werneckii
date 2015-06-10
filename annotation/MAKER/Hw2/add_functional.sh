#PBS -j oe -N addfunctional -l walltime=12:00:00 -l nodes=1:ppn=1
module load stajichlab
module load stajichlab-perl
module load perl
module load maker/2.31.6
DB=/shared/stajichlab/db/uniprot/uniprot_sprot.fasta
BLASTFILE=Hw2.all.maker.swissprot.BLASTP
BASE=Hw2.all

maker_functional_fasta $DB $BLASTFILE $BASE.maker.transcripts.fasta > $BASE.maker.transcripts.functional.fasta
maker_functional_fasta $DB $BLASTFILE $BASE.maker.proteins.fasta > $BASE.maker.proteins.functional.fasta

maker_functional_gff $DB $BLASTFILE $BASE.gff > $BASE.functional.gff
