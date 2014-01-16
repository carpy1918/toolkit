#!/usr/bin/perl

#generate index page for nodeStats

my $webdir = "/srv/www/htdocs/nodeStats/";
my @files = `ls $webdir`; 
my @servers;
my $hit=0;

open(fh,">".$webdir."index.html");

print fh "<html><body><p><b>Network Server Node Data</b></p><br><p>";

foreach(@files)
{
  my $file=$_;
  chomp($file);
  if($file eq "index.html")
  { next; }
  @output=split("-",$file);
  foreach(@servers)
  {
    if($output[0] eq $_)
    {
      $hit++;
      next;
    }

  } #end foreach
  if($hit == 0)
  { push(@servers,$output[0]); }
  $hit = 0;
} #end foreach

foreach(@servers)
{
  print fh "<a href=$_-stats.html>$_-stats</a>\n<a href=$_-cmd.html>$_-cmd</a>\n<a href=$_-kmods.html>$_-kmods</a>\n<a href=$_-errors.html>$_-errors</a><br>\n"; 

} #print foreach

print fh "</body></html>";

