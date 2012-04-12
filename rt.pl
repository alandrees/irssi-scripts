use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);

$VERSION = '1.00';
%IRSSI = (
        authors         => 'Alan Drees',
        contact         => 'alandrees@theselves.com',
        name            => 'rtorrent',
        description     => 'get the current rtorrent throughput',
        license         => 'GPLv3',
);


#set this to the location of the rtorrent-rate.sh script
our $SCRIPT_DIR = "~/scripts/";

sub _rtorrent{
    my($server, $msg, $nick, $address, $target) = @_;
    my($response, $dl, $ul);

    my @arguments = split(' ',$msg);
    
    if(lc($arguments[0]) eq '!rtorrent'){
	$dl = readpipe($SCRIPT_DIR."rtorrent-rate.sh download_rate");
	$ul = readpipe($SCRIPT_DIR."rtorrent-rate.sh upload_rate");   
    	$server->command("MSG ".$target." Upload: ".$ul." "."Download: ".$dl); 
    }
}

signal_add("message public", "_rtorrent");
