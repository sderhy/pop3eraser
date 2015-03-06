# pop3eraser
I needed a simple program to quickly delete my emails from my pop3 account. 

But rather than deleting all at once, it had to display each subject line separately, moving from line to line with a "j" or "k" or arrow up arrow down key.
If unwanted, mark it (x) for deletion, then at the end commit (or not) the deletion.

I wanted it to work as a vim plugin, but didn't found it, so I had to program something.
It's a very simple perl command line utility.

## Requirements: 
perl installed,with these modules:  
	-  Term::Screen;
	-  Mail::POP3Client;
	-  MIME::Base64.

Use something like "sudo cpan install Mail::POP3Client"  or whatever works on you OS.

## Configuration:
	Please edit the pop3eraser.pl file at the beginning.

## Launching:  
	perl pop3eraser.pl
	type j or k to walk through your mails subjects
	type x to mark for deletion.
	when you are finished, type qq and confirm with y to delete.
	You can also exit without deleting by typing q our n.

This utility is entirely free.
If you use it, please send me an email, I would be soooo happy !

Serge Derhy

