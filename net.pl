use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);

$VERSION = '0.50';
%IRSSI = (
        authors         => 'Alan Drees',
        contact         => 'alandrees@theselves.com',
        name            => 'Net I/O',
        description     => 'Output Current Network I/O',
        license         => 'GPLv3',
    );

#this code looks like a mess to me... I want to refactor it.

sub net_stat{
    my($server, $msg, $nick, $address, $target) = @_;
    my($response, $silence_target);

    my @arguments = split(' ',$msg);
    
    if(lc($arguments[0]) eq '!net'){
	if(exists($arguments[1])){
	    $response = readpipe("ifstat -i".$arguments."-b 1 1 | grep [0-9]*\.[0-9][0-9] | sed 's/^[ \t]*/Rx: /' | sed 's/ [ \t]*/ Tx: /2'");
	}elsif($arguments[1] eq 'eth1'){
	    $response = readpipe("ifstat -i eth1 -b 1 1 | grep [0-9]*\.[0-9][0-9] | sed 's/^[ \t]*/Rx: /' | sed 's/ [ \t]*/ Tx: /2'");
	}else{
	    $response = readpipe("ifstat -b 1 1 | grep [0-9]*\.[0-9][0-9] | sed 's/^[ \t]*/Rx:  /' | sed 's/ [ \t]*/ Tx:  /2' | sed 's/     / || Rx: /' | sed 's/[\t]*//' | sed 's/ [ \t]*/ Tx:  /7'");

	    my $rx2_index = index($response, "Rx:", 2);
	    my $if_;
	    my $spaces;

	    $rx2_index = $rx2_index / 2;

	    for(my $i=0; $i<(($rx2_index / 2)) ;$i++){
		$if_ = $if_." ";
	    }

	    $if_ = $if_."eth0";

	    for(my $i=0; $i<(($rx2_index / 2) - 2);$i++){
		$if_ = $if_."  ";
	    }

	    for(my $i=0; $i<(($rx2_index / 2) - 2);$i++){
		$if_ = $if_."  ";
	    }

	    $if_ = $if_."eth0";

	    $server->command('MSG '.$silence_target.' '.$if_);
	}
    
	$server->command('MSG '.$silence_target.' '.$response);
    }
}

signal_add("message public", "net_stat");
