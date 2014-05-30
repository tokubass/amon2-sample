package AmonSample::Web;
use strict;
use warnings;
use utf8;
use parent qw/AmonSample Amon2::Web/;
use File::Spec;

# dispatcher
use AmonSample::Web::Dispatcher;
sub dispatch {
    return (AmonSample::Web::Dispatcher->dispatch($_[0]) or die "response is not generated");
}

# load plugins
__PACKAGE__->load_plugins(
    'Web::FillInFormLite',
    'Web::JSON',
    '+AmonSample::Web::Plugin::Session',
);

# setup view
use AmonSample::Web::View;
{
    sub create_view {
        my $view = AmonSample::Web::View->make_instance(__PACKAGE__);
        no warnings 'redefine';
        *AmonSample::Web::create_view = sub { $view }; # Class cache.
        $view
    }
}

sub render {
    my ($c,$filename,$vars) = @_;

    no warnings 'redefine';
    local *Teng::Row::update = sub { die 'Teng::Row::update not allow in view template' };
    local *Teng::Row::delete = sub { die 'Teng::Row::delete not allow in view template' };

    my $header = $c->{router}{dispatch_class}->LAYOUT_HEADER;
    my $footer = $c->{router}{dispatch_class}->LAYOUT_FOOTER;

    $c->SUPER::render($filename, {
        %{$vars || {} },
        header_inc => $header,
        footer_inc => $footer,
        config => $c->config,
    });
}


# for your security
__PACKAGE__->add_trigger(
    AFTER_DISPATCH => sub {
        my ( $c, $res ) = @_;

        # http://blogs.msdn.com/b/ie/archive/2008/07/02/ie8-security-part-v-comprehensive-protection.aspx
        $res->header( 'X-Content-Type-Options' => 'nosniff' );

        # http://blog.mozilla.com/security/2010/09/08/x-frame-options/
        $res->header( 'X-Frame-Options' => 'DENY' );

        # Cache control.
        $res->header( 'Cache-Control' => 'private' );
    },
);

1;
