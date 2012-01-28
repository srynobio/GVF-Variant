#!/usr/bin/perl

use strict;
use warnings;
use lib '/home/srynearson/GVF_DB_Variant/lib';
use GVF::DB::Variant;
use Bio::Perl;
use Bio::DB::Fasta;
use Data::Dumper;


my $usage = "\n

DESCRIPTION:
USAGE:
\n";

my $fastaInput = $ARGV[0];
my $file  = $ARGV[1];

my $fileIO = IO::File->new( $file, 'r');

# db handle and indexing fasta file.
my $dbxh = GVF::DB::Variant->connect( 'dbi:mysql:GVF_DB_Variant', 'srynearson', 'sh@wnPAss')|| die "Can't connect to db\n";
my $db   = Bio::DB::Fasta->new( $FastaInput, -debug=>1 ) || die "Please enter fasta file\n";


my ( $correct, $mismatch );

# collects the start position from database
my $var_obj = $dbxh->resultset('Variant')->search || die "resultset dbix failed\n"; 
while (my $key = $var_obj->next) {
        my $chr      = $key->source;
        my $type     = $key->type;
        my $start    = $key->start;
        my $end      = $key->end;
        my $ref_seq  = $key->reference_sequence;
	
        my $seq = $db->seq($chr, $start => $end);


        #die if $seq neq "$file_position_ref";
        #pos = which position in the genome you want to look at
        #in this case start and stop are the coordinates you want to check in a fasta. 

    if ( $seq eq $ref_seq ) {
        $correct++;
    }
    else {
        $mismatch++;
    }

}

my $total = ($correct/$mismatch) * 100;

print $total;    


#
#my ( $correct, $numbers );
#
#while ( defined ( my $line = <$fileIO>) ) {
#    
#        # Chromosome	GenomicLocation	dbSNPId	ReferenceAllele	VariantAllele
#        # chr1	114376651	rs77162890	T:0.9995	C:0.0005
#        
#        my ( $chr, $pos, $dbSNPId, $refAllele, $varAllele ) = split /\t/, $line;
#        #
#        my ($refsequence, $value) = split /:/, $refAllele;
#        
#        #my $seq = $db->seq($chr, $pos => $pos);
#        
#
#
#
# #   my( $chr, $type, ,$soTerm, $start, $end, $count, $strand, $place, $atts ) = split /\t/, $line;
# #   
# #   my ( $ID, $Alias, $Variant_seq, $Reference_seq, $rest ) = split /;/, $atts; 
# #   
# ## chr12   Variant_seq=T   Reference_seq=C    
# #   my ( $tag1, $variant ) = split /=/, $Variant_seq;
# #   my ( $tag2, $ref )     = split /=/, $Reference_seq;
# #   
# #
# #   
#    my $seq = uc( $db->seq($chr, $pos => $pos) );
# #   
##    print "seq: $seq\tref: $refsequence\n";    
#    #print "$chr\tstart: $start\tend: $end\n";
#    #print "seq: $seq\tstart: $ref\n";
#    
#    $numbers++;
#    
#    if ( $seq eq $refsequence ) {
#        #print "$line\n";
#        $correct++;
#    }
#
#}
#
#
#my $total = ($correct/$numbers) * 100;
#
#print "$total\t$correct\t$numbers\n";    











