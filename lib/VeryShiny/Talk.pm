package VeryShiny::Talk;
use Moose;

use VeryShiny::Text;

use namespace::clean -except => 'meta';

with qw(VeryShiny::Container);

has default_type => (
	isa => "Str",
	is  => "ro",
	default => "VeryShiny::Text",
);

sub BUILDARGS {
	my ( $class, @parts ) = @_;
	
	return {
		parts => \@parts,
	};
}

sub body_class {
	my $self = shift;
	$self->default_type;
}

__PACKAGE__->meta->make_immutable;

__PACKAGE__

__END__
