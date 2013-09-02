package scriptcfg;

use strict;

##FILES WHICH USE THIS CONFIGURATION FILE
#ident.pl
#np.pl
#rt.pl
#sr.pl
#ul.pl

#ident.pl
%authorizations = ('netname' => ["username","servicename", "password"]);

#np.pl
$MPD_SERVER = "127.0.0.1";
$MPD_PORT   = "6600";

#rt.pl
$SCRIPT_DIR = "~/scripts/";

#sr.pl
%ALIASES = ( 'path-to-mountpoint' => ['array', 'of', 'aliases']);

#ul.pl
$DBPATH = "~/.irssi";
