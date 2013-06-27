#!/usr/local/bin/perl -w
use strict; use warnings;

use Test::More qw( no_plan );
#use Test::More tests => 16;
use Test::Exception;
use Test::Warn;

use lib 'lib';
use lib '../lib';

sub module_under_test { return 'ariba::Test::Apache::RequestPool' };

BEGIN{
    use_ok( module_under_test() );
}

## Method tests
#{
#    my @methods = qw{ new stop_server start_server start_mock stop_mock };
#    can_ok( module_under_test(), @methods );
#}

__END__

