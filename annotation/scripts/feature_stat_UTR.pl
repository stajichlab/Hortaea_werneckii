use strict;
use warnings;
use List::Util qw(sum);
use Statistics::Descriptive;

my $gff = 'Hw2.maker_genes.functional.gff3.gz';
open(my $fh => "zcat $gff |") || die $!;

my %features;
while(<$fh>) {
    last if /^\#\#FASTA/;
    next if /^\#/;
    chomp;
    my $line = $_;
    my @row = split(/\t/,$_);
    next unless $row[1] eq 'maker';
    my %grp = map { split(/=/,$_ ) } split(/;/,pop @row);
    my ($id) = exists $grp{Parent} ? $grp{Parent} : $grp{ID};
    if( ! defined $id) {
	warn("no $id for $line\n");
	next;
    }
    if( $row[2] eq 'gene' ) {
	$features{gene}->{$id}++;
    } elsif ( $row[2] =~ /UTR/ ) {
	$features{$row[2]}->{$id} += abs($row[4]-$row[3]);
    }
}

for my $ftype (sort  keys %features ) {
    my $total = scalar keys %{$features{$ftype}};
    printf "%s\t%d features\n",$ftype,$total;
    if( $ftype !~ /gene/ ) {
	printf "\t%d total bp\n",sum ( values %{$features{$ftype}} );
	my $stats = Statistics::Descriptive::Full->new();
	$stats->add_data([ values %{$features{$ftype}}]);
	printf "\t%.2f median len\t%.2f mean len\n",$stats->median, $stats->mean;
    }
    print "//\n";
}
