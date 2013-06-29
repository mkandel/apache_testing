#------------------------------------------------------------------------------
# $Id$
# $HeadURL$
#------------------------------------------------------------------------------
package ariba::Test::Apache::RequestPool;

use warnings;
use strict;

use Data::Dumper;
# Some Data::Dumper settings:
local $Data::Dumper::Useqq  = 1;
local $Data::Dumper::Indent = 3;

use Carp;
use Cwd;
use IO::CaptureOutput qw( capture_exec );
use Time::HiRes;

use Parallel::ForkManager;
##  ^^^^^^^^^^^^^^^^^^^^^
## See docs at http://search.cpan.org/~szabgab/Parallel-ForkManager-1.03/lib/Parallel/ForkManager.pm

use FindBin;
use lib "$FindBin::Bin/../../lib";

local $| = 1;

## NOTE: If you change this MAX_REQUESTS value, please update the POD for new() (ARGUMENTS section)
my $MAX_REQUESTS = 5000; ## Should have some maximum, try 5000 to start ...

=head1 NAME

ariba::Test::Apache::RequestPool - an object containing a pool of ariba::Test::Apache::Request objects

=head1 VERSION

Version 0.01

=cut

use version; our $VERSION = '0.01';

=head1 SYNOPSIS

    use ariba::Test::Apache::RequestPool;

    my $req_pool = ariba::Test::Apache::RequestPool->new({ num_reqs => 10 });

    foreach my $req ( $req_pool->each() ){
        $req->url( 'http://some.url/' );
    }

    $req_pool->get_all();

    foreach my $req ( $req_pool->each() ){
    while ( my $req = $req_pool->next_req() ) {
        print "Request return code: ", $req->resp->code(), "\n";
        print "Response contents:\n";
        print $req->resp->content();
        print "Response received in ", $req->resp_time(), " seconds\n";
    }

=head1 DESCRIPTION


=cut

=head1 PUBLIC METHODS

new() 

    FUNCTION: Instantiate a ariba::Test::Apache::RequestPool object

   ARGUMENTS: debug - Enable debugging for this module
              num_reqs - Size of the pool (5000 maximum)
           
     RETURNS: A ariba::Test::Apache::RequestPool object

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
    ## 10 seems like a good default to start with
    $self->{ 'num_reqs' } = 10 unless $self->{ 'num_reqs' };

    ## Set to $MAX_REQUESTS if the user chose a value > $MAX_REQUESTS
    $self->{ 'num_reqs' } = $MAX_REQUESTS if $self->{ 'num_reqs' } > $MAX_REQUESTS;

    ## Populate the requests array with request objects
    foreach my $req ( 1..$self->{ 'num_reqs' } ){
        push @{ $self->{ 'req_objs' } }, ariba::Test::Apache::Request->new({ debug => $self->{ 'debug' } });
    }

    $self->{ 'pool_mgr' } = Parallel::ForkManager->new( $self->{ 'num_reqs' } );

    $self->{ 'pool_mgr' }->run_on_start( sub {
        my ( $pid, $ident ) = @_;
        print "** $ident started, pid: $pid\n";
    });

    $self->{ 'pool_mgr' }->run_on_finish( sub {
        my ($pid, $exit_code, $ident, $exit_signal, $core_dump, $data_structure_reference) = @_;
        print "** $ident just got out of the pool with PID $pid and exit code: $exit_code\n";
        if ( defined( $data_structure_reference )) {
            $self->{ 'req_objs' }->[ $ident ] = $data_structure_reference;
        } else {
            print "No data recieved from child '$ident'\n";
        }
    });

    if ( $self->{ 'debug' } ){
        print __PACKAGE__, ": Created object:\n";
        print Dumper $self;
    }

    return bless $self, $class;
}

=head1

get_all() 

    FUNCTION: Retrieve URLs for all ariba::Test::Apache::Request objects in the pool

   ARGUMENTS: None
           
     RETURNS: TODO: Not sure what I'll return here ... possibly nothing ...

=cut

sub get_all {
    my $self = shift;

    my $child = 0;
    foreach my $req ( @{ $self->{ 'req_objs' } } ){
        ## Here's where we'll use Parallel::ForkManager to spawn the gets
        my $orig = $child;
        $self->{ 'pool_mgr' }->start( $child++ ) and next; ##Idiomatic - see doc

        ## This is the first time i'm using P::FM, hope this works ...
        $req->get();
        $self->{ 'pool_mgr' }->finish( $orig, $req );
        $child++;
    }
    $self->{ 'pool_mgr' }->wait_all_children;
}

=head1

next_req() 

    FUNCTION: Iterator for the ariba::Test::Apache::Request objects in the pool

   ARGUMENTS: None
           
     RETURNS: The "next" ariba::Test::Apache::Request object in the pool, undef when no more are left

=cut

sub _mk_iter {
    my $arr = shift;

    my $i;
    return sub {
        $i = 0 unless $i;
        return $arr->[ $i++ ];
    };
}

sub next_req {
    my $self = shift;

    if( not $self->{ req_objs_iter } ) {
        $self->{ req_objs_iter } = _mk_iter( $self->{ 'req_objs' });
    }

    my $ret = $self->{ req_objs_iter }->();
    undef $self->{ req_objs_iter } unless defined $ret;

    return $ret;
}

=head1 DEPENDENCIES

IO::CaptureOutput

Time::HiRes

Parallel::ForkManager

=head1 AUTHOR

Marc Kandel C<< <mkandel at ariba.com> >>

=head1 LICENSE

Copyright 2013 Ariba, Inc. (an SAP Company)

=cut

1; # End of Module

__END__
