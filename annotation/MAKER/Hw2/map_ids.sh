#PBS -j oe
module load stajichlab
module load stajichlab-perl
module load perl
module load maker/2.31.6

map_fasta_ids Hw2.mapids Hw2.all.maker.proteins.fasta
map_fasta_ids Hw2.mapids Hw2.all.maker.transcripts.fasta
map_gff_ids Hw2.mapids Hw2.all.gff 
