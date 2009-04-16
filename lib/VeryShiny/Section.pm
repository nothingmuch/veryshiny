package VeryShiny::Section;
use Moose;

use namespace::clean -except => 'meta';

with qw(
	VeryShiny::Part
	VeryShiny::Container
);

has slide => (
	isa => "VeryShiny::Slide",
	is  => "ro",
	init_arg => undef,
	lazy_build => 1,
);

has _slide => (
	is => "ro",
	init_arg => "slide",
	required => 1,
);

sub _build_slide {
	my $self = shift;
	$self->new_slide($self->_slide, parent => $self);
}

__PACKAGE__->meta->make_immutable;

__PACKAGE__

__END__
