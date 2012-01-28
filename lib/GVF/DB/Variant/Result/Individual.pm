use utf8;
package GVF::DB::Variant::Result::Individual;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

GVF::DB::Variant::Result::Individual

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

=head1 TABLE: C<INDIVIDUAL>

=cut

__PACKAGE__->table("INDIVIDUAL");

=head1 ACCESSORS

=head2 ID

  accessor: 'id'
  data_type: 'integer'
  is_nullable: 0

=head2 dbxref

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 Gender

  accessor: 'gender'
  data_type: 'varchar'
  is_nullable: 1
  size: 7

=head2 Population

  accessor: 'population'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 Comment

  accessor: 'comment'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 GenomeAnnotation

  accessor: 'genome_annotation'
  data_type: 'varchar'
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "ID",
  { accessor => "id", data_type => "integer", is_nullable => 0 },
  "dbxref",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "Gender",
  { accessor => "gender", data_type => "varchar", is_nullable => 1, size => 7 },
  "Population",
  {
    accessor => "population",
    data_type => "varchar",
    is_nullable => 1,
    size => 50,
  },
  "Comment",
  { accessor => "comment", data_type => "varchar", is_nullable => 1, size => 50 },
  "GenomeAnnotation",
  {
    accessor => "genome_annotation",
    data_type => "varchar",
    is_nullable => 1,
    size => 50,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</ID>

=back

=cut

__PACKAGE__->set_primary_key("ID");

=head1 RELATIONS

=head2 genomescopes

Type: has_many

Related object: L<GVF::DB::Variant::Result::Genomescope>

=cut

__PACKAGE__->has_many(
  "genomescopes",
  "GVF::DB::Variant::Result::Genomescope",
  { "foreign.INDIVIDUAL_ID" => "self.ID" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 individualphenotypes

Type: has_many

Related object: L<GVF::DB::Variant::Result::Individualphenotype>

=cut

__PACKAGE__->has_many(
  "individualphenotypes",
  "GVF::DB::Variant::Result::Individualphenotype",
  { "foreign.INDIVIDUAL_ID" => "self.ID" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 samples

Type: has_many

Related object: L<GVF::DB::Variant::Result::Sample>

=cut

__PACKAGE__->has_many(
  "samples",
  "GVF::DB::Variant::Result::Sample",
  { "foreign.INDIVIDUAL_ID" => "self.ID" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 variants

Type: has_many

Related object: L<GVF::DB::Variant::Result::Variant>

=cut

__PACKAGE__->has_many(
  "variants",
  "GVF::DB::Variant::Result::Variant",
  { "foreign.INDIVIDUAL_ID" => "self.ID" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07014 @ 2012-01-27 12:01:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:JRiNxE54HkY8psGFL0MJjg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
