#!/usr/bin/perl

    use strict;
    use FindBin;
    use lib "$FindBin::Bin/lib";
    use Nagios::Plugin::SNMP;

    my $badprocesses = '';  #list of processes and are not listed
    my $goodprocesses = '';  #list of found processes and nagiosobj stats
    my @processes;              #holds ports given at command line to query
    my $found = 0;      #set when a match is found
#    my $hrSWRunPath_oid = '.1.3.6.1.2.1.25.4.2.1.4';   #command nagiosobj OID
    my $hrSWRunPath_oid = '.1.3.6.1.2.1.25.4.2.1';      #command nagiosobj OID
#    my $hrSWRunParameters_oid = '.1.3.6.1.2.1.25.4.2.1.5';
    my $hrSWRunPerfMem_oid = '.1.3.6.1.2.1.25.5.1.1.2';
    my %STATUS_CODE = ( 'OK' => '0', 'WARNING' => '1', 'CRITICAL' => '2', 'UNKNOWN' => '3' );

    my $USAGE = <<EOF;
USAGE: %s {} [-b|--base_oid=<base_oid>] [-p|--check_processes=<processeslist>]
EOF
    my $LABEL = 'SNMP-Listener-Check';
    my $nagiosobj = Nagios::Plugin::SNMP->new(
        'shortname' => $LABEL,
        'usage'     => $USAGE
    );

    $nagiosobj->add_arg(
        'spec' => 'base_oid|b=s','help' => "-b, --base_oid\nSpecifies the SNMP OID to search and compare\n\n",'default' => '.'
    );
    $nagiosobj->add_arg(
        'spec' => 'check_processes|p=s','help' => "-p, --check_processes\nComma delimitated list of processes strings to check. Ex. sshd,ArcSight,java -blah\n\n",'default' => 'sshd'
    );

    $nagiosobj->getopts;                #get command line variables
    my $base_oid = $nagiosobj->opts->get('base_oid');
    my $processlist = $nagiosobj->opts->get('check_processes');
    @processes = split(',',$processlist);
    my ($result,$error) = $nagiosobj->walk($hrSWRunPath_oid);   #get SNMP data

    foreach(@processes)
    {
       my $process = $_;
       while( my ($key,$value) = each(%{$result->{$hrSWRunPath_oid}}))
       {
          if($value =~ /$process/)
          {
             $key =~ /.*\.(\d+)/;       #grab the PID and set as variable
             my $pid = $1;
             my $result2 = $nagiosobj->walk($hrSWRunPerfMem_oid);       #get SNMP data
             while( my ($key,$value) = each(%{$result2->{$hrSWRunPerfMem_oid}}))
             {
                if($key =~ /$pid/)
                {
                   $goodprocesses = $goodprocesses . " " . $process . "-" . $value . "|";
                }
             } #end while
             $found = 1;
          }
       } #end while
       if($found == 0)
       {
         $badprocesses = $badprocesses . " " . $process;
       }
       $found = 0;
  } #end foreach process

#  print "Good processes: $goodprocesses\n";
#  print "Bad processes: $badprocesses\n";

  if($badprocesses eq '')
  { print "OK - | $goodprocesses \n"; exit $STATUS_CODE{"OK"}; }
  else
  { print "CRITICAL: Process(es): $badprocesses not found!\n"; exit $STATUS_CODE{"CRITICAL"}; }
