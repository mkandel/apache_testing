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
my $sleep   = 10;

GetOptions(
    "help|h"         => sub { pod2usage( 1 ); },
    "debug|d"        => \$mydebug,
    "dryrun|n"       => \$dryrun,
    "sleep|s=i"      => \$sleep,
);

my $prog = $0;
$prog =~ s/^.*\///;

do_mock();
exit;

my $apache_test  = ariba::Test::Apache->new({ port => 8888 });
print "With args:\n";
print Dumper $apache_test;

my $apache_test2 = ariba::Test::Apache->new();
#print "Without args:\n";
#print Dumper $apache_test2;

my $return;

print "Trying to start apache ...\n";
eval{
    $return = $apache_test->start_server();
};
#print "$@\n" if $@;
print "Call returned: '$return'\n";
#print Dumper $return;

print "Sleeping $sleep seconds ...\n";
sleep $sleep;

print "Apache process list:\n";
my $ps = 'ps -ef | grep http | grep opt | grep -v grep';
my ( $psOut, $psErr, $ps_success, $ps_exitCode ) = capture_exec( $ps );
print "\n$psOut\n";

print "Trying to stop apache ...\n";
eval{
    $return = $apache_test->stop_server();
};
#print "$@\n" if $@;
print "Call returned: '$return'\n";
#print Dumper $return;

print "Sleeping $sleep seconds ...\n";
sleep $sleep;

$ps = 'ps -ef | grep http | grep opt | grep -v grep';
print "Apache process list:\n";
( $psOut, $psErr, $ps_success, $ps_exitCode ) = capture_exec( $ps );
print "\n$psOut\n";

sub do_mock {
    ## Dummy, so I can call start/stop_mock()
    my $apache_test  = ariba::Test::Apache->new({ port => 8888 });
    my $port = 9191;

    print "Starting a Mock on port '$port' ...\n";
    eval{
        $apache_test->start_mock2( $port );
    };
    print "*** $@ ***\n" if $@;

    sleep 5; ## Give Mojo a few seconds to start

    my $mech = WWW::Mechanize->new();
    $mech->get( "http://127.0.0.1:$port/" );
    print "Read from mock on '$port':\n", $mech->content(), "\n";

#    print "Starting a Mock on port '$port' ...\n";
#    eval{
#        $apache_test->start_mock( $port );
#    };
#    print "*** $@ ***\n" if $@;
    #
#    sleep 5; ## Give Mojo a few seconds to start

    $ps = 'ps -ef | grep Mojo | grep -v grep';
    print "Mock process list:\n";
    ( $psOut, $psErr, $ps_success, $ps_exitCode ) = capture_exec( $ps );
    print "\n$psOut\n";

    print "Stopping a Mock on port '$port' ...\n";
    eval{
        $apache_test->stop_mock( $port );
    };
    print "*** $@\n ***" if $@;
}

__END__

