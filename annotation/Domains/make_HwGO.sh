
awk '{print $4,"IEA",$2}' Hw2.all.maker.proteins.functional_remake.IPR.tsv.InterPro.association | perl -p -e 's/ /\t/g' > Hw2.GO.tab
