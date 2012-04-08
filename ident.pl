use strict;
use vars qw($VERSION %IRSSI %authorizations);

use Irssi qw(command_bind signal_add signal_stop);

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

#format: network name, [username, auth service name, password]
%authorizations = (piratenet => ["Pie_Mage", "SickleNick", "sonicthehedgehog"],
		   voxinfinitus =>   ["Pie_Mage","NickServ","superduper"],
		   freenode =>  ["Pie_Mage","NickServ","superduper"],
                   oftc =>      ["Pie_Mage","NickServ","superduper"]);
		   
sub identificator{
    my ($data, $server) = @_;
    my $current_nick = lc($server->{nick});
    my $netname = lc($server->{tag});

    $server->command('nick '.%authorizations->{$netname}[0]);
    $server->command('msg '.%authorizations->{$netname}[1].' IDENTIFY '.%authorizations->{$netname}[2]);
}

sub nick_handler{
	my ($server, $newnick, $oldnick, $address) = @_;

	my @auth_array;
	my $currnick = lc($oldnick);

	if(lc($server->{chatnet}) eq "sicklenet"){
	    @auth_array = %authorizations->{lc($server->{chatnet})};
	    if($currnick ne lc($auth_array[0])){
		$server->command('msg '.$auth_array[1].' DROP '.$currnick);
	    }

	    if(lc($newnick) eq lc($auth_array[0])){
		$server->command('nick '. $newnick);
		$server->command('msg '.$auth_array[1].' IDENTIFY '.$auth_array[2]);
                return;
	   }

	  $server->command('msg SickleNick GROUP Pie_Mage '.$auth_array[2]);
	}
}

command_bind('identify', 'identificator');
#command_bind('nick','nick_handler');
