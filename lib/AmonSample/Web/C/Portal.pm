package AmonSample::Web::C::Portal;

use constant LAYOUT_HEADER => 'include/portal/header.tx';
use constant LAYOUT_FOOTER => 'include/portal/footer.tx';

sub dispatch_index {
    my $class = shift;
    my $c = shift;

    my $counter = $c->session->get('counter') || 0;
    $counter++;
    $c->session->set('counter' => $counter);
    return $c->render('index.tx', {
        counter => $counter,
    });
};

1;
