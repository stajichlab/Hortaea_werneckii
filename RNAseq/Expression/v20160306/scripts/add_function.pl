#!env perl
use strict;
use warnings;
use Getopt::Long;

my $debug = 0;

GetOptions('v|debug!'  => \$debug);
my $fpkm = shift || "cuffnorm/genes.fpkm_table";
my $functional= shift || '../../../annotation/Hw2.maker.MTedit_longID.v20160306.desc';

open(my $fh => $functional) || die "Cannot open $functional$!";
my %gene;
while(<$fh>) {
	chomp;
	my ($id,$function) = split(/\t/,$_);
	$gene{$id} = $function;
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
