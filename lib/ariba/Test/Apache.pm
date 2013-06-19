package ariba::Test::Apache;

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

use ariba::Test::Apache::TestServer;
use ariba::Test::Apache::MockServer;

sub new {
    my $class = shift;
    my $args = shift;
    my $self = {};

    while ( my ( $key, $val ) = each %{ $args } ){
        $self->{ $key } = $val;
        print "$key: $val\n" if $args->{ 'debug' };
    }

    $self->{ 'test_server' } = ariba::Test::Apache::TestServer->new( $args );
    $self->{ 'mock_srvs'   } = {};

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

sub start_mock {
    my $self = shift;
    my $port = shift || croak __PACKAGE__, ": start_mock: Port required!\n";

    $self->{ 'mock_srvs' }->{ "$port" } = ariba::Test::Apache::MockServer->new();
    $self->{ 'mock_srvs' }->{ "$port" }->start( $port );
}

sub stop_mock {
    my $self = shift;
    my $port = shift || croak __PACKAGE__, ": stop_mock: Port required!\n";

    $self->{ 'mock_srvs' }->{ "$port" }->stop( $port );
    delete $self->{ 'mock_srvs' }->{ "$port" };
}

1;

__END__

