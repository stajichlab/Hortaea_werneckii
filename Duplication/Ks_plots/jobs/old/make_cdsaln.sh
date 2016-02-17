#PBS -l nodes=1:ppn=1,mem=2gb,walltime=48:00:00 -j  oe 

GENOMELIST=FILES
if [ ! -f $GENOMELIST ]; then
 ls *.pep > $GENOMELIST
fi

for base in `cat $GENOMELIST`;
do
 b=`basename $base .pep`
 if [ ! -f $b.cds.fasaln -o ]; then
  perl /bigdata/stajichlab/shared/projects/1KFG/analysis/Paralog/jobs/bp_mrtrans.pl -if fasta -of fasta -i $base.fasaln -o $b.cds.fasaln -s $b.cds
 fi
done
