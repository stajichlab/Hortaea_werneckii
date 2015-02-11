#PBS -l nodes=1:ppn=48,mem=64gb,walltime=48:00:00 -q js -j oe -N quast.vs.best

module load QUAST
module load python
#module load mummer
module load genemarkHMM

if [ ! $PBS_NP ]; then
 PBS_NP=2
fi

quast.py --gage -R ../Hw_HGAP1_016457.fasta -f --eukaryote --threads $PBS_NP ../Hw1.fasta ../Hw_HGAP2_016438.fasta ../Hw_HGAP3_016437.fasta
