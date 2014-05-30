package AmonSample::Web::Dispatcher;
use strict;
use warnings;
use utf8;
use AmonSample::Web::Dispatcher::RouterBoom;

use Module::Find qw/useall/;
useall(AmonSample::Web::C);

get  '/' => 'AmonSample::Web::C::Portal#dispatch_index';

post '/reset_counter' => sub {
    my $c = shift;
    $c->session->remove('counter');
    return $c->redirect('/');
};

post '/account/logout' => sub {
    my ($c) = @_;
    $c->session->expire();
    return $c->redirect('/');
};

1;
