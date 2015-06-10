#!env perl
use strict;
use warnings;
my $fpkm = shift || "cuffnorm/genes.fpkm_table";
my $functional_fasta = shift || 'Hw2.pep';

open(my $fh => $functional_fasta) || die "Cannot open $functional_fasta: $!";
my %gene;
while(<$fh>) {
    next unless /^>/;
    if( /^>(\S+)\s+.+Name:\"(.+)\"\s+AED:/) {
	my ($name,$function) = ($1,$2);
	my ($gene) = split/-/,$name;
	$gene{$gene} = $function;
	
	warn("name='$name' gene=$gene, function=$function\n");
    } else {
	warn("Cannot match function in $_");
    }
}

open($fh => $fpkm) || die $!;
my $i =0;
while(<$fh>) {
    my ($id,@row) = split;
    if( $i++ == 0 ) {
	print join("\t",$id,qw(FUNCTION),@row),"\n";
    } else {
	print join("\t",$id,$gene{$id} || '',@row),"\n";
    }
}
