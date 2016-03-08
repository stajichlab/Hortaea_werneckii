use strict;
use warnings;
my %uniq;
while(<>) {
    chomp;
    my @row = split(/\t/,$_);
    my $gene = $row[1];
    $gene =~ s/-R\d+$//;
    $uniq{$gene}->{$row[4]}++;
}
for my $g ( sort keys %uniq ) {
    for my $v ( sort keys %{$uniq{$g}} ) {
	print join("\t",$g,'IEA',$v),"\n";
    }
}
