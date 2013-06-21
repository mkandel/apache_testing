#!/usr/local/bin/perl -w

use Test::More qw(no_plan);

use lib 'lib';
use lib '../lib';

my $tests_run = 0;
sub module_under_test { return 'ariba::Test::Apache::MockServer' };

use_ok( module_under_test() );

#done_testing( $tests_run );
