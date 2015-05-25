use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);

use Module::Refresh;
$VERSION = '0.50';
%IRSSI = (
    authors         => 'Alan Drees',
    contact         => 'alandrees@theselves.com',
    name            => 'IP resolving',
    description     => 'IP Resolving for DNS names',
    license         => 'GPLv3',
    );

sub _resolve{
    my($server, $msg, $nick, $address, $target) = @_;
    my($response);

    my @arguments = split(' ', $msg);

    if(lc($arguments[0]) eq '!ip'){

	$response = readpipe('dig +short "'.$arguments[1].'" | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"');
	$server->command('MSG '.$target.' '.''.$arguments[1].":4 ".$response);
    }
}

signal_add("message public", "_resolve");

#this refreshes the script_config.pm module, meaning you don't need reload
#all of irssi just to test a new configuration variable
my $refresher = Module::Refresh->new;
$refresher->refresh_module('script_config.pm');
