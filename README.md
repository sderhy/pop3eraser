# pop3eraser
I needed a simple command line programm to delete my mails from my pop3account.
It's a very simple perl command line utility
I wanted it to work as a vi utility, but I didn't found it so I had to program it.

Requirements: 
perl installed,with these modules: 
	-  Term::Screen;
	-  Switch; 
	-  Mail::POP3Client;
	-  MIME::Base64 ;
Configuration:
	Please edit the pop3eraser.pl file at the beginning.

Launching: 
	perl pop3eraser.pl
	type j or k to walk through your mails subjects
	type x to mark for deletion.
	when you are finished, type qq and confirm with y to delete.
	You can also exit without deleting by typing q our n.

This utility is entirely free.
If you use it, please send me an email, I would be soooo happy !

Serge Derhy
