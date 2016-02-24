my $gff = shift;
# print out just gene regions but flip strand on rev
open(my $in => $gff) || die $!;
while(<$in>) {
    chomp;
    my @row = split(/\t/,$_);
    my ($chr,$src,$type,$start,$end,$score,$strand,$phase,$group) = @row;
    my ($name) = ($group=~ /ID=([^;]+);/);
    print join("\t", $chr,$start,$end,$name,0,$strand),"\n";
}
