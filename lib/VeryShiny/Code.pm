package VeryShiny::Code;
use Moose;

use namespace::clean -except => 'meta';

with qw(VeryShiny::Body);

has body => (
	isa => "Str",
	is  => "ro",
	required => 1,
);

has language => (
	isa => "Str",
	is  => "ro",
	default => "perl",
);

__PACKAGE__->meta->make_immutable;

__PACKAGE__

__END__
