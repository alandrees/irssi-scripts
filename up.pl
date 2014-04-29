use strict;
use vars qw($VERSION %IRSSI);

use script_config;

use Irssi qw(command_bind signal_add);

use Module::Refresh;
$VERSION = '1.01';
%IRSSI = (
        authors         => 'Alan Drees',
        contact         => 'alandrees@theselves.com',
        name            => 'ups status',
        description     => 'get the current wattage draw of a UPS',
        license         => 'GPLv2',
);

sub upsw{
        my ($server, $msg, $nick, $address, $target) = @_;
        my ($draw, $response);
	my @arguments = split(' ',$msg);

	if(lc($arguments[0]) eq '!ups'){
	    if($arguments[1] ne ''){
		while ( my ($key, $value) = each (%script_config::ups_commands) ){
		    if(lc($key) =~ lc($arguments[1])){
			$draw = readpipe($value);
			$response = "8".$key.":4 ".$draw.'W';
		    }
		}
	    }

	    $server->command('msg '.$target.' '.$response);
        }
}

signal_add("message public", "upsw");

#this refreshes the script_config.pm module, meaning you don't need reload
#all of irssi just to test a new configuration variable
my $refresher = Module::Refresh->new;
$refresher->refresh_module('script_config.pm');

