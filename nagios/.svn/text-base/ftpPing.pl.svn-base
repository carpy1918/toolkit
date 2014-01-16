#!/usr/bin/perl

    use Net::FTP;

    my $server = shift;

    if($server eq "")
    { print "No server set. Exiting.\n";exit; }

    $ftp = Net::FTP->new($server, Debug => 0)
    or die "Cannot connect to " . $server . "\nem_result=1";

    $ftp->login("infra","passwd")
    or die "Error: ", $ftp->message . "\nem_result=2";

    $ftp->cwd("/pub")
    or die "Cannot change working directory " . $ftp->message . "\nem_result=3";

#    $ftp->get("that.file")
#    or die "get failed ", $ftp->message;

    $ftp->quit;
    print "em_result=0\n";
