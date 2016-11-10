use strict;
use vars qw($VERSION %IRSSI);

use Irssi qw(command_bind signal_add);

use Module::Refresh;
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
    if(lc($msg) =~ '!br'){
	$server->command('msg '.$target.' ヽ( ｡ヮﾟ)c[~]');
	return
    }

    #table flip
    if(lc($msg) =~ '!tf'){
	$server->command('msg '.$target.' (╯ `Д´)╯ ~┻━━━┻');
	return
    }

    #coffee
    if(lc($msg) =~ '!cf'){
	$server->command('msg '.$target.' \( \'-\')c[~]');
	return
    }

    #kyubi
    if(lc($msg) =~ '!ky'){
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

    #point
    if(lc($msg) =~ '!pt'){
	$server->command('msg '.$target.' ☜(ﾟヮﾟ☜)');
    }

    #david caruso
    if(lc($msg) =~ '!dc'){
	$server->command('msg '.$target.' (•_•)');
	$server->command('msg '.$target.'  ( •_•)>⌐■-■');
	$server->command('msg '.$target.' (⌐■_■)');
    }

    #lenny
    if(lc($msg) =~ '!lenny'){
	$server->command('msg '.$target.' ( ͡° ͜ʖ ͡°)');
    }

    #shrug
    if(lc($msg) =~ '!sh'){
       $server->command('msg '.$target.' ¯\_(ツ)_/¯');
    }

    #yah
    if(lc($msg) =~ '!ya'){
	$server->command('msg '.$target.' ˉ\\oˉ\\');
    }
}

signal_add("message public", "_text_trigger");

#this refreshes the script_config.pm module, meaning you don't need reload
#all of irssi just to test a new configuration variable
my $refresher = Module::Refresh->new;
$refresher->refresh_module('script_config.pm');
