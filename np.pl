use strict;

use script_config;

use vars qw($VERSION %IRSSI %channels $MPD_SERVER $MPD_PORT);

use Irssi qw(command_bind signal_add signal_stop channel_find);
use IO::Socket::INET;
use Encode;

$VERSION = '1.01';

%IRSSI = (
	authors		=> 'Alan Drees',
	contact		=> 'alandrees@theselves.com',
	name		=> 'Now Playing: mpd edition',
	description	=> 'Displays the currently playing song retrieved from MPD, either on the same system or remotely.  Also allows for remote triggering, via screen registers.',
	license		=> 'GPLv3',
);

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

sub local_np{
    my($data, $server, $channel) = @_;

    my $title = get_title();

    if($title ne ""){
	if(defined($channel)){
	    $server->command('action '.$channel->{'name'}.' '.$title.' '.$data);
	}else{
	    Irssi::print($title);
	}
    }
}
		   
sub get_title{
    my ($data, $server, $channel) = @_;
    
    my %songinfo = get_data('currentsong');
    
    my %statusinfo = get_data('status');
    
    if(%statusinfo->{"state"} == "play"){
	#do play stuff
    }elsif(%statusinfo->{"state"} == "pause"){
	#do pause stuff
    }elsif(%statusinfo->{"state"} == "stop"){
	#do stop stuff
    }

    my $a = %statusinfo->{"time"};
    $a =~ m/(\d+)/;

    my $minutes = sprintf "%.0f", $a / 60;
    my $seconds = sprintf "%02d",$a % 60;

    #style this however you like
    my $title = "3listens 7to9 ".%songinfo->{"Artist"} . " - " . %songinfo->{"Album"} . " - " . %songinfo->{"Title"} . "1 @7 " . $minutes . ":" . $seconds;

    if( (scalar keys %songinfo) != 0 ){
	return $title;
    }else{
	return "";
    }
}

sub get_data{
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


		
#local np: binds /np to display the title in the current window
command_bind('np', 'local_np');

#remote np: bind /npr to display the currently playing track in 
#whatever channel windows are listed
command_bind('npr', 'remote_np');
