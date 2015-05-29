package script_config;

use strict;

##FILES WHICH USE THIS CONFIGURATION FILE
#ident.pl
#np.pl
#rt.pl
#sr.pl
#ul.pl
#ut.pl



###ident.pl###

#this is a list of authorizations this client can make
our %id_authorizations = ('netname' => ["username","servicename", "password"]);



###np.pl###

#mpd server url or domain name
our $np_MPD_SERVER = "127.0.0.1";

#mpd server port
our $np_MPD_PORT   = "6600";

#enables or disables the /npv and /nprv commands
our $np_VLC = 1;

#list of paths to the VLC xml file which will generate the XML data you want
#these urls are checked in order of the array, so keep that in mind when constructing
#the array. $np_VLC_URL must be an empty string, or else it won't be checked

our @np_VLC_URL_LIST = ("http://127.0.0.1:8080/requests/irssi.xml",
			"http://192.168.0.1:8080/requests/irssi.xml");

#full path to the VLC xml file which will generate the XML data you want (if you only want to check one system)
our $np_VLC_URL = "http://127.0.0.1:8080/requests/irssi.xml";

#password for accessing the VLC web interface
our $np_VLC_PASS = "password";



####rt.pl###

#script directory containing the rtorrent script
our $rt_SCRIPT_DIR = "~/scripts/";



###sr.pl###

#aliases for path
our %sr_ALIASES = ( 'path-to-mountpoint' => ['array', 'of', 'aliases']);



###ul.pl###

#path to the url database file
our $ul_DBPATH = "~/.irssi";

#url ignore list for incoming /me commands
our $ul_ME_IGNORE_LIST = ();

#url ignore list for incoming /msg commands
our $ul_MSG_IGNORE_LIST = ();

#Server API key for youtube data
our $ul_YOUTUBE_API_KEY = "";

#Personal Access Token for vimeo.com API
our $ul_VIMEO_AUTH_KEY = "";

###ut.pl###

#the command to execute 4to get the uptime to be displayed in the channel
our $uptime_command = "cat /proc/uptime | awk '{print $1}'";

#up.pl
our $ups_commands = ('upsname' => "command to execute to get the current load in watts");
