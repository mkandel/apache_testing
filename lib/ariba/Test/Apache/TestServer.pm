#------------------------------------------------------------------------------
# $Id$
# $HeadURL$
#------------------------------------------------------------------------------
package ariba::Test::Apache::TestServer;

use warnings;
use strict;

use Data::Dumper;
# Some Data::Dumper settings:
local $Data::Dumper::Useqq  = 1;
local $Data::Dumper::Indent = 3;

use IO::CaptureOutput qw( capture_exec );
use Carp;
use Cwd;

use FindBin;
use lib "$FindBin::Bin/../../lib";
use ariba::rc::Utils;

local $| = 1;

=head1 NAME

ariba::Test::Apache::TestServer - Discrete class representing the Apache server under test

=head1 VERSION

Version 0.01

=cut

use version; our $VERSION = '0.01';

=head1 SYNOPSIS

    use ariba::Test::Apache::TestServer;

    my $server = ariba::Test::Apache::TestServer->new({ port => 8080 });

    $server->start();
    ... Run some tests ...
    $server->restart();
    ... Run some tests ...
    $server->stop();

=head1 DESCRIPTION

These mock http servers are useful as workers for testing load balancing, mod JK config, WO config.  

The mock is based on Mojolicious, a Perl web framework.  This is all contained in one Mojolicious script which can be extended to offer more complex test scenarios if needed.

=cut

=head1 PUBLIC METHODS

new() 

    FUNCTION: Instantiate a ariba::Test::Apache::TestServer object

   ARGUMENTS: debug - Enable debugging for this module
           
     RETURNS: A ariba::Test::Apache::TestServer object

=cut

sub new{
    my $class = shift;
    my $args = shift;
    my $self = {};

    while ( my ( $key, $val ) = each %{ $args } ){
        $self->{ $key } = $val;
        print "$key: $val\n" if $args->{ 'debug' };
    }

    ## Setting some defaults
    $self->{ 'run_dir' } = getcwd;
    $self->{ 'port' } = $args->{ 'port' } || 8080
        unless $self->{ 'port' };
    $self->{ 'apache_home' } = $args->{ 'apache_home' } || '/opt/apache'
        unless $self->{ 'apache_home' };
    $self->{ 'apache_conf' } = $args->{ 'apache_conf' }
        || "$self->{ 'run_dir' }/conf/httpd.conf"
        || "$self->{ 'apache_home' }/conf/httpd.conf"
        unless $self->{ 'apache_conf' };
    $self->{ 'action' } = $args->{ 'action' } || 'nop' ## Dummy default to 'No Op'
        unless $self->{ 'action' };

    ## Calculate this from apache_home
    $self->{ 'apachectl' } = ariba::rc::Utils::sudoCmd() ." $self->{ 'apache_home' }/bin/apachectl"
        unless $self->{ 'apachectl' };

    if ( $self->{ 'debug' } ){
        print __PACKAGE__, ": Created object:\n";
        print Dumper $self;
    }

    return bless $self, $class;
}

=head1

start()/stop()/restart()/graceful()/graceful_stop()

    FUNCTION: Starts/Stops/Restarts the apache server

   ARGUMENTS: None
           
     RETURNS: True (1) if action suceeds, (0) if action fails, croak's on unrecoverable error

=cut

sub AUTOLOAD {
    my $self = shift;
    our $AUTOLOAD;
    return if $AUTOLOAD =~ /::DESTROY$/;
    if ( $self->{ 'debug' } ) {
        print __PACKAGE__, ": AUTOLOAD: Got '$AUTOLOAD'\n";
    }
    $AUTOLOAD =~ m/.*::(\w+)$/;
    my $action = $1;

    ## Valid apachectl options
    ## start|restart|graceful|graceful-stop|stop
    my %valid_actions = (
        'start'         => 1,
        'stop'          => 1,
        'restart'       => 1,
        'graceful'      => 1, ## graceful restart
        'graceful_stop' => 1, ## graceful stop - probably not useful ...
        'nop'           => 1, ## default/dummy 'No Op'
    );
    if ( $self->{ 'debug' } ) {
        print Dumper \%valid_actions;
        print __PACKAGE__, ": AUTOLOAD: Got '$action' from '$AUTOLOAD'\n";
    }

    unless ( defined $valid_actions{ "$action" } && $valid_actions{ "$action" } == 1 ){
        croak __PACKAGE__, ": Invalid action '$action'";
    }

    return $self->_apachectl( $action );
}

=head1

is_running()

    FUNCTION: Starts/Stops/Restarts the apache server

   ARGUMENTS: None
           
     RETURNS: True (1) if action suceeds, (0) if action fails, croak's on unrecoverable error

=cut

sub is_running {
    my $self = shift;

    return ( defined $self->{ 'is_running' } && $self->{ 'is_running' } == 1 )
        ? 1
        : 0;
}

=head1 PRIVATE METHODS

_apachectl()

    FUNCTION: 

   ARGUMENTS: Action to perform: start/stop/restart/graceful/graceful-stop

     RETURNS: True (1) if action suceeds, (0) if action fails

=cut

sub _apachectl {
    my $self   = shift;
    my $action = shift || croak __PACKAGE__, ": apachectl: action is a required argument, exiting.\n";

    return 1 if $action eq 'nop'; ## Default 'No Op'

    $action =~ s/_/-/; ## convert graceful_stop to graceful-stop for commandline

    my $cmd = "$self->{ 'apachectl' } $action -f $self->{ 'apache_conf' }";

    if ( $self->{ 'debug' } ){
        print __PACKAGE__, ": Action: '$action'\n";
        print __PACKAGE__, ": Calling '$cmd'\n";
    }

    my ( $stdOut, $stdErr, $success, $exitCode ) = capture_exec( $cmd );
    ## Print Errors
    if ( $stdErr ){
        ## Except debug
        if ( $stdErr !~ /:debug/ ){
            print __PACKAGE__, ": '$action' returned Error:\n$stdErr\n";
        }
    }

    ## Set/unset is_running appropriately
    if ( $action eq 'start' && $success ){ 
        if ( $self->is_running() ){
            carp "Not starting again, server is already running.\n";
            return 1; ## return success since we're running and that's what was asked of us
        }
        $self->{ 'is_running' } = 1;
    } elsif ( $success && $action =~ /stop/ ){
        unless ( $self->is_running() ){
            carp "Not stopping server, server is already stopped.\n";
            return 1; ## return success since we're running and that's what was asked of us
        }
        delete $self->{ 'is_running' };
    }

    return $success;
}

=head1 AUTHOR

Marc Kandel C<< <mkandel at ariba.com> >>

=head1 LICENSE

Copyright 2013 Ariba, Inc. (an SAP Company)

=cut

1; # End of Module

__END__

