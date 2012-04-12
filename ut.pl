use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);

$VERSION = '1.00';

%IRSSI = (
        authors         => 'Alan Drees',
        contact         => 'alandrees@theselves.com',
        name            => 'uptime',
        description     => 'irssi uptime output',
        license         => 'GPLv2',
);

sub _uptime{

    my($server, $msg, $nick, $address, $target) = @_;

    my($response, $elapsed);
    my($weeks, $days, $hours, $minutes, $seconds);

    my @arguments = split(' ',$msg);

    if(lc($arguments[0]) eq '!uptime'){
	
	if(-e '/proc/uptime'){

	    $response = readpipe('cat /proc/uptime | awk \'{ print $1 }\'' );
	    $elapsed = int($response);
	
	    $days = int($elapsed / 86400); #total days
	    $weeks = int($days / 7); #weeks
	    $days = $days % 7; #days less than a week
	    $hours = int(($elapsed % 86400) / 3600); #hours
	    $minutes = int((($elapsed % 86400) % 3600) / 60); #minutes
	    $seconds = int(((($elapsed % 86400) % 3600) % 60));
	
	    $response = "14Last restart:7 ";
	    if($weeks > 0){
		if($weeks > 1){
		    $response .= $weeks . " Weeks ";
		}elsif ($weeks == 1){
		    $response .= $weeks . " Week ";
		}
	    }
	    if($days > 0){
		if($days > 1){
		    $response .= $days . " Days ";
		}elsif ($days == 1){
		    $response .= $days . " Day ";
		}
	    }
	    if($hours > 0){
		if($hours > 1){
		    $response .= $hours . " Hours ";
		}elsif ($hours == 1){
		    $response .= $hours . " Hour ";
		}
	    }
	    if($minutes > 0){
		if($minutes > 1){
		    $response .= $minutes . " Minutes ";
		}elsif ($minutes == 1){
		    $response .= $minutes . " Minute ";
		}
	    }

	    if($seconds > 0){
		if($seconds > 1){
		    $response .= $seconds . " Seconds";
		}elsif ($seconds == 1){
		    $response .= $seconds . " Second";
		}
	    }

	    $server->command('MSG '.$target.' '.$response);
	}else{
	    $server->command('MSG '.$target.' /proc/uptime does not exist.')
	}
    }
}

signal_add("message public", "_uptime");
