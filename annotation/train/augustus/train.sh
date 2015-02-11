#PBS -l nodes=1:ppn=1 -j oe -n augTrain
module load stajichlab
module load augustus/2.7

autoAugTrain.pl --CRF --trainingset=Hw.CEGMA.gbk --species=Hortaea_werneckii_CEGMA_CRF --optrounds=2
