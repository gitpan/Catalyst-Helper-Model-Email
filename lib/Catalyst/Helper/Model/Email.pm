package Catalyst::Helper::Model::Email;
use strict;
use warnings;

our $VERSION = '0.01';

sub mk_compclass {
    my ( $class, $helper, $mailer, @mailer_args) = @_;

    my %args;
    $args{mailer} = $mailer;
    
    if ($mailer eq 'SMTP' or $mailer eq 'NNTP') {
        @args{qw/host username password/} = @mailer_args;
    }
    elsif ($mailer eq 'Gmail') {
        @args{qw/username password/} = @mailer_args;
    }

    $helper->render_file('compclass', $helper->{file}, \%args);
}

=head1 NAME

Catalyst::Helper::Model::Email - Helper for Mail::Builder::Simple

=head1 SYNOPSIS

Running:

 ./script/myapp_create.pl model Email1 Email SMTP smtp.host.com usr passwd

Will create C<MyApp::Model::Email1> that looks like:

 package MyApp::Model::Email1;
 use strict;
 use warnings;
 use base 'Catalyst::Model::Factory';
 
 __PACKAGE__->config(
  class       => 'Mail::Builder::Simple',
  args => {
   mail_client => {
    mailer => 'SMTP',
    mailer_args => [Host => 'smtp.host.com', username => 'usr', password => 'passwd'],
   },
  },
 );

 1;

And you will be able to send email with this model, using in your controllers just:

 $c->model("Email1"->send(
  from => 'me@host.com',
  to => 'you@yourhost.com',
  subject => 'The subject with UTF-8 chars',
  plaintext => "Hello\n\nHow are you?\n\n",
 );

But you will be also able to send more complex email messages like:

 $c->model("Email1"->send(
  from => ['me@host.com', 'My Name'],
  to => ['you@yourhost.com', 'Your Name'],
  subject => 'The subject with UTF-8 chars',
  plaintext => "Hello\n\nHow are you?\n\n",
  htmltext => "<h1>Hello</h1> <p>How are you?</p>",
  attachment => ['file', 'filename.pdf', 'application/pdf'],
  image => ['logo.png', 'image_id_here'],
  priority => 1,
  mailer => 'My Emailer 0.01',
  'X-Special-Header' => 'My special header',
 );

...or even more complex messages, using templates.

=head1 ARGUMENTS

 ./script/myapp_create.pl model <model_name> Email <mailer_args>

You need to specify the C<model_name> (the name of the model you want to create), and all other elements are optional.

For the <mailer_args> you should add the mailer_args parameters required by the mailer you want to use.

If you want to use Sendmail (which is the default), you don't need to add any parameters for <mailer_args>, or you could add just Sendmail.

If you want to use qmail as a mailer, you need to add Qmail.

If you want to use an SMTP server, you need to add just SMTP and the address of the SMTP server.

If you want to use an SMTP server that requires authentication, you need to add SMTP, the address of the server, the username and the password, like in the exemple given above.

If you want to send email with Gmail email provider, you need to use Gmail, then the username and the password.

If you want to use NNTP, you need to add NNTP, the address of the server, the username and the password.

The module supports all the mailers supported by Mail::Builder::Simple.

You can add to the generated model any other parameters you can use for sending email, for example the C<From:> field, and you won't need to specify those parameters when sending each email.

You can also put the configuration variables in the application's main configuration file (myapp.conf), using something like:

 <Model::Email1>
  class Mail::Builder::Simple
  <args>
   <mail_client>
    mailer SMTP
    <mailer_args>
     Host smtp.host.com
     username myuser
     password mypass
    </mailer_args>
   </mail_client>
   from me@host.com
  </args>
 </Model::Email1>

=head1 SEE ALSO

L<Catalyst>, L<Mail::Builder::Simple>

=head1 AUTHOR

Octavian Rasnita C<orasnita@gmail.com>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as perl itself.

No copyright claim is asserted over the generated code.

=cut

1;

__DATA__

__compclass__
package [% class %];
use strict;
use warnings;
use base 'Catalyst::Model::Factory';

__PACKAGE__->config( 
    class       => 'Mail::Builder::Simple',
    args => {
        mail_client => {
            mailer => '[% mailer %]',
[% IF (mailer == 'SMTP' || mailer == 'NNTP') && username && password -%]
            mailer_args => [Host => '[% host %]', username => '[% username %]', password => '[% password %]'],
[% ELSIF (mailer == 'SMTP' || mailer == 'NNTP') && username -%]
            mailer_args => [Host => '[% host %]', username => '[% username %]', password => 'type_password_here'],
[% ELSIF mailer == 'SMTP' || mailer == 'NNTP' -%]
            mailer_args => [Host => '[% host %]'],
[% ELSIF mailer == 'Gmail' -%]
            mailer_args => [username => '[% username || 'type_username_here' %]', password => '[% password || 'type_password_here' %]'],
[% END -%]
        },
    },
);

1;
