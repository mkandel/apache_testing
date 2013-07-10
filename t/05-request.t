#!/usr/local/bin/perl -w
use strict; use warnings;

use Test::More tests => 10;
use Test::Exception;
use Test::Warn;

use lib 'lib';
use lib '../lib';
use ariba::Test::Apache::MockServer;

sub module_under_test { return 'ariba::Test::Apache::Request' };

BEGIN{
    use_ok( module_under_test() );
}

## Method tests
{
    my @methods = qw{ new url get resp_time resp _has_timing };
    can_ok( module_under_test(), @methods );
}

## Functionality testing
{
    my $mock = ariba::Test::Apache::MockServer->new();
    my $port = 9898;

    $mock->start( $port );
    sleep 3; ## Give the mock a few seconds to come up

    my $url = "http://127.0.0.1:$port";

    my $req1_exp = <<EOT;
<!DOCTYPE html>
<html>
  <head><title>Balancer Testing</title></head>
  <body>Listening on port: $port
</body>
</html>
EOT

    my $req1 = module_under_test()->new({ url => $url });
    my $req2 = module_under_test()->new({ debug => 1 });
    
    my $req1_resp = $req1->get();
    ok( $req1_resp, 'Get with URL in constructor' );

    is( $req2->_has_timing(), 0, 'Should not have timing if we ahvent run got()' );
    is( $req2->url(), undef, 'url() should return undef if not set' );
    throws_ok { $req2->get() } qr{Must set a URL to get}, 'Attempt to get() wihout setting a URL';
    is( $req2->resp_time(), undef, 'response time is undef before get()' );
    ok( $req2->get( "$url/sleep/" ), 'Get with URL in call' );

    ok( $req1->resp_time(), 'Got response time' );

    is( $req1->resp->decoded_content(), $req1_exp, 'Got expected result from req1' );

#    print "req1: ", $req1->resp->decoded_content(), "\n";
#    print "req2: ", $req2->resp->decoded_content(), "\n";

    ## Stop the mock now that we're done with it
    $mock->stop( $port );
}
__END__

