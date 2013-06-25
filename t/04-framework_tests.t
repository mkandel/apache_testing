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

    my $port1 = 8080;
    my $port2 = 8081;
    my $mock1 = 9090;
    my $mock2 = 9091;

    my $fw1 = module_under_test()->new({ port => 8081 });
    my $fw2 = module_under_test()->new({ 
            port => 8081,
            debug => 1,
            apache_home => '/opt/apache',
            apache_conf => '/home/mkandel/src/POC/apache_testing/ariba_tests/framework/conf/apache_configs/httpd.conf',
            apachectl   => '/opt/apache/bin/apachectl',
            action      => 'nop',
    });
    
    my @serv_methods = qw{ start_server stop_server };

    foreach my $method ( @serv_methods ){
        #diag( "Testing ariba::Test::Apache::TestServer->$method() ('$method')" );
        my $expected_success = 1;

        my $result = $fw1->$method();
        is( $result, $expected_success, "Testing ariba::Test::Apache::TestServer->$method()" );

#        my $result = $fw2->$method();
#        is( $result, $expected_success, "Testing ariba::Test::Apache::TestServer->$method()" );
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
}

__END__

