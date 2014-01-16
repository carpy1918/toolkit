#!/usr/bin/perl

#this script will scrape the users from server list and look for mismatches and improper UID uses

#my @server = ( bdr01mgr,bdr01rhel5,bdr01vid01 ); 
open fh,"/home/ccarp001/server-info/rhel-servers.txt";
my @server = <fh>;
my @results;
my %HoH;
my $debug = 1;

#data gathering and insert into array/hash
foreach(@server)
{
  my $svr = $_;
  chomp($svr);
  print "hit server: $_...\n" if $debug;
  my $passwdf = "data/$svr-passwd";
  open pfh,">>$passwdf";

#  @results = `ssh -t $svr cat /etc/passwd | /bin/awk -F ':' '{print \$1"\t"\$3}'`;
  @results = `ssh -t $svr cat /etc/passwd`;

  foreach(@results)
  {
    my $d = $_;
    chomp($d);
    my @data = split(':',$d);
    print pfh $d . "\n";
    print "passwd file entry: $d \n" if $debug;
    $HoH{$svr}{$data[0]} = $data[2];
    print "HoH $svr $data[0] value: $HoH{$svr}{$data[0]} set\n" if $debug;
  } #end foreach

} #end foreach

#parse each server data
for $svr (keys %HoH)
{
  print "processing $svr\n";
 
  for $user ( keys %{$HoH{$svr}} )
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
      while ( my ($key,$value) = each(%{$HoH{$svr}}) )
      {
 	print "compare $source_svr-$user-$uid to $svr-$key-$value\n" if $debug;
	if($user eq $key)
	{ 
	  print "$source_svr:$user UID:$uid mismatch for $svr:$key:$value\n" if $uid ne $value;
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

