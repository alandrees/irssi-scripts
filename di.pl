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


sub _dice{
    my($server, $msg, $nick, $address, $target) = @_;
    my $delimiter;
    
    if(index($msg,',') != -1){
	$delimiter = ',';
    }
    else{
        $delimiter = ' ';
    }

    my @arguments = split($delimiter, $msg); 
    if($arguments[0] =~ /!dice/){ 
	$server->command( 'MSG '.$target.' '.$nick.': '.$arguments[ int( rand( ( scalar( @arguments ) - 1 ) ) + 1)] );
    }
}

signal_add("message public", "_dice");
