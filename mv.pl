use strict;
use script_config;
use vars qw($VERSION %IRSSI);
use JSON::XS;
use Irssi qw(command_bind signal_add);
use Data::Dumper;

use Module::Refresh;
$VERSION = '1.00';
%IRSSI = (
    authors => 'Alan Drees',
    contact => 'alandrees@theselves.com',
    name    => 'randmovie',
    description     => 'Execute a python script which returns a json string, containing a path and a movie name',
    license => 'GPLv3',
    );

sub _movie_trigger{
    my($server, $msg, $nick, $address, $target) = @_;
    my($response, $js, $path, $title);

    my @arguments = split(' ',$msg);

    if(lc($arguments[0]) eq '!randofilm'){
	
	$response = readpipe($script_config::mv_SCRIPT_DIR."random_movie_script");

	$js = decode_json $response;

	$title = ${ $js }[1];
	$path = ${ $js }[0];

	$server->command("MSG ".$target." 4Your film sir: 3".$title." 0(1".$path."0)" );
    }
}

signal_add("message public", "_movie_trigger");

#this refreshes the script_config.pm module, meaning you don't need reload
#all of irssi just to test a new configuration variable
my $refresher = Module::Refresh->new;
$refresher->refresh_module('script_config.pm');
