#------------------------------------------------------------------------------
# $Id$
# $HeadURL$
#------------------------------------------------------------------------------
package ariba::Test::Apache;

use warnings;
use strict;

use Data::Dumper;
# Some Data::Dumper settings:
local $Data::Dumper::Useqq  = 1;
local $Data::Dumper::Indent = 3;

use Cwd;
use Carp;
use IO::CaptureOutput qw( capture_exec );

use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../lib";
use lib "$FindBin::Bin/../../../lib";
use lib "$FindBin::Bin/../../../../lib";
use lib "$FindBin::Bin/../../..//../../lib";
use lib "$FindBin::Bin/../../../../../../lib";

use ariba::Test::Apache::TestServer;
use ariba::Test::Apache::MockServer;

local $| = 1;

=head1 NAME

ariba::Test::Apache - Base class for running the Ariba Apache test suite

=head1 VERSION

Version 0.01

=cut

use version; our $VERSION = '0.01';


=head1 SYNOPSIS

    use ariba::Test::Apache;

    my $apache_test  = ariba::Test::Apache->new({ port => 8888 });
    my $return = $apache_test->start_server();
    ... Do some testing ...
    $return = $apache_test->stop_server();

=head1 DESCRIPTION

This is a frame work for testing arbitrary versions of Apache for use at Ariba.

Background: Ariba is hesitant to upgrade Apache due to our inability to pre-qualify an Apache version as "OK" for the functionality Ariba uses.  This framework is an attempt to provide this ability to pre-qualify Apache.  This pre-qualification will better ensure that QA will not be wasting time trying to test an Apache version that will not work with Ariba products.

=cut

=head1 PUBLIC METHODS

new() 

    FUNCTION: Instantiate an ariba::Test::Apache onject

   ARGUMENTS: None are required.
                debug - Enable debug for this and all related modules (default: 0)
                port - TCP port that Apache should listen on (default: 8080)
                apache_home - Base directory for Apache you are testing (default: /opt/apache)
                apache_conf - Apache configuration file to use (default: .//conf/httpd.conf - Relative to this framework)
           
     RETURNS: An ariba::Test::Apache object

       NOTES: Any special notes

=cut

sub new {
    my $class = shift;
    my $args = shift;
    my $self = {};

    while ( my ( $key, $val ) = each %{ $args } ){
        $self->{ $key } = $val;
        print "$key: $val\n" if $args->{ 'debug' };
    }

    $self->{ 'test_server' } = ariba::Test::Apache::TestServer->new( $args );
    $self->{ 'args'        } = $args;
    $self->{ 'mock_srvs'   } = {};

    return bless $self, $class;
}

=head1

start_server()/stop_server() 

    FUNCTION: Start/Stop Apache under test

   ARGUMENTS: None
           
     RETURNS: True (1) if action is successful, False (0) if not

=cut

sub start_server {
    my $self = shift;

    if ( $self->{ 'test_server' }->is_running() ){
        croak "Server already started, can't call start again.\n";
    }
    return $self->{ 'test_server' }->start();
}

sub stop_server {
    my $self = shift;

    unless ( $self->{ 'test_server' }->is_running() ){
        croak "Server not started, can't call stop.\n";
    }
    return $self->{ 'test_server' }->stop();
}

=head1

start_mock()/stop_mock() 

    FUNCTION: Start/Stop a mock server

   ARGUMENTS: port - the TCP port to start the mock on.  Also used to 
              select proper mock to stop.  REQUIRED for both start and stop
           
     RETURNS: True (1) if action is successful, False (0) if not

       NOTES: These mocks are useful as workers

=cut

sub start_mock {
    my $self = shift;
    my $port = shift || croak __PACKAGE__, ": start_mock: Port required!\n";

    $self->{ 'mock_srvs' }->{ "$port" } = ariba::Test::Apache::MockServer->new( $self->{ 'args' } );
    return $self->{ 'mock_srvs' }->{ "$port" }->start( $port );
}

sub stop_mock {
    my $self = shift;
    my $port = shift || croak __PACKAGE__, ": stop_mock: Port required!\n";

    ## I would just 'return $self->blah->stop' but i want to delete the hash element after stopping
    my $retval = $self->{ 'mock_srvs' }->{ "$port" }->stop( $port );
    delete $self->{ 'mock_srvs' }->{ "$port" };
    return $retval;
}

=head1 AUTHOR

Marc Kandel C<< <mkandel at ariba.com> >>

=head1 LICENSE

Copyright 2013 Ariba, Inc. (an SAP Company)

=cut

1; # End of Module

__END__

