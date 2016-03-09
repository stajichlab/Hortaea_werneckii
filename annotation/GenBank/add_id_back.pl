use warnings;
use strict;
my %ct;
while(<>) {
    if ( /^\#/ ) {
	print;
	next;
    }
    chomp;
    my @row = split(/\t/,$_);
    if( ! defined $row[2] ) { warn("no value for $_"); next }
    my @col9 = map { [ split(/=/,$_)] } split(/;/,pop @row);
    my %groups = map { @$_ } @col9;
    if( ! exists $groups{'ID'} ) {
	unshift @col9, [ 'ID', sprintf("%s%d",$row[2],++$ct{$row[2]})];
    }
    print join("\t", @row,join(";",map {join("=",@$_)} @col9)),"\n";
}
