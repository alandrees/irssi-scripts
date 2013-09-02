package script_config;

use strict;

##FILES WHICH USE THIS CONFIGURATION FILE
#ident.pl
#np.pl
#rt.pl
#sr.pl
#ul.pl

#ident.pl
%id_authorizations = ('netname' => ["username","servicename", "password"]);

#np.pl
$np_MPD_SERVER = "127.0.0.1";
$np_MPD_PORT   = "6600";

#rt.pl
$rt_SCRIPT_DIR = "~/scripts/";

#sr.pl
%sr_ALIASES = ( 'path-to-mountpoint' => ['array', 'of', 'aliases']);

#ul.pl
$ul_DBPATH = "~/.irssi";
