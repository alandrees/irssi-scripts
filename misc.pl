use strict;
use vars qw($VERSION %IRSSI $auth_name );

use Irssi qw(command_bind signal_add signal_stop);

$VERSION = '1.00';
%IRSSI = (
	authors		=> 'Alan Drees',
	contact		=> 'alandrees@theselves.com',
	name		=> 'miscmd',
	description	=> 'various useful commands',
	license		=> 'GPLv3',
);

sub lod{
    #output the look of disapproval
    my ($data, $server, $witem) = @_;
    
    if($witem->{type} eq "CHANNEL" || $witem->{type} eq "QUERY"){
	$server->command('msg '.$witem->{name}.' ಠ_ಠ');
    }else{
      Irssi:print("ಠ_ಠ");
    }
}

command_bind('lod', 'lod');
