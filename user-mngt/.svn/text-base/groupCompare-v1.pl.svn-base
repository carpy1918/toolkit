#!/usr/bin/perl

#this script will scrape the groups from server list and look for mismatches and improper GID uses

#my @server = ( bdr01mgr,bdr01rhel5,bdr01vid01 ); 
open fh,"servers-temp.log";
my @server = <fh>;
my @results;
my %HoH;
my $debug = 0;

#data gathering and insert into array/hash
foreach(@server)
{
  print "hit server: $_...\n" if $debug;
  my $svr = $_;
  chomp($svr);
  @results = `ssh -t $svr cat /etc/group | /bin/awk -F ':' '{print \$1"\t"\$3}'`;

  foreach(@results)
  {
    my $d = $_;
    chomp($d);
    print $d . "\n" if $debug;
    my @data = split('\t',$d);
    $HoH{$svr}{$data[0]} = $data[1];
    print "Hash value $HoH{$svr}{$data[0]} set\n" if $debug;
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
  my $gid = shift();

  foreach(@server)
  {
    print "$source_svr $user $gid compare() to $_\n" if $debug;
    my $svr = $_;
    if($source_svr ne $_)
    {
      while ( my ($key,$value) = each(%{$HoH{$svr}}) )
      {
 	print "compare $source_svr-$user-$gid to $svr-$key-$value\n" if $debug;
	if($user eq $key)
	{ 
	  print "$source_svr:$user GID:$gid mismatch for $svr:$key:$value\n" if $gid ne $value;
	}
	else
	{
	  print "$source_svr:$user GID:$gid found at $svr:$key:$value\n" if $gid eq $value;
	}
      } #while

    } #end if
    else 
    { next; } 
  } #end foreach
} #end compare

