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
my $print = 1;                  #print output
my @downtime_entries;           #log of downtime for servers
my %nagios_services = (cpu => "CPU_Load", users => "Current Users", http => "HTTP", ping => "Ping", root => "Disk-/", ssh => "SSH", swap => "Swap Usage", processes => "Total Processes",mem => "Memory",diskall => "Disk-all");

                                #get the hosts monitored by nagios
   $query="SELECT DISTINCT name1 FROM nagios_objects WHERE objecttype_id=2;";
   $result=dbquery($query);

                                #get nagios clients from db
   while (@results = $result->fetchrow_array())
   {
      my $i = 0;                                #loop counter
         if(@results > 0)
         {
            next if($results[$i] =~ /-bu/);               #ignore baackup interfaces
            next if($results[$i] =~ /-rm/);               #ignore remote mngt interfaces
            next if($results[$i] =~ /^chi2/);             #ignore VIP's
            next if($results[$i] =~ /pdu/);             #ignore VIP's
            next if($results[$i] =~ /SETA/);             #ignore SETA hardware devices
            print "host: " . $results[$i] . "\n" if $debug;
            push(@hosts,$results[$i]);
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

   print "<html><body><p>" if $print;
   print "<center><b>CTMS Server Performance Report</b></center><br>" if $print;
                                #get cpu data for each host for each service
   print "<br><center><b>###<br>CPU USAGE AVERAGE (% USED)<br>###</b></center>" if $print;
   print "<table>" if $print;
   foreach(@hosts)
   {
      $month = getHostData('cpu',$_,'month');
      $week = getHostData('cpu',$_,'week');
      if($week != 0)
     { print "<tr><td>$_</td><td>&nbsp</td><td>month 'avg/max'</td><td>&nbsp</td><td>$month\%</td><td>&nbsp</td><td>week 'avg/max'</td><td>&nbsp</td><td>$week\%</td></tr>" if $print; }
   } #foreach - cpu host loop
   print "</table><br>" if $print;
                                #get ping data for each host for each service
   print "<br><center><b>###<br>PING RESPONSE TIME AVERAGE<br>###</b></center>" if $print;
   print "<table>" if $print;
   foreach(@hosts)
   {
      $month = getHostData('ping',$_,'month');
      $week = getHostData('ping',$_,'week');
      print "<tr><td>$_</td><td>&nbsp</td><td>month avg</td><td>   </td><td>&nbsp</td><td>" . $month . "ms</td><td>&nbsp</td><td>   </td><td>week avg</td><td>&nbsp</td><td>   </td><td>&nbsp</td><td>" . $week . "ms</td></tr>" if $print;
   } #foreach - ping host loop
   print "</table><br>" if $print;

   print "<br><center><b>###<br>MEMORY USAGE AVERAGE (mem% free/swap% free)<br>###</b></center>" if $print;
   print "<table>" if $print;
   foreach(@hosts)
   {
      $month = getHostData('mem',$_,'month');
      $week = getHostData('mem',$_,'week');
      if($week != 0)
      { print "<tr><td>$_</td><td>&nbsp</td><td>month 'mem/swap' avg</td><td>&nbsp</td><td>" . $month . "%</td><td>&nbsp</td><td>week 'mem/swap' avg</td><td>&nbsp</td><td>" .$week . "%</td></tr>" if $print; }
   } #foreach - mem host loop
   print "</table><br>" if $print;

   print "<br><center><b>###<br>DISK PARTITION USAGE AVERAGE<br>###</b></center>" if $print;
   print "<table>" if $print;
   foreach(@hosts)
   {
      $month = getHostData('diskall',$_,'month');
      $week = getHostData('diskall',$_,'week');
      if($week !~ /n\/a/)
      { print "<tr><td>$_</td><td>&nbsp</td><td>month 'partition usage'</td><td>&nbsp</td><td>" . $month . "</td><td>&nbsp</td><td>week 'partition usage'</td><td>&nbsp</td><td>" . $week . "</td></tr>" if $print; }
   } #foreach - mem host loop
   print "</table><br>" if $print;

                                #get swap data for each host for each service
#   print "###\n#SWAP - % FREE\n###\n";
#   foreach(@hosts)
#   {
#      $month = getHostData('swap',$_,'month');
#      $week = getHostData('swap',$_,'week');
#      print "$_\t\tmonth avg\t" . $month . "\% free\tweek avg\t" . $week . "\% free\n";
#   } #foreach - cpu host loop
#   print "\n";

                                #get processes data for each host for each service
#   print "###\n#PROCESSES RUNNING\n###\n";
#   foreach(@hosts)
#   {
#      $month = getHostData('processes',$_,'month');
#      $week = getHostData('processes',$_,'week');
#      print "$_\t\tmonth avg\t$month\tweek avg\t$week\n";
#   } #foreach - cpu host loop
#   print "\n";

                                #get users data for each host for each service
#   print "###\n#USER LOGINS\n###\n";
#   foreach(@hosts)
#   {
#      $month = getHostData('users',$_,'month');
#      $week = getHostData('users',$_,'week');
#      print "$_\t\tmonth avg\t$month\tweek avg\t$week\n";
#   } #foreach - cpu host loop
#   print "\n";

   print "<br><center>DOWNTIME REPORT</center><br>" if $print;
   if(@downtime_entries == 0)
   { print "No downtime to report<br>" if $print; }
   else
   {
      foreach(@downtime_entries)
      {
         print $_ . "\n" if $print;
      } #end foreach
   } #end else

   print "</p></body></html>" if $print;
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
#$service_ids{$host}{$service_name}
      return "'n/a'" if(!$id);

#      print "ID value: " . $id . "\n" if($debug);
#      print "grabbing $service info for " . $host . " using id " . $id . "\n" if $debug;
      if($timeframe eq "month")
      {
         $query="SELECT output,perfdata,start_time FROM nagios_servicechecks WHERE start_time BETWEEN (NOW() - INTERVAL 1 MONTH) AND NOW() AND service_object_id=$id;";
#        print "Monthly query: $query\n" if($debug);
      }
      elsif($timeframe eq "week")
      {
         $query="SELECT output,perfdata,start_time FROM nagios_servicechecks WHERE start_time BETWEEN (NOW() - INTERVAL 1 WEEK) AND NOW() AND service_object_id=$id;";
#        print "Weekly query: $query\n" if($debug);
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

#        print "output: $o \t perfdata: $p \t time: $s\n" if $debug;
      } #end while

      #cpu, users, http, ping, root, ssh, swap, processes
      return parseCPU(\@perfdata) if($service eq 'cpu');
      return parsePING(\@output,\@starttime,$host) if($service eq 'ping');
      return parseSWAP(\@output) if($service eq 'swap');
      return parsePROCESSES(\@output) if($service eq 'processes');
      return parseUSERS(\@output) if($service eq 'users');
      return parseMEMORY(\@output) if($service eq 'mem');
      return parseDISK(\@perfdata) if($service eq 'diskall');
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
   my $j = 0;                                   #loop counter
   my $scpu = 0;                                #cpu core sum
   my $core_avg = 0;                            #core avg
   my $total = 0;                               #total
   my $avg = 0;                                 #avg over time-frame
   my $max = 0;                                 #max cpu value

   foreach(@$data)
   {
#      print "parseCPU data - $_\n";
#      $_ =~ /load average: \d.\d\d, (\d.\d\d), \d.\d\d/;
      @results = $_ =~ /=(\d+);/g;
      foreach(@results)
      {
        $scpu = $scpu + $_;
        $j++;
      }
      $core_avg = $scpu/$j if $j ne 0;
      $max = $core_avg if($core_avg > $max);
      $i++;
      $total = $total + $core_avg;

   } #end foreach
   return 0 if $total == 0;
   return 0 if $i == 0;
   $avg = $total/$i;
   $avg = sprintf("%.3f", $avg);
   $max = sprintf("%.3f", $max);
   print "total cpu: $total total entries: $i\n" if $debug;
   print "Average CPU: $avg Max CPU: $max\n" if $debug;
   return $avg . "/" . $max
} #end parseCPU

##
#parseDisk
#Take the Disk-all data and crunch it for avg partition usage
##
sub parseDISK($)
{
   my $data = shift();                          #array ref
   my $partition;                               #partition of server
   my $usage;                                   #% use
   my $track;                                   #number of stat entries
   my %partitions;                              #sum of part usage
   my %ptracking;                               #number of entries for each
   my %pavg;                                    #partition avgs
   my $avg;                                     #partitions avg
   my $value;                                   #holder value
   my $avg;                                     #return string
   my @strings;                                 #hold split strings

   foreach(@$data)
   {
      print "parseDISK data - $_\n" if $debug;
      $value = $_;
      @strings = split(';',$value);
      foreach(@strings)
      {
#         print "parsing partition entry: $_ \n" if $debug;
         ($partition,$usage) = split('=',$_);
         $partition =~ /'(.*)'/;
         $partition = $1;
         $partitions{$partition} = $partitions{$partition} + $usage;
         $ptracking{$partition} = $ptracking{$partition} + 1;
#         print "Partition info: $partition\nUsage: $partitions{$partition}\nTracking: $ptracking{$partition}\n" if $debug;
      } #end foreach strings
   } #end foreach data

   for(keys %partitions)        #compute average for each partition
   {
         $usage = $partitions{$_};
         $track = $ptracking{$_};
         print "calculating avg for $_\n" if $debug;
   #      $pavg{$_} = (($partitions{"$_"})\($ptracking{"$_"}));
         $pavg{$_} = $usage/$track;
         $pavg{$_} = sprintf("%.3f", $pavg{$_});
         print "partition: usage value: $_ $usage \ entries: $track = $pavg{$_}\n" if $debug;
   } #end results foreach

   for(keys %partitions)        #print values
   {
         $avg = $avg . "$_=$pavg{$_}%;";
   } #end print results

   print "Calculated Disk-all usage: $avg\n" if $debug;
   return $avg;
} #end parseDISK

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
      $_ =~ /PING OK.*mdev = \d+.\d+\/(\d+.\d+)/;
      print "ping value: $1\n" if $debug;

      if($1)
      {
         if($downtime > 0)
         {
            print $host . ": end of downtime at " . $$time[$i] . "\n";
            push(@downtime_entries,"$host: end of downtime at $$time[$i]\n");
            $downtime = 0;
         }
         $i++;
         $total = $total + $1;
      } #end if
      else
      {
         print $host . ": start of downtime: " . $$time[$i] . "\n" if $debug;
         push(@downtime_entries,"$host: start of downtime: $$time[$i]");
         $downtime++;
      } #else
   } #end foreach
   return 0 if($total == 0 || $i == 0);
   $avg = $total/$i;
   $avg = sprintf("%.3f", $avg);
   print "total ping: $total total entries: $i\n" if $debug;
   print "Average Ping: $avg\n" if $debug;
   return $avg
} #end parsePING

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
} #end parseSWAP

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
   $avg = sprintf("%.3f", $avg);
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
   $avg = sprintf("%.3f", $avg);
   print "total users: $total total entries: $i\n" if $debug;
   print "Average Users: $avg\n" if $debug;
   return $avg
} #end parseCPU

##
#parseUSERS
#Take the USERS data and crunch it for avg
##
sub parseMEMORY($)
{
   my $data = shift();                          #array ref
   my $i = 0;                                   #number of entries
   my $mem_total = 0;                           #total memory
   my $swap_total = 0;                          #total swap
   my $avg_mem = 0;                             #avg memory
   my $avg_swap = 0;                            #avg swap

   foreach(@$data)
   {
      print "parseMemory data - $_\n" if $debug;
      $_ =~ /total memory used : (\d+)%  ram used : \d+%, swap used (\d+)%/;
      print "memory percent used: $1 swap percent used: $2\n" if $debug;
      $i++;
      $mem_total = $mem_total + $1;
      $swap_total = $swap_total + $2;
   } #end foreach

   return 0 if($i eq 0);
   $avg_mem = $mem_total/$i;
#   print "Operation: $mem_total \/ $i\n";
   $avg_swap = $swap_total/$i;
   $avg_mem = sprintf("%.3f", $avg_mem);
   $avg_swap = sprintf("%.3f", $avg_swap);
   print "Average Memory/Swap: $avg_mem/$avg_swap\n" if $debug;
   return $avg_mem . "/" . $avg_swap
} #end parseCPU

##
#dbquery connects to the MySQL DB and passes a ref to the results back
##
sub dbquery($)
{
   my $db = "centstatus";                       #nagios mysql database
   my $dbuser = "report";                       #nagios db user
   my $dbpasswd = "Knowisp0wer";                #nagios db passwd
   my $dsn = "$db,$dbuser,$dbpasswd";           #dbi conection string
   my $query = shift();                         #db query string
   my @results;                                 #db query results

   my $dbh = DBI->connect('DBI:mysql:'.$db, $dbuser, $dbpasswd) or die "Could not connect to database $db: $DBI::errstr";

   my $sth = $dbh->prepare($query);
   $sth->execute or die $dbh->errstr;

   return $sth
} #end db-query