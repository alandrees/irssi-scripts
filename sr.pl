use strict;
use vars qw($VERSION %IRSSI %ALIASES);
use Irssi qw(command_bind signal_add);

$VERSION = '1.00';
%IRSSI = (
        authors         => 'Alan Drees',
        contact         => 'alandrees@theselves.com',
        name            => 'sizereport',
        description     => 'Reports current storage system statistics (free/total)',
        license         => 'GPLv3',
    );

#it will use the keys here to create a list of mount points to add to the sizereport

#mountpoint => (list of ailiases)
%ALIASES = ( '/mnt/data' => ['data','backups','sda1'],
	     '/mnt/local-data' => ['local-data','backups','sdd2'] );

sub _sizereport{
    my($server, $msg, $nick, $address, $target) = @_;
    my($response, $path_list);

    $path_list = '';
    my @arguments = split(' ',$msg);
    my @mps;
    if(lc($arguments[0]) eq '!sizereport'){

	if($arguments[1] ne ''){
	    foreach(@mps = @arguments[1 .. (scalar(@arguments) - 1)]){
		my $argument = $_;
		while ( my ($key, $value) = each (%ALIASES) ){
		    if($argument eq $key){
			if(index($path_list, $key) == -1){
			    $path_list .= $key . " ";
			    last;
			}else{
			    last;
			}
		    }else{
			foreach(@{$value}){
			    if($argument eq $_){
				if(index($path_list, $key) == -1){
				    $path_list .= $key . " ";
				}else{
				    last;
				}
			    }
			}
		    }
		}
	    }
	}else{
	    my @temp_keys = keys(%ALIASES);
	    
	    foreach(@temp_keys){

		$path_list .= $_ . " ";
	    }
	}

	Irssi::print($path_list);

	if($path_list ne ""){
	    if($arguments[1] eq ''){
		$response = readpipe("df -h ".$path_list."--total");
	    }else{
		if(scalar(@mps) == 1){
		    $response = readpipe("df -h ".$path_list);
		}else{
		    $response = readpipe("df -h ".$path_list."--total");
		}
	    }

	    my @lines = split(/\n/,$response);

	    foreach(@lines){
		$server->command('MSG '.$target.' '.$_);
	    }
	}
	
    }
}
      	
signal_add("message public", "_sizereport");
