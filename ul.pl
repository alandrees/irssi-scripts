use strict;
use Irssi;
use vars qw($VERSION %IRSSI);
use JSON::XS;
use HTTP::Request;
use LWP::UserAgent;
use LWP::Simple;
use HTML::HeadParser;
use IO::Socket::INET;
use DBI;
use Cwd;

use POSIX qw(strftime);


use threads;

$VERSION = '1.00';
%IRSSI = (
        authors         => 'Alan Drees',
        contact         => 'alandrees@theselves.com',
        name            => 'URLs',
        description     => 'URL lookup & shortening...',
        license         => 'GPLv3',
);

chdir "~";

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
	    log_url($data, $nick);

        }
        else{   
            Irssi::print("Some error occured trying to goo.gl that url! :(");
        }
    }
    else{   
        Irssi::print("No url to shorten!");
    }
}

sub trigger_title{
    my($server, $msg, $nick, $address, $target) = @_;

    my @arguments = split(' ',$msg);

    my($token,$title,$lasttitle,$response);

    foreach $token(@arguments){
	$response = "";
	if($token =~ /https*:\/\//){
	    if($token !~ /mp3\.com/){
		$title = title($token);
		if($title ne "" && $lasttitle ne $title){
		    $response .= $title." linked by 6".$nick;
		    $server->command("MSG ".$target." ".$response);
		    $lasttitle = $title;
		}
		log_url($token, $nick);
      	    }
	}
    }
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
    }

    return $title;
}

sub vimeo_title{                                                                                                                                                                        
    my($vid)=@_;
    
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
    my($url, $nick) = @_;
    my $db = DBI->connect("dbi:SQLite:dbname=url.db","","");
    
    $db->quote($url);
    $db->quote($nick);
    
    my $query = "INSERT INTO urlist (`url`,`nick`,`date`) VALUES('".$url."','".$nick."',strftime('%s'));";
    Irssi::print($query);
    my $qh = $db->prepare($query);

    $qh->execute();
    $db->disconnect();

}

sub setup_db{
    my($data, $server, $witem) = @_;
    my $db = DBI->connect( "dbi:SQLite:dbname=url.db" ,"" ,"");
    
    $db->do("CREATE TABLE urlist (id INTEGER PRIMARY KEY AUTOINCREMENT,url TEXT, nick TEXT,  date INTEGER);");
    $db->disconnect();
    Irssi::print("Database Created");
}

sub trigger_history{
    my($server, $msg, $nick, $address, $target) = @_;

    my @arguments = split(' ',$msg);

    my @urllist;
    if($arguments[0] eq '!url'){
	if(length(@arguments) == 1){
	    my %query = ('query' => 'select * from urlist order by id desc limit 10;',);
	    @urllist = get_url_list(%query);
	    

	    if ( (scalar(@urllist) % 4) == 0){
		while( my ($did, $durl, $dnick, $ddate) = splice(@urllist,0,4)){
		    $server->command("MSG " . $nick . " " . googl($durl) ." - " . title($durl,1) ." linked by  6". $dnick ." on ". strftime "%e/%m/%Y %T", gmtime($ddate));
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

}

sub get_url_list{
    my(%options) = @_;
    
    my $db = DBI->connect( "dbi:SQLite:dbname=url.db", "","",{ RaiseError => 0, AutoCommit => 1});
    
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

Irssi::signal_add('message private',\&shorten );
Irssi::signal_add('message public', \&trigger_title);
Irssi::signal_add('message irc action', \&trigger_title);
Irssi::signal_add('message public', \&trigger_history);
Irssi::command_bind('setupdb', \&setup_db);
