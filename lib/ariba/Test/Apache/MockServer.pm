package ariba::Test::Apache::MockServer;

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

local $| = 1;

=head1 NAME

ariba::Test::Apache::MockServer - a Mojolicious based mock http server

=head1 VERSION

Version 0.01

=cut

use version; our $VERSION = '0.01';

=head1 SYNOPSIS

    use ariba::Test::Apache::MockServer;

    my $mock  = ariba::Test::Apache::MockServer->new();
    my $other = ariba::Test::Apache::MockServer->new();

    $mock->start( 8090 );
    $other->start( 8091 );
    ... Run some tests ...
    $mock->stop( 8090 );
    $other->stop( 8091 );

    $mock->start( 8092 );
    $other->start( 8093 );
    ... Run some more tests ...
    $mock->stop( 8092 );
    $other->stop( 8093 );
    

=head1 DESCRIPTION

These mock http servers are useful as workers for testing load balancing, mod JK config, WO config.  

The mock is based on Mojolicious, a Perl web framework.  This is all contained in one Mojolicious script which can be extended to offer more complex test scenarios if needed.

=cut

=head1 PUBLIC METHODS

=item new() 

    FUNCTION: Instantiate a ariba::Test::Apache::MockServer object

   ARGUMENTS: debug - Enable debugging for this module
           
     RETURNS: A ariba::Test::Apache::MockServer object

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
    $self->{ 'run_dir'     } = getcwd;
    $self->{ 'script_dir'  } = $self->{ 'run_dir'} . '/scripts';
    $self->{ 'mock_script' } = $self->{ 'script_dir' } . '/MojoMock';

    $self->{ 'mock_pids'   } = {};
    $self->{ 'debug' } = 0 unless $self->{ 'debug' };

    if ( $self->{ 'debug' } ){
        print __PACKAGE__, ": Created object:\n";
        print Dumper $self;
    }

    return bless $self, $class;
}

=head1

=item start()/stop() 

    FUNCTION: Starts/Stops a mock server

   ARGUMENTS: port - TCP port to listen on.  REQUIRED for both start and stop
           
     RETURNS: N/A, croak's on unrecoverable errors

=cut

sub start {
    my $self = shift;
    my $port = shift || croak __PACKAGE__, ": start: Port required!\n";

    if ( $port !~ /^\d+$/ ){
        croak __PACKAGE__, ": ERROR: start: port must be numeric, you passed '$port'\n";
    }

    if ( defined $self->{ 'mock_pids' }->{ "$port" }
        && $self->{ 'mock_pids' }->{ "$port" } =~ /\d+/
    ){
        ## We already have a Mock on this port
        carp __PACKAGE__, ": ERROR: start: Not starting another mock on port '$port'\n";
        return 0;
    }

    my $pid;
    unless ( $pid = fork ){ # uncoverable branch true ## Devel::Cover uncoverable
        use Mojo::Server::Daemon;
        my $server = Mojo::Server::Daemon->new( listen => ["http://*:$port"] ); # uncoverable statement ## Devel::Cover uncoverable
        my $app = $server->load_app( $self->{ 'mock_script' } ); # uncoverable statement ## Devel::Cover uncoverable

        $server = $server->silent( !$self->{ 'debug' } ); # uncoverable statement ## Devel::Cover uncoverable
        $server->run; # uncoverable statement ## Devel::Cover uncoverable

        return 1; # uncoverable statement ## Devel::Cover uncoverable
    } else {
        $self->{ 'mock_pids' }->{ "$port" } = $pid;

        if ( $self->{ 'debug' } ){
            print Dumper $self->{ 'mock_pids' };
        }

        return 1;
    }

}

sub stop {
    my $self = shift;
    my $port = shift || croak __PACKAGE__, ": stop: Port required!\n";


    if ( $port !~ /^\d+$/ ){
        croak __PACKAGE__, ": ERROR: stop: port must be numeric, you passed '$port'\n";
    }

    if ( defined $self->{ 'mock_pids' }->{ "$port" }
        && $self->{ 'mock_pids' }->{ "$port" } =~ /\d+/
    ){
        if ( $self->{ 'debug' } ){
            print "Calling 'kill 9, $self->{ 'mock_pids' }->{ \"$port\" }'\n";
        }
        kill 9, $self->{ 'mock_pids' }->{ "$port" };
        delete $self->{ 'mock_pids' }->{ "$port" };
        return 1;
    } else {
        carp "Cannot kill mock for port '$port': No mock running on that port!\n";
        return 0;
    }
}

=head1 DEPENDENCIES

IO::CaptureOutput

=head1 AUTHOR

Marc Kandel C<< <mkandel at ariba.com> >>

=head1 LICENSE

Copyright 2013 Ariba, Inc. (an SAP Company)

=cut

1; # End of Module

__END__

