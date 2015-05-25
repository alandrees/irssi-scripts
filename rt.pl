use strict;
use script_config;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);

use Module::Refresh;
$VERSION = '1.00';
%IRSSI = (
    authors => 'Alan Drees',
    contact => 'alandrees@theselves.com',
    name    => 'rtorrent',
    description     => 'get the current rtorrent throughput',
    license => 'GPLv3',
    );


#set this to the location of the rtorrent-rate.sh script
sub _rtorrent{
    my($server, $msg, $nick, $address, $target) = @_;
    my($response, $dl, $ul);

    my @arguments = split(' ',$msg);

    if(lc($arguments[0]) eq '!rtorrent'){
	$dl = readpipe($script_config::rt_SCRIPT_DIR."rtorrent-rate.sh download_rate");
	$ul = readpipe($script_config::rt_SCRIPT_DIR."rtorrent-rate.sh upload_rate");
	$server->command("MSG ".$target." Upload: ".$ul." "."Download: ".$dl);
    }
}

signal_add("message public", "_rtorrent");

#this refreshes the script_config.pm module, meaning you don't need reload
#all of irssi just to test a new configuration variable
my $refresher = Module::Refresh->new;
$refresher->refresh_module('script_config.pm');
