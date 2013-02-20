perl6-swampy
============

A Perl 6 glue wrapper for the Python Swampy environment - WARNING VERY DUMB

Author
------

Brian Wisti <https://github.com/brianwisti>

Prerequisites
-------------

* [Perl 6](http://perl6.org)
** I am using [Rakudo](http://rakudo.org)
* [Panda](https://github.com/tadzik/panda/)
* [Python](http://python.org)
* [Swampy](http://www.greenteapress.com/thinkpython/swampy/)
* A UNIX-ish system is assumed right now.

Installation
------------

Download [perl6-Swampy](https://github.com/brianwisti/perl6-swampy). Extract it and run `panda install` on the extracted folder.

    $ unzip perl6-swampy-master.zip
    $ panda install ./perl6-Swampy-master

Documentation
-------------

Access existing documentation via `p6doc` once perl6-Swampy is installed.

    $ p6doc Swampy

Usage
-----

Really. It's a bad idea right now. I'm pretty sure it only works on my machine, and only two of the Swampy functions are wrapped. 

Oh, fine.

    use v6;
    use Swampy;

    my $turtle = make-turtle();

    for 1..4 {
        fd($turtle, 100);
        lt($turtle);
    }

    draw-it();

That's it right now. You can go forward and turn right to your heart's content.

Goals
-----

In rough order:

1. Make it a real live module with documentation and tests and stuff
2. Wrap enough Swampy functionality to finish [Think Python](http://thinkpython.com) in [Perl 6](http://blogs.perl.org/mt/mt-search.fcgi?blog_id=270&tag=thinkperl6&limit=20)
3. Interactive mode: you type in a directive, and the little turtle works its magic.

LICENSE
-------

This code is distributed under the terms of The Artistic License 2.0. See [LICENSE](LICENSE.txt)
