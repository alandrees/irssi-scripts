use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);

#use IO::File;

$VERSION = '0.02';
%IRSSI = (
        authors         => 'Deepmagic',
        contact         => 'deepie@dm',
        name            => 'IP resolving',
        description     => 'IP Resolving for DNS names',
        license         => 'WEE',
);

sub resolve{
    my($server, $msg, $nick, $address, $target) = @_;
    my($response);

    my @arguments = split(' ', $msg);

    if(lc($arguments[0]) eq '!ip'){

      $response = readpipe('host -t A '.$arguments[1].' | sed \'s/'.$arguments[1].' has address //\'');
      #Irssi:print($response);
      #Irssi:print($arguments[1]);
      $server->command('MSG '.$target.' '.''.$arguments[1].":4 ".$response);
    }
}

signal_add("message public", "resolve");
