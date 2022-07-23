package Color;
use strict;
use warnings;
use Term::ANSIColor qw(colored);
use Sub::Exporter -setup => {
    exports => [ qw(blue red cyan) ],
};

# Ansi Colors Helper
sub create_colored {
    my ($color) = @_;
    return sub {
        my ($str) = @_;
        return colored([$color], $str);
    }
}

*blue = create_colored("blue");
*red  = create_colored("red");
*cyan = create_colored("cyan");

1;
