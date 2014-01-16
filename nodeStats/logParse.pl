#!/usr/bin/perl
#
#Parse log files
#
my $host=`hostname`;
my @parse=`sudo tail -n 500 logs/* | egrep -i '(error|fail|exception|fault|panic)'`;

chomp($host);
open(fh,">".$host."-logs.html");

print fh "<html><body><p>";
print fh "---Host: $host--------------------------------------------------<br>";
print fh "Log entries:<br>";
foreach(@parse)
{ print fh $hostname . " " . $_ . "<br>"; }
print fh "----------------------------------------------------------------------------------------------------<br>";
print fh "</body></html>";
