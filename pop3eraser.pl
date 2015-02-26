	use Mail::POP3Client;
	use MIME::Base64 ;
	$pop = new Mail::POP3Client( USER  => "me@github.com", PASSWORD => "wontgiveyou",HOST => "mail.host.com" , AUTH_MODE=>'PASS' );
	$count = $pop->Count() ; print "$count messages \n" ;
	#### Chaque message est examiné : 
	for ($i = 1; $i <= $pop->Count(); $i++) {
		# Recherche du header s'il s'agit d'un fichier exapaq, is_exapaq=1 ;
  		foreach ( $pop->Head( $i ) ) { # Analyse de chaque ligne en général une 20 aine de lignes...
			#if(/^(From|Subject):(.*)/i){ print $_ ."\n" ; 	}
			#/^From:(.*)/i && printf( "%03d %40.40s |",$i, $1 );
			/^Subject:(.*)/i && printf( "%03d >> %-60s\n", $i,  $1 );
		}
	}#fin de for
	$pop->Close();

exit(0) ;
