#!/usr/bin/perl

#
#This script will take syslog-ng alerts and hand them off to Nagios.
#
my $pipe = "/usr/local/nagios-log-pipe";

while(1)
{
    open PIPE,"$pipe" or die("Could not open pipe for read\n");

    while(<PIPE>)
    {
       $_ =~ ~ /^(.*)\s+(.*)\s+(\d.*)$/;
       my $line ="$1\t$2\t$3";
       system(`echo "$line" >> tee /var/log/syslog-nagios.log`);
       system(`echo "$line" | /usr/local/nagios/libexec/send_nsca 10.70.50.101 -c /usr/local/nagios/etc/send_nsca.cfg 1> /dev/null`);
    } #end inner while
    close(PIPE);
    sleep(20);
} #outter while
