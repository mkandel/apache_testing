#!/usr/local/bin/perl -w

use Test::More qw(no_plan);

use lib 'lib';
use lib '../lib';

#my $tests_run = 0;

BEGIN {
    my $module_under_test = 'ariba::Test::Apache::TestServer';

    use_ok( "$module_under_test" ) || print "Bail out!\n"; #$tests_run++;
}

#done_testing( );
#done_testing( $tests_run );
