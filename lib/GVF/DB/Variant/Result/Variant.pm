use utf8;
package GVF::DB::Variant::Result::Variant;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

GVF::DB::Variant::Result::Variant

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

=head1 TABLE: C<VARIANT>

=cut

__PACKAGE__->table("VARIANT");

=head1 ACCESSORS

=head2 ID

  accessor: 'id'
  data_type: 'bigint'
  is_nullable: 0

=head2 FileID

  accessor: 'file_id'
  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 Source

  accessor: 'source'
  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 Type

  accessor: 'type'
  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 Start

  accessor: 'start'
  data_type: 'integer'
  is_nullable: 0

=head2 End

  accessor: 'end'
  data_type: 'integer'
  is_nullable: 0

=head2 Score

  accessor: 'score'
  data_type: 'float'
  is_nullable: 0

=head2 Strand

  accessor: 'strand'
  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 dbxref

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 ReferenceSequence

  accessor: 'reference_sequence'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 TotalReads

  accessor: 'total_reads'
  data_type: 'integer'
  is_nullable: 1

=head2 Alias

  accessor: 'alias'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 Zygosity

  accessor: 'zygosity'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 VariantSequence

  accessor: 'variant_sequence'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 VariantReads

  accessor: 'variant_reads'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 INDIVIDUAL_ID

  accessor: 'individual_id'
  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "ID",
  { accessor => "id", data_type => "bigint", is_nullable => 0 },
  "FileID",
  { accessor => "file_id", data_type => "varchar", is_nullable => 0, size => 50 },
  "Source",
  { accessor => "source", data_type => "varchar", is_nullable => 0, size => 50 },
  "Type",
  { accessor => "type", data_type => "varchar", is_nullable => 0, size => 50 },
  "Start",
  { accessor => "start", data_type => "integer", is_nullable => 0 },
  "End",
  { accessor => "end", data_type => "integer", is_nullable => 0 },
  "Score",
  { accessor => "score", data_type => "float", is_nullable => 0 },
  "Strand",
  { accessor => "strand", data_type => "varchar", is_nullable => 0, size => 50 },
  "dbxref",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "ReferenceSequence",
  {
    accessor => "reference_sequence",
    data_type => "varchar",
    is_nullable => 1,
    size => 50,
  },
  "TotalReads",
  { accessor => "total_reads", data_type => "integer", is_nullable => 1 },
  "Alias",
  { accessor => "alias", data_type => "varchar", is_nullable => 1, size => 50 },
  "Zygosity",
  {
    accessor => "zygosity",
    data_type => "varchar",
    is_nullable => 1,
    size => 50,
  },
  "VariantSequence",
  {
    accessor => "variant_sequence",
    data_type => "varchar",
    is_nullable => 1,
    size => 50,
  },
  "VariantReads",
  {
    accessor => "variant_reads",
    data_type => "varchar",
    is_nullable => 1,
    size => 50,
  },
  "INDIVIDUAL_ID",
  {
    accessor       => "individual_id",
    data_type      => "integer",
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

=head2 cosmics

Type: has_many

Related object: L<GVF::DB::Variant::Result::Cosmic>

=cut

__PACKAGE__->has_many(
  "cosmics",
  "GVF::DB::Variant::Result::Cosmic",
  { "foreign.VARIANT_ID" => "self.ID" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 genomevariantrelations

Type: has_many

Related object: L<GVF::DB::Variant::Result::Genomevariantrelation>

=cut

__PACKAGE__->has_many(
  "genomevariantrelations",
  "GVF::DB::Variant::Result::Genomevariantrelation",
  { "foreign.VARIANT_ID" => "self.ID" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 individual

Type: belongs_to

Related object: L<GVF::DB::Variant::Result::Individual>

=cut

__PACKAGE__->belongs_to(
  "individual",
  "GVF::DB::Variant::Result::Individual",
  { ID => "INDIVIDUAL_ID" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);

=head2 thousandgenomes

Type: has_many

Related object: L<GVF::DB::Variant::Result::Thousandgenome>

=cut

__PACKAGE__->has_many(
  "thousandgenomes",
  "GVF::DB::Variant::Result::Thousandgenome",
  { "foreign.VARIANT_ID" => "self.ID" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 varianteffects

Type: has_many

Related object: L<GVF::DB::Variant::Result::Varianteffect>

=cut

__PACKAGE__->has_many(
  "varianteffects",
  "GVF::DB::Variant::Result::Varianteffect",
  { "foreign.VARIANT_ID" => "self.ID" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-01-27 12:01:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:LgTU4G60jRIO9zuXS9s6qA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
