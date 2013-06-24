#!/usr/local/bin/perl -w

use Test::More tests => 18;
use Test::Exception;
use Test::Differences;
use Test::Warn;

use lib 'lib';
use lib '../lib';

sub module_under_test { return 'ariba::Test::Apache::TestServer' };

my $port = 8080;

BEGIN{
    use_ok( module_under_test() );
}

## Method tests
{

    my @methods = qw{ is_running new };
    can_ok( module_under_test(), @methods );

}

## Test the server object itself:
{
    my $server = ariba::Test::Apache::TestServer->new({ port => $port, debug => 0 });
    my @methods = qw{ start stop restart graceful graceful_stop };
    foreach my $method ( @methods ){
        #diag( "Testing ariba::Test::Apache::TestServer->$method() ('$method')" );
        my $expected_success = 1;
        my $result = $server->$method();
        is( $result, $expected_success, "Testing ariba::Test::Apache::TestServer->$method()" );
    }

    ok( $server->start(), '$server->start()' );
    ok( $server->is_running(), 'Server is running' );
    ok( $server->nop(), '$server->nop() - dummy no op' );
    ok( $server->restart(), '$server->restart()' );
    ok( $server->graceful(), '$server->graceful()' );
    ok( $server->graceful_stop(), '$server->graceful_stop()' );
    ## Start again so we can try stop()
    $server->start();
    warning_like { $server->start() } qr/Not starting again, server is already running/
        , 'Warn about attempt to start running server';
    ok( $server->stop(), '$server->stop()' );
    ## Since the server is down this should report an error (croak)
    warning_like { $server->stop() } qr/Not stopping server, server is already stopped/
        , 'Warn about attempt to stop stopped server';
    ok( ! $server->is_running(), 'Server is not running' );

    throws_ok { $server->bad_method_name() } qr/: Invalid action /, 'Properly handle invalid action';
}

__END__

