use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);

$VERSION = '1.00';
%IRSSI = (
        authors         => 'Alan Drees'
        contact         => 'alandrees@theselves.com',
        name            => 'rtorrent',
        description     => 'get the current rtorrent throughput',
        license         => 'GPLv3',
);

sub rtorrent{
    my($server, $msg, $nick, $address, $target) = @_;
    my($response, $dl, $ul);

    my @arguments = split(' ',$msg);
    
    if(lc($arguments[0]) eq '!rtorrent'){
	$dl = readpipe("~/scripts/rtorrent-rate.sh download_rate");
	$ul = readpipe("~/scripts/rtorrent-rate.sh upload_rate");   
    	$server->command("MSG ".$target." Upload: ".$ul." "."Download: ".$dl); 
    }
}

sub silence_target{
}

signal_add("message public", "rtorrent");
