package Color;
use v5.32;
use warnings;
use feature 'signatures';
no warnings 'experimental::signatures';
use Term::ANSIColor qw(colored);
use Sub::Exporter -setup => {
    exports => [ qw(black red green yellow blue magenta cyan white) ],
};

# creates a new function with color partial applied
sub create_colored ($color) {
    return sub {
        my ($str) = @_;
        return colored([$color], $str);
    }
}

for my $color ( qw/black red green yellow blue magenta cyan white/ ) {
    no strict 'refs';
    *$color = create_colored($color);
}

1;
