use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);

$VERSION = '0.50';
%IRSSI = (
        authors         => 'Alan Drees',
        contact         => 'alandrees@theselves.com',
        name            => 'IP resolving',
        description     => 'IP Resolving for DNS names',
        license         => 'GPLv3',
);

sub resolve{
    my($server, $msg, $nick, $address, $target) = @_;
    my($response);

    my @arguments = split(' ', $msg);

    if(lc($arguments[0]) eq '!ip'){
	
	$response = readpipe('host -t A '.$arguments[1].' | sed \'s/'.$arguments[1].' has address //\'');
	$server->command('MSG '.$target.' '.''.$arguments[1].":4 ".$response);
    }
}

signal_add("message public", "resolve");
