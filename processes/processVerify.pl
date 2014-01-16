#!/bin/perl

#This script will cross-compare the /proc PID dirs and the output of ps.  Just as a basic sanity check

my @temp;
my @ps;
my @proc;
my $debug = 0;

my @temp = </proc/*>;
foreach(@temp)
{
   print "proc string: " . $_ . "\n" if($debug);
   if($_ =~ /\/proc\/(\d+)/)
   {
      my $p = $1;
      push(@proc,$p);
   } #end if
} #end proc

my @temp = `ps aux`;
foreach(@temp)
{
   print "ps string: " . $_ . "\n" if($debug);
   if($_ =~ /^\w+\s+(\d+)/)
   {
      print "match hit: " . $1 . "\n" if($debug);
      push(@ps,$1);
   } #end if
} #end ps

foreach(@proc)
{
   my $p = $_;
   my $found = 0;
   print "searching for: $p\n" if($debug);
   foreach(@ps)
   { $found++ if($p == $_) } #foreach
   if($found == 0)
   {
      if(-d "/proc" . $p)
      {
        my $alert = "Warning: $p process found in /proc not listed in ps!\n";
        my $cat = `cat /proc/$p/cmdline;`;
        my $stat = `cat /proc/$p/stat;`;
        print $alert . "\n" . $cat . "\n" . $stat . "\n";
        email($alert . $cat . $stat);
      } #if
      else
      { print "Proc $p dir already disappeared, ignoring for good or bad\n"; }
   } #foreach
} #end foreach

sub email($)
{
   my $mail_to = "cc771m\@att.com";
   my $mail_from = `seta` . "\@att.com";
   my $subject = "`hostname` - process alert";
   my $mail_body = $_;
   my $sendmail = "/usr/lib/sendmail -t";

   open(SENDMAIL, "|$sendmail") or die "Cannot open sendmail: $!";
   print (SENDMAIL "To: " . $mail_to . "\nFrom: " . $mail_from . "\nSubject: " . $subject . "\n\n" . $mail_body);
   close(SENDMAIL);
} #end email
