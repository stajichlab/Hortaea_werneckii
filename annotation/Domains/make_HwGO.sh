
awk '{print $2,"IEA",$4}' Hw2.all.maker.proteins.functional_remake.IPR.tsv.InterPro.association | perl -p -e 's/ /\t/g' > Hw2.GO.tab
