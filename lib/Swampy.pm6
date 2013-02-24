
module Swampy {
    my @directives;
    my @turtles;

    sub make-turtle() is export {
        my $turtle-count = @turtles.elems;
        my $next-turtle = "t" ~ ($turtle-count + 1);
        @turtles.push($next-turtle);
        return $next-turtle;
    }

    sub bk($turtle, $distance) is export {
        @directives.push("bk($turtle, $distance)");
    }

    sub dump-canvas() is export {
        @directives.push("world.canvas.dump()");
    }

    sub fd($turtle, $distance) is export {
        @directives.push("fd($turtle, $distance)");
    }

    sub kill-turtle($turtle) is export {
        @directives.push("die($turtle)");
    }

    sub lt($turtle, $angle=90) is export {
        @directives.push("lt($turtle, $angle)");
    }

    sub pd($turtle) is export {
        @directives.push("pd($turtle)");
    }

    sub pu($turtle) is export {
        @directives.push("pu($turtle)");
    }

    sub rt($turtle, $angle=90) is export {
        @directives.push("rt($turtle, $angle)");
    }

    sub set-delay($turtle, $delay) is export {
        @directives.push("$turtle.delay = $delay");
    }

    sub draw-it() is export {
        my $code = @directives.join("\n");
        my $turtle-code = turtle-code();

        my $full-code = qq:to/END/;
from swampy.TurtleWorld import *

world = TurtleWorld()
$turtle-code

$code

wait_for_user()
END

        my $py-name = make-file-name();
        my $python-file = save-code($full-code, $py-name);
        say "Python code is in $python-file";
        run-python-with $python-file;
    }

    # Yes, this is expected to return 'interactive.py' when invoked from
    # an interactive session, and 'app.pl6.py' for the normal case.
    sub make-file-name() {
        PROCESS::<$PROGRAM_NAME> ~ '.py';
    }

    sub save-code($code, $name) {
        # Don't forget props for http://perl6maven.com/perl6-files
        my $handle = open $name, :w;
        $handle.say($code);
        $handle.close;

        return $name;
    }

    sub turtle-code() {
        @turtles.map({ "$_ = Turtle()" }).join("\n")
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

    my $turtle = make-turtle();

    for 1..4 {
        fd($turtle, 100);
        lt($turtle);
    }

    draw-it();

=head1 NOTES

This actually writes a Python script to disk and asks Python to run the script.
Any error handling is done by Python. The filename is reported to the user for
debugging purposes.

Swampy.pm6 will die if it cannot find a python executable. The code generation is
also simplistic at this point. That means Python will be the one catching argument
errors.

=head1 AVAILABLE

=defn C<make-turtle()>

Tell swampy that you want a new turtle for drawing. Returns a name that
you can use to reference this turtle in future instructions.

=defn C<bk($turtle, $distance)>

Move C<$turtle> backward C<$distance> pixels.

=defn C<dump-canvas()>

Write the current canvas to file C<canvas.eps>.

=defn C<fd($turtle, $distance)>

Move C<$turtle> forward $distance pixels.

=defn C<kill-turtle($turtle)>

Shuffle off this mortal C<$turtle>, indicating that no further directives
will be sent its way.

=defn C<lt($turtle, $angle=90)>

Turn C<$turtle> to the left by C<$angle> degrees.

=defn C<pd($turtle)>

Put down C<$turtle>. Moving C<$turtle> around will leave a trail.

=defn C<pu($turtle)>

Pick up C<$turtle>. You can move C<$turtle> without leaving a trail until
you put it down with C<pd>.

=defn C<rt($turtle, $angle=90)>

Turn C<$turtle> to the right by C<$angle> degrees.

=defn C<set-delay($turtle, $delay)>

Change the time between executing directives for C<$turtle>, in seconds. Yes, fractional values are supported.

=defn C<draw-it()>

Write code to disk and execute the instructions. Swampy.pm6 will report the 
name of the written file - usually the name of the current program with a 
C<.py> appended. That's C<interactive.py> when run from an interactive Perl 
6 shell.

=end pod
