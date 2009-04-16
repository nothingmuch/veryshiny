package VeryShiny::Container;
use Moose::Role;

use namespace::clean -except => 'meta';

has parts => (
	isa => "ArrayRef[VeryShiny::Part]",
	is  => "ro",
	init_arg => undef,
	lazy_build => 1,
);

has _parts => (
	is => "ro",
	init_arg => "parts",
	required => 1,
);

sub _build_parts {
	my $self = shift;

	return [ map { $self->new_part($_, parent => $self) } @{ $self->_parts } ];
}

sub new_part {
	my ( $self, $part, @args ) = @_;

	if ( ref $part ) {
		if ( blessed($part) ) {
			if ( $part->does("VeryShiny::Part") ) {
				return $part; 
			} elsif ( $part->does("VeryShiny::Body") ) {
				return $self->new_slide( $part, @args );
			}
		} elsif ( ref $part eq 'HASH' ) {
			$self->new_section( @args, %$part );
		} else {
			die "wtf";
		}
	} else {
		$self->new_slide( $part, @args );
	}
}

sub new_section {
	my ( $self, @args ) = @_;
	VeryShiny::Section->new( @args );
}

sub new_slide {
	my ( $self, $part, @args ) = @_;

	return $part if blessed($part) and $part->isa("VeryShiny::Slide");

	VeryShiny::Slide->new( $part, @args );
}

require VeryShiny::Slide;
require VeryShiny::Part;

__PACKAGE__

__END__
