use strict;
use warnings;

use Getopt::Long;

my $bedgenes = 'Hw2.maker_genes_only.bed';
my $bedwindows = 'Hw2.maker_genes_only.5windows.bed';

GetOptions("g|gene|genes:s" => \$bedgenes,
	   'w|window|windows:s' => \$bedwindows,
    );

open(my $in => $bedgenes) || die $!;
my %genes;
while(<$in>) {
    my ($chr,$start,$end,$name,$score,$strand) = split;
    $genes{$name} = $strand;
}

open($in => $bedwindows) || die $!;
my %windows;
while(<$in>) {
    my ($chr,$start,$end,$w) = split;
    my $gene;
    if( $w =~ /(\S+)_(\d+)$/ ) {
	$gene = $1;
    } else {
	$gene= $w;
#	die"expected window num at end of gene name";
    }
    push @{$windows{$chr}->{$gene}}, [$start,$end];
}
for my $chr ( sort keys %windows ) {
    for my $gene ( sort keys %{$windows{$chr}} ) {
	my @windows = @{$windows{$chr}->{$gene}};
	if ( $genes{$gene} eq '-' ) {
	    @windows = reverse @windows; # flip the order if 
	}
	my $i = 1;
	for my $window ( @windows ) {
	    print join("\t", $chr, @$window, sprintf("%s_%d",$gene,$i++),'.',$genes{$gene}),"\n";
	}
    }
}
