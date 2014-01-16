#!/usr/bin/perl
#
#Grab node specs
#

my $host=`hostname`;
my $dmi=`/usr/sbin/dmidecode | egrep -i '(BIOS Revision|Manufacturer:\s\w{1,5}\s{0,1}\w{1,5}.$|Product Name|Serial Number:\s\w{7}$|Height:|External Connector:|NIC|^\s*Size:)'`;
my $runlevel=`/sbin/runlevel | gawk '{print hostfile \$2}'`;
my @service=`/sbin/chkconfig --list | grep 3:on | gawk '{print hostfile \$1}'`;
my @listening=`netstat -na | egrep 'LISTEN' | gawk '{print hostfile \$4}' | egrep -v '[A-Z]'`;
my @kmod=`/sbin/modprobe -l`;
my @rpm=`rpm -qa --queryformat '%{NAME}-%{VERSION}-%{ARCH}\n'`;
my $kernel=`uname -r`;
my $machine=`uname -m`;
my $redhat=`cat /etc/redhat-release`;
my $openfilecount=`/usr/sbin/lsof | wc -l`;
my @disk=`df -hP | grep -v Filesystem | gawk '{print hostfile \$1" "\$2" "\$5}'`;
my $mem=`free -m | grep Mem | gawk '{print hostfile \$2" "\$3" "\$4}'`;
my $swap=`free -m | grep Swap | gawk '{print hostfile \$2" "\$3" "\$4}'`;
my $cpu=`cat /proc/cpuinfo | grep processor | wc -l`;
my @lusers=`cat /etc/passwd | gawk -F ':' '{print hostfile \$1}'`;
my $sudo=`cat /etc/sudoers | egrep -v '(^#|^Defaults|^\$)'`;
my $last=`last | gawk '{print hostfile \$1}' | sort | uniq -c`;
my @cmd=`tail -n 100 /root/.bash_history | uniq`;
my $home='/home/curt/';

chomp($host);chomp($redhat);chomp($machine);chomp($kernel);chomp($runlevel);chomp($mem);chomp($swap);chomp($openfiles);chomp($cpu);chomp($sudo);chomp($last);

open(kmod,">".$home.$host."-kmods.html") or die("cannot open kernel file\n");
open(cmd,">".$home.$host."-cmd.html") or die("cannot open command file\n");
open(hostfile,">".$home.$host.".html") or die("cannot open hostfile\n");

print hostfile "<html><body>";
print cmd "<html><body>";
print kmod "<html><body>";
print hostfile "<p>---Host: $host\tMachine: $machine\tKernel: $kernel--------------------------------------------------\n";
print hostfile "<p>OS: $redhat\tRunlevel: $runlevel\tCPU Count: $cpu\n";
print hostfile "<p>Memory: $mem\tSwap: $swap\tOpen Files: $openfilecount\n";
print hostfile "<p>Disk:\n";
foreach(@disk)
{ print hostfile $_; }
print hostfile "<p>Services: ";
foreach(@service)
{ chomp($_);print hostfile $_ . " "; }
print hostfile "<p>\nListening Ports: ";
foreach(@listening)
{ chomp($_);print hostfile $_ . " "; }
print hostfile "<p>\nKernel Modules: Please see kmod file";
foreach(@kmod)
{ chomp($_);print kmod $_ . "<br>"; }
foreach(@cmd)
{ chomp($_);print cmd $_ . "<br>"; }
print hostfile "<p>\nLocal Users: ";
foreach(@lusers)
{ chomp($_);print hostfile $_ . " "; }
print hostfile "<p>\nSudo Entries: \n$sudo\n";
print hostfile "<p>\nLast Login Count: \n$last\n";
print hostfile "<p>\nDMI Stats:\n$dmi\n";
print hostfile "<p>----------------------------------------------------------------------------------------------------\n";
print hostfile "</html></body>";
print cmd "</html></body>";
print kmod "</html></body>";
