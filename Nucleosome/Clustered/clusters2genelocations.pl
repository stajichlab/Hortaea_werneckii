#!env perl
use strict;
use warnings;

my $annot = '../../annotation/Hw2.maker_genes.functional.gff3.gz';
my $clusters = '7clustered_FPKM_compiled.tsv.gz';
open(my $fh => "zcat $annot |") || die $!;
my %genes;
while(<$fh>) {
    next if /^\#/;
    chomp;
    my @row = split(/\t/,$_);
    my %grp = map { split(/=/,$_) } split (/;/,pop @row);
    if( $row[2] eq 'gene' ) {
	$genes{$grp{'ID'}} = [ $row[0],(sort { $a<=>$b} ($row[3],$row[4])),
			       $row[6] ];
    }
}

open($fh => "zcat $clusters |") || die "cannot open $clusters: $!";
my %clusters;
while(<$fh>) {
    next if /^\#/;
    chomp;
    my ($gene,$clusterid,$altid,$desc,$rna_0,$rna_10,$rna_20) = split(/\t/,$_);
    push @{ $clusters{$clusterid} }, [$gene,$desc,$rna_0,$rna_10,$rna_20];
}

for my $cluster ( keys %clusters ) {
    open(my $ofh => ">CLUSTER$cluster.locs.dat") || die $!;
    my @cluster_set;
    for my $genecl ( @{$clusters{$cluster}} ) {
	# maybe re-sort this by chromosome?
	my ($geneid,$genedesc,$rna0,$rna10,$rna20) = @$genecl;
	push @cluster_set, [ $geneid,@{$genes{$geneid}},
			     $rna0,$rna10,$rna20,$genedesc];
    }
    print $ofh "#",join("\t", qw(GENEID CHROM START END STRAND RPKM0 RPKM10 RPKM20 GENEDESC)),"\n";
    for my $genedat ( sort { $a->[1] cmp $b->[1] || $a->[2] <=> $b->[2] }
		   @cluster_set) {
	print $ofh join("\t", @$genedat), "\n";
    }
}
