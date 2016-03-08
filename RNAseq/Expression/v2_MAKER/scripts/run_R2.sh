#PBS -l nodes=1:ppn=1,mem=8gb -j oe
R --no-save < edgeR_analysis_combo.R
