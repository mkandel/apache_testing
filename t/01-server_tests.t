#!/usr/local/bin/perl -w

use Test::More qw(no_plan);

use lib 'lib';
use lib '../lib';

my $tests_run = 0;

sub module_under_test { return 'ariba::Test::Apache::TestServer' };

BEGIN{
    use_ok( module_under_test() ) || print "Bail out!\n"; $tests_run++;
}

#done_testing( );
#done_testing( $tests_run );
