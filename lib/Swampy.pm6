
module Swampy {
    my @directives;
    my $turtle = 'turtle';

    sub fd($distance) is export {
        @directives.push("fd($turtle, $distance)");
    }

    sub lt() is export {
        @directives.push("lt($turtle)");
    }

    sub draw-it() is export {
        my $code = @directives.join("\n");

        my $full-code = qq:to/END/;
from swampy.TurtleWorld import *

world = TurtleWorld()
$turtle = Turtle()

$code

wait_for_user()
END

        my $python-file = save-code $full-code;
        say "Python code is in $python-file";
        run-python-with $python-file;
    }

    sub save-code($code, $name='default.py') {
        # Don't forget props for http://perl6maven.com/perl6-files
        my $handle = open $name, :w;
        $handle.say($code);
        $handle.close;

        return $name;
    }

    sub run-python-with($script) {
        my $python = qx{which python}.chomp;

        unless $python {
            die "I expected a Python!";
        }

        my $result = qqx{$python $script}.chomp;

        if $result {
            say "$python output:";
            say $result;
        }
    }
}

=begin pod

=head1 TITLE

Swampy.pm6

=head1 DESCRIPTION

The rough beginnings of a Perl 6 wrapper for Allen Downey's Swampy Python 
library. 

=head1 USAGE

    use v6;
    use Swampy;

    for 1..4 {
        fd(100);
        lt();
    }

    draw-it();

=head1 NOTES

This actually writes a Python script to disk and asks Python to run the script.
Any error handling is done by Python. The filename is reported to the user for
debugging purposes.

Swampy.pm6 will die if it cannot find a python executable.

=head1 AVAILABLE

=over 4

=item fd($distance)

Move the turtle forward $distance pixels, pen down.

=item lt()

Turn the turtle 90 degrees to the left.

=back

=end pod
