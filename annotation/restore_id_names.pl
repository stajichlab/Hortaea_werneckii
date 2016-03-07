use strict;
use warnings;

my %ids;

while(<>) {
 next if /^\#/;
 chomp;
 my @row = split(/\t/,$_);
 my @lastcol = split(/;/,pop @row);
 my @order = map { (split(/=/,$_))[0] } @lastcol;
 my %groups = map { split(/=/,$_) } @lastcol;
 if( exists $groups{Name} && exists $groups{ID} ) {
   $ids{$groups{ID}} = $groups{Name};
 }
 for my $replace ( qw(ID Parent) ) {
   if( exists $groups{$replace} && exists $ids{$groups{$replace}} ) {
	$groups{$replace} = $ids{$groups{$replace}};
   } else {
	# warn("unknown $replace for ",$groups{ID},"\n");
   }
 }
 print join("\t", @row, join(";",map { join("=",$_, $groups{$_}) } @order)),"\n";
}
