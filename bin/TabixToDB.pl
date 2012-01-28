#!/usr/bin/perl -w 
use strict;
use lib '/home/srynearson/GVF_DB_Variant/lib';
use Tabix;
use IO::File;
use GVF_DB_Connect;
use GVF::DB::Variant;
use Getopt::Long;

# Script by Shawn Rynearson For Karen Eilbeck
# shawn.rynearson@gmail.com

my $usage = "\n

DESCRIPTION:
			Collects all Chromosomes and start position from GVF DB
			compairs them with tabix version of 1000G file and Cosmic.
			then adds them to existing database tables.
			*** Must perform on tabix-ed files.
USAGE:

			./TabixToDB.pl -option <tabix file>
		
OPTIONS(required):
			 Each option corresponds to a table in the database.

			- thousand	Preform search against thousandgenomes file. 

			- cosmic	Preform search against cosmic file.
\n";

# Options for 1000k genome match or Cosmic
my ( $thousand, $cosmic);
my $input = $ARGV[1];

GetOptions( 

	'thousand'  => \$thousand,
	'cosmic'    => \$cosmic,

) || die $usage;

# db handle.
my $dbxh = GVF::DB::Variant->connect( 'dbi:mysql:GVF_DB_Variant', 'srynearson', 'sh@wnPAss')|| die "Can't connect to db\n";

# object and vars.
my $tab = Tabix->new(-data => $input) || die "Please input Tabix file $usage\n";

# Collect current id from database
my $fkey_obj = $dbxh->resultset('Individual')->search;
my $rs_column = $fkey_obj->get_column('id');
my $max_id = $rs_column->max;

my ( @thousandList, @cosmicList );

# collects the start position from database
my $var_obj = $dbxh->resultset('Variant')->search || die "resultset dbxh failed\n";
while (my $key = $var_obj->next) {
	my $id       = $key->id;
        my $chr      = $key->source;
        my $type     = $key->type;
        my $start    = $key->start;
        my $end      = $key->end;
	my $ref_seq  = $key->reference_sequence;
	my $max_var  = $key->individual_id;
	
	# Mush have range which enclude the position.
	my $iter = $tab->query($chr, $start - 1, $end + 1);
		
	while (my $read = $tab->read($iter)) {

		if ( $thousand ){
			my ($_chr, $_start, $dbsnpid, $refseq, $varseq ) = split /\t/, $read;
			
			my ($ref, $refValue) = split /:/, $refseq;
			my ($var, $varValue) = split /:/, $varseq;
			
			next unless $chr eq $_chr && $start == $_start;
			push @thousandList, [$read, $id, $max_var] if $max_id eq $max_var;
		}

		if ( $cosmic ){
			my ( $_chr, $type, $soTerm, $_start, $_end, $remainder) = split /\t/, $read;
			
			next unless $chr eq $_chr && $start == $_start;
			push @cosmicList, [$read, $id];
		}
    	}
}

# Send to DB.
if ( $thousand ) { M_genomes($dbxh, \@thousandList); }

# Send to DB.
if ( $cosmic ) { cosmic($dbxh, \@cosmicList ); }

