use utf8;
package GVF::DB::Variant::Result::Cosmic;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

GVF::DB::Variant::Result::Cosmic

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<COSMIC>

=cut

__PACKAGE__->table("COSMIC");

=head1 ACCESSORS

=head2 ID

  accessor: 'id'
  data_type: 'bigint'
  is_nullable: 0

=head2 Version

  accessor: 'version'
  data_type: 'varchar'
  is_nullable: 0
  size: 10

=head2 GeneName

  accessor: 'gene_name'
  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 HGNC

  accessor: 'hgnc'
  data_type: 'integer'
  is_nullable: 1

=head2 AccessionNumber

  accessor: 'accession_number'
  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 PrimarySite

  accessor: 'primary_site'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 SiteSubtype

  accessor: 'site_subtype'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 PrimaryHistology

  accessor: 'primary_histology'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 HistologySubtype

  accessor: 'histology_subtype'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 MutationId

  accessor: 'mutation_id'
  data_type: 'integer'
  is_nullable: 1

=head2 MutationAA

  accessor: 'mutation_aa'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 MutationCDS

  accessor: 'mutation_cds'
  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 SomaticStatus

  accessor: 'somatic_status'
  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 StartLocation

  accessor: 'start_location'
  data_type: 'integer'
  is_nullable: 0

=head2 EndLocation

  accessor: 'end_location'
  data_type: 'integer'
  is_nullable: 1

=head2 Strand

  accessor: 'strand'
  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 SAMPLE_ID

  accessor: 'sample_id'
  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 VARIANT_ID

  accessor: 'variant_id'
  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "ID",
  { accessor => "id", data_type => "bigint", is_nullable => 0 },
  "Version",
  { accessor => "version", data_type => "varchar", is_nullable => 0, size => 10 },
  "GeneName",
  {
    accessor => "gene_name",
    data_type => "varchar",
    is_nullable => 1,
    size => 45,
  },
  "HGNC",
  { accessor => "hgnc", data_type => "integer", is_nullable => 1 },
  "AccessionNumber",
  {
    accessor => "accession_number",
    data_type => "varchar",
    is_nullable => 1,
    size => 45,
  },
  "PrimarySite",
  {
    accessor => "primary_site",
    data_type => "varchar",
    is_nullable => 1,
    size => 50,
  },
  "SiteSubtype",
  {
    accessor => "site_subtype",
    data_type => "varchar",
    is_nullable => 1,
    size => 50,
  },
  "PrimaryHistology",
  {
    accessor => "primary_histology",
    data_type => "varchar",
    is_nullable => 1,
    size => 50,
  },
  "HistologySubtype",
  {
    accessor => "histology_subtype",
    data_type => "varchar",
    is_nullable => 1,
    size => 50,
  },
  "MutationId",
  { accessor => "mutation_id", data_type => "integer", is_nullable => 1 },
  "MutationAA",
  {
    accessor => "mutation_aa",
    data_type => "varchar",
    is_nullable => 1,
    size => 50,
  },
  "MutationCDS",
  {
    accessor => "mutation_cds",
    data_type => "varchar",
    is_nullable => 1,
    size => 45,
  },
  "SomaticStatus",
  {
    accessor => "somatic_status",
    data_type => "varchar",
    is_nullable => 1,
    size => 45,
  },
  "StartLocation",
  { accessor => "start_location", data_type => "integer", is_nullable => 0 },
  "EndLocation",
  { accessor => "end_location", data_type => "integer", is_nullable => 1 },
  "Strand",
  { accessor => "strand", data_type => "varchar", is_nullable => 1, size => 45 },
  "SAMPLE_ID",
  {
    accessor       => "sample_id",
    data_type      => "integer",
    is_foreign_key => 1,
    is_nullable    => 1,
  },
  "VARIANT_ID",
  {
    accessor       => "variant_id",
    data_type      => "bigint",
    is_foreign_key => 1,
    is_nullable    => 0,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</ID>

=back

=cut

__PACKAGE__->set_primary_key("ID");

=head1 RELATIONS

=head2 sample

Type: belongs_to

Related object: L<GVF::DB::Variant::Result::Sample>

=cut

__PACKAGE__->belongs_to(
  "sample",
  "GVF::DB::Variant::Result::Sample",
  { ID => "SAMPLE_ID" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "CASCADE",
  },
);

=head2 variant

Type: belongs_to

Related object: L<GVF::DB::Variant::Result::Variant>

=cut

__PACKAGE__->belongs_to(
  "variant",
  "GVF::DB::Variant::Result::Variant",
  { ID => "VARIANT_ID" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-01-27 12:01:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6rt6rD0ugwd2i3aB/326kg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
