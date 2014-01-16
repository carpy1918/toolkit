#!/usr/bin/perl

my %ipid;
my %idport;
my @output;
my $debug=0;

open(fh1, "id-port.txt") or die("cannot open id-port.txt");
open(fh2, "ip-serviceid.txt") or die("cannot open ip-serviceid.txt");

print "starting file consumption\n" if $debug;
while(<fh1>)
{
  @output=split("\t",$_);
  $idport{"$output[0]"}=$output[1];
  print "added $output[0] and $output[1] to idport\n" if $debug;
}

while(<fh2>)
{
  @output=split("\t",$_);
  $string = $ipid{"$output[0]"};
  $ipid{"$output[0]"}=$string . "," . $output[1];
  print "added $output[0] and $ipid{$output[0]} to ipid\n" if $debug;
}

print "exiting file consuption\nentering comparison\n" if $debug;
while ( my ($ip, $idstring) = each(%ipid) )
{
  @output=split(",",$idstring);
  foreach(@output)
  {
    my $id=$_;
    chomp($ip);
    chomp($id);

    print "entering ipid while with $ip and $id\n" if $debug;
    while (my ($d, $port) = each(%idport) )
    {
     chomp($d);
     chomp($port);

     print "entering idport (comparison) while with $ip $id and $d $port\n" if $debug;
     if($id == $d)
     { print "$ip\t$port\n";next; }
    }
  } #end foreach
}

