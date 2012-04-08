use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);

$VERSION = '0.02';
%IRSSI = (
        authors         => 'Alan Drees',
        contact         => 'alandrees@theselves.com',
        name            => 'HELP!',
        description     => 'Provides a command listing',
        license         => 'GPLv3',
    );

sub _help{
    my($server, $msg, $nick, $address, $target) = @_;

    my @arguments = split(' ',$msg); 
    
    if(lc($arguments[0]) eq '!help'){
	$server->command('NOTICE '.$nick.' !help - This help text.');
	$server->command('NOTICE '.$nick.' !silence! - Changes the target of messages from channel to user.  Doesn\'t work for either !futurama or !uptime.');
	$server->command('NOTICE '.$nick.' !sizereport [device] - Current disk usage.');
	$server->command('NOTICE '.$nick.' !iostat [device] - Current disk IO usage.');
	$server->command('NOTICE '.$nick.' !uptime - Current system uptime.');
	$server->command('NOTICE '.$nick.' !net - Current network throughput.');
	$server->command('NOTICE '.$nick.' !futurama - Random Futurama Quote.');
	$server->command('NOTICE '.$nick.' !ip <dns name> - Resolves the IP address for a dns name.');
	$server->command('NOTICE '.$nick.' !dice <options> - Randomly pick of the space-delimited options.');
	$server->command('NOTICE '.$nick.' !rtorrent - Current rtorrent throughput.');
	$server->command('NOTICE '.$nick.' !tf, !br, !lod, !cf, !ky, !ki - Output ascii-art one-liner.');
    }
}

signal_add("message public", "_help");
