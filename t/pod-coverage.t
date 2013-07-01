use strict;
use warnings;
use Test::More;

# Ensure a recent version of Test::Pod::Coverage
eval "use Test::Pod::Coverage";
plan skip_all => "Test::Pod::Coverage required for testing pod coverage" if $@;

use lib 'lib';
use lib '../lib';

#plan tests => 1;
my @modules = all_modules();
#all_pod_coverage_ok();
#my @modules = ( 'lib/ariba/Test/Apache.pm', 'lib/ariba/Test/Apache/TestServer.pm', 'lib/ariba/Test/Apache/MockServer.pm' );

foreach my $module ( @modules ){
    pod_coverage_ok( $module );
}

done_testing()

__END__

