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

#enables or disables the /npv and /nprv commands
our $np_VLC = 1;

#full path to the VLC xml file which will generate the XML data you want
our $np_VLC_URL = "http://127.0.0.1:8080/requests/irssi.xml";

#password for accessing the VLC web interface
our $np_VLC_PASS = "password"


#rt.pl
our $rt_SCRIPT_DIR = "~/scripts/";

#sr.pl
our %sr_ALIASES = ( 'path-to-mountpoint' => ['array', 'of', 'aliases']);

#ul.pl
our $ul_DBPATH = "~/.irssi";

#ut.pl
our $uptime_command = "cat /proc/uptime | awk '{print $1}'";
