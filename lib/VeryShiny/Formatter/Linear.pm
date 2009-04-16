package VeryShiny::Formatter::Linear;
use Moose::Role;

use namespace::clean -except => 'meta';

with qw(VeryShiny::Formatter);

requires qw(format_text join_slides format_wrapper);

sub format_parts {
	my ( $self, $slides ) = @_;

	map { $self->format_part($_) } @$slides;
}

sub format_part {
	my ( $self, $part ) = @_;

	if ( $part->isa("VeryShiny::Slide") ) {
		return $self->format_slide($part);
	} else {
		return (
			$self->format_slide($part->slide),
			$self->format_parts($part->parts),
		);
	}
}

sub process {
	my ( $self, $talk ) = @_;

	my @slides = $self->format_parts( $talk->parts );

	return $self->format_wrapper( $self->join_slides(@slides) );
}

sub format_slide {
	my ( $self, $slide ) = @_;

	return $self->format_slide_body( $slide->body );
}

sub format_slide_body {
	my ( $self, $body ) = @_;

	if ( $body->isa("VeryShiny::Text") ) {
		$self->format_text($body);
	} elsif ( $body->isa("VeryShiny::Code") ) {
		$self->format_code($body);
	} elsif ( $body->isa("VeryShiny::HTML") ) {
		$self->format_html($body);
	} else {
		die "unknown format $body";
	}
}

__PACKAGE__

__END__
