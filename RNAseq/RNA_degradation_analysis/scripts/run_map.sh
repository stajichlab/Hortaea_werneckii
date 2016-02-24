#PBS -l nodes=1:ppn=2 -j oe -N multiMap -l walltime=48:00:00 -l mem=4gb
R --save < compute_5prime_3prime_coverage_prod.R
