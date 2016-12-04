use strict;
use warnings;
my $file = shift || 'Hw2.maker.MTedit_longID.v20160306.gff3';

open(my $fh => $file) || die $!;
while(<$fh>) {
    next if /^\#/;
    chomp;
    my $line = $_;
    my @row = split(/\t/,$line);
    if( $row[2] eq 'gene' ) {
	my $grp = pop @row;
	my %groups = map { split(/=/,$_) } split(/;/,$grp);
	if( ! exists $groups{ID}  ) {
	    warn("no group for line $line");
	    next;
	}
	if( exists $groups{Note} ) {
	    print join("\t", $groups{ID}, $groups{Note}), "\n";
	}
    }
}
