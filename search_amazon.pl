#!/usr/bin/perl

use strict;
use XML::Amazon;
use Getopt::Std;

our $opt_u;
our $opt_p;
our $opt_y;
our $opt_a;
our $yearfilter;
our $asinfilter;
our $user;
our $pass;

getopt('yaup');

if ( $opt_y ne "" ) {
	$yearfilter=$opt_y;
} else {
	$yearfilter=0;
}

if ( $opt_u ne "" ) {
	$user=$opt_u;
} else {
	$user="";
}

if ( $opt_p ne "" ) {
	$pass=$opt_p;
} else {
	$pass="";
}

#if ( $opt_a ne "" ) {
#	$asinfilter=$opt_a;
#} else {
#	die "ERROR: You must enter an ASIN argument.";
#}


my $search=@ARGV[0];

my $amazon = XML::Amazon->new(token => $user, sak => $pass, locale => 'us');
        
#my $item = $amazon->asin('0596101058');## ASIN access
        
#if ($amazon->is_success){
#	print $item->title;
#}
        
my $items = $amazon->search(keywords => $search, type => 'Music');

if ( ! $amazon->is_success ) {
	print "ERROR: Query Failed.\n";
	exit 50;
}
        
foreach my $item ($items->collection){
	my $type = $item->type;
	if ( $type eq "Music" ) {
		my $title = $item->title;
		my $artist;
		if ($item->artist) {
			$artist = $item->artist->[0];
		}
		my $asin = $item->asin;
		my $origdate = $item->origreleasedate;
		$origdate =~ /(\d{4})-(\d{2})-(\d{2})/;
		my $year = $1;
		my $month = $2;
		my $day = $3;
		#utf8::encode($title);
		if ( int($1) >= $yearfilter ) {
			print $artist . " - " . $title . " (" . $year . ") " . $asin . "\n";
		}
	}
}
