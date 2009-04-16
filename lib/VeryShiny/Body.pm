package VeryShiny::Body;
use Moose::Role;

use namespace::clean -except => 'meta';

our $DEFAULT_BODY_TYPE = "VeryShiny::Text";

around BUILDARGS => sub {
	my ( $next, $self, @args ) = @_;

	if ( @args % 2 and not ref $args[0] ) {
		unshift @args, "body";
	}

	$self->$next(@args);
};

__PACKAGE__

__END__
