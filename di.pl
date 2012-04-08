use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);

$VERSION = '1.01';
%IRSSI = (
        authors         => 'Alan Drees',
        contact         => 'alandrees@theselves.com',
        name            => 'Dice',
        description     => 'provides a dice-rolling mechanism',
        license         => 'GPLv3',
    );

sub _help{
    my($server, $msg, $nick, $address, $target) = @_;

    if($msg =~ /!dice/){
	my @arguments = split(' ',$msg); 
	
	$server->command( 'MSG '.$target.' '.$nick.': '.$arguments[ int( rand( ( scalar( @arguments ) - 1 ) ) + 1)] );

    }
}

signal_add("message public", "_help");
