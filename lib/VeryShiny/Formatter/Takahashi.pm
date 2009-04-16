package VeryShiny::Formatter::Takahashi;
use Moose;

use namespace::clean -except => 'meta';

use Statistics::Descriptive;

with qw(VeryShiny::Formatter::Linear);

# the rewrapping logic is very kludgy
# basically it shits words around lines (up to a maximum of 3) as long as
# the standard deviation seems to be going down

# a more complete solution would be to permute all combinations and sort
# them by standard deviation, but this is good enough and not NP complete

# it tries to select the most balanced rectangular text shape
# unfortunately it assumes monospace... ;-)

sub wrap {
	my ( $self, $text, $target ) = @_;

	my @symbols = ( $text =~ /(?<=\s)([^\w\s]+)(?=\s)/g );

	if ( @symbols == 1 ) {
		# split on symbol
		return join "\n", split /\s+([^\w\s]+)\s+/, $text;
	} else {
		my @lines = ( [ split /\s+/, $text ] );

		my ( $formatted, $score ) = $self->_optimize_wrap([ [], @lines], length($text));

		return join "\n", map { join " ", @$_ } @$formatted;
	}
}

sub _optimize_wrap {
	my ( $self, $lines, $dev ) = @_;

	my $prev;

	my @copy = map { [@$_] } @$lines;

	foreach my $cur ( reverse @copy ) {
		if ( $prev and @$prev >= 2 ) {
			my $d = $dev;
			do {
				push @$cur, shift @$prev
			} while @$prev > 2 and $d > ( $d = abs(length(join(' ', @$prev)) - length(join(' ', @$cur))));
		}

		$prev = $cur;
	}

	# stop if any line was emptied, can't shuffle around anymore
	foreach my $line ( @copy ) {
		return ( $lines, $dev ) if not @$line;
	}

	my $s = Statistics::Descriptive::Full->new;
	$s->add_data( map { length(join " ", @$_) } @copy );
	my $new_dev = $s->standard_deviation / $s->geometric_mean;

	if ( $new_dev >= $dev ) {
		# no more improvement, try adding a line
		if ( @copy < 3 ) {
			my ( $more, $more_dev ) = $self->_optimize_wrap([ [], @$lines ], $dev);

			if ( $more_dev < $dev ) {
				return ( $more, $more_dev );
			}
		}

		return ( $lines, $dev );
	} else {
		# still improving, repeat
		return $self->_optimize_wrap(\@copy, $new_dev);
	}
}

sub format_text {
	my ( $self, $body ) = @_;

	my $text = $body->body;

	if ( length($text) >= 10 and $text !~ /\n/ ) {
		my $target = 1 + ( length($text) / ( length($text) > 20 ? 3 : 2 ) ); # no more than 3 lines

		return $self->wrap($text, $target);
	} else {
		return $text;
	}
}

sub format_code {
	my ( $self, $body ) = @_;

	return "[[PRE:\n" . $body->body . "\n]]";

	my $code = $body->body;
	$code =~ s/^/    /mg;
	return $code;
}

sub format_html {
	my ( $self, $body ) = @_;
	use HTML::Entities qw(encode_entities);
	return "[[RAW:\n" . $body->body . "\n]]";
}

sub join_slides {
	my ( $self, @slides ) = @_;
	join "\n----\n", @slides;
}

sub format_wrapper {
	my ( $self, $inner ) = @_;
	return "$inner\n";
}

__PACKAGE__->meta->make_immutable;

__PACKAGE__

__END__
