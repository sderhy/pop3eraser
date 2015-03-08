# This program is aimed at deleting pop3 mail, without looking further than the subject.
# I am developping it on github as a test please allow some  mistakes !
# Edit here your configuration:
	$host =  "maildomain.maildomain.maildomain" ; 
	$user = "$user" ;
	$password = "mysecretpassword" ; 
	#require ("config.pl") ;  # or require a personnal config

# Libraries: 
# sudo cpan install .. 
	use Term::Screen;
	use Mail::POP3Client;
	use MIME::Base64 ;
	use Encode qw/encode decode/;


# Global variables: 
	($x,$y) = (0,0) ; # global variables to maintain the screen 
	@froms=() ;
	$scr ; 
	@todelete = () ; 

# Connexion, and get the froms and subjects: 
	$pop = connexion() ; 
	$count = $pop->Count() ;# number of messages
	@subjects = getSubjects($pop) ; 

# Use the terminal :
	 usescreen( @subjects) ; 
	$pop->Close();

	exit(0) ; 

#### Below are functions only ###
sub connexion(){
	$pop = new Mail::POP3Client( 
			USER  =>$user, 
			PASSWORD => $password ,
			HOST => $host ,
			AUTH_MODE=>'PASS' );
	return $pop ; 
}

sub getSubjects($pop){
	my $pop = shift ; 
	my $from = ''; 
	my @subjects = ()  ; 
	for ($i = 1; $i <= $pop->Count(); $i++) {

  		foreach ( $pop->Head( $i ) ) { 
			if(/^From: ?(.*)/i){
				$from   =   decode('MIME-HEADER', $1)  ;
				$from   =~s/"//g ;
				$froms[$i] = $from ; 
				$from ='';
			}
			if(/^Subject:(.*)/i){
				$subjects[$i] =  decode('MIME-HEADER', $1)  ; 
			}
			
			
		}#end foreach
	}#End of for 
	return   @subjects ; 
}

sub usescreen(){

	my @subjects = @_ ; 
	my $count = scalar(@subjects) ;
	$scr = new Term::Screen;
	unless ($scr) { die " Something's wrong \n"; }
	$scr->clrscr();
	my $rows = $scr -> rows() ; 
	my $cols = $scr -> cols() ; 

	my $numLines = $count > $rows ? $rows : $count ; 
	my $i  ; 
	
	status($scr, "There is ". ($count -1)  . " messages . " )  ; 
	my $line= '';
	foreach my $x(1 .. $cols){ $line .= '-' ; }
	$scr->at(5,0) ->puts(  $line ) ;
	$scr->at(6,0) ->puts( "Strike  j to go down , k up , x mark for deletion , qq to quit and y to confirm")  ;  

	my $c =''; 
	$scr->noecho() ; 
	while($c ne 'q' ){
		$c = $scr->getch();      # doesn't need Enter key 
		charnavigation($scr, $c) ; 
	}
	$c= $scr->getch() ;
	status( $scr , "Delete ".countMsg()." mails ? n or y  ") ; 
	while(1){
		$c= $scr->getch() ;
		if($c eq 'y') {
			erase() ; 
			last ; 
		}
		if($c =~m/[nqNQ]/) { last ; } 
	}
}

sub erase{
	my $i = 0 ; 
			
	$scr->clreol() -> at(0,0) -> puts("Deleted messages: ") ; 	
	for($i=0; $i < scalar(@todelete) ; $i++ ) {
		if($todelete[$i] eq "X"){
			$pop->Delete($i);
			$scr->bold()->puts("...$i ") ->normal() ; 
		}
	}
}

# See also Term::ReadKey
sub charnavigation(){
	my ($scr , $c ) =  @_ ; 
	if($c eq 'k' or $c eq "ku" ){
		$i=$i-1 ; 
		if($i==0){  $i=1 ; }
	}elsif($c eq  'j' or $c eq "kd" ) { 
		$i++ ; 
		if($i > $count) {  $i=$count  ;  }
	}elsif($c eq 'x'){
		if($todelete[$i] eq "X") {  $todelete[$i] =''} else {  $todelete[$i]="X" ;}
	}
	displayMessage($scr, $i , 2, 0 ) ; 
	
}

sub displayMessage {
		my($scr, $i ,$r,$c) = @_ ; 
		$scr ->at($r,$c) ->clreol() ->normal()-> puts( $froms[$i])  ; 	
		$scr ->at($r+1,$c) ->clreol() ->bold() ->puts($i ) ->normal()-> puts(" [".$todelete[$i]."] ") ->puts( $subjects[$i])  ; 	
		$scr ->at($r+2,$c) ->clreol() ; 
		return $scr ;
}

sub status{
	my ($scr, $msg)  = @_ ; 
	$scr->clreol() -> at(0,0) -> puts($msg) ; 	
}

sub countMsg{
	my $totalX = O ; 
	foreach my $x(1 .. $count){
		if($todelete[$x] eq "X"){  $totalX = $totalX+1 ; }
	}
	return $totalX ; 
}
exit(0) ;
