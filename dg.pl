use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add signal_stop);

use Module::Refresh;
$VERSION = '1.00';
%IRSSI = (authors	=> 'Alan Drees',
	  contact	=> 'alandrees@theselves.com',
	  name		=> 'DogeDefence',
	  description	=> 'wow much defence',
	  license	=> 'GPLv3',
);

sub self_defence{
    my ($server, $msg, $nick, $address, $target) = @_;

    srand(time);

    my $selfnick = lc($server->{nick});
    my $index = int(rand(5));
    my $color = int(rand(15));
    my $response = '';
    my @responses = ('wow','so','such','very', 'much');

    if(lc($msg) =~ m/$selfnick/){

	if($index == 0){
	    $response = $responses[$index];
	}else{
	    $response = $responses[$index].' '.$msg;

	    $response =~ s/[\s]*$server->{nick}('s)*[\s]*/ /i;

	}

	Irssi::print($index);


	$server->command('action '.$target.' '.$color.$response);
    }

}

signal_add('message irc action', 'self_defence');

#this refreshes the script_config.pm module, meaning you don't need reload
#all of irssi just to test a new configuration variable
my $refresher = Module::Refresh->new;
$refresher->refresh_module('script_config.pm');
