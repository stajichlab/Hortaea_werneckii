cd Hw2
BASE=Hw2
if [ ! -f $BASE.fasta ];
then
 zcat $BASE.fasta.gz > $BASE.fasta
fi

if [ ! -f $BASE.fasta.amb ];
then
 bwa index $BASE.fasta
fi
