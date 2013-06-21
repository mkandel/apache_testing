#!/usr/local/bin/perl -w

use Test::More tests => 6;

use lib 'lib';
use lib '../lib';

use_ok( 'ariba::Test::Apache' );
use_ok( 'ariba::Test::Apache::TestServer' );
use_ok( 'ariba::Test::Apache::MockServer' );

my $apache = ariba::Test::Apache->new();
my $server = ariba::Test::Apache::TestServer->new();
my $mock   = ariba::Test::Apache::MockServer->new();

isa_ok( $apache, 'ariba::Test::Apache' );
isa_ok( $server, 'ariba::Test::Apache::TestServer' );
isa_ok( $mock, 'ariba::Test::Apache::MockServer' );
