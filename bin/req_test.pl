#!/usr/local/bin/perl -w
# $Id:$
# $HeadURL:$
use strict;
use warnings;

use Carp;
use Getopt::Long;
Getopt::Long::Configure qw/bundling no_ignore_case/;
use Data::Dumper;
# Some Data::Dumper settings:
local $Data::Dumper::Useqq  = 1;
local $Data::Dumper::Indent = 3;
use Pod::Usage;

my $mydebug = 0;
my $dryrun  = 0;

GetOptions(
    "help|h"         => sub { pod2usage( 1 ); },
    "debug|d"        => \$mydebug,
    "dryrun|n"       => \$dryrun,
);

my $port = 8080;
my $url = "http://127.0.0.1:$port/sleep/2";

my $prog = $0;
$prog =~ s/^.*\///;

use lib './lib';
use ariba::Test::Apache::RequestPool;
use ariba::Test::Apache::Request;

sub test_request {
    my $req = ariba::Test::Apache::Request->new({ debug => $mydebug });

    $req->get( $url );

#    print Dumper $req;

    print_req( $req );
    return 0;
}

sub test_pool {
    my $req_pool = ariba::Test::Apache::RequestPool->new({ num_reqs => 10, debug => $mydebug });

    print "This should fail: \n";
    $req_pool->get_all();
    exit;
    
    while ( my $req = $req_pool->next_req() ){
        $req->url( $url );
    }

    $req_pool->get_all();

    my $tot = 0;
    my $print = 0;
    while ( my $req = $req_pool->next_req() ) {
#        print Dumper $req;
        print "Handling obj: $req->{name}\n";
        $tot += $req->resp_time();
        print_req( $req, $print++ );
    }
    my $avg = $tot/$print;
    print "Average request time: $avg seconds (", $avg * 1000000, " microseconds)\n";
#    print Dumper $req_pool;
    return 0;
}

sub print_req {
    my $req = shift;
    my $print = shift || 0;

#    unless ( $print ) {
#        print "Resp: \n";
#        print Dumper $req->resp();
#    }

    print "Request return code: ", $req->resp->code, "\n";
#    print "Response contents:\n";
#    print $req->resp->content();
    print "Response received in ", $req->resp_time(), " seconds (", $req->resp_time() * 1000000, " microseconds)\n";
}

#test_request();
#print "########################################################\n";
test_pool();

__END__

