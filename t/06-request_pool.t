#!/usr/local/bin/perl -w
use strict; use warnings;

use Test::More qw( no_plan );
#use Test::More tests => 9;
use Test::Exception;
use Test::Warn;

use lib 'lib';
use lib '../lib';
use ariba::Test::Apache::MockServer;
use ariba::Test::Apache::Request;

sub module_under_test { return 'ariba::Test::Apache::RequestPool' };

BEGIN{
    use_ok( module_under_test() );
}

## Method tests
{
    my @methods = qw{ new get_all next_req _mk_iter };
    can_ok( module_under_test(), @methods );
}

## Functionality testing
{
    my $mock = ariba::Test::Apache::MockServer->new();
    my $port = 9898;
    my $pool_size = 5;

    $mock->start( $port );
    sleep 3; ## Give the mock a few seconds to come up

    my $url = "http://127.0.0.1:$port";

    my $req_exp = <<EOT;
<!DOCTYPE html>
<html>
  <head><title>Balancer Testing</title></head>
  <body>Listening on port: 9898
</body>
</html>
EOT

    my $req_pool = module_under_test()->new({ num_reqs => $pool_size });

    ## Test more code paths ... not going to use $req_pool2 otherwise
    my $req_pool2 = module_under_test()->new({ debug => 1, num_reqs => $pool_size });
    $req_pool2 = module_under_test()->new();
    $req_pool2 = module_under_test()->new({ num_reqs => 10000 });

    is( $req_pool->pool_size, $pool_size, 'Pool is the correct size');

#    dies_ok { $req_pool->get_all() } 'get_all on an pool without setting URLs';
#    throws_ok { $req_pool->get_all() } qr{Must set a URL to get}, 'Attempt to get() wihout setting a URL';

    while ( my $req = $req_pool->next_req() ){
        is( $req->resp_time(), undef, 'response time is undef before get()' );
        $req->url( $url );
    }

    ok( $req_pool->get_all(), 'get_all() returned successfully' );

    my $count = 0;
    while ( my $req = $req_pool->next_req() ){
        is( $req->resp->decoded_content(), $req_exp, 'Got expected response for reqest' );
        ok( $req->resp_time(), 'Response has a response time attribute' );
        $count++;
    }

    ## Double check the request counts
    is( $count, $pool_size, 'Verify counting' );
    
    ## Stop the mock now that we're done with it
    $mock->stop( $port );
}
__END__

