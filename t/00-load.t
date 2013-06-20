#!/usr/local/bin/perl -w

use Test::More tests => 3;

use lib 'lib';
use lib '../lib';

BEGIN {
    use_ok( 'ariba::Test::Apache' ) || print "Bail out!\n";
    use_ok( 'ariba::Test::Apache::TestServer' ) || print "Bail out!\n";
    use_ok( 'ariba::Test::Apache::MockServer' ) || print "Bail out!\n";
}

#diag( "Testing ariba::Test::Apache $ariba::Test::Apache::VERSION, Perl $], $^X" );
#diag( "Testing ariba::Test::Apache::TestServer $ariba::Test::Apache::TestServer::VERSION, Perl $], $^X" );
#diag( "Testing ariba::Test::Apache::MockServer $ariba::Test::Apache::MockServer::VERSION, Perl $], $^X" );
