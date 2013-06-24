#!/usr/local/bin/perl -w
use strict;
use warnings;
use Test::More;
use Test::Compile;

all_pl_files_ok( all_pm_files() );

__END__

