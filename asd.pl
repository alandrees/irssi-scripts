use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add signal_stop);

use Module::Refresh;
$VERSION = '1.00';
%IRSSI = (
	authors		=> 'Alan Drees',
	contact		=> 'alandrees@theselves.com',
	name		=> 'self defense',
	description	=> 'Self Defense+, with a bit extra',
	license		=> 'GPLv3',
);



sub self_defence{
	my ($server, $msg, $nick, $address, $target) = @_;
	my $selfnick = lc($server->{nick});
	my $sickle = "#sickle";

	#if($target =~ m/$sickle/){
	    if(lc($msg) =~ m/$selfnick/){

		#accept a beer
		if((lc($msg) =~ m/beer/)||(lc($msg) =~ m/cold one/)){
		    if(lc($msg) =~ m/bottle/){
			$server->command('action '.$target.' moves out of the way and watches '.$nick.' flail about!');
			return;
		    }
		    $server->command('action '.$target.' downs another beer!');
		    return;
		}

		#accept a high five
		if(lc($msg) =~ m/high/){
		    if(lc($msg) =~ m/five/){
			if( (lc($msg) =~ m/with/) || (lc($msg) =~ m/Pie_Mage's/)){
			    $server->command('action '.$target.' escapes the clutches of evil!');
			    return;
			}
			$server->command('action '.$target.' oh yeahs!');
			return;
		    }
		}

		#a joint
		if(lc($msg) =~ m/joint/){
		    $server->command('action '.$target.' hits that shit!');
		    return;
		}

		#data file....
		if(lc($msg) =~ m/properly/){
		    if(lc($msg) =~ m/data/){
			$server->command('action '.$target.' thanks you for the 4,5D5,4a4,5T5,4a 4,5F5,4i4,5L5,4e');
			return;
		    }
		}

		#default condition
		$server->command('action '.$target.' moves out of the way and watches '.$nick.' flail about!');
	    }
	#}

}

signal_add('message irc action', 'self_defence');

#this refreshes the script_config.pm module, meaning you don't need reload
#all of irssi just to test a new configuration variable
my $refresher = Module::Refresh->new;
$refresher->refresh_module('script_config.pm');
