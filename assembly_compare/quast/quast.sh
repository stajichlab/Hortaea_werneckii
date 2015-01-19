#PBS -l nodes=1:ppn=48,mem=64gb,walltime=48:00:00 -q js -j oe -N quast

module load QUAST
module load python
#module load mummer
module load genemarkHMM

if [ ! $PBS_NP ]; then
 PBS_NP=2
fi

quast.py --gage -R ../Hw1.fasta -f --eukaryote --threads $PBS_NP ../Hw_*.fasta
