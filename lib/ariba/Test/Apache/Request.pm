#------------------------------------------------------------------------------
# $Id$
# $HeadURL$
#------------------------------------------------------------------------------
package ariba::Test::Apache::Request;

use warnings;
use strict;

use Data::Dumper;
# Some Data::Dumper settings:
local $Data::Dumper::Useqq  = 1;
local $Data::Dumper::Indent = 3;

use Carp;
use Time::HiRes qw{ time };
use WWW::Mechanize;

use FindBin;
use lib "$FindBin::Bin/../../lib";

local $| = 1;

=head1 NAME

ariba::Test::Apache::Request - a wrapper object for sending and timing http requests to the server and/or mock objects

=head1 VERSION

Version 0.01

=cut

use version; our $VERSION = '0.01';

=head1 SYNOPSIS

    use ariba::Test::Apache::Request;

    my $req = ariba::Test::Apache::Request->new();

    $req->get( $url );
    print $req->resp->content();
    print "response received in ", $req->resp_time(), " seconds\n";

=head1 DESCRIPTION

Convenience class.  Uses Time::HiRes and WWW::Mechanize to time and retrieve a URL.

=cut

=head1 PUBLIC METHODS

new()

    FUNCTION: Instantiate a ariba::Test::Apache::Request object

   ARGUMENTS: debug - Enable debugging for this module
           
     RETURNS: An ariba::Test::Apache::Request object

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
    $self->{ '_has_timing' } = 0;
    $self->{ 'resp' } = undef;

    if ( $self->{ 'debug' } ){
        print __PACKAGE__, ": Created object:\n";
        print Dumper $self;
    }

    return bless $self, $class;
}

=head1

get()

    FUNCTION: Time and request the URL associated with this object or one passed to this method

   ARGUMENTS: Optional - URL
           
     RETURNS:  1 for success, 0 for failure - response is stored in the object

=cut

sub get {
    my $self = shift;
    my $url = shift;

    $self->url( $url ) if $url;

    croak "Must set a URL to get!\n" unless $self->{ 'url' };

    my $mech = WWW::Mechanize->new();

    ## Start timer
    my $start = time; ## From Time::HiRes

    ## Make http request:
    $mech->get( $self->{ 'url' } );
    ## Stop timer
    $self->{ 'resp_time' } = time - $start;
    $self->_has_timing( 1 ); ## Set _has_timing to true

    my $success = $mech->success;
    if ( $success ){
        $self->{ 'resp' } = $mech->response(); ## An HTTP::Response object
    }
    
    return $success;
}

=head1

url()

    FUNCTION: Get/Set URL associated with an instance of this object

   ARGUMENTS: Optional - URL to set
           
     RETURNS: URL if set, undef if not

=cut

sub url {
    my $self = shift;
    my $url = shift;

    my $ret = undef;

    $self->{ 'url' } = $url if $url;
    $ret = $self->{ 'url' } if $self->{ 'url' };

    return $ret;
}

=head1

resp_time()

    FUNCTION: Get the response time of the request

   ARGUMENTS: None
           
     RETURNS: Response time of last get() call, undef if not get() has been called

=cut

sub resp_time {
    my $self = shift;

    return $self->{ 'resp_time' };
}

=head1

resp()

    FUNCTION: Response to the most recent get() request for this object

   ARGUMENTS: None
           
     RETURNS: An HTTP::Response object for the most reent get(), undef is no get() has been run

=cut

sub resp {
    my $self = shift;
    return $self->{ 'resp' };
}

=head1 PRIVATE METHODS

_has_timing()

    FUNCTION: Tell whether this instance has timing info or not

   ARGUMENTS: This is an accessor, if you pass a value it will set and return that value otherwise just returns the current value

     RETURNS: true/false

=cut

sub _has_timing {
    my $self = shift;
    my $val = shift;

    $self->{ '_has_timing' } = $val if $val;
    return $self->{ '_has_timing' };
}

=head1 DEPENDENCIES

WWW::Mechanize

Time::HiRes

HTTP::Response

=head1 AUTHOR

Marc Kandel C<< <mkandel at ariba.com> >>

=head1 LICENSE

Copyright 2013 Ariba, Inc. (an SAP Company)

=cut

1; # End of Module

__END__

