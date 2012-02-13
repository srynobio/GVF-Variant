package GVF_DB_Connect;

require Exporter;
@GVF_DB_Connect::ISA = qw(Exporter); 
@EXPORT = qw(individual genome_scope variant variant_effect genome_variant_relation M_genomes individual_phenotype cosmic);

# Script by Shawn Rynearson For Karen Eilbeck
# shawn.rynearson@gmail.com

#------------------------------------------------------------------------------
#------------------------------- FUNCTIONS ------------------------------------
#------------------------------------------------------------------------------

sub variant {

	my ( $dbxh, $gvf ) = @_;

        # Collect current id from database
	my $fkey_obj = $dbxh->resultset('Individual')->search;
        my $rs_column = $fkey_obj->get_column('id');
        my $max_id = $rs_column->max; 

	# add to db
	foreach my $i (@$gvf) {
		$dbxh->resultset('Variant')->create({
			FileID            => $i->{'id'},
			Source            => $i->{'seq_id'},
			Type              => $i->{'type'},
			Start             => $i->{'start'},
			End               => $i->{'end'},
			Score             => $i->{'score'},
			Strand            => $i->{'strand'},
			dbxref            => $i->{'dbxref'},
			ReferenceSequence => $i->{'ref_seq'},
			TotalReads        => $i->{'total_read'},
			Alias             => $i->{'allias'},
			Zygosity          => $i->{'genotype'},
			VariantSequence   => $i->{'var_seq'},
			VariantReads      => $i->{'var_read'},
			INDIVIDUAL_ID     => $max_id, 	
		});
	}
}

#------------------------------------------------------------------------------

sub genome_variant_relation {

	my ( $dbxh ) = @_;
	
	# Collect current id from database
	my $fkey_obj = $dbxh->resultset('Individual')->search;
        my $rs_column = $fkey_obj->get_column('id');
        my $max_id = $rs_column->max;
	
        # collect GenomescopeID foreign key data.
        my $gene_obj = $dbxh->resultset('Genomescope')->search;
        my $gene_column = $gene_obj->get_column('id');
        my $max_gene_id = $gene_column->max;

	# collect IndividualID foreign key data
	my @var_list;
        my $var_obj = $dbxh->resultset('Variant')->search;
        while (my $key = $var_obj->next) {
		push (@var_list, $key->id) if $max_id eq $key->individual_id;
	}

	foreach my $i (@var_list) {
		$dbxh->resultset('Genomevariantrelation')->create({
			VARIANT_ID     => $i,
                	GENOMESCOPE_ID => $max_gene_id,
		});
	}
}
	
#------------------------------------------------------------------------------

sub variant_effect {

	my ($dbxh, $gvf) = @_;
	
	# Collecting foreign key data.
        my @varseq_list;
        my $varseq_obj = $dbxh->resultset('Variant')->search;
        while (my $key = $varseq_obj->next) {
                push (@varseq_list, $key->id);
        }

	# add to db.
	foreach my $i (@$gvf) {
		my ($seq_var, $index, $feature_type, $feature_id ) = split /\s+/, $i->{'var_effect'};

		# additional contains gene information not used at this time.
		my ($ncbi_gene, $additional) = split /,/, $feature_id; 

		$dbxh->resultset('Varianteffect')->create({
			FeatureID          => $i->{'ref_seq'},
			VariantEffect      => $seq_var, 
			FeatureAffected    => $feature_type,
			NcbiRefSeq         => $ncbi_gene,
			VARIANT_ID         => shift @varseq_list,
		});
	}
}	
		
#------------------------------------------------------------------------------

sub genome_scope {
	
	my ( $dbxh, $meta_data, $gvf ) = @_;

	# collecting foreign key data.
	my $fkey_obj = $dbxh->resultset('Individual')->search;
	my $rs_column = $fkey_obj->get_column('id');
  	my $max_id = $rs_column->max;

        # collecting all the metadata     
        my $source_method  = $meta_data->{'source-method'}->{'Source'};
        my $tech_plat      = $meta_data->{ 'technology-platform' }->{ 'Platform_name'}; 
	my $score_method   = $meta_data->{'source-method'}->{'Comment'};  
        my $genomic_source =  'germline'; # currently GVF is all germline, in future this will change.

	# add to db.
      	$dbxh->resultset('Genomescope')->create({
        	SourceMethod       => $source_method,
                TechnologyPlatform => $tech_plat,
                ScoreMethod        => $score_method,
                GenomicSource      => $genomic_source,
		INDIVIDUAL_ID      => $max_id,
        });
}

#------------------------------------------------------------------------------

sub individual {

	my ( $dbxh, $meta_data, $gvf ) = @_;

	# collecting all the metadata     
	my $geno_annot = ''; # future versions of gvf will have this.
        my $dbxref     = $meta_data->{ 'individual-id' }->{ 'Dbxref' };
        my $sex        = $meta_data->{ 'individual-id' }->{ 'Gender' };
        my $popul      = $meta_data->{ 'individual-id' }->{ 'Population' };
        my $comment    = $meta_data->{ 'individual-id' }->{ 'Comment' };
	
	# second location were sex can be specified.
	my $sec_loca   = $meta_data->{ 'phenotype-description' }->{ 'Term' };

	my $gender;
       	if ( $sex || $sec_loca ) {
		if( $sex eq /male/i ) { $gender = 'XY' } else { $gender = 'XX' }
	}

	$dbxh->resultset('Individual')->create({
		dbxref           => $dbxref,
		Gender           => $gender,
		Population       => $popul,
		Comment          => $comment,
		GenomeAnnotation => $geno_annot,
	});
}

#------------------------------------------------------------------------------

sub M_genomes {

	my ($dbxh, $m_match ) = @_;

	# collecting foreign key data.
	my $fkey_obj = $dbxh->resultset('Individual')->search;
	my $rs_column = $fkey_obj->get_column('id');
  	my $indiv_id = $rs_column->max;
	
	# Split incoming data into parts
	my ( @file, @ids, $max );
	foreach my $i (@$m_match) {
		push @file, $i->[0];
		push @ids, $i->[1];
		$max = $i->[2];
	}
	
	foreach my $elements (@file) {
		my ($chromosome, $genomicLocation, $dbSNPId, $referenceAllele, $variantAllele) = split /\t/, $elements;

		if ( ! $indiv_id eq $max ) { next; }
		
		my $location = join(':', $chromosome, $genomicLocation );

		my ($ref_allele, $ref_stat) = split /:/, $referenceAllele; 
		my ($var_allele, $var_stat) = split /:/, $variantAllele;	
 
		$dbxh->resultset('Thousandgenome')->create({
			GenomeLocation      => $location,
			Dbsnpid		    => $dbSNPId,
			ReferenceAllele     => $ref_allele,
			ReferenceStat       => $ref_stat,
			VariantAllele       => $var_allele,
			VariantFrequency    => $var_stat,
			Individual_Id       => $max,
			VARIANT_ID          => shift @ids,
			});
	}	
}

#------------------------------------------------------------------------------

sub individual_phenotype {
	
	my ($dbxh, $meta_data) = @_;

	# Collect current max id from database
        my $fkey_obj = $dbxh->resultset('Individual')->search;
        my $rs_column = $fkey_obj->get_column('id');
        my $max_id = $rs_column->max;	


	my $term    = $meta_data->{ 'phenotype-description' }->{ 'Term' };
	my $comment = $meta_data->{ 'phenotype-description' }->{ 'Comment' };


	if ( $term || $comment ) {
		$dbxh->resultset('Individualphenotype')->create({
			Phenotype => ($term || $comment), 
			INDIVIDUAL_ID   => $max_id,
		});
	}
}

#------------------------------------------------------------------------------

sub cosmic {
	
	my ($dbxh, $cosmic) = @_;

	# collecting foreign key data.
        my $fkey_obj = $dbxh->resultset('Individual')->search;
        my $rs_column = $fkey_obj->get_column('id');
        my $max_id = $rs_column->max;

	# Split incoming data into parts
	my ( @files, @ids );
	foreach my $i (@$cosmic) {
		push @files, $i->[0];
		push @ids, $i->[1];
	}

	# First set to add to Sample DB.
	foreach my $line ( @files ) {
		
		my ( $chr, $source, $type, $start, $end, $score, $strand, $phase, $remainder ) = split /\t/, $line;

		my ( $id, $alias, $var_seq, $ref_seq, $hgnc, $sample, $sample_id, $tumour_id, $prim_site,
		    $site_sub, $pri_hist, $his_subtype, $mutation_id, $mut_aa, $mut_cds, $acc_numb, $mutant_stat ) = split /;/, $remainder;
		
		my (undef, $sampleDB) = split /=/, $sample;
		my (undef, $samID)    = split /=/, $sample_id;
		my (undef, $tumID)    = split /=/, $tumour_id;
				
		$dbxh->resultset('Sample')->create({
			INDIVIDUAL_ID => $max_id,
			SampleName    => $sampleDB,
			SampleId      => $samID,
			TumorId       => $tumID,
			});
	}
	
	# Capture the new Sample id only if it matches the max value.
	my @idList;
	my $rs = $dbxh->resultset('Sample')->search;
	while (my $i = $rs->next) {
		push @idList, $i->id if $i->individual_id == $max_id;
	}
	
	# Second set to add to Cosmic DB.		
	foreach my $line ( @files ) {
		
		my ( $chr, $source, $type, $start, $end, $score, $strand, $phase, $remainder ) = split /\t/, $line;

		my ( $id, $alias, $var_seq, $ref_seq, $hgnc, $sample, $sample_id, $tumour_id, $prim_site,
		    $site_sub, $pri_hist, $his_subtype, $mutation_id, $mut_aa, $mut_cds, $acc_numb, $mutant_stat ) = split /;/, $remainder;

		my (undef, $idDB )    = split /=/, $id;
		my (undef, $aliasDB)  = split /=/, $alias;
		my (undef, $vSeq)     = split /=/, $var_seq;
		my (undef, $rSeq)     = split /=/, $ref_seq;
		my (undef, $hgncDB)   = split /=/, $hgnc;
		my (undef, $primDB)   = split /=/, $prim_site;
		my (undef, $siteDB)   = split /=/, $site_sub;
		my (undef, $phistDB)  = split /=/, $pri_hist;
		my (undef, $hisSub)   = split /=/, $his_subtype;
		my (undef, $mutID)    = split /=/, $mutation_id;
		my (undef, $mutAA)    = split /=/, $mut_aa;
		my (undef, $mutcds)   = split /=/, $mut_cds; 
		my (undef, $accDB)    = split /=/, $acc_numb;
		my (undef, $mutStat)  = split /=/, $mutant_stat;		

		# Add data to the db.
		$dbxh->resultset('Cosmic')->create({
			Version  	 => '56',
			GeneName 	 => $aliasDB,
			HGNC             => $hgncDB,
			AccessionNumber  => $accDB,
			PrimarySite 	 => $primDB,
			SiteSubtype 	 => $siteDB,
			PrimaryHistology => $phistDB,
			HistologySubtype => $hisSub,
			MutationId 	 => $mutID,
			MutationAA 	 => $mutAA,
			MutationCDS      => $mutcds,
			SomaticStatus 	 => $mutStat,
			StartLocation 	 => $start,
			EndLocation 	 => $end,
			Strand 		 => $strand,
			SAMPLE_ID	 => shift @idList,
			VARIANT_ID	 => shift @ids,
			});
	}
}	

#------------------------------------------------------------------------------

1;
