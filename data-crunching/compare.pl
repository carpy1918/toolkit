#!/usr/bin/perl

my %nms;
my %ptl;
my @output;
my $found=0;
my $notfound;
my $debug=0;

open(opennms, "opennms-ip-port-list.txt") or die("cannot open file");
open(portal, "portal-ip-port-list.txt") or die("cannot open file");

print "starting file intake\n" if $debug;
while(<portal>)
{
  @output=split("\t",$_);
  $ptl{$output[0]}=$output[1];
  print "added entry $output[0] $output[1] to portal\n" if $debug;
}

while(<opennms>)
{
  @output=split("\t",$_);
  chomp($output[1]);
  my $string=$nms{$output[0]} . "," . $output[1];
  $nms{$output[0]}=$string;
  print "added entry $output[0] $nms{$output[0]} to opennms\n" if $debug;
}
print "end file consumption\nentering comparison\n" if $debug;

while ( my ($ip, $port) = each(%ptl) )
{
  print "hit first ptl loop with $ip and $port\n" if $debug;
  chomp($ip);
  chomp($port);
  my @port = split(",",$port);
  foreach(@port)
  {
    my $portnum = $_;
    print "entering second port loop - foreach with $ip $portnum\n" if $debug;
    while (my ($i, $p) = each(%nms) )
    {
     chomp($p);
     chomp($i);
     @output=split(',',$p); 
     foreach(@output)
     { 
       my $p=$_;
       print "entered nms while with $ip $portnum and $i $p\n" if $debug;
       if($ip eq $i)
       {
	  print "hit matching ip's comparison with ports $portnum and $p\n" if $debug;
          if($portnum eq $p)
          { print "match found - $ip $portnum\n";$found++;next; }
       }
       #print "exiting nms while loop with $ip $portnum and $i $p\n" if $debug;
     } #end foreach
    } #end while
   if($found == 0)
   {
     #print "$ip\t$portnum\n";
     $notfound = $notfound . "$ip\t$portnum\n";
   }
   $found = 0;
  } #end foreach

}

print $notfound;

