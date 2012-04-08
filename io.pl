use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);

$VERSION = '0.02';
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

#    $target = silence_target($nick, $target);
    
     if(lc($arguments[0]) eq '!iostat'){
	$response = readpipe("iostat -d | grep -A 4 Device | sed 's/sd/\\tsd/'");
	my @lines = split(/\t/,$response);
	
	foreach(@lines){
	    $server->command('MSG '.$target.' '.$_);
	}
    }
}

sub silence_target{
    my($nick, $target) = @_;
    my $silence_target;
    my @sil;
    $silence_target = $target;
    open(SILENCE, "silence.dat") || return $target;
    @sil = <SILENCE>;
    close(SILENCE);

    if($sil[0] ne "0"){
        $silence_target = $nick;
    }else{
	$silence_target = $target;
    }
    return $silence_target;
}

signal_add("message public", "iostat");
