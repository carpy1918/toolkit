#!/usr/bin/perl

#this script will scrape the users from server list and look for mismatches and improper UID uses

open fh,"/home/ccarp001/server-info/ldap-local-access.log" or die('cannot open server list\n');
#open fh,"/home/ccarp001/server-info/temp" or die('cannot open server list\n');
my @server = <fh>;
my @results;
my %HoH;
my @ignore;
my $debug = 0;

#data gathering and insert into array/hash
my $ignoref = "user-ignore-list.txt";	#get user ignore list
open ifh,"$ignoref" or die("cannot open $ignoref\n");
while(<ifh>)
{ 
  my $i = $_;
  chomp($i);
  print "adding $i to ignore list\n" if $debug;
  push(@ignore,$i);
}

foreach(@server)	#process each server
{
  my $svr = $_;
  chomp($svr);
  print "hit server: $svr...\n" if $debug;
  my $passwdf = "data/$svr-group";
  open pfh,">$passwdf" or die('cannot open $passwdf\n');

  @results = `ssh -t $svr cat /etc/group`;

  foreach(@results)
  {
    my $skip = 0;
    my $d = $_;
    chomp($d);
    print $d . "\n" if $debug;
    my @data = split(':',$d);
    foreach(@ignore)
    {
      if ($data[0] eq $_)
      { 
	$skip++; 
        print "skipping $data[0]\n" if $debug;
      }
    }
    next if($skip > 0);
    print pfh $d . "\n";
    $HoH{$svr}{$data[0]} = $data[2];
    print "HoH $svr $data[0] $HoH{$svr}{$data[0]} set\n" if $debug;
  } #end foreach

} #end foreach

#parse each server data
for $svr (keys %HoH)
{
  print "\nPROCESSING: $svr\n";
 
  for $user ( keys $HoH{$svr} )
  { 
    print "pulling values: $svr-$user-$HoH{$svr}{$user} \n" if $debug; 
    compare($svr,$user,$HoH{$svr}{$user});
  }
} #end for

sub compare($$$)
{
  my $source_svr = shift();
  my $source_user = shift();
  my $source_uid = shift();

  print "hit compare() for round of processing\n" if $debug;
  for my $svr (keys %HoH)
  {
    if($source_svr ne $svr)
    {
        print "\ncompare $source_svr with $svr\n" if $debug;
        for my $user ( keys $HoH{$svr} )
        { 
          print "compare $source_svr-$source_user-$source_uid to $svr-$user-$HoH{$svr}{$user}\n" if $debug;
	  if($source_user eq $user)
          {
            print "Mismatch: $source_svr:$source_user:$source_uid $svr:$user:$HoH{$svr}{$user}\n" if $source_uid ne $HoH{$svr}{$user};
          }
        }
    } #end if
    else 
    { next; }
  } #end for
  print "exiting compare()\n" if $debug;
} #end compare
