package VeryShiny::Text;
use Moose;

use namespace::clean -except => 'meta';

with qw(VeryShiny::Body);

has body => (
	isa => "Str",
	is  => "ro",
);

__PACKAGE__->meta->make_immutable;

__PACKAGE__

__END__
