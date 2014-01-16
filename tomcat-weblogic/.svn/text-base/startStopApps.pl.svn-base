#!/usr/bin/perl

#this script is going to start all apps across a platform - weblogic and tomcat

my @apps = ('qadomain01');
my $host = `hostname`;

#Key == server name, value == apps list

   if(@ARGV != 1)
   {
      print "syntax: startStopApps.pl <[start|stop]>\n";
      exit;
   }

foreach(@apps)
{
   my $pid = fork();
   my $result;

   if($pid == 0)
   {
      my $flag = 0;
      while($flag =< 1)
      {
         if($flag == 0)
         {
            sleep(1);
            $flag = loadCheck();
         }
      $result = commandCentral($_);
      if(-f $result)
      {
         print "App $_ ERROR";
         my $body;
         open(fh,$_);
         while(<fh>)
         { $body = $body . $_; }
         close(fh);
         email($body);
      }
      $flag++;
   }
   else
   { waitpid($pid,0); }

} #end foreach


sub commandCentral($)
{
   my $app = shift();
   my $result;
   my $LOG = "/root/logs/appStartup/$host-`$date( +%m%d%Y).log`";
   #start apps
   $result = `exec 3>&amp;1;exec1>$LOG;/etc/init.d/viant-$app $1;exec 1>&amp;3;exec 3>&amp;-`;
   if($result == 0)
   { return 0; }
   else
   { return $LOG; }
}

sub loadCheck()
{
  #return 1 if success or 0 if fail
  my result = `loadCheck.sh`;
  if($result == 0)
  { return 1; }
  else
  { return 0; }
}

sub email($)
{
   my $mail_to = "curtis.carpenter\@viant.com";
   my $mail_from = "$host\@viant.com";
   my $subject = "$host - $1 Error Alert";
   my $mail_body = shift();
   my $sendmail = "/usr/lib/sendmail -t";

   open(SENDMAIL, "|$sendmail") or die "Cannot open sendmail: $!";
   print (SENDMAIL "To: " . $mail_to . "\nFrom: " . $mail_from . "\nSubject: " . $subject . "\n\n" . $mail_body);
   close(SENDMAIL);

} #end email
