use strict;
use script_config;
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


sub _self_uptime{
    my($server, $msg, $target) = @_;
    my($response, $elapsed);

    my @arguments = split(' ',$msg);

    if(lc($arguments[0]) eq '!uptime'){
	$response = calc_uptime();
	$server->command('MSG '.$target." 14Last restart:7 ".$response);
    }
}


sub _uptime{

    my($server, $msg, $nick, $address, $target) = @_;
    my($response, $elapsed);

    my @arguments = split(' ',$msg);

    if(lc($arguments[0]) eq '!uptime'){
	$response = calc_uptime();
	$server->command('MSG '.$target." 14Last restart:7 ".$response);
    }
}

sub calc_uptime{

    my($response, $elapsed, $days, $weeks, $hours, $minutes, $seconds);

    $response = readpipe($script_config::uptime_command);
    $elapsed = int($response);
	
    $days = int($elapsed / 86400); #total days
    $weeks = int($days / 7); #weeks
    $days = $days % 7; #days less than a week
    $hours = int(($elapsed % 86400) / 3600); #hours
    $minutes = int((($elapsed % 86400) % 3600) / 60); #minutes
    $seconds = int(((($elapsed % 86400) % 3600) % 60));
	
    $response = "";

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

    return $response;
}


signal_add("message public", "_uptime");
signal_add("message own_public", "_self_uptime");
