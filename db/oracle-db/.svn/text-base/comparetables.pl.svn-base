#!/usr/bin/perl
#
#This script will compare database table data for the tables provided
#

use DBI;
use DBD::Oracle;

my $sql;
my $db1 = 'test2';				#db1 is the TARGET database
my $db2 = 'test';				#db2 is the SOURCE known-good database
my $dbh;					#database connection handle
my $sth;					#database connection instance
my $data;					#data results from sql query
my @dbtables = ('');			#array of tables from database 1
my $error = 0;					#error flag
my $debug = 0;					#1=debug on, 0=debug off

###
###DATABASE 1 (dbh) is the TARGET database to be compared
#   $dbh = DBI->connect('dbi:Oracle:'.$db1,'sys','',{ora_session_mode=>2}) or die('Could not connect to database');
   $dbh = DBI->connect('dbi:Oracle:'.$db1,'system','') or die('Could not connect to database');
###


#
#Compare table data
#

   print "Starting table data comparison...\n";
   my $sql = "create public database link " . $db2 . "link using '$db2'";
   print "SQL: $sql \n" if $debug==1;
   $sth = $dbh->prepare($sql) or die('Could not prepare sql');
   $sth->execute() or die('Could not execute sql');
   $sth->finish();


   foreach(@dbtables)
   {

	my $table = $_;
	print "Comparing $table...\n";
   	my $sql = "select * from $table@" . $db2 . "link minus select * from $table";
   	print "SQL: $sql \n" if $debug==1;
   	$sth = $dbh->prepare($sql) or die('Could not prepare sql');
   	$sth->execute() or die('Could not execute sql');

   	while($data = $sth->fetchrow_array())
   	{
		print "MISSING ROW FROM $table: $data\n";
   	}
   	$sth->finish();

   } #end foreach

   print "Table row comparison complete.\n\n";   
   print "Disconnecting from databases.\n\n";

   my $sql = "drop public database link " . $db2 . "link";
   print "SQL: $sql \n" if $debug==1;
   $sth = $dbh->prepare($sql) or die('Could not prepare sql');
   $sth->execute() or die('Could not execute sql');
   $sth->finish();
   $dbh->disconnect();



