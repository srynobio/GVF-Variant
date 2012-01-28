use utf8;
package GVF::DB::Variant::Result::Sample;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

GVF::DB::Variant::Result::Sample

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

=head1 TABLE: C<SAMPLE>

=cut

__PACKAGE__->table("SAMPLE");

=head1 ACCESSORS

=head2 ID

  accessor: 'id'
  data_type: 'integer'
  is_nullable: 0

=head2 INDIVIDUAL_ID

  accessor: 'individual_id'
  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 SampleName

  accessor: 'sample_name'
  data_type: 'varchar'
  is_nullable: 1
  size: 45

=head2 SampleId

  accessor: 'sample_id'
  data_type: 'integer'
  is_nullable: 0

=head2 TumorId

  accessor: 'tumor_id'
  data_type: 'integer'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "ID",
  { accessor => "id", data_type => "integer", is_nullable => 0 },
  "INDIVIDUAL_ID",
  {
    accessor       => "individual_id",
    data_type      => "integer",
    is_foreign_key => 1,
    is_nullable    => 0,
  },
  "SampleName",
  {
    accessor => "sample_name",
    data_type => "varchar",
    is_nullable => 1,
    size => 45,
  },
  "SampleId",
  { accessor => "sample_id", data_type => "integer", is_nullable => 0 },
  "TumorId",
  { accessor => "tumor_id", data_type => "integer", is_nullable => 0 },
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
  { "foreign.SAMPLE_ID" => "self.ID" },
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


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-01-27 12:01:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XbfvBVeVDVNSnnIfopAejw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
