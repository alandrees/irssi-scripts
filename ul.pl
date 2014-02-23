use strict;
use Irssi;
use script_config;
use vars qw($VERSION %IRSSI);
use JSON::XS;
use HTTP::Request;
use LWP::UserAgent;
use LWP::Simple;
use HTML::HeadParser;
use IO::Socket::INET;
use DBI;
use DBI qw(:sql_types);
use Cwd;
use URI;
use Data::Dumper;

use POSIX qw(strftime);

use Module::Refresh;

use threads;

###########################
####TODO:
####     sprintf all the db queries
####     add the other db search command line options
####     add other statistical analysis of the database
##########################

$VERSION = '1.00';
%IRSSI = (
        authors         => 'Alan Drees',
        contact         => 'alandrees@theselves.com',
        name            => 'URLs',
        description     => 'URL lookup & shortening...',
        license         => 'GPLv3',
);


##NOTE: Careful with ~. If you su'd into a bot's account, use the full path, because ~ will be for the 
#       account you originally logged in as (even if you did something like script /dev/null 
#       or the like).

chdir $script_config::ul_DBPATH;


##\fn 
sub shorten{   
    my($server, $msg, $nick, $address, $target) = @_;

    my @arguments = split(' ',$msg);

    my ($uri, $json, $req, $js, $response, $msg, $data, $output, $info);

    my $target = "#moonbeam";

    if(lc($arguments[0]) eq '!glg'){
	if($arguments[1] eq '-p'){
	    $target = $nick;
	    for(my $count = 2; $count < @arguments; $count++){
		$data .= $arguments[$count];
	    }
	}else{
	    #parse the string
	    for(my $count = 1; $count < @arguments; $count++){
		$data .= $arguments[$count];
	    }
	}
    
	my $shortened = googl($data);
        
	if($js->{id}){
	    #get the title if it's not a private link
	    if($arguments[1] ne "-p"){
		my $head = title($data);
		$info .= " ".$head. " linked by 6".$nick;
	    }
	    
	    $server->command("MSG ".$target." ".$js->{id}.$info);
	    log_url($data, $nick, lc($target));

        }
        else{   
            Irssi::print("Some error occured trying to goo.gl that url! :(");
        }
    }
    else{   
        Irssi::print("No url to shorten!");
    }
}

#this is the entry point for a message being receieved
sub trigger_title_msg{
    my($server, $msg, $nick, $address, $target) = @_;

    my @arguments = split(' ',$msg);

    my($token, $url, $filter_url);

    foreach $token (@arguments){
	if($token =~ /https*:\/\//){

	    $url = URI->new($token);
	    


	    foreach $filter_url (@script_config::ul_MSG_IGNORE_LIST){

		if( index($url->host, $filter_url) != -1){
		    
		    return;
		}
	    }

	    trigger_title($server, 
			  $token, 
			  $nick, 
			  $address, 
			  $target);
	}
    }
}

#this is the entry point for an action being performed
sub trigger_title_me{
    my($server, $msg, $nick, $address, $target) = @_;

    my @arguments = split(' ',$msg);

    my($token, $url, $filter_url);

    foreach $token (@arguments){
	if($token =~ /https*:\/\//){

	    $url = URI->new($token);
	    


	    foreach $filter_url (@script_config::ul_ME_IGNORE_LIST){

		if( index($url->host, $filter_url) != -1){
		    
		    return;
		}
	    }

	    trigger_title($server, 
			  $token, 
			  $nick, 
			  $address, 
			  $target);
	}
    }
}

sub trigger_title{
    my($server, $url, $nick, $address, $target) = @_;

    my($response) = "";
    
    my $title = title($url);

    my $repost = build_repost_string($url, $target);

    if($title ne ""){
	$response .= $title." linked by 6".$nick;
	$server->command("MSG ".$target." ".$response);
    }

    if($response ne ""){
	$server->command("MSG ".$target." ".$repost);
    }

    log_url($url, $nick, lc($target));
}

sub title{
    my($url, $gl_url) = @_;
    my $title = "";
    
    if($url=~ m/vimeo.com/){
	$title = vimeo_title($url);
    }elsif($url=~ m/youtube.com/){
	$title = youtube_title($url);
    }else{
	my $req = HTTP::Request->new('GET',$url);

	my $lwp = LWP::UserAgent->new;

	my $mimetype = $lwp->head($url);

	my @content_type = split(';',$mimetype->header('Content-Type'));
	
	if( (@content_type[0] eq "text/html" ) || ( @content_type[0] eq "text/plain" ) ){
 

	    if(@content_type[0] eq "text/html"){

		my $response = $lwp->request($req);

		my $p = HTML::HeadParser->new;
		$p->parse($response->decoded_content);

		if($gl_url != 1){
		    my $g = googl($url);
		    
		    if($g ne ""){
			$title .= $g . " - ";
		    }
		}

		$title .= $p->header('Title');
	    }else{
		my $response = $lwp->request($req);
		
		my @lines = split('\n', $response->decoded_content);
		
		$title .= @lines[0];
	    }	
		
	}else{
	    $title .= @content_type[0];
	}
    }

    return $title;
}

sub vimeo_title{                                                                                                                                                                        
    my($vid) = @_;
    
    #this line matches to the 
    $vid =~ m/(?:https*:\/\/|www\.|https*:\/\/www\.)vimeo\.com\/([^\s&\?\.,!]+)/;
    $vid = $1;

    my $sock = IO::Socket::INET->new(
                PeerAddr=>'vimeo.com',
                PeerPort=>'http(80)',
                Proto=>'tcp',
	    );
    my $req="GET /api/v2/video/$vid.xml HTTP/1.0\r\n";
    $req.="host: vimeo.com\r\n";
    $req.="\r\n";
    my $title;

    print $sock $req;                                                                                                                                                                 
    while(<$sock>) {                                                                                                                                                                  
                if(/<title>(.*)<\/title>/) {                                                                                                                                             
                        close $sock;                                                                                                                                                     
                        $title = $1;
                }                                                                                                                                                                        
    }                                                                                                                                                                                 
                                                                                                                                                                                         
    return '11vimeo - 14'.$title.'';
}

sub youtube_title {
    my($vid)=@_;
    
    #this line matches to the last part of the url, the video id
    $vid =~ m/(?:https*:\/\/|www\.|https*:\/\/www\.)youtube\.com\/watch\?\S*v=([^\s&\?\.,!]+)/;
    $vid = $1;

    my $sock = IO::Socket::INET->new(
	PeerAddr=>'gdata.youtube.com',
        PeerPort=>'http(80)',
        Proto=>'tcp',
	); 
    
    my $req="GET /feeds/api/videos/$vid HTTP/1.0\r\n";    
    $req.="host: gdata.youtube.com\r\n";
    #$req.="user-agent: $IRSSI{'name'}-$VERSION (irssi script)\r\n";
    $req.="\r\n";

    my $title;

    print $sock $req;
    while(<$sock>) {
	if(/<media:title type='plain'>(.*)<\/media:title>/) {
	    close $sock;
            $title = $1;
	}
    }

    

    return '0YOU4TUBE - 14'.$title.'';
}

sub build_repost_string{
    my($url, $channel) = @_;

    my $repost_data = check_for_repost($url, $channel);

    if(exists $repost_data->{'nick'}){
    	return "4<<REPOST ALERT>>7 ".$repost_data->{'nick'}." 7@7 ".strftime("%e/%m/%Y %T", gmtime($repost_data->{'date'}))." 4<<REPOST ALERT>>";
    }else{
	return "";
    }
}


sub googl{
    my($data) = @_;

    my $uri = 'https://www.googleapis.com/urlshortener/v1/url?key=AIzaSyAIm2aMUFrsv0KDrKzAlOrrgrUCOOEIKWU';
    my $json = '{longUrl: "'.$data.'"}';

    my $req = HTTP::Request->new('POST', $uri);

    $req->header('Content-Type' => 'application/json');
    $req->content($json);

    my $lwp = LWP::UserAgent->new;
    my $response = $lwp->request($req);

    my $js = decode_json $response->decoded_content;

    if($js->{id}){
	return $js->{id};
    }
}

sub log_url{
    my($url, $nick, $channel) = @_;
    my $db = DBI->connect("dbi:SQLite:dbname=".$script_config::ul_DBPATH,"","");
    $db->quote($url);
    $db->quote($nick);
    $db->quote($channel);

    my $query = "INSERT INTO urlist (`url`,`nick`,`date`,`channel`) VALUES('".$url."','".$nick."',strftime('%s'),'".$channel."');";
    my $qh = $db->prepare($query);

    $qh->execute();
    $db->disconnect();

}

sub setup_db{
    my($data, $server, $witem) = @_;
    my $db = DBI->connect( "dbi:SQLite:dbname=".$script_config::ul_DBPATH,"" ,"");
    
    my($query) = "";

    $query = 
	"CREATE TABLE ".
	"urlist (id INTEGER PRIMARY KEY AUTOINCREMENT, url TEXT, nick TEXT, date INTEGER, channel TEXT);";

    $db->do($query);
    $db->disconnect();
    Irssi::print("Database Created");
}

sub trigger_command{
    my($server, $msg, $nick, $address, $target) = @_;

    my @arguments = split(' ',$msg);

    my @urllist;
    if($arguments[0] eq '!url'){
	if(length(@arguments) == 1){
	    my %query = ('query' => "SELECT * FROM `urlist` WHERE `channel` = '".$target."' ORDER BY id DESC LIMIT 10;");

	    @urllist = get_url_list(%query);
	    
	    if ( (scalar(@urllist) % 5) == 0){
		while( my ($did, $durl, $dnick, $ddate, $channel) = splice(@urllist,0,5)){
		    $server->command("MSG " . $nick . " " . googl($durl) ." - " . title($durl,1) ." linked by  6". $dnick ." on ". strftime "%e/%m/%Y %T", gmtime($ddate));
		}
	    }
	}
    }elsif($arguments[0] eq '!top10'){
	my %query = ('query' => "SELECT DISTINCT url FROM `urlist` WHERE `channel` = '".$target."'");

	my %toplist = ();

	my $uri;

	my $urllist;

	@urllist = get_url_list(%query);

	foreach my $url(@urllist){
	    if($url =~ /^https*:\/\//){

		$uri = URI->new($url);

		if ( exists($toplist{$uri->host}) ){
		    $toplist{$uri->host}++;
		}else{
		    $toplist{$uri->host} = 1;
		}

	    }
	}

	my $i = 0;

	my @keys = sort {$toplist{$b} <=> $toplist{$a} } keys %toplist;

	foreach( @keys ){
	    if ($i < 10){
		$server->command("MSG ".$target." ".$_.": ".$toplist{$_});
		$i++;
	    }else{
		last;
	    }
	}
	    
    }
	#case for help

        #case for providing a user

	#case for providing a date, or a date and a range, or a word "last week", "today", "yesterday"

	#case for providing a domain, and searching by domain

	#case for providing a number to display, or a number and a range

	#case for no options, just list the 5 or 10 previous URLs

	#output: limit the maximum output of urls to a reasonable number, and private message the rest... have a hard limit so as to not slow things down too much

}

sub check_for_repost{
    my($url, $channel) = @_;

    my $row = {};

    my $db = DBI->connect( "dbi:SQLite:dbname=".$script_config::ul_DBPATH, 
			   "" , 
			   "", 
			   {AutoCommit => 1, 
			    RaiseError => 1});


    #my $query = "SELECT * FROM `urlist` WHERE `channel` = ? AND `url` = ? ORDER BY date LIMIT 1";

    my $query = "SELECT * FROM `urlist` WHERE `channel` = ? AND `url` = ? ORDER BY date LIMIT 1";
    
    my $qh = $db->prepare($query);
    
    $qh->bind_param(1, $channel);
    $qh->bind_param(2, $url);

    $qh->execute();
    
    if(! ($row = $qh->fetchrow_hashref() ) ){
	$db->disconnect();
	return {};
    }

    return $row;
}
    
sub get_url_list{
    my(%options) = @_;
    
    my $db = DBI->connect( "dbi:SQLite:dbname=".$script_config::ul_DBPATH, "","",{ RaiseError => 1, AutoCommit => 1});
    
    my($qh, @record, @records);

    if(exists $options{'query'}){
	$qh = $db->prepare($options{'query'});
	$qh->execute();
    }
    
    while(@record = $qh->fetchrow_array()){
	push(@records, @record);
    }

    $db->disconnect();
    return @records;
}

sub url_count{
    my($query, $db, $qr, $result);

    my $db = DBI->connect("dbi:SQLite:dbname=".$script_config::ul_DBPATH,"","");
    $query = "SELECT DISTINCT COUNT(url) AS count FROM urlist;";

    $qr = $db->prepare($query);

    $qr->execute();
    
    $result = $qr->fetchrow_array();
    
    Irssi::print($result);

    $db->disconnect();

    return $result;
}

sub trigger_count{
    my($server, $msg, $nick, $address, $target) = @_;

    if ($msg =~ "!ucount") {
        $server->command("MSG ".$target." "."There are currently ".url_count()." urls in the database.");
    }
}

sub assemble_statistics{
    #statistics like who posts most frequently, 
    #what domains are most frequent
}
    
Irssi::signal_add('message private',\&shorten );
Irssi::signal_add('message public', \&trigger_title_msg);
Irssi::signal_add('message irc action', \&trigger_title_me);
Irssi::signal_add('message public', \&trigger_command);
Irssi::signal_add('message public', \&trigger_count);
Irssi::command_bind('setupdb', \&setup_db);
#Irssi::signal_add('message public',\&url_stats);
#Irssi::signal_add('message private',\&url_stats);
Irssi::command_bind('test', \&url_stats);

#this refreshes the script_config.pm module, meaning you don't need reload
#all of irssi just to test a new configuration variable
my $refresher = Module::Refresh->new;
$refresher->refresh_module('script_config.pm');
