#PBS -l mem=32gb,nodes=1:ppn=2,walltime=64:00:00 -j oe
module load bedtools
bedtools coverage -counts -sorted -a Hw2.maker_genes_only.5windows_stranded_sorted.bed -b ../coverage/*.bg > Hw2.maker_genes_only.5windows.coverage
