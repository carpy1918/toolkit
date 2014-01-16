#!/usr/bin/perl

#
#This script creates a performance report by querying the Nagios database and parsing
#the database
#

use DBI;
use strict;

my $sth;                        #db query handle
my $query;                      #SQL commands
my @hosts;                      #clients monitored by nagios
my %service_ids;                #service id's for each host
my $result;                     #results passed back from fuctions
my $month = 0;                  #return value, month
my $week = 0;                   #return value, week
my @results;                    #results passed back in an array - sql
my @tmp;                        #random holder array
my $start_time = 0;             #start time for report
my $end_time = 0;               #end time for report
my $debug = 0;                  #print debug statements or not
my @downtime_entries;           #log of downtime for servers
my %nagios_services = (cpu => "Current Load", users => "Current Users", http => "HTTP", ping => "PING", root => "Root Partition", ssh => "SSH", swap => "Swap Usage", processes => "Total Processes");

                                #get the hosts monitored by nagios
   $query="SELECT DISTINCT name1 FROM nagios_objects WHERE objecttype_id=2;";
   $result=dbquery($query);

                                #get nagios clients from db
   while (@results = $result->fetchrow_array())
   {
      my $i = 0;                                #loop counter
         if(@results > 0)
         {
            print "hit first loop. " . $results[$i] . "\n" if $debug;
            push(@hosts,$results[$i]);
            print "\n";
         } #end if
         else
         {
            print "No hosts returned from db. exiting.\n";
            exit;
         }
      $i++;
   } #end while

                                #get the service name and id and create HoH
                                #%service_ids{host}{service_name} = service_id
   foreach(@hosts)
   {
      print "parsing hosts, getting service id's for $_\n" if $debug;
      my $host = $_;
      if($host eq '')
      { next; }
      $query="SELECT object_id,name2 FROM nagios_objects WHERE name1='$host';";
      $result=dbquery($query);

      while (@tmp = $result->fetchrow_array())
      {
         my $service_id;
         my $service_name;

         ($service_id,$service_name) = @tmp;
         next if(!$service_id||!$service_name);
         print $service_id . " " . $service_name . "\n" if $debug;
         $service_ids{$host}{$service_name}=$service_id;
      } #end while
   } #foreach end

   print "\t\t\tCTMS Servers Performance Report\n";
                                #get cpu data for each host for each service
   foreach(@hosts)
   {
      print "###\n#CPU DATA\n###\n";
      $month = getHostData('cpu',$_,'month');
      $week = getHostData('cpu',$_,'week');
      print "Host: $_\t\tmonth 'avg/max'\t$month\tweek 'avg/max'\t$week\n";
   } #foreach - cpu host loop
   print "\n";
                                #get ping data for each host for each service
   foreach(@hosts)
   {
      print "###\n#PING DATA\n###\n";
      $month = getHostData('ping',$_,'month');
      $week = getHostData('ping',$_,'week');
      print "Host: $_\t\tmonth avg\t$month\tweek avg\t$week\n";
   } #foreach - cpu host loop
   print "\n";

                                #get swap data for each host for each service
   foreach(@hosts)
   {
      print "###\n#SWAP DATA\n###\n";
      $month = getHostData('swap',$_,'month');
      $week = getHostData('swap',$_,'week');
      print "Host: $_\t\tmonth avg\t$month\t\t\tweek avg\t$week\n";
   } #foreach - cpu host loop
   print "\n";

                                #get processes data for each host for each service
   foreach(@hosts)
   {
      print "###\n#PROCESSES DATA\n###\n";
      $month = getHostData('processes',$_,'month');
      $week = getHostData('processes',$_,'week');
      print "Host: $_\t\tmonth avg\t$month\tweek avg\t$week\n";
   } #foreach - cpu host loop
   print "\n";

                                #get users data for each host for each service
   foreach(@hosts)
   {
      print "###\n#USERS DATA\n###\n";
      $month = getHostData('users',$_,'month');
      $week = getHostData('users',$_,'week');
      print "Host: $_\t\tmonth avg\t$month\tweek avg\t$week\n";
   } #foreach - cpu host loop
   print "\n";

   print "\t\tDowntime Report\n";
   if(@downtime_entries == 0)
   { print "No downtime to report\n\n"; }
   else
   {
      foreach(@downtime_entries)
      {
         print $_ . "\n";
      } #end foreach
   } #end else

##
#getHostData
#Grab the data for a host and service. Parse it and return the value
##
sub getHostData($$$)
{
   my $service = shift();
   my $host = shift();
   my $timeframe = shift();
   my @output;                  #array to hold output from db
   my @perfdata;                #array to hold perfdata from db
   my @starttime;               #array to hold start_time from db

                                #get data for each host for each service
      my $id = $service_ids{$host}{$nagios_services{$service}};

      print "grabbing $service info for " . $host . " using id " . $id . "\n" if $debug;

      if($timeframe eq "month")
      {
         $query="SELECT output,perfdata,start_time FROM nagios_servicechecks WHERE start_time BETWEEN (NOW() - INTERVAL 1 MONTH) AND NOW() AND service_object_id=$id;";
      }
      elsif($timeframe eq "week")
      {
         $query="SELECT output,perfdata,start_time FROM nagios_servicechecks WHERE start_time BETWEEN (NOW() - INTERVAL 1 WEEK) AND NOW() AND service_object_id=$id;";
      }
      else
      { print "Error, invalid timeframe\n"; return }

      $result = dbquery($query);

      while (@tmp = $result->fetchrow_array())
      {
         my $o;                 #output field from nagios_servicechecks
         my $p;                 #perfdata field from nagios_servicechecks
         my $s;                 #start_time field from nagios_servicechecks
         ($o,$p,$s) = @tmp;
         push(@output,$o);
         push(@perfdata,$p);
         push(@starttime,$s);

         print "output: $o \t perfdata: $p \t time: $s\n" if $debug;
      } #end while

      #cpu, users, http, ping, root, ssh, swap, processes
      return parseCPU(\@output) if($service eq 'cpu');
      return parsePING(\@output,\@starttime,$host) if($service eq 'ping');
      return parseSWAP(\@output) if($service eq 'swap');
      return parsePROCESSES(\@output) if($service eq 'processes');
      return parseUSERS(\@output) if($service eq 'users');
      if($service eq '')
      { print "ERROR: getHostData() host: $host service is empty.\n"; return 1; }
} #end getHostData

##
#parseCPU
#Take the CPU data and crunch it for avg,median,min/max
##
sub parseCPU($)
{
   my $data = shift();                          #array ref
   my $i = 0;                                   #number of entries
   my $total = 0;                               #total
   my $avg = 0;                                 #avg over time-frame
   my $max = 0;                                 #max cpu value

   foreach(@$data)
   {
      print "parseCPU data - $_\n" if $debug;
      $_ =~ /load average: \d.\d\d, (\d.\d\d), \d.\d\d/;
      $max = $1 if $1 > $max;
      print "cpu value: $1\n" if $debug;
      $i++;
      $total = $total + $1;

   } #end foreach
   $avg = $total/$i;
   $avg = sprintf("%.3f", $avg);
   print "total cpu: $total total entries: $i\n" if $debug;
   print "average CPU: $avg max CPU: $max\n" if $debug;
   return $avg . "/" . $max
} #end parseCPU

##
#parsePING
#Take the PING data and crunch it for avg
##
sub parsePING($$)
{
   my $data = shift();                          #array ref
   my $time = shift();
   my $host = shift();                          #host of data
   my $i = 0;                                   #number of entries
   my $total = 0;                               #total users
   my $avg = 0;                                 #avg over time-frame
   my $downtime = 0;                            #keep track of downtime windows
   my $downtime_start;                          #start of a downtime window

   foreach(@$data)
   {
      print "parsePING data - $_\n" if $debug;
      $_ =~ /PING OK.*RTA = (\d.\d+) ms/;
      print "ping value: $1\n" if $debug;

      if($1)
      {
         if($downtime)
         {
            print $host . ": end of downtime at " . $$time[$i] . "\n";
            push(@downtime_entries,"$host: end of downtime at $$time[$i]\n");
            $downtime = 0;
         }
         print "ping value: $1\n" if $debug;
         $i++;
         $total = $total + $1;
      } #end if
      else
      {
         print $host . ": start of downtime at " . $$time[$i] . "\n";
         push(@downtime_entries,"$host: start of downtime at $$time[$i]\n");
         $downtime++;
      } #else

   } #end foreach
   $avg = $total/$i;
   print "total ping: $total total entries: $i\n" if $debug;
   print "Average Users: $avg\n" if $debug;
   return $avg
} #end parseCPU

##
#parseSWAP
#Take the SWAP data and crunch it for avg
##
sub parseSWAP($)
{
   my $data = shift();                          #array ref
   my $i = 0;                                   #number of entries
   my $total = 0;                               #total users
   my $avg = 0;                                 #avg of users logged in over time-frame

   foreach(@$data)
   {
      print "parseSWAP data - $_\n" if $debug;
      $_ =~ /(\d+)% free/;
      print "swap value: $1\n" if $debug;
      $i++;
      $total = $total + $1;

   } #end foreach
   $avg = $total/$i;
   print "total swap: $total total entries: $i\n" if $debug;
   print "Average Users: $avg\n" if $debug;
   return $avg
} #end parseCPU

##
#parsePROCESSES
#Take the PROCESSES data and crunch it for avg
##
sub parsePROCESSES($)
{
   my $data = shift();                          #array ref
   my $i = 0;                                   #number of entries
   my $total = 0;                               #total users
   my $avg = 0;                                 #avg of users logged in over time-frame

   foreach(@$data)
   {
      print "parsePROCESSES data - $_\n" if $debug;
      $_ =~ /(\d+) processes/;
      print "processes value: $1\n" if $debug;
      $i++;
      $total = $total + $1;
   } #end foreach
   $avg = $total/$i;
   print "total processes: $total total entries: $i\n" if $debug;
   print "Average Processes: $avg\n" if $debug;
   return $avg
} #end parseCPU

##
#parseUSERS
#Take the USERS data and crunch it for avg
##
sub parseUSERS($)
{
   my $data = shift();                          #array ref
   my $i = 0;                                   #number of entries
   my $total = 0;                               #total users
   my $avg = 0;                                 #avg of users logged in over time-frame

   foreach(@$data)
   {
      print "parseUSERS data - $_\n" if $debug;
      $_ =~ /(\d+) users/;
      print "users value: $1\n" if $debug;
      $i++;
      $total = $total + $1;
   } #end foreach
   $avg = $total/$i;
   print "total users: $total total entries: $i\n" if $debug;
   print "Average Users: $avg\n" if $debug;
   return $avg
} #end parseCPU

##
#dbquery connects to the MySQL DB and passes a ref to the results back
##
sub dbquery($)
{
   my $db = "nagios";                           #nagios mysql database
   my $dbuser = "nagiosuser";                   #nagios db user
   my $dbpasswd = "nagios";                     #nagios db passwd
   my $dsn = "$db,$dbuser,$dbpasswd";           #dbi conection string
   my $query = shift();                         #db query string
   my @results;                                 #db query results

   my $dbh = DBI->connect('DBI:mysql:'.$db, $dbuser, $dbpasswd) or die "Could not connect to database $db: $DBI::errstr";

   my $sth = $dbh->prepare($query);
   $sth->execute or die $dbh->errstr;

   return $sth
} #end db-query
