#!/usr/bin/perl

#this script will scrape the users from server list and look for mismatches and improper UID uses

#my @server = ( gfs1, gfs2 ); 
open fh,"/home/ccarp001/server-info/active.txt";
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
  print "hit server: $_...\n" if $debug;
  my $passwdf = "data/$svr-passwd";
  open pfh,">>$passwdf";

#  @results = `ssh -t $_ sudo cat /etc/passwd | gawk -F ':' '{print \$1"\t"\$3}'`;
  @results = `ssh -t $_ sudo cat /etc/passwd`;

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
  my $user = shift();
  my $uid = shift();

  foreach(@server)
  {
    print "$source_svr $user $uid compare() to $_\n" if $debug;
    my $svr = $_;
    if($source_svr ne $_)
    {
      while ( my ($key,$value) = each($HoH{$svr}) )
      {
 	print "compare $source_svr-$user-$uid to $svr-$key-$value\n" if $debug;
	if($user eq $key)
	{ 
	  print "Mismatch: $source_svr:$user:$uid\t$svr:$key:$value\n" if $uid ne $value;
	}
	else
	{
	  print "$source_svr:$user UID:$uid found at $svr:$key:$value\n" if $uid eq $value;
	}
      } #while

    } #end if
    else 
    { next; } 
  } #end foreach
} #end compare

