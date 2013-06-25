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
use IO::CaptureOutput qw( capture_exec );
use WWW::Mechanize;

use FindBin;
use lib "$FindBin::Bin/../lib";
use ariba::Test::Apache;

my $mydebug = 0;
my $dryrun  = 0;
my $sleep   = 5;

GetOptions(
    "help|h"         => sub { pod2usage( 1 ); },
    "debug|d"        => \$mydebug,
    "dryrun|n"       => \$dryrun,
    "sleep|s=i"      => \$sleep,
);

my $prog = $0;
$prog =~ s/^.*\///;

#do_mock();
#exit;

my $apache_test  = ariba::Test::Apache->new({ 
        port => 8888,
        debug => 1,
        apache_home => '/opt/apache',
        apache_conf => '/home/mkandel/src/POC/apache_testing/ariba_tests/framework/conf/httpd.conf',
        apachectl   => '/opt/apache/bin/apachectl',
        action      => 'nop',
});
print "With args:\n";
print Dumper $apache_test;

my $apache_test2 = ariba::Test::Apache->new({ debug => 1 });
#print "Without args:\n";
#print Dumper $apache_test2;

my $return;

print "Trying to start apache ...\n";
eval{
    $return = $apache_test->start_server();
};
print "** $@\n" if $@;
print "Test1 start_server\n";
print "Call returned: '$return'\n";
#print Dumper $return;

print "Trying to start apache ...\n";
eval{
    $return = $apache_test2->start_server();
};
print "** $@\n" if $@;
print "Test2 start_server\n";
print "Call returned: '$return'\n";
#print Dumper $return;

print "Sleeping $sleep seconds ...\n";
sleep $sleep;

print "Apache process list:\n";
my $ps = 'ps -ef | grep http | grep opt | grep -v grep; grep -i listen /tmp/httpd.*';
my ( $psOut, $psErr, $ps_success, $ps_exitCode ) = capture_exec( $ps );
print "\n$psOut\n";

print "Trying to stop apache ...\n";
eval{
    $return = $apache_test->stop_server();
};
print "** $@\n" if $@;
print "Test1 stop_server\n";
print "Call returned: '$return'\n";
#print Dumper $return;

print "Trying to stop apache ...\n";
eval{
    $return = $apache_test2->stop_server();
};
print "** $@\n" if $@;
print "Test2 stop_server\n";
print "Call returned: '$return'\n";
#print Dumper $return;

#do_mock();
exit;

print "Sleeping $sleep seconds ...\n";
sleep $sleep;

$ps = 'ps -ef | grep http | grep opt | grep -v grep';
print "Apache process list:\n";
( $psOut, $psErr, $ps_success, $ps_exitCode ) = capture_exec( $ps );
print "\n$psOut\n";

sub do_mock {
    ## Dummy, so I can call start/stop_mock()
    my $apache_test  = ariba::Test::Apache->new({ port => 8888, debug => $mydebug });
    my $port = 9191;
    my $port2 = 9192;

    eval{
        $apache_test->stop_server();
    };
#    print "This should fail, not a valid action 'blah' ...\n";
#    eval{
#        $apache_test->blah();
#    };
#    print "*** $@ ***\n" if $@;

    print "Starting a Mock on port '$port' ...\n";
    eval{
        $apache_test->start_mock( $port );
    };
    print "*** $@ ***\n" if $@;

    print "Starting a Mock on port '$port2' ...\n";
    eval{
        $apache_test->start_mock( $port2 );
    };
    print "*** $@ ***\n" if $@;

    sleep 5; ## Give Mojo a few seconds to start

    my $mech = WWW::Mechanize->new();
    $mech->get( "http://127.0.0.1:$port/" );
    print "Read from mock on '$port':\n", $mech->content(), "\n";
    $mech->get( "http://127.0.0.1:$port2/" );
    print "Read from mock on '$port2':\n", $mech->content(), "\n";

#    print "Starting a Mock on port '$port' ...\n";
#    eval{
#        $apache_test->start_mock( $port );
#    };
#    print "*** $@ ***\n" if $@;

#    sleep 5; ## Give Mojo a few seconds to start

    print "Stopping a Mock on port '$port' ...\n";
    eval{
        $apache_test->stop_mock( $port );
    };
    print "*** $@ ***\n" if $@;

    print "Stopping a Mock on port '$port2' ...\n";
    eval{
        $apache_test->stop_mock( $port2 );
    };
    print "*** $@ ***\n" if $@;
}

__END__

