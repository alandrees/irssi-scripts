use strict;

use script_config;

use vars qw($VERSION %IRSSI %channels);

use Irssi qw(command_bind signal_add signal_stop channel_find);
use IO::Socket::INET;
use XML::Simple;
use HTTP::Request;
use LWP::UserAgent;
use LWP::Simple;
use Module::Refresh;
use Encode;

$VERSION = '1.01';

%IRSSI = (
    authors		=> 'Alan Drees',
    contact		=> 'alandrees@theselves.com',
    name		=> 'Now Playing: mpd edition',
    description	=> 'Displays the currently playing song retrieved from MPD, either on the same system or remotely.  Also allows for remote triggering, via screen registers.',
    license		=> 'GPLv3',
    );


#\fn remote_np
#
# Used to trigger an mpd np in a window which may or may not be the active one
#
# @param $data placeholder variable
# @param $server Irssi server object
# @param $channel channel to send to
#
# returns None

sub remote_np{
    my($data, $server, $channel) = @_;

    my @args = split(' ', $data);

    if(scalar(@args) != 0){
	foreach my $chan (@args){
	    my $chan = channel_find($chan);
	    local_np("", $chan->{'server'}, $chan);
	}
    }
}

#\fn local_np
#
# Used to trigger an mpd np in a window (bound to the channel that it is passed as an argument)
#
# @param $data placeholder variable
# @param $server Irssi server object
# @param $channel channel to send to
#
# returns None

sub local_np{
    my($data, $server, $channel) = @_;

    my $title = get_np_mpd($data, $server, $channel);

    if($title ne ""){
	if(defined($channel)){
	    $server->command('action '.$channel->{'name'}.' '.$title.' '.$data);
	}else{
	    Irssi::print($title);
	}
    }
}

#\fn get_np_mpd
#
# Used to trigger an np in a window which may or may not be the active one
#
# @param $data placeholder variable
# @param $server Irssi server object
# @param $channel channel to send to
#
# returns None

sub get_np_mpd{
    my ($data, $server, $channel) = @_;

    my %songinfo = get_data_mpd('currentsong');

    my %statusinfo = get_data_mpd('status');

    my $a = $statusinfo{"time"};
    $a =~ m/(\d+)/;

    my $title = "";

    my $minutes = sprintf "%.0f", $a / 60;
    my $seconds = sprintf "%02d",$a % 60;

    my $use_color = 1;

    if($statusinfo{"state"} == "play"){
	#do play stuff
    }elsif($statusinfo{"state"} == "pause"){
	#do pause stuff
    }elsif($statusinfo{"state"} == "stop"){
	#do stop stuff
    }

    foreach my $netname (@script_config::np_strip_color){
	if(lc($server->{chatnet}) eq lc($netname)){
	    $use_color = 0;
	    last;
	}
    }

    #style this however you like
    my $title = "3listens 7to9 ".$songinfo{"Artist"} . " - " . $songinfo{"Album"} . " - " . $songinfo{"Title"} . "1 @7 " . $minutes . ":" . $seconds;

    if( (scalar keys %songinfo) != 0 ){
	return $title;
    }else{
	return "";
    }
}

#\fn get_data_mpd
#
# Used to trigger an np in a window which may or may not be the active one
#
# @param $data placeholder variable
# @param $server Irssi server object
# @param $channel channel to send to
#
# returns None

sub get_data_mpd{
    my ($command) = @_;

    my @output;

    my @lines;
    my (@items, %param);

    my $socket = IO::Socket::INET->new(PeerAddr => $script_config::np_MPD_SERVER,PeerPort => $script_config::np_MPD_PORT,);

    if ($socket == ""){
	return;
    }

    my $line = $socket->getline;

    chomp $line;

    die "Not an mpd server -welcome string was [$line]\n"
	if $line !~ /^OK MPD (.+)$/;

    my $version = $1;


    $socket->print( encode("utf-8", $command."\n") );



    while (defined (my $line = $socket->getline)){
	chomp $line;
	last if $line =~ /^OK/;
	push @output, decode('utf-8', $line);
    }

    @lines = @output;

    foreach my $line (reverse @lines){
	my ($k, $v) = split /:\s/, $line, 2;
	$param{$k} = $v;
	next unless $k eq 'file' || $k eq 'directory' || $k eq 'playlist';
    }

    return %param;
}


#\fn remote_npv
#
# Used to trigger a vlc np in a specified window
#
# @param $data placeholder variable
# @param $server Irssi server object
# @param $channel channel to send to
#
# returns None

sub remote_npv{
    my($data, $server, $channel) = @_;

    my @args = split(' ', $data);

    if(scalar(@args) != 0){
	foreach my $chan (@args){
	    my $chan = channel_find($chan);
	    local_npv("", $chan->{'server'}, $chan);
	}
    }
}

#\fn remote_np
#
# Used to trigger a vlc np in a window which may or may not be the active one
#
# @param $data placeholder variable
# @param $server Irssi server object
# @param $channel channel to send to
#
# returns None

sub local_npv{
    my($data, $server, $channel) = @_;

    my $title = get_np_vlc();

    if($title ne ""){
	if(defined($channel)){
	    $server->command('action '.$channel->{'name'}.' '.$title.' '.$data);
	}else{
	    Irssi::print($title);
	}
    }
}

#\fn get_np_vlc
#
# used to assemble the
#
# @param $data placeholder variable
# @param $server Irssi server object
# @param $channel channel to send to
#
# returns None

sub get_np_vlc{
    my ($data, $server, $channel) = @_;

    my ($return_value);

    my @vlc_request = ();
    push(@vlc_request, "title");
    push(@vlc_request, "status");
    push(@vlc_request, "time");
    push(@vlc_request, "resolution");


    my $vlc_data = {};

    $vlc_data = get_data_vlc( @vlc_request );

    my $hours   = sprintf "%02d", $vlc_data->{"time"} / 3600;
    my $minutes = sprintf "%02.0f", ($vlc_data->{"time"} % 3600) / 60;
    my $seconds = sprintf "%02d", $vlc_data->{"time"} % 60;

    if($vlc_data->{"title"} ne ''){
	$return_value = "3watches 9".$vlc_data->{"title"}." 3[".$vlc_data->{"resolution"}."]"."1 @7 ".$hours.":".$minutes.":".$seconds;
    }else{
	$return_value = "3watches 9nothing!";
    }
}


#\fn get_data_vlc
#
# Retreives the data from the named XML file via the VLC http interface
#
# @tags an array of tags to search for and return the data of
#
# returns Hashref containing the tag => data pairs

sub get_data_vlc{
    my(@tags) = @_;

    my $xml_doc;

    my $vlc_return_data = {};

    my $return_value = {};

    my @urls = ();

    if($script_config::np_VLC_URL != ""){
	push(@urls, $script_config::np_VLC_URL);
    }
    else
    {
	@urls = @script_config::np_VLC_URL_LIST;
    }

    foreach(@urls){
	$vlc_return_data = vlc_call_http($_, @tags);

	if(!exists($vlc_return_data->{'fail'})){
	    $return_value = $vlc_return_data;
	    last;
	}
    }

    return $return_value;
}

#\fn vlc_call_http
#
# Makes the actual network/http call to VLC
#
# @parm $host string of the uri of the vlc resource
#
# @returns Hashref containing the tag => data pairs

sub vlc_call_http{
    my($uri, @tags) = @_;

    my $return_value = {};

    my $req = HTTP::Request->new('GET', $uri);


    $req->authorization_basic("", $script_config::np_VLC_PASS);

    my $ua = LWP::UserAgent->new;

    my $response = $ua->request($req);

    if(!$response->is_error()){
	my $xml_doc = XMLin($response->decoded_content);

	foreach(@tags){
	    $return_value->{$_} = $xml_doc->{$_};
	}
    }
    else
    {
	$return_value->{'fail'} = 1;
    }

    return $return_value;
}

#local np: binds /np to display the title in the current window
command_bind('np', 'local_np');

#local npv: binds /npv to display the info for VLC
if($script_config::np_VLC){
    command_bind('npv', 'local_npv');
}

#remote np: bind /npr to display the currently playing track in
#whatever channel windows are listed
command_bind('npr', 'remote_np');

#remote npv: bind /npv to display the info for VLC in whatever channel
#windows are listed
if($script_config::np_VLC){
    command_bind('nprv', 'remote_npv');
}

#this refreshes the script_config.pm module, meaning you don't need reload
#all of irssi just to test a new configuration variable
my $refresher = Module::Refresh->new;
$refresher->refresh_module('script_config.pm');
