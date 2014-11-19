use strict;

use script_config;

use vars qw($VERSION %IRSSI %ALIASES);
use Irssi qw(command_bind signal_add);

use Module::Refresh;
$VERSION = '1.00';
%IRSSI = (
        authors         => 'Alan Drees',
        contact         => 'alandrees@theselves.com',
        name            => 'random port',
        description     => 'Picks a random number between 1025 and 65535',
        license         => 'GPLv3',
    );

#it will use the keys here to create a list of mount points to add to the sizereport

#mountpoint => (list of ailiases)
#%ALIASES = ( '/mnt/data' => ['data','backups','sda1'],
#	     '/mnt/local-data' => ['local-data','backups','sdd2'] );

sub _randomport{
    my($server, $msg, $nick, $address, $target) = @_;
    my($port);

    my @arguments = split(' ',$msg);

    if(lc($arguments[0]) eq '!randport'){

	$port = int(rand(64511) + 1025);

	$server->command('MSG '.$target.' '.$port);

    }
}
      	
signal_add("message public", "_randomport");

#this refreshes the script_config.pm module, meaning you don't need reload
#all of irssi just to test a new configuration variable
my $refresher = Module::Refresh->new;
$refresher->refresh_module('script_config.pm');
