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
    $self->{ 'port' } = $args{ 'port' } || 8080
        unless $self->{ 'port' };
    $self->{ 'apache_home' } = $args{ 'apache_home' } || '/opt/apache'
        unless $self->{ 'apache_home' };
    $self->{ 'apache_conf' } = $args{ 'apache_conf' }
        || "$self->{ 'run_dir' }/conf/httpd.conf"
        || "$self->{ 'apache_home' }/conf/httpd.conf"
        unless $self->{ 'apache_conf' };
    $self->{ 'action' } = $args{ 'action' } || 'nop' ## Dummy default to 'No Op'
        unless $self->{ 'action' };

    ## Calculate this from apache_home
    $self->{ 'apachectl' } = ariba::rc::Utils::sudoCmd() ." $self->{ 'apache_home' }/bin/apachectl"
        unless $self->{ 'apachectl' };

    if ( $self->{ 'debug' } ){
        print "Dumping ariba::Test::Apache::TestServer ISA:\n";
        print Dumper \@ISA;
        print Dumper $self;
    }

    return bless $self, $class;
}

sub AUTOLOAD {
    my ($self) = shift;
    my ($key, $val) = @_;
    our $AUTOLOAD;
    return if $AUTOLOAD =~ /::DESTROY$/;
    my ($action) = $AUTOLOAD =~ m/.*::(\w+)$/;

    ## Valid apachectl options
    ## start|restart|graceful|graceful-stop|stop
    my %valid_actions = (
        'start'         => 1,
        'stop'          => 1,
        'restart'       => 1,
        'graceful'      => 1, ## graceful restart
        'graceful-stop' => 1, ## graceful stop - probably not useful ...
        'nop'           => 1, ## default/dummy 'No Op'
    );
    
    unless ( defined $valid_actions{ $action } && $valid_actions{ $action } == 1 ){
        croak __PACKAGE__, ": Invalid action '$action'";
    }

    return $self->_apachectl( $action );
}

sub _apachectl {
    my $self   = shift;
    my $action = shift || croak __PACKAGE__, ": apachectl: action is a required argument, exiting.\n";

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

