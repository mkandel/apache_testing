package ariba::Test::Apache::TestServer;

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
    $self->{ 'run_dir' } = getcwd;

    $self->{ 'port' } = 8080
        unless $self->{ 'port' };
    $self->{ 'apache_home' } = '/opt/apache'
        unless $self->{ 'apache_home' };
    $self->{ 'apachectl' } = ariba::rc::Utils::sudoCmd() ." $self->{ 'apache_home' }/bin/apachectl"
        unless $self->{ 'apachectl' };
    $self->{ 'apache_conf' } = "$self->{ 'run_dir' }/conf/httpd.conf"
        unless $self->{ 'apache_conf' };
    $self->{ 'action' } = 'nop' ## Dummy default to 'No Op'
        unless $self->{ 'action' };

    if ( $self->{ 'debug' } ){
        print "Dumping ariba::Test::Apache::TestServer ISA:\n";
        print Dumper \@ISA;
        print Dumper $self;
    }

    return bless $self, $class;
}

sub start {
    my $self = shift;

    return $self->apachectl( 'start' );
}

sub stop {
    my $self = shift;

    return $self->apachectl( 'stop' );
}

sub apachectl {
    my $self   = shift;
    my $action = shift || croak __PACKAGE__, ": apachectl: action is a required argument, exiting.\n";

    ## Valid apachectl options
    ## start|restart|graceful|graceful-stop|stop
    my %valid_actions = (
        'start'       => 1,
        'stop'        => 1,
        'restart'     => 1,
        'graceful'    => 1, ## graceful restart
        'nop'         => 1,
    );
    return 0 unless $valid_actions{ $action } == 1;
    return 1 if $action eq 'nop'; ## Default 'No Op'

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
    return $success;
}

1;

__END__

