#!/usr/local/bin/perl -w
use strict; use warnings;

use Test::More qw( no_plan );
#use Test::More tests => 16;
use Test::Exception;
use Test::Warn;

use lib 'lib';
use lib '../lib';

my $tests_run = 0;
sub module_under_test { return 'ariba::Test::Apache' };

BEGIN{
    use_ok( module_under_test() );
}

## Method tests
{
    my @methods = qw{ new stop_server start_server start_mock stop_mock };
    can_ok( module_under_test(), @methods );
}

## Test the mock object(s): 
{

    my $port1 = 8888;
    my $port2 = 8889;
    my $mock1 = 9090;
    my $mock2 = 9091;

    my $fw1 = module_under_test()->new({ port => $port1 });
    my $fw2 = module_under_test()->new({ 
            port => $port2,
            debug => 1,
            apache_home => '/opt/apache',
            apache_conf => 'conf/httpd.conf',
            apachectl   => '/opt/apache/bin/apachectl',
            action      => 'nop',
    });
    
    my @serv_methods = qw{ start_server stop_server };

    foreach my $method ( @serv_methods ){
        #diag( "Testing ariba::Test::Apache::TestServer->$method() ('$method')" );
        my $expected_success = 1;

        my $result = $fw1->$method();
        is( $result, $expected_success, "Testing ariba::Test::Apache::TestServer->$method() (fw1)" );

        $result = $fw2->$method();
        is( $result, $expected_success, "Testing ariba::Test::Apache::TestServer->$method() (fw2)" );
    }

    my @mock_methods = qw{ start_mock stop_mock };
    foreach my $method ( @mock_methods ){
        #diag( "Testing ariba::Test::Apache::TestServer->$method() ('$method')" );
        my $expected_success = 1;

        my $result = $fw1->$method( $mock1 );
        is( $result, $expected_success, "Testing ariba::Test::Apache::TestServer->$method()" );

        $result = $fw2->$method( $mock2 );
        is( $result, $expected_success, "Testing ariba::Test::Apache::TestServer->$method()" );

        throws_ok( sub { $fw1->$method() }, qr/Port required!/
            , 'Must specify port for start_mock and stop_mock actions' );
    }

    throws_ok( sub { $fw1->stop_server() }, qr/Server not started, can't call stop/
        , 'Attempt to stop a server that is not started.' );

    ok( $fw1->start_server(), 'Cleanly start apache' );
    throws_ok( sub { $fw1->start_server() }, qr/Server already started, can't call start again./
        , 'Attempt to start a server that is already started.' );
    ok( $fw1->stop_server(), 'Cleanly stop apache' );
}

__END__

