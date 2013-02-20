
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
        my $result = qqx{$python $script}.chomp;

        if $result {
            say "$python output:";
            say $result;
        }
    }
}

=begin pod

=head1 DESCRIPTION

The rough beginnings of a Perl 6 wrapper for Allen Downey's Swampy Python 
library. 

=end pod
