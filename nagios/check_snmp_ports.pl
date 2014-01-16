#!/usr/bin/perl

    use strict;
    use FindBin;
    use lib "$FindBin::Bin/lib";
    use Nagios::Plugin::SNMP;

    my $badports = '';  #list of ports and are not listed
    my @ports;          #holds ports given at command line to query
    my $found = 0;      #set when a match is found
    my $base_oid = '.1.3.6.1.2.1.6.13.1';
    my %STATUS_CODE = ( 'OK' => '0', 'WARNING' => '1', 'CRITICAL' => '2', 'UNKNOWN' => '3' );

    my $USAGE = <<EOF;
USAGE: %s {} [-b|--base_oid=<base_oid>] [-p|--check_ports=<portlist>]
EOF

    my $LABEL = 'SNMP-Listener-Check';
    my $plugin = Nagios::Plugin::SNMP->new(
        'shortname' => $LABEL,
        'usage'     => $USAGE
    );

    $plugin->add_arg(
        'spec' => 'base_oid|b=s',
        'help' => "-b, --base_oid\n" .
                  "   Specifies the SNMP OID to search and compare\n" .
                  "   \n",
        'default' => '.'
    );

    $plugin->add_arg(
        'spec' => 'check_ports|p=s',
        'help' => "-p, --check_ports\n" .
                  "   Comma delimitated list of port numbers to check. Ex. 22,80,443\n" .
                  "   \n",
        'default' => '22,80,443'
    );

    $plugin->getopts;           #get command line variables
    my $base_oid = $plugin->opts->get('base_oid');
    my $portlist = $plugin->opts->get('check_ports');

    my $result = $plugin->walk($base_oid);      #get SNMP data

    $plugin->close();           #close SNMP session

    @ports = split(',',$portlist);

    foreach(@ports)
    {
       my $port = $_;
       foreach my $value (keys %{$result->{$base_oid}})
       {
          if($value =~ /.1.3.6.1.2.1.6.13.1.1.\d+.\d+.\d+.\d+.$port.\d+.\d+.\d+.\d+/)
          {
             #print "Value found: " . $value . "\n";
             #print "Key Value: " . $result->{$base_oid}->{$value} . "\n";
             $found = 1;
          }
       } #end foreach compare

       if($found == 0)
       {
          $badports = $badports . " " . $port;
       }
       $found = 0;
   } #end foreach ports

   if($badports == '')
   { print "OK\n"; exit $STATUS_CODE{"OK"}; }
   else
   { print "CRITICAL: Port(s): $badports not listening!\n"; exit $STATUS_CODE{"CRITICAL"}; }
