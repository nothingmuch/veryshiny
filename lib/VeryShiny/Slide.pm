package VeryShiny::Slide;
use Moose;

use namespace::clean -except => 'meta';

with qw(VeryShiny::Part);

has body => (
	does => "VeryShiny::Body",
	is  => "ro",
	init_arg => undef,
	lazy_build => 1,
);

has _body => (
	is => "ro",
	init_arg => "body",
	required => 1,
);

sub _build_body {
	my $self = shift;

	$self->new_body($self->_body);
}

sub BUILDARGS {
	my ( $self, @args ) = @_;

	unshift @args, "body" if @args % 2;

	return { @args };
}

__PACKAGE__->meta->make_immutable;

__PACKAGE__

__END__
