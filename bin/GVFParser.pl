#!/usr/bin/perl
use warnings;
use strict;
use lib '/home/srynearson/GVF_DB_Variant/lib';
use Utils;
use GVF_DB_Connect;
use GVF::DB::Variant;
use IO::File;
use Getopt::Long;
use Data::Dumper;

# Script by Shawn Rynearson For Karen Eilbeck
# shawn.rynearson@gmail.com

my $usage = "\n

DESCRIPTION:
	                Parsing script which takes gvf file and stores metadata and 
			gvf line in data structures.
			Options allow you to added to all tables in GVF_Variant 
			database or 'data' to view the data structures.

USAGE:			./GVFParser.pl -option <GVF_file> 

OPTIONS(required):
			 Each option corresponds to a table in the database.

			- all 	Option will add all areas of GVF file to database
				and run Tabix scripts to add Thousandgenomes and
				Cosmic data.

			- data	Will print out the data structures to view.

\n";

my ($all, $data);
my $input = $ARGV[1] || die $usage;
 
GetOptions( 

	'all'  => \$all,
	'data' => \$data,

) || die $usage; 


#I/O
my $GVF_FILE = IO::File->new( $input, 'r') || die "Could not open GVF file $usage\n";

# handle to connect to db.
my $dbxh = GVF::DB::Variant->connect( 'dbi:mysql:GVF_DB_Variant', 'srynearson', 'sh@wnPAss');

# Where the magic happens.
my (@meta, @gvf);
foreach my $line ( <$GVF_FILE> ){
	chomp $line;

	if ($line =~ /^#/) {
               push @meta, $line;	
	}
	elsif ($line =~ /^chr/){
		push @gvf, $line;
	}
}

# the data structures.
my $parsed_meta = parse_metadata(\@meta);
my $parsed_gvf = parse_gvf(\@gvf);


## -- send to GVF_DB_Connect to add to the database -- ##

# This order needs to be maintaned.
if ($all) {
	individual($dbxh, $parsed_meta, $parsed_gvf);
	variant($dbxh, $parsed_gvf);
	system ("./TabixToDB.pl -thousand ../tabix/ThousandGenome.gz");
	genome_scope($dbxh, $parsed_meta );
	genome_variant_relation($dbxh);
	variant_effect($dbxh, $parsed_gvf);
	individual_phenotype($dbxh, $parsed_meta);
	system ("./TabixToDB.pl -cosmic ../tabix/Cosmic.gz");
	variant_stat($dbxh, $parsed_gvf);
}

if ($data) {
	print "\nFirst section is meta data followed by gvf data\n";
	print Dumper($parsed_meta, $parsed_gvf);
}

