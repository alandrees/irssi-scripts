use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);

$VERSION = '1.00';
%IRSSI = (
        authors         => 'Alan Drees',
        contact         => 'alandrees@theselves.com',
        name            => 'Self Defence',
        description     => 'keep deepmagic somewhat protected from violators.',
        license         => 'GPLv3',
);

sub self_defence{
        my ($server, $msg, $nick, $address, $target) = @_;
        my ($selfnick);
	$selfnick = lc($server->{nick});
        if(lc($msg) =~ $selfnick){
                $server->command('action '.$target.' responds with an equal and opposite force!');
        }
}

signal_add("message irc action", "self_defence");
