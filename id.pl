use strict;
use script_config;
use vars qw($VERSION %IRSSI %authorizations);

use Irssi qw(command_bind signal_add signal_stop);

use Module::Refresh;
$VERSION = '0.75';
%IRSSI = (
	authors		=> 'Alan Drees',
	contact		=> 'alandrees@theselves.com',
	name		=> 'multi-server identification',
	description	=> 'identifies the user based on server, configurable
                            for other service names.  Nick handler is for
                            anope nickserv, to keep yourself authed at all
                            times.  Still buggy.',
	license		=> 'GPLv3',
);


#format: network name => [username, auth service name, password]
#%authorizations = ('netname' =>  ["username","servicename","password"]);


sub identificator{
    my ($data, $server) = @_;
    my $current_nick = lc($server->{nick});
    my $netname = lc($server->{tag});
    
    $server->command('nick '.$script_config::id_authorizations{$netname}[0]);
    $server->command('msg '.$script_config::id_authorizations{$netname}[1].' IDENTIFY '.$script_config::id_authorizations{$netname}[2]);
}

#sub nick_handler{
#	my ($server, $newnick, $oldnick, $address) = @_;
#
#	my @auth_array;
#	my $currnick = lc($oldnick);
#
#	if(lc($server->{chatnet}) eq "sicklenet"){
#	    @auth_array = $authorizations->{lc($server->{chatnet})};
#	    if($currnick ne lc($auth_array[0])){
#		$server->command('msg '.$auth_array[1].' DROP '.$currnick);
#	    }
#
#	    if(lc($newnick) eq lc($auth_array[0])){
#		$server->command('nick '. $newnick);
#		$server->command('msg '.$auth_array[1].' IDENTIFY '.$auth_array[2]);
 #               return;
#	   }
#
#	  $server->command('msg NickServ GROUP '.$auth_array[0].' '.$auth_array[2]);
#	}
#}

command_bind('identify', 'identificator');
#command_bind('nick','nick_handler');

#this refreshes the script_config.pm module, meaning you don't need reload
#all of irssi just to test a new configuration variable
my $refresher = Module::Refresh->new;
$refresher->refresh_module('script_config.pm');
