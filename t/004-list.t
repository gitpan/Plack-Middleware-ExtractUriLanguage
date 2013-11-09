#
# This file is part of Plack-Middleware-ExtractUriLanguage
#
# This software is copyright (c) 2013 by BURNERSK.  No
# license is granted to other entities.
#
use strict;
use warnings FATAL => 'all';
use utf8;

use Test::More tests => 1 + 4;
use Test::NoWarnings;

use Plack::Middleware::ExtractUriLanguage;
use Plack::Builder;
use HTTP::Request::Common;
use Plack::Test;
use Plack::Middleware::ExtractUriLanguage::Type ':all';

############################################################################

{
  my %test = (
    client => sub {
      my ($cb) = @_;
      {
        my $res = $cb->( GET "http://localhost/de/path" );
        is( $res->content, "/de/path\n", "ExtractUriLanguageList de" );
      }
      {
        my $res = $cb->( GET "http://localhost/de-de/path" );
        is( $res->content, "/path\nde-de", "ExtractUriLanguageList de-de" );
      }
      {
        my $res = $cb->( GET "http://localhost/en/path" );
        is( $res->content, "/path\nen", "ExtractUriLanguageList en" );
      }
      {
        my $res = $cb->( GET "http://localhost/en-us/path" );
        is( $res->content, "/en-us/path\n", "ExtractUriLanguageList en-us" );
      }
      return;
    },
    app => builder {
      enable 'Plack::Middleware::ExtractUriLanguage', (
        ExtractUriLanguageList => [qw( de-de en )],
        );
      sub {
        my ($env) = @_;
        [
          200,
          [ 'Content-Type' => 'text/plain' ],
          [ sprintf "%s\n%s", $env->{$PATH_INFO_FIELD} // '', $env->{$DEFAULT_LANGUAGE_TAG_FIELD} // '' ],
        ];
        }
    },
  );

  test_psgi %test;
}

############################################################################
1;
