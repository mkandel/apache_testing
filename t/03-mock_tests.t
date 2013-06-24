#!/usr/local/bin/perl -w

use Test::More qw(no_plan);

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

## Test the server object itself:
{

    my $port1 = 7777;
    my $mock1 = module_under_test()->new();
    my $port2 = 7778;
    my $mock2 = module_under_test()->new();

    my @methods = qw{ start stop };

    foreach my $method ( @methods ){
        #diag( "Testing ariba::Test::Apache::MockServer->$method() ('$method')" );
        my $expected_success = 1;
        my $result = $mock1->$method( $port1 );
        is( $result, $expected_success, "Testing ariba::Test::Apache::MockServer->$method()" );
    }

}

__END__

Errors:

Start a mock on a port with a mock already:
ERROR: start_mock: Not starting another mock on port '$port'

Stop/kill mock that isn't running:
Cannot kill mock for port '$port': No mock running on that port

Bad calls:

start_mock: Port required
stop_mock: Port required
