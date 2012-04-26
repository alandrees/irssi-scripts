use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);

$VERSION = '1.01';
%IRSSI = (
        authors         => 'Alan Drees',
        contact         => 'alandrees@theselves.com',
        name            => 'ascii art',
        description     => 'Some ascii characters... to make IRC even more interesting!',
        license         => 'GPLv2',
);

sub _text_trigger{
        my ($server, $msg, $nick, $address, $target) = @_;
        my ($selfnick);
        $selfnick = lc($server->{nick});
       
	#beer
	if(lc($msg) =~ "!br"){
	    $server->command('msg '.$target.' ヽ( ｡ヮﾟ)c[~]');
	    return
        }

	#table flip
	if(lc($msg) =~ "!tf"){
	    $server->command('msg '.$target.' (╯ `Д´)╯ ~┻━━━┻');
	    return
        }

	#coffee
	if(lc($msg) =~ "!cf"){
	    $server->command('msg '.$target.' \( \'-\')c[~]');
	    return
        }

	#kyubi
	if(lc($msg) =~ "!ky"){                                                                            
	    $server->command('msg '.$target.' ／人◕ ‿‿ ◕人＼');
	    return
	}

	#look of disapproval
	if(lc($msg) =~ '!lod'){
            $server->command('msg '.$target.' ಠ_ಠ');
	    return
        }

	#????
	if(lc($msg) =~ '!ki'){
	    $server->command('msg '.$target.' ｷﾀ━━━━━━（゜∀゜）━━━━━━ッ!!');
	    return
	}
	
	#zoidberg
	if(lc($msg) =~ '!zb'){
	    $server->command('msg '.$target.' (V) (;,,;) (V)');
	    return
	}

	#crazy
	if(lc($msg) =~ '!cz'){
	    $server->command('msg '.$target.' ヽ( ｡ ヮﾟ)7');
	}
}

signal_add("message public", "_text_trigger");
