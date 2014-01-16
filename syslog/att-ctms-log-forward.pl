#!/bin/perl

#This Perl script will take the output of a log file, attach the server name, and then pipe it to the central log server

use File::Tail;
use Log::Syslog::Fast ':all';

   my $line = '';                                       #log line to process
   my $port = $ARGV[1];                         #central server port
   my $debug = 1;                                       #debug flag
   my $hostname = 'localhost';                  #localhost name to append
   my $centrallog = '10.70.50.101';             #central log server
   my $syslogport = 514;
   my $service = "Oracle";                      #syslog service name
   chomp($hostname);
   print "Hostname: " . $hostname . " File: " . $ARGV[0] . "\n" if $debug;

   if(@ARGV < 1)
   { print "Wrong command syntax. Syntax: perl att-ctms-log-forward.pl <log_file>\n"; exit; } #end if

   my $file=File::Tail->new($ARGV[0]);  #open log for monitoring

   while (defined($line=$file->read))
   {
      print "Found a new line: $line\n" if $debug;
      chomp($line);
#      $logger = Log::Syslog::Fast->new(LOG_UDP, $centrallog, $syslogport, LOG_LOCAL0, LOG_INFO, $hostname, $name);
      $logger = Log::Syslog::Fast->new(LOG_UNIX, '/dev/log', $syslogport, LOG_LOCAL0, LOG_INFO, $hostname, $name);
      $logger->send($line);                     #if processing slowly add $time to send($line,$time)
   } #end while
