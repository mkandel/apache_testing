#!/usr/local/bin/perl -w

use Test::More qw(no_plan);

use lib 'lib';
use lib '../lib';

my $tests_run = 0;
my $module_under_test = 'ariba::Test::Apache::MockServer';

use_ok( "$module_under_test" ) || print "Bail out!\n"; $tests_run++;

done_testing( $tests_run );
