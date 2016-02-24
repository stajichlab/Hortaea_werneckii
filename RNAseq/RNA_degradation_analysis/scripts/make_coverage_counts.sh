#PBS -l mem=16gb,nodes=1:ppn=1,walltime=64:00:00 -j oe
module load bedtools
#bedtools coverage -counts -sorted -a Hw2.maker_genes_only.5windows_stranded_sorted.bed -b ../coverage/*.bg >> Hw2.maker_genes_only.5windows.coverage
for file in ../coverage/*.bg
do
 name=`basename $file .bg`
 bedtools coverage -counts -sorted -a Hw2.maker_genes_only.5windows_stranded_sorted.bed -b $file > Hw2.maker_genes_only.5windows.$name.coverage
done
