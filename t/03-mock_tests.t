#!/usr/local/bin/perl -w
use strict; use warnings;

use Test::More tests => 16;
use Test::Exception;
use Test::Warn;

use lib 'lib';
use lib '../lib';

my $tests_run = 0;
sub module_under_test { return 'ariba::Test::Apache::MockServer' };

BEGIN{
    use_ok( module_under_test() );
}

## Method tests
{
    my @methods = qw{ new stop start };
    can_ok( module_under_test(), @methods );
}

## Test the mock object(s): 
{

    my $mock1 = module_under_test()->new({});
    my $mock2 = module_under_test()->new({ debug => 1 });
    my $port1 = 7777;
    my $port2 = 7778;

    my @methods = qw{ start stop };

    foreach my $method ( @methods ){
        #diag( "Testing ariba::Test::Apache::MockServer->$method() ('$method')" );
        my $expected_success = 1;
        my $result = $mock1->$method( $port1 );
        is( $result, $expected_success, "Testing ariba::Test::Apache::MockServer->$method()" );

        ## These should croak:
        throws_ok( sub { $mock1->$method() }, qr/Port required!/, 'Must specify port for start and stop actions' );
    }

    warning_like { $mock1->stop( $port1 ) } qr/Cannot kill mock for port .*: No mock running on that port/i
        , 'Warn about attempt to stop mock without port';

    ok( $mock1->start( $port1 ), 'Start a mock' );

    warning_like { $mock1->start( $port1 ) } qr/ERROR: start_mock: Not starting another mock on port/i
        , 'Warn about attempt to start a mock on a port that already has a mock';

    ok( $mock1->stop( $port1 ), 'Stop a mock' );

    ## Start two mocks concurrently
    ok( $mock1->start( $port1 ), 'Start multiple mocks concurrently' );
    ok( $mock2->start( $port2 ), 'Start multiple mocks concurrently' );
    $mock1->stop( $port1 );
    $mock2->stop( $port2 );

    ## Start two mocks from the same MockServer object.  (not even sure this will work ...)
    ok( $mock1->start( $port1 ), 'Start two mocks from the same MockServer object.' );
    ok( $mock1->start( $port2 ), 'Start two mocks from the same MockServer object.' );
    ok( $mock1->stop( $port1 ), 'Stop two mocks from the same MockServer object.' );
    ok( $mock1->stop( $port2 ), 'Stop two mocks from the same MockServer object.' );

}

__END__

