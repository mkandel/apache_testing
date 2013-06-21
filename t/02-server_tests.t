#!/usr/local/bin/perl -w

use Test::More tests => 13;
use Test::Exception;

use lib 'lib';
use lib '../lib';

my $tests_run = 0;

sub module_under_test { return 'ariba::Test::Apache::TestServer' };

my $port = 8080;

BEGIN{
    use_ok( module_under_test() ); $tests_run++;
}

my $server = ariba::Test::Apache::TestServer->new({ port => $port });
my $server2 = ariba::Test::Apache::TestServer->new({ port => ++$port, debug => 1 });

my @methods_to_test = qw{ start stop restart graceful graceful_stop };
foreach my $method ( @methods_to_test ){
    #diag( "Testing ariba::Test::Apache::TestServer->$method()" );
    my $expected_success = 1;
    my $result = $server->$method();
    is( $result, $expected_success, "Testing ariba::Test::Apache::TestServer->$method()" );
}

ok( $server->start(), '$server->start()' );
ok( $server->restart(), '$server->restart()' );
ok( $server->graceful(), '$server->graceful()' );
ok( $server->graceful_stop(), '$server->graceful_stop()' );
## Start again so we can try stop()
$server->start();
ok( $server->stop(), '$server->stop()' );
ok( $server->nop(), '$server->nop() - dummy no op' );

dies_ok { $server->bad_method_name() } 'Properly handle invalid action';
#throws_ok( { $server->bad_method_name() }, qr/: Invalid action /, 'Properly handle invalid action' );

#done_testing( );
#done_testing( $tests_run );
