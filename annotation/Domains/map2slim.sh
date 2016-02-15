module load OWLTools

owltools /srv/projects/db/GO/current/go.obo --gaf Hw2.IPR.association.gaf --map2slim \
 --subset goslim_pombe --write-gaf Hw2.pombemap.gaf

owltools /srv/projects/db/GO/current/go.obo --gaf Hw2.IPR.association.gaf --map2slim \
 --subset goslim_yeast --write-gaf Hw2.yeastmap.gaf

owltools /srv/projects/db/GO/current/go.obo --gaf Hw2.IPR.association.gaf --map2slim \
 --subset goslim_aspergillus --write-gaf Hw2.aspergillusmap.gaf
