use strict;
use warnings;
use Getopt::Long;

my $normalize = 'normalize_factor.tab';
my $multicov = "Hw2.maker_genes_only.5windows.multicov";

GetOptions('n|normalize:s' => \$normalize,
	   'm|multi|cov:s' => \$multicov);

open(my $in => $normalize) || die "$normalize: $!";
my %normalizeFactor;
while(<$in>) {
    my ($sample,$normfactor) = split;
    $normalizeFactor{$sample} = $normfactor;
}
open($in => $multicov) || die $!;
my $header = <$in>;
chomp($header);
my ($hchr,$hstart,$hend,$hwindow,$hscore,$hstrand,@labels) = split(/\t/,$header);
#my ($hchr,$hstart,$hend,$hwindow,@labels) = split(/\t/,$header);
my %genes;
while(<$in>) {
    my ($chr,$start,$end,$window,$score,$strand,@obs) = split;
    my ($gene,$wn);
    my $len = abs($end - $start);
    if( $window =~ /(\S+)_(\d+)$/) {
	($gene,$wn) = ($1,$2);
    } else {
	# do we do this by order, or just die for now
	die "expecting a formatted window which looks like GENE_N where N is the window number"
    }
    $wn -= 1; # since the numbers are 1..5 not 0..4
    # this could be solved also by pushing onto an array and then later we take 1st and last
    my $i = 0;
    
    for my $lbl ( @labels ) {
	# normalizing the counts by the number in the normalizeFactor, we figure out which factor to use
	# based on which column this is, walking through the labels column as the name
	# need a second counter to keep track of this numerically in the observered data array
	# so using ($i) 	
	push @{$genes{$gene}->[$wn]}, sprintf("%.8f",1000 * $obs[$i++] / $len / $normalizeFactor{$lbl});
    }	
#    $genes{$gene}->[$wn] = [@obs];
}

# still will need to normalize readcount
print join("\t", qw(GENE TREATMENT SAMPLE COUNT5PRIME COUNT3PRIME)), "\n";
for my $gene ( sort keys %genes ) {
    my $windows = $genes{$gene};
    # take 1st and last
    my $treat = 0;
    for my $sample ( @labels ) {
	my ($factor) = split(/_/,$sample);
	print join("\t", $gene, $factor, $sample, 
		   $windows->[0]->[$treat], # this is the 1st gene window value for this treatment
		   $windows->[-1]->[$treat], # this is the last gene window value for this treatment
	    ), "\n";
	$treat++;
    }
}
