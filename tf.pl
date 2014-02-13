use strict;
use vars qw($VERSION %IRSSI);
use Irssi qw(command_bind signal_add);
use Encode qw(encode decode);

use Module::Refresh;
$VERSION = '1.00';
%IRSSI = (
        authors         => 'Alan Drees',
        contact         => 'deepie@dm',
        name            => 'table fixer',
        description     => 'Fix the damn tables!',
        license         => 'GPLv3',
);

sub _tablefix{
        my ($server, $msg, $nick, $address, $target) = @_;

        if($msg=~ m/┻(━)*┻/x){
	    
	    my $tabletop = "";
	    {
		use utf8;
		Irssi::print($msg = /━/);
	    }

	    $server->command('msg '.$target.' ┬'. $tabletop . '┬ノ( º _ ºノ)');
        }
}

signal_add("message public", "_tablefix");

#this refreshes the script_config.pm module, meaning you don't need reload
#all of irssi just to test a new configuration variable
my $refresher = Module::Refresh->new;
$refresher->refresh_module('script_config.pm');
