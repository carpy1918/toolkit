#!/usr/bin/perl
#
#This script will compare database schemas and data post migration
#

use DBI;
use DBD::Oracle;

my $sql;
my $db1 = 'test2';				#db1 is the TARGET database
my $db2 = 'test';				#db2 is the SOURCE known-good database
my $dbh;					#database connection handle
my $dbh2;
my $sth;					#database connection instance
my $sth2;
my $data;					#data results from sql query
my $data2;
my @db1tables;					#array of tables from database 1
my @db2tables;					#array of tables from database 2
my $error = 0;					#error flag
my $debug = 0;					#1=debug on, 0=debug off

###
###DATABASE 1 (dbh) is the TARGET database to be compared
#   $dbh = DBI->connect('dbi:Oracle:'.$db1,'sys','',{ora_session_mode=>2}) or die('Could not connect to database');
   $dbh = DBI->connect('dbi:Oracle:'.$db1,'system','') or die('Could not connect to database');
###

###
###DATABASE 2 (dbh2) is the ORIGINAL known-good database
###
#   $dbh2 = DBI->connect('dbi:Oracle:'.$db2,'sys','',{ora_session_mode=>2}) or die('Could not connect to database');
   $dbh2 = DBI->connect('dbi:Oracle:'.$db2,'system','') or die('Could not connect to database');
###


#
#Compare tables
#

   print "Starting table comparison...\n";
   my $sql = "select table_name from user_tables";
   print "SQL: $sql \n" if $debug==1;
   $sth = $dbh->prepare($sql) or die('Could not prepare sql');
   $sth2 = $dbh2->prepare($sql) or die('Could not prepare sql');
   $sth->execute() or die('Could not execute sql');
   $sth2->execute() or die('Could not execute sql');

   while($data = $sth->fetchrow_array())
   {
	print "Adding $data to table array for $db1\n" if $debug==1;
	push(@db1tables,$data);
   }
   while($data = $sth2->fetchrow_array())
   {
	print "Adding $data to table array for $db2\n" if $debug==1;
	push(@db2tables,$data);
   }

   foreach(@db2tables)
   {
	my $table = $_;
	my $flag = 0;
	print "Comparing $table from $db2 to $db1\n" if $debug==1;
 	foreach(@db1tables)
	{
		if($_ eq $table)
		{
			$flag++;
		}
	} #end inner foreach
	if($flag == 0)
	{
		print $table . " not found in " . $db1 . "!!!\n";
	}
	$flag = 0;
   } #end outer foreach

   print "Table comparison complete.\n\n";
   $sth->finish();
   $sth2->finish();

#
#Compare table fields
#

   $sth->finish();
   $sth2->finish();
   print "Starting table field comparision...\n";

   foreach(@db1tables)
   {
	my $table = $_;
	my @columns;
	my @columns2;
	my $qual;
	my $owner;
	my $type;

	$error = 0;
	$sql = "select * from $table";
	print "Table: " . $table . "\n" if $debug==1;
	print "SQL: " . $sql . "\n" if $debug==1;
	$sth = $dbh->prepare($sql) or die('Could not prepare sql');
	$sth2 = $dbh2->prepare($sql) or die('Could not prepare sql');
	$sth->execute() or $error = 1;
	$sth2->execute() or $error = 1;
	if($error == 1)
	{ print "Error getting info on $table\n";last; }
	
		my $fields = $sth->{NUM_OF_FIELDS};
		for(my $i = 0;$i < $fields;$i++)
		{
			print "Adding " . $sth->{NAME}->[$i] . " to column list\n" if $debug==1;
			push(@columns,$sth->{NAME}->[$i]);	
		}#end for

		my $fields2 = $sth2->{NUM_OF_FIELDS};
		for(my $i = 0;$i < $fields2;$i++)
		{
			print "Adding " . $sth2->{NAME}->[$i] . " to column list\n" if $debug==1;
			push(@columns2,$sth2->{NAME}->[$i]);	
		}#end for
		foreach(@columns2)
		{
			my $col = $_;
			my $flag = 0;
			print "Comparing $col of $table to $db1 table columns\n" if $debug==1;
			foreach(@columns)
			{
	                	if($_ eq $col)
                		{ 
                        		$flag++;
                		} 
        		} #end inner foreach
        		if($flag == 0) 
        		{ 
                		print "Column $col not found in $table of $db1!!!\n";
        		} 
        		$flag = 0; 

		}#end foreach
   }#end foreach

   $sth->finish();
   $sth2->finish();
   print "Table field comparison complete.\n\n";

#
#Compare table row count
#

   print "Starting table row count comparison...\n";
   foreach(@db1tables)
   {
	$error = 0;
  	my $table = $_;
	$sql = "select count(*) from $table";
	print "Table: $table \n" if $debug==1;
	print "SQL: $sql \n" if $debug==1;

	$sth = $dbh->prepare($sql) or die('Could not prepare sql');
        $sth2 = $dbh2->prepare($sql) or die('Could not prepare sql');
	$sth->execute() or $error = 1;
	$sth2->execute() or $error = 1;
	if($error == 1)
	{ print "Error getting info on $table\n";last; }

	$data = $sth->fetchrow_array();
	$data2 = $sth2->fetchrow_array();
	print "Comparing $table count $data for $db1 to $data2 for $db2\n" if $debug==1;

	if($data != $data2)
	{
		print "Table entry count ($data and $data2) for $table do not match in $db1 and $db2!!!\n";
	}
   } #end foreach	

   print "Table row comparison complete.\n\n";   
   $sth->finish();
   $sth2->finish();

   print "Disconnecting from databases.\n\n";
   $dbh->disconnect();
   $dbh2->disconnect();

