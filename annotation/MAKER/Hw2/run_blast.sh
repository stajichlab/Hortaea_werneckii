#PBS -l nodes=1:ppn=16,mem=32gb -q js -j oe -N BLASTP.sprot
module load ncbi-blast
blastp -db ../uniprot_sprot.fasta -out JEL142.maker-vs-uniprot.BLASTP.tab -outfmt 6 -query JEL142.scf.all.maker.proteins.fasta -evalue 1e-5 -max_target_seqs 3 -num_threads $PBS_NP -use_sw_tback -seg yes -soft_masking true
