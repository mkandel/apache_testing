#!/usr/local/bin/perl -w

use Test::More tests => 3;

use lib 'lib';
use lib '../lib';

use_ok( 'ariba::Test::Apache' ) || print "Bail out!\n";
use_ok( 'ariba::Test::Apache::TestServer' ) || print "Bail out!\n";
use_ok( 'ariba::Test::Apache::MockServer' ) || print "Bail out!\n";
