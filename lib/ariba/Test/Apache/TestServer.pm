package ariba::Test::Apache::TestServer;
#use base 'Apache::TestRun';
#use Apache::Test;

use FindBin;
use lib "$FindBin::Bin/../../lib";
use ariba::rc::Utils;
use IO::CaptureOutput qw( capture_exec );
use Carp;

sub new{
    my $class = shift;
    my $args = shift;
    my $self = {};

    while ( my ( $key, $val ) = each %{ $args } ){
        $self->{ $key } = $val;
#        print "$key: $val\n";
    }

    ## Setting some defaults
#    $self->{ 'sudoCmd'     } = ariba::rc::Utils::sudoCmd();
    $self->{ 'port'        } = 8080
        unless $self->{ 'port' };
    $self->{ 'apache_home' } = '/opt/apache'
        unless $self->{ 'apache_home' };
    $self->{ 'apachectl'   } = ariba::rc::Utils::sudoCmd() ." $self->{ 'apache_home' }/bin/apachectl"
        unless $self->{ 'apachectl'   };
    $self->{ 'apache_conf' } = "$self->{ 'apache_home' }/conf/httpd.conf" unless $self->{ 'apache_conf' };
#    $self->{ 'action'      } = 'nop' unless $self->{ 'action' };

    use Data::Dumper;
#    print "Dumping ariba::Test::Apache::TestServer ISA:\n";
#    print Dumper \@ISA;
#    print Dumper $self;

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
    my %validOptions = (
        'start'    => 1,
        'stop'     => 1,
        'restart'  => 1,
    );
    my $cmd = "$self->{ 'apachectl' } $action";

#    print __PACKAGE__, ": Calling '$cmd'\n";

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

#sub new_test_config {
#    my $self = shift;
#
#    $self->{conf_opts}->{authname}      = 'Ariba, Inc.';
#    $self->{conf_opts}->{httpd}         = '/opt/apache/bin/httpd';
#    $self->{conf_opts}->{httpd_conf}    = '/opt/apache/conf/httpd.conf';
#
#    return $self->SUPER::new_test_config;
#}
#
#sub bug_report {
#    my $self = shift;
#
#    print <<EOI;
#+--------------------------------------------------------+
#| Error encountered, open a Tools ticket ...             |
#+--------------------------------------------------------+
#EOI
#}

1;

__END__

