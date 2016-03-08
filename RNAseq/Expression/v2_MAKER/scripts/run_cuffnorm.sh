#PBS -l nodes=1:ppn=8,mem=4gb -N cuffnorm.Bd -j oe 

module load cufflinks/2.2.1

CPU=$PBS_NP
if [ ! $CPU ]; then
 CPU=2
fi

N=$PBS_ARRAYID
if [ ! $N ]; then
 N=$1
fi

FILE=`ls -1 -d *.cuffquant | perl -p -e 'chomp; $_ .= "/abundances.cxb ";'`
LABEL=`ls -1 -d *.cuffquant | perl -p -e 's/\.cuffquant//; s/\s+/,/g;'`
LABEL=`echo $LABEL | perl -p -e 's/,\n/\n/'` # drop trailing ,
echo "$FILE"
echo $LABEL

GFF=Hw2.maker_genes.gff3

cuffnorm -p $CPU -o cuffnorm -L $LABEL $GFF $FILE
