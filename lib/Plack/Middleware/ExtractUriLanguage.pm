#
# This file is part of Plack-Middleware-ExtractUriLanguage
#
# This software is copyright (c) 2013 by BURNERSK.  No
# license is granted to other entities.
#
package Plack::Middleware::ExtractUriLanguage;
use strict;
use warnings FATAL => 'all';
use utf8;

BEGIN {
  our $VERSION = '0.001';
}

use parent 'Plack::Middleware';
use Plack::Util::Accessor qw(
  ExtractUriLanguageOrig
  ExtractUriLanguageTag
);

############################################################################
# Called on every reqeust.
sub call {
  my ( $self, $env ) = @_;
  my $language_tag;
  my $orig_name = $self->ExtractUriLanguageOrig || 'PATH_INFO_ORIG';
  my $tag_name  = $self->ExtractUriLanguageTag  || 'LANGUAGE_TAG';
  my $path_info = $env->{PATH_INFO}; # is "/en-us/some-site" when "http://example.com/en-us/some-site".

  # The following conditions are true if their substitution regular expressions do anything.
  # All characters after the identified language tag will be the new PATH_INFO.
  # # "/en-us/some-site" will be "/some-site".

  # language tag format: ISO 639-1 "-" ISO 3166 ALPHA-2 ("en-us", "en-gb")
  if    ( $path_info =~ s{^/([[:alpha:]]{2}-[[:alpha:]]{2})/?$}{/} )     { $language_tag = $1 }
  elsif ( $path_info =~ s{^/([[:alpha:]]{2}-[[:alpha:]]{2})(/.*)$}{$2} ) { $language_tag = $1 }

  # language tag format: ISO 639-1 ("en")
  elsif ( $path_info =~ s{^/([[:alpha:]]{2})/?$}{/} )     { $language_tag = $1 }
  elsif ( $path_info =~ s{^/([[:alpha:]]{2})(/.*)$}{$2} ) { $language_tag = $1 }

  # Manipulate environment only when a language tag was identified.
  if ($language_tag) {
    $env->{$tag_name}  = $language_tag;      # The language tag wich was found.
    $env->{$orig_name} = $env->{PATH_INFO};  # The original PATH_INFO.
    $env->{PATH_INFO}  = $path_info;         # The new manupulated PATH_INFO.
  }

  # Dispatch request to application.
  return $self->app->($env);
}

############################################################################
1;
__END__
=pod

=encoding utf8

=head1 NAME

Plack::Middleware::ExtractUriLanguage - Cuts off language tags out of the request's PATH_INFO to simplify internationalization route handlers.

=head1 VERSION

This documentation describes L<ExtractUriLanguage|Plack::Middleware::ExtractUriLanguage> within version 0.001.

=head1 SYNOPSIS

    # with Plack::Middleware::ExtractUriLanguage
    enable 'Plack::Middleware::ExtractUriLanguage',
      ExtractUriLanguageOrig => 'PATH_INFO_ORIG',
      ExtractUriLanguageTag  => 'LANGUAGE_TAG';

=head1 DESCRIPTION

L<ExtractUriLanguage|Plack::Middleware::ExtractUriLanguage> cuts off
language tags out of the request's PATH_INFO to simplify
internationalization route handlers. The extracted language tag will be
stored within the environment variable C<LANGUAGE_TAG> (configurable). The
original unmodified C<PATH_INFO> is additionaly saved within the environment
variable C<PATH_INFO_ORIG> (configurable).

=head1 CONFIGURATION AND ENVIRONMENT

=head2 ExtractUriLanguageOrig

    ExtractUriLanguageOrig  => 'PATH_INFO_ORIG';

Environment variable name for the original unmodified C<PATH_INFO>. The
default is "PATH_INFO_ORIG".

=head2 ExtractUriLanguageTag

    ExtractUriLanguageTag  => 'LANGUAGE_TAG';

Environment variable name for the detected language tag. The default is
"LANGUAGE_TAG".

=head1 BUGS AND LIMITATIONS

Please report all bugs and feature requests at
L<GitHub Issues|https://github.com/burnersk/Plack-Middleware-ExtractUriLanguage/issues>.

=head1 AUTHOR

BURNERSK E<lt>burnersk@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This file is part of Plack-Middleware-ExtractUriLanguage

This software is copyright (c) 2013 by BURNERSK.  No
license is granted to other entities.

=cut
