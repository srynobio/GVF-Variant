use utf8;
package GVF::DB::Variant::Result::Thousandgenome;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

GVF::DB::Variant::Result::Thousandgenome

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

=head1 TABLE: C<THOUSANDGENOMES>

=cut

__PACKAGE__->table("THOUSANDGENOMES");

=head1 ACCESSORS

=head2 ID

  accessor: 'id'
  data_type: 'bigint'
  is_nullable: 0

=head2 GenomeLocation

  accessor: 'genome_location'
  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 Dbsnpid

  accessor: 'dbsnpid'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 ReferenceAllele

  accessor: 'reference_allele'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 ReferenceStat

  accessor: 'reference_stat'
  data_type: 'float'
  is_nullable: 1

=head2 VariantAllele

  accessor: 'variant_allele'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 VariantFrequency

  accessor: 'variant_frequency'
  data_type: 'float'
  is_nullable: 1

=head2 Individual_Id

  accessor: 'individual_id'
  data_type: 'integer'
  is_nullable: 0

=head2 VARIANT_ID

  accessor: 'variant_id'
  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "ID",
  { accessor => "id", data_type => "bigint", is_nullable => 0 },
  "GenomeLocation",
  {
    accessor => "genome_location",
    data_type => "varchar",
    is_nullable => 0,
    size => 50,
  },
  "Dbsnpid",
  { accessor => "dbsnpid", data_type => "varchar", is_nullable => 1, size => 50 },
  "ReferenceAllele",
  {
    accessor => "reference_allele",
    data_type => "varchar",
    is_nullable => 1,
    size => 50,
  },
  "ReferenceStat",
  { accessor => "reference_stat", data_type => "float", is_nullable => 1 },
  "VariantAllele",
  {
    accessor => "variant_allele",
    data_type => "varchar",
    is_nullable => 1,
    size => 50,
  },
  "VariantFrequency",
  { accessor => "variant_frequency", data_type => "float", is_nullable => 1 },
  "Individual_Id",
  { accessor => "individual_id", data_type => "integer", is_nullable => 0 },
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:0TwLNOJrcXBdDSN83nQqDQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
