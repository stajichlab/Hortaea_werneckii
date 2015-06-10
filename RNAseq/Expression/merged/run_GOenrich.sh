#PBS -l nodes=1:ppn=1,mem=8gb
R --no-save < GO_enrich.R
