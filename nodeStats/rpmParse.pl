#!/usr/bin/perl
#
#Parse RPM packages
#
my $host=`hostname`;
my @parse=`sudo yum list all | egrep -ie '(installed\$|updates.*\$)'`;
my $hardware=`sudo uname -i`;
my @installed_name;
my %install_version;
my @updates_name;
my %update_version;
my $debug=1;

chomp($host);
chomp($hardware);
open(fh,">".$host."-rpm.html");

foreach(@parse)
{
  if($_ =~ /installed/)
  {
    print "installed value: $_\n" if $debug;
    my @data = split('\s+',$_);
    print "hardware value: $hardware\n";
    $data[0] =~ s/\.$hardware//;
    $data[0] =~ s/\.noarch//;
#    print "values: $data[0] - $data[1] - $data[2]\n" if $debug;
    push(@installed_name,$data[0]);
    $install_version{$data[0]}=$data[1];
  }
  else
  {
    print "updates value: $_\n" if $debug;
    my @data = split('\s+',$_);
    $data[0] =~ s/\.$hardware//;
    $data[0] =~ s/\.noarch//;
    print "values: $data[0] - $data[1] - $data[2]\n" if $debug;
    push(@updates_name,$data[0]);
    $update_version{$data[0]}=$data[1];
  }

} #end foreach

print fh "<html><body><p>";
print fh "---Host: $host--------------------------------------------------<br>";
print fh "RPM entries:<br>";
foreach(@updates_name)
{
  print fh "$_\t$install_version{$_}\t$update_version{$_}<br>\n";
#  print "$_\t$install_version{$_}\t$update_version{$_}<br>\n" if $debug;
}
print fh "----------------------------------------------------------------------------------------------------<br>";
print fh "</body></html>";

