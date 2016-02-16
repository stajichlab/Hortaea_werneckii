use strict;
use warnings;

my $normalize_factor = shift;

while(<>) {
    my ($ctg,$start,$end,$value) = split;
    print join("\t", $ctg,$start,$end,
	       sprintf("%.6f",$value / $normalize_factor)),"\n";
}

