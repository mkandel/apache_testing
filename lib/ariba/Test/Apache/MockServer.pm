package ariba::Test::Apache::MockServer;

use IO::CaptureOutput qw( capture_exec );
use Carp;
use Data::Dumper;
use Cwd;

use FindBin;
use lib "$FindBin::Bin/../../lib";
use ariba::rc::Utils;

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
    $self->{ 'test_server' } = ariba::Test::Apache::TestServer->new( $args );

    $self->{ 'mock_pids'   } = {};

    if ( $self->{ 'debug' } ){
        print "Dumping ariba::Test::Apache::MockServer ISA:\n";
        print Dumper \@ISA;
        print Dumper $self;
    }

    return bless $self, $class;
}

sub start {
    my $self = shift;
    my $port = shift || croak __PACKAGE__, ": start_mock: Port required!\n";

    if ( defined $self->{ 'mock_pids' }->{ "$port" }
        && $self->{ 'mock_pids' }->{ "$port" } =~ /\d+/
    ){
        ## We already have a Mock on this port
        carp __PACKAGE__, ": ERROR: start_mock: Not starting another mock on port '$port'\n";
        return 0;
    }

    unless ( $pid = fork ){
        use Mojo::Server::Daemon;
        my $server = Mojo::Server::Daemon->new( listen => ["http://*:$port"] );
        my $app = $server->load_app( $self->{ 'mock_script' } );

        $server = $server->silent( 1 );

        $server->run;
    } else {
        $self->{ 'mock_pids' }->{ "$port" } = $pid;
    }

    if ( $self->{ 'debug' } ){
        print Dumper $self->{ 'mock_pids' };
    }
}

sub stop {
    my $self = shift;
    my $port = shift || croak __PACKAGE__, ": stop_mock: Port required!\n";


    if ( defined $self->{ 'mock_pids' }->{ "$port" }
        && $self->{ 'mock_pids' }->{ "$port" } =~ /\d+/
    ){
        if ( $self->{ 'debug' } ){
            print "Calling 'kill 9, $self->{ 'mock_pids' }->{ \"$port\" }'\n";
        }
        kill 9, $self->{ 'mock_pids' }->{ "$port" };
        delete $self->{ 'mock_pids' }->{ "$port" };
    } else {
        carp "Cannot kill mock for port '$port': No mock running on that port!\n";
    }
}

1;

__END__

