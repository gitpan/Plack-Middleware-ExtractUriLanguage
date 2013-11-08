#
# This file is part of Plack-Middleware-ExtractUriLanguage
#
# This software is copyright (c) 2013 by BURNERSK.  No
# license is granted to other entities.
#
use strict;
use warnings FATAL => 'all';
use utf8;

use Test::More tests => 1 + 1;
use Test::NoWarnings;

############################################################################

BEGIN {
  use_ok( 'Plack::Middleware::ExtractUriLanguage' );
}

############################################################################
1;
