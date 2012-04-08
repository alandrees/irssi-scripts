use strict;
use vars qw($VERSION %IRSSI);
use Filesys::Df;
use Irssi qw(command_bind signal_add);

$VERSION = '1.00';
%IRSSI = (
        authors         => 'Alan Drees',
        contact         => 'alandrees@theselves.com',
        name            => 'sizereport',
        description     => 'Reports current storage system statistics (free/total)',
        license         => 'free to use, free to destroy',
    );

sub sizereport{
    my($server, $msg, $nick, $address, $target) = @_;
    my($response, $silence_target);

    my @arguments = split(' ',$msg);

    my @sil;

    my($totalsize,$remaining, $used, $size_string);

    #read the silence
    #$silence_target = $target;
    #open(SILENCE, "/home/deepie/.irssi/silence.dat") || return;
    #@sil = <SILENCE>;
    #close(SILENCE);

    #if($sil[0] ne "0"){
    #    $silence_target = $nick;
    #}
    
    if(lc($arguments[0]) eq '!sizereport'){

	if($arguments[1] ne ''){

	    #pre-parse the drive sent if it's
	    if(lc($arguments[1]) eq 'musique' || lc($arguments[1]) eq 'sdb1'){
		$arguments[1] = '/dev/sdb1';
	    }elsif (lc($arguments[1]) eq 'production' || lc($arguments[1]) eq 'sdf1'){
		$arguments[1] = '/dev/sdf1';
	    }elsif (lc($arguments[1]) eq 'data' || lc($arguments[1]) eq 'sdf2'){
		$arguments[1] = '/dev/sdf2';
	    }elsif (lc($arguments[1]) eq 'movies' || lc($arguments[1]) eq 'sdd1'){
		$arguments[1] = '/dev/sdd1';
	    }elsif (lc($arguments[1]) eq 'video' || lc($arguments[1]) eq 'sde1'){
		$arguments[1] = '/dev/sde1';
	    }elsif (lc($arguments[1]) eq 'working' || lc($arguments[1]) eq 'sdc1'){
                $arguments[1] = '/dev/sdc1';
	    }

	}

	$response = readpipe("df -h ".$arguments[1]."| grep '/dev/sd' |  sed \'s/Filesystem            Size  Used Avail Use% Mounted on//\' | sed \'s/            / /' | sed 's/\\/dev\\/sd/\\n\\/dev\\/sd/' | grep -v /dev/sda1");

	$response = readpipe("df -h /media/rtorrent /media/video /media/movies /media/musique /media/data /media/production /media/vms --total");


     	my @lines = split(/\n/,$response);

	foreach(@lines){
	    $server->command('MSG '.$silence_target.' '.$_);
	}
	
    }
}
      	
signal_add("message public", "sizereport");
