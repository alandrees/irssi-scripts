package script_config;

use strict;

##FILES WHICH USE THIS CONFIGURATION FILE
#ident.pl
#np.pl
#rt.pl
#sr.pl
#ul.pl
#ut.pl

#ident.pl
our %id_authorizations = ('netname' => ["username","servicename", "password"]);

#np.pl
our $np_MPD_SERVER = "127.0.0.1";
our $np_MPD_PORT   = "6600";

#rt.pl
our $rt_SCRIPT_DIR = "~/scripts/";

#sr.pl
our %sr_ALIASES = ( 'path-to-mountpoint' => ['array', 'of', 'aliases']);

#ul.pl
our $ul_DBPATH = "~/.irssi";

#ut.pl
our $uptime_command = "cat /proc/uptime | awk '{print $1}'";
