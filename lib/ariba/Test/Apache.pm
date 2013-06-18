package ariba::Test::Apache;

#use Apache::TestRun ();
use ariba::Test::Apache::TestServer;

use Cwd;
use Carp;
use Data::Dumper;
use IO::CaptureOutput qw( capture_exec );

use FindBin;
use lib "$FindBin::Bin/../lib";
use lib "$FindBin::Bin/../../lib";
use lib "$FindBin::Bin/../../../lib";
use lib "$FindBin::Bin/../../../../lib";
use lib "$FindBin::Bin/../../..//../../lib";
use lib "$FindBin::Bin/../../../../../../lib";

sub new {
    my $class = shift;
    my $args = shift;
    my $self = {};

    while ( my ( $key, $val ) = each %{ $args } ){
        $self->{ $key } = $val;
#        print "$key: $val\n";
    }

    $self->{ 'run_dir'     } = getcwd;
    $self->{ 'script_dir'  } = $self->{ 'run_dir'} . '/scripts';
    $self->{ 'mock_script' } = $self->{ 'script_dir' } . '/MojoMock';
    $self->{ 'morbo_exe'   } = $args->{ 'morbo_exe' } || '/usr/local/bin/morbo';
    $self->{ 'test_server' } = ariba::Test::Apache::TestServer->new( $args );

    $self->{ 'mock_pids'   } = {};
    $self->{ 'mock_servs'  } = {};

    ## We run the mocks using morbo, make sure we have it.  Will ensure we have Mojoliciuos as well
    unless ( $self->{ 'morbo_exe' } && -x $self->{ 'morbo_exe' } ){
        croak __PACKAGE__, ": new: Need valid path to morbo executable (part of Mojolicious Perl distro)\n";
    }

    return bless $self, $class;
}

sub start_server {
    my $self = shift;

    return $self->{ 'test_server' }->start();
}

sub stop_server {
    my $self = shift;

    return $self->{ 'test_server' }->stop();
}

sub start_mock2 {
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
#        close STDIN;
#        close STDOUT;
    #    use Mojo::Base 'Mojo::Server';
        use Mojo::Server;
        my $server = Mojo::Server->new;
        my $app = $server->load_app( $self->{ 'mock_script' } );

        print Dumper $server;

        $app->start( 'daemon', '-l', "http://*:$port" );
        $self->{ 'mock_servs' }->{ 'port' } = $app;
    } else {
        $self->{ 'mock_pids' }->{ "$port" } = $pid;
    }

    if ( $self->{ 'debug' } ){
        print Dumper $self->{ 'mock_pids' };
        print Dumper $self->{ 'mock_servs' };
    }

}

sub stop_mock2 {
    my $self = shift;
    my $port = shift || croak __PACKAGE__, ": start_mock: Port required!\n";

    return undef;
}
## morbo --listen http://*:3002 MojoMock
sub start_mock {
    my $self = shift;
    my $port = shift || croak __PACKAGE__, ": start_mock: Port required!\n";

    if ( defined $self->{ 'mock_pids' }->{ "$port" }
        && $self->{ 'mock_pids' }->{ "$port" } =~ /\d+/
    ){
        ## We already have a Mock on this port
        carp __PACKAGE__, ": ERROR: start_mock: Not starting another mock on port '$port'\n";
        return 0;
    }

    my $cmd = "$self->{ 'morbo_exe' } --listen http://*:$port $self->{ 'mock_script' }";
    #my $cmd = "morbo --listen http://*:$port MojoMock 2>&1 /dev/null &";
    my $redir = '2>&1 /dev/null';
    my $bg    = '&';
    my $pid;

    unless ( $pid = fork ){
        ## Child code:
        close STDIN;
        close STDOUT;
        my ( $stdOut, $stdErr, $success, $exitCode ) = capture_exec( $cmd );
#        exec $cmd;
#        exec $cmd, $redir, $bg;
        exit;
    } else {
        ## Parent - track port -> PID map:
#        $self->{ 'mock_pids' }->{ "$port" } = $pid;
        ## hmmm, seemed to be 1 higher than the returned PID, now it's not ...
        $self->{ 'mock_pids' }->{ "$port" } = ++$pid;
    }
#    print Dumper $self->{ 'mock_pids' };
}

sub stop_mock {
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

