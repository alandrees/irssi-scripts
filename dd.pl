use strict;
use script_config;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);

use Module::Refresh;
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

#this refreshes the script_config.pm module, meaning you don't need reload
#all of irssi just to test a new configuration variable
my $refresher = Module::Refresh->new;
$refresher->refresh_module('script_config.pm');
