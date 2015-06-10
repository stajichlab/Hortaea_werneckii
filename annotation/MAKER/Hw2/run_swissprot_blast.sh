#PBS -l nodes=1:ppn=24 -q js -N spblast -j oe
module load ncbi-blast
blastp -query Hw2.all.maker.proteins.fasta -db /shared/stajichlab/db/uniprot/uniprot_sprot.fasta -use_sw_tback \
-num_threads 24 -outfmt 6  -evalue 1e-3 -out Hw2.all.maker.swissprot.BLASTP -max_target_seqs 5
