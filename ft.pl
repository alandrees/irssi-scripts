use strict;
use vars qw($VERSION %IRSSI);
use Filesys::Df;
use Irssi qw(command_bind signal_add);

$VERSION = '1.00';
%IRSSI = (
        authors         => 'Alan Drees' ,
        contact         => 'alandrees@theselves.com',
        name            => 'Random Futurama Quote',
        description     => 'Outputs Random quote',
        license         => 'GPLv3',
    );


#db is not really a database, just a file where each line is a quote...

$DATABASE = "/home/deepie/.irssi/scripts/futurama.db"
$TRIGGER = "!futurama"

# Perl trim function to remove whitespace from the start and end of the string
sub trim($)
{
    my $string = shift;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
    return $string;
}
# Left trim function to remove leading whitespace
sub ltrim($)
{
    my $string = shift;
    $string =~ s/^\s+//;
    return $string;
}
# Right trim function to remove trailing whitespace
sub rtrim($)
{
    my $string = shift;
    $string =~ s/\s+$//;
    return $string;
}

sub quote{
    my($server, $msg, $nick, $address, $target) = @_;
    my($response, $silence_target);

    my @arguments = split(' ',$msg);

    if(lc($arguments[0]) eq $TRIGGER){

	open(F_DB, $DATABASE);
	my @db=<F_DB>;
	close F_DB;

	my $add = "1";


	if($arguments[1] eq "add"){
	    open(F_DB, ">>".$DATABASE) || die("unable to open database");
	    print F_DB $response;
	    close(F_DB);
	}else{
	    open(F_DB, $DATABASE);
	    my @db=<FUT_DB>;
	    close F_DB;

	    $response = trim($db[ int( rand( scalar(@db) - 1 ) ) ] );
	}
	   
    }else{
	my @temp;
	open(F_DB, $DATABASE);
	my @db=<F_DB>;
	close F_DB;
	my $probability = rand();
	if($probability >= 0.95){
	    foreach my $argument (@arguments){
		if(length($argument) > 2){
		    foreach my $quote (@db){
			if($quote =~ $argument){
			    push(@temp, $quote);
			}
		    }
		}
	    }
	    $response = trim( $temp[ int( rand( scalar(@temp) - 1 ) ) ] );
	}else{
	    $response = "";
	}
    }
    
    if ( $response ne ""){
	$server->command('MSG '.$target.' 6'.$response);
    }

}

signal_add("message public", "quote");
