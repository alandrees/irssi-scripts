use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);

$VERSION = '1.0';
%IRSSI = (
        authors         => 'Alan Drees',
        contact         => 'alandrees@theselves.com',
        name            => 'iostat',
        description     => 'HDD throughput statistics',
        license         => 'GPLv3',
);

sub iostat{
    my($server, $msg, $nick, $address, $target) = @_;
    my($response);

    my @arguments = split(' ',$msg);

    if(lc($arguments[0]) eq '!iostat'){
	$response = readpipe("iostat -d | grep -A 4 Device | sed 's/sd/\\tsd/'");
	my @lines = split(/\t/,$response);
	
	foreach(@lines){
	    $server->command('MSG '.$target.' '.$_);
	}
    }
}

signal_add("message public", "iostat");
