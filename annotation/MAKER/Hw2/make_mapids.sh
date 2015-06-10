#PBS -j oe
module load stajichlab
module load stajichlab-perl
module load perl
module load maker/2.31.8

maker_map_ids  --prefix HWER_ --iterate 0 --justify 5 Hw2.all.gff > Hw2.mapids
