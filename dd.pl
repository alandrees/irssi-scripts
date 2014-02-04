use strict;
use script_config;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);

$VERSION = '1.00';
%IRSSI = (
        authors         => 'Alan Drees',
        contact         => 'alandrees@theselves.com',
        name            => 'Discordian Date',
        description     => 'get the current discordian date',
        license         => 'GPLv3',
);


#set this to the location of the rtorrent-rate.sh script
sub _rtorrent{
    my($server, $msg, $nick, $address, $target) = @_;
    my($dd, $ul);

    my @arguments = split(' ',$msg);
    
    if(lc($arguments[0]) eq '!dd'){
	$dd = readpipe("ddate");
    	$server->command("MSG ".$target." ".$dd);
    }
}

signal_add("message public", "_rtorrent");
