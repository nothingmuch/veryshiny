package VeryShiny::Part;
use Moose::Role;

use namespace::clean -except => 'meta';

use Moose::Role;

has parent => (
	isa => "VeryShiny::Container",
	is  => "ro",
	required => 1,
	weak_ref => 1,
	handles => [qw(body_class)],
);

sub new_body {
	my ( $self, $part, @args ) = @_;

	return $part if blessed($part) and $part->does("VeryShiny::Body");	

	$self->body_class->new( body => $part, @args );
}

__PACKAGE__

__END__
