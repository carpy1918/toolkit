#!/usr/bin/perl

#
#limits-conf.pl - management of the entries in /etc/security/limits.conf. insert and edit
#

`. ./tealeaf-env.sh`;
my $CFILE = shift();
my $ADDITION = shift();

if($CFILE eq '' || $ADDITION eq '')
{ print "Bad file given on CL\nSyntax: limits-conf.pl <config_file> <mod_file> <field_separator>\n";exit; }

`cp $CFILE $CFILE.bkup`;
open(fh1, "$ADDITION") or die("cannot open $ADDITION\n");
open(fh3, "$CFILE.bkup") or die("cannot open $CFILE.bkup\n");
open(fh2, ">$CFILE") or die("cannot open $CFILE\n");
my @NEW=<fh1>;
my @BKUP=<fh3>;
my @MERGE=@BKUP;
my $SEPARATOR=shift();
my $COUNT=0;
my $debug=1;

if($CFILE eq '' || $ADDITION eq '')
{ print "No file given on CL\n";exit; }

foreach(@MERGE)		#foreach config file entry check it against the old ones
{
  print "Hit \@MERGE with $_\n" if $debug;
  my @CONFIGv=split(/\s+/,$_);
  my $WRITTENv=0;
  my $COUNTn=0;
  foreach(@NEW)
  {
    print "Hit \@NEW with $_\n" if $debug;
    @NEWv=split(/\s+/,$_);
    next if $WRITTENv == 1;
    next if $CONFIGv[0] =~ /^#/;
    if($CONFIGv[0] eq $NEWv[0])       #1st value
    { 
      if($CONFIGv[1] eq $NEWv[1])     #2nd value
      {
        if($CONFIGv[2] eq $NEWv[2])   #3rd value
        {
          if($CONFIGv[3] eq $NEWv[3]) #4th value
 	  {
            $NEW[$COUNTn] = '';
	    $WRITTENv++;
	  } #end 3 if
          else
  	  { 
	    $MERGE[$COUNT] = $CONFIGv[0] . $SEPARATOR . $CONFIGv[1] . $SEPARATOR . $CONFIGv[2] . $SEPARATOR . $NEWv[3];
            $NEW[$COUNTn]='';
	    $WRITTEN++;
	  }
        } #end 2 if
      } #end 1 if
    } #end 0 if
    $COUNTn++;
  } #end foreach NEW 
  $COUNT++;
} #foreach MERGE

foreach(@NEW)
{
  next if $_ eq '';
  push(@MERGE,$_);
}
foreach(@MERGE)		#print config file
{
  print fh2 $_;
}
