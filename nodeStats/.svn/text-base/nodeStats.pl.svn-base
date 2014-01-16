#!/usr/bin/perl
#
#Grab node specs
#

my $host=`hostname`;
my $dmi=`/usr/sbin/dmidecode | egrep -i '(BIOS Revision|Manufacturer:\s\w{1,5}\s{0,1}\w{1,5}.$|Product Name|Serial Number:\s\w{7}$|Height:|External Connector:|NIC|^\s*Size:)'`;
my $runlevel=`/sbin/runlevel | gawk '{print \$2}'`;
my @service=`/sbin/chkconfig --list | grep 3:on | gawk '{print \$1}'`;
my @listening=`netstat -na | egrep 'LISTEN' | gawk '{print \$4}' | egrep -v '[A-Z]'`;
my @kmod=`/sbin/modprobe -l`;
my @rpm=`rpm -qa --queryformat '%{NAME}-%{VERSION}-%{ARCH}\n'`;
my $kernel=`uname -r`;
my $machine=`uname -m`;
my $redhat=`cat /etc/redhat-release`;
my $openfilecount=`lsof | wc -l`;
my @disk=`df -hP | grep -v Filesystem | gawk '{print \$1" "\$2" "\$5}'`;
my $mem=`free -m | grep Mem | gawk '{print \$2" "\$3" "\$4}'`;
my $swap=`free -m | grep Swap | gawk '{print \$2" "\$3" "\$4}'`;
my $cpu=`cat /proc/cpuinfo | grep processor | wc -l`;
my @lusers=`cat /etc/passwd | gawk -F ':' '{print \$1}'`;
my $sudo=`cat /etc/sudoers | egrep -v '(^#|^Defaults|^\$)'`;
my $last=`last | gawk '{print \$1}' | sort | uniq -c`;
open(kmod,$host."-kmods.txt");

chomp($host);chomp($redhat);chomp($machine);chomp($kernel);chomp($runlevel);chomp($mem);chomp($swap);chomp($openfiles);chomp($cpu);chomp($sudo);chomp($last);

print "---Host: $host\tMachine: $machine\tKernel: $kernel--------------------------------------------------\n";
print "OS: $redhat\tRunlevel: $runlevel\tCPU Count: $cpu\n";
print "Memory: $mem\tSwap: $swap\tOpen Files: $openfilecount\n";
print "Disk:\n";
foreach(@disk)
{ print $_; }
print "Services: ";
foreach(@service)
{ chomp($_);print $_ . " "; }
print "\nListening Ports: ";
foreach(@listening)
{ chomp($_);print $_ . " "; }
print "\nKernel Modules: --PRINT DISABLED--";
foreach(@kmod)
{ chomp($_);print kmod $_ . " "; }
print "\nLocal Users: ";
foreach(@lusers)
{ chomp($_);print $_ . " "; }
print "\nSudo Entries: \n$sudo\n";
print "\nLast Login Count: \n$last\n";
print "\nDMI Stats:\n$dmi\n";
print "----------------------------------------------------------------------------------------------------\n";
