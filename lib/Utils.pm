package Utils;

require Exporter;
@Utils::ISA = qw(Exporter);
@EXPORT = qw(parse_gvf parse_metadata meta_hash_maker gvf_hash_maker get_shared_variant revcomp so_term_builder seqid_pos_builder seq_grabber);
use strict;

# Script by Shawn Rynearson For Karen Eilbeck
# shawn.rynearson@gmail.com
# ~10 lines of code from parse_gvf were from Marc S. the rest is new. 

#------------------------------------------------------------------------------
#------------------------------- FUNCTIONS ------------------------------------
#------------------------------------------------------------------------------

sub parse_gvf {
	
	my $data = shift;
	my @gvf_list;

	foreach my $line (@$data) {
		my ($id, $allias, $dbxref, $var_seq, $ref_seq, $var_read, $total_read, $genotype, $var_freq,
            	    $var_effect, $var_copy_num, $ref_copy_num, $start_range, $end_range, $phased);

        	my ($seq_id, $source, $type, $start, $end, $score, $strand, $place_hold, $info) = split(/\t/, $line);

    		my @attributes = split(/\;/, $info);

        	foreach(@attributes){
			($id)           = $_ =~ /ID=(.+)/ if $_ =~ /ID=/;
			($allias)       = $_ =~ /Alias=(\S+)/ if $_ =~ /Alias/;
			($dbxref)       = $_ =~ /Dbxref=(\S+)/ if $_ =~ /Dbxref/;
			($var_seq)      = $_ =~ /Variant_seq=(\S+)/ if $_ =~ /Variant_seq/;
			($ref_seq)      = $_ =~ /Reference_seq=(\S+)/ if $_ =~ /Reference_seq/;
			($var_read)     = $_ =~ /Variant_reads=(\S+)/ if $_ =~ /Variant_reads/;
			($total_read)   = $_ =~ /Total_reads=(\S+)/ if $_ =~ /Total_reads/;
			($genotype)     = $_ =~ /Genotype=(\S+)/ if $_ =~ /Genotype/;
			($var_freq)     = $_ =~ /Variant_freq=(\S+)/ if $_ =~ /Variant_freq/;
			($var_effect)   = $_ =~ /Variant_effect=(.+)/ if $_ =~ /Variant_effect/;
			($var_copy_num) = $_ =~ /Variant_copy_number=(\S+)/ if $_ =~ /Variatn_copy_number/;
			($ref_copy_num) = $_ =~ /Reference_copy_number=(\S+)/ if $_ =~ /Reference_copy_number/;
			($start_range)  = $_ =~ /Start_range=(\S+)/ if $_ =~ /Start_range/;
			($end_range)    = $_ =~ /End_range=(\S+)/ if $_ =~ /End_range/;
			($phased)       = $_ =~ /Phased=(\S+)/ if $_ =~ /Phased/;
		}
		my @column = ( $seq_id, $source, $type, $start, $end, $score, $strand, $id, $allias, $dbxref, $var_seq, 
		       	       $ref_seq, $var_read, $total_read, $genotype, $var_freq, $var_effect, $var_copy_num, 
		               $ref_copy_num, $start_range, $end_range, $phased);
		my $gvf = gvf_hash_maker(\@column);
		push @gvf_list, $gvf;
	}
	return(\@gvf_list);
}	


#------------------------------------------------------------------------------

sub parse_metadata {

   my $metadata = shift;
   my %meta;

   foreach my $i (@$metadata) {
	$i =~ s/^##//g;
        $i =~ s/^#//g;
        $i =~ s/^\s+//g;
	#if ($i =~ /(ploidy)\s+(.*)$/ ) {
	if ($i =~ /(\w+-\w+)\s+(.*)$/ ) {
		my $pragma = $1;
		my @defined = $2;

		my $list = meta_hash_maker(@defined);

		$meta{$pragma} = $list;
	}
    }
    return (\%meta); 
}
  
#------------------------------------------------------------------------------

sub meta_hash_maker {
	my $list = shift;
	my @first  = split(/;/, $list);

	my (%hash, $tag, $desc, $single);
	foreach my $i (@first) {
		if ($i =~ /(.*)\=(.*)/){
			$tag  = $1;
			$desc = $2;
			$hash{$1} = $2
		}
		else {
			$single = $i;
			$hash{$single} = '';
		}
	}
	return (\%hash);
}

#------------------------------------------------------------------------------

sub gvf_hash_maker {
	my $list = shift;
	my %gvf_hash;
	my %gvf;

	my ($seq_id, $source, $type, $start, $end, $score, $strand,$id, $allias, $dbxref, 
	    $var_seq, $ref_seq, $var_read, $total_read, $genotype, $var_freq, $var_effect, 
            $var_copy_num, $ref_copy_num, $start_range, $end_range, $phased);
	
	$gvf_hash{'seq_id'} 	   = shift(@$list);
	$gvf_hash{'source'} 	   = shift(@$list);
	$gvf_hash{'type'} 	   = shift(@$list);
	$gvf_hash{'start'} 	   = shift(@$list);
	$gvf_hash{'end'} 	   = shift(@$list);
	$gvf_hash{'score'} 	   = shift(@$list);
	$gvf_hash{'strand'}        = shift(@$list);
	$gvf_hash{'id'} 	   = shift(@$list);
	$gvf_hash{'allias'} 	   = shift(@$list);
	$gvf_hash{'dbxref'}        = shift(@$list);
	$gvf_hash{'var_seq'}       = shift(@$list);
	$gvf_hash{'ref_seq'}       = shift(@$list);
	$gvf_hash{'var_read'}      = shift(@$list);
	$gvf_hash{'total_read'}    = shift(@$list);
	$gvf_hash{'genotype'}      = shift(@$list);
	$gvf_hash{'var_freq'}      = shift(@$list);
	$gvf_hash{'var_effect'}    = shift(@$list);
	$gvf_hash{'var_copy_num'}  = shift(@$list);
	$gvf_hash{'ref_copy_num'}  = shift(@$list);
	$gvf_hash{'start_range'}   = shift(@$list);
	$gvf_hash{'end_range'}     = shift(@$list);
	$gvf_hash{'phased'}        = shift(@$list); 

	while (my ($key, $value) = each (%gvf_hash)) {
		$gvf{$key} = $value if defined $value;
	}
	return (\%gvf);
}

#------------------------------------------------------------------------------

sub get_shared_variant {

	# parser generates two lists types, metadata and gvfdata. This sub will allow you to
	# pull data from one type into another, as needed to add to database. 

	my ( $gvf, $option ) = @_;

	if ($option eq 'charID') {
		my @charID;
		foreach my $i (@$gvf) {
        		push @charID, $i->{'id'};
		}
		return (@charID);
	}
}

#------------------------------------------------------------------------------

sub revcomp {

  # thanks Barry!
  my ($sequence) = shift;

  my $revcomp_seq = reverse $sequence;
  $revcomp_seq =~ tr/acgtrymkswhbvdnxACGTRYMKSWHBVDNX/tgcayrkmswdvbhnxTGCAYRKMSWDVBHNX/;
  return $revcomp_seq;
}

#------------------------------------------------------------------------------

sub so_term_builder {
    
    my $line = shift;
    
    $line =~ s/(Complex - compound substitution)/complex_substitution/g;
    $line =~ s/(Complex - deletion inframe)/complex_change_in_transcript/g;
    $line =~ s/(Complex - frameshift)/complex_change_in_transcript/g;
    $line =~ s/(Complex - insertion inframe)/complex_change_in_transcript/g;
    $line =~ s/(Deletion - Frameshift)/deletion/g;
    $line =~ s/(Deletion - In frame)/deletion/g;
    $line =~ s/(Insertion - Frameshift)/insertion/g;
    $line =~ s/(Insertion - In frame)/insertion/g;
    $line =~ s/(Substitution - Missense)/substitution/g;
    $line =~ s/(Substitution - Nonsense)/substitution/g;
    $line =~ s/(Substitution - coding silent)/substitution/g;
    $line =~ s/(Whole gene deletion)/deletion/g;
    $line =~ s/(Unknown)/unknown/g;
    $line =~ s/(Nonstop extension)/substitution/g;
    $line =~ s/No detectable mRNA\/protein/No_detectable_mRNA\/protein/g;
    return $line;
}

#------------------------------------------------------------------------------

sub seqid_pos_builder {
   
   my ($position, $which) = @_;
   
   if ($which eq 'seqid'){
        my ($chr, $loc) = split /:/, $position;

        my $id = 'chr'. $chr;
        return $id; 
   }
   
   if ($which eq 'start-end') {
        my ($chr, $loc) = split /:/, $position;
        my ($start, $end) = split /-/, $loc;
        return ($start, $end);
   }
}

#------------------------------------------------------------------------------

sub seq_grabber {
    
    my ( $cds, $strand ) = @_;

    my ($var, $ref);
    
    if ($cds =~ /(\d+)\>([A-Z]{1,})/ ) {
        if  ($strand eq '-') { 
            my $revMatch = revcomp($2) if $strand eq '-';
            
            $var ="Variant_seq=$revMatch";
        }
        else { $var ="Variant_seq=$2"; }
    }
    elsif ( $cds =~ /([A-Z]{1,})\>([A-Z]{1,})$/ ) {   
        if  ($strand eq '-') { 
            my $revMatch1 = revcomp($2) if $strand eq '-';
            my $revMatch2 = revcomp($1) if $strand eq '-';
            
            $var ="Variant_seq=$revMatch1";
            $ref = "Reference_seq=$revMatch2";
        }
        else {
            $var = "Variant_seq=$2";
            $ref = "Reference_seq=$1";
        }
    }
    elsif ( $cds =~ /(.*)(ins)([A-Z]{1,})/) {
        if  ($strand eq '-') { 
            my $revMatch1 = revcomp($3) if $strand eq '-';
            
            $var ="Variant_seq=$revMatch1";
            $ref = "Reference_seq='-'";
        }
        else {
            $var = "Variant_seq=$3";
            $ref = "Reference_seq='-'";
        }
    }
    elsif ( $cds =~ /(.*)(del)([A-Z]{1,})/ ) {
        if  ($strand eq '-') { 
            my $revMatch2 = revcomp($3) if $strand eq '-';
            
            $var ="Variant_seq='-'";
            $ref = "Reference_seq=$revMatch2";
        }
        else {
            $var = "Variant_seq='-'";
            $ref = "Reference_seq=$3";
        }
    }
    return ($var, $ref);
}

#------------------------------------------------------------------------------

1; 
