#!/usr/bin/perl

#############################################################################
## Author: Hui Chen
## Created Time: 2018-1-3 14:41:44
## File Name: Generate_report.pl
## Description: MADE is deposited in https://github.com/chenh1gis/MADE_docker
#############################################################################

##use strict;
##use warnings;

$SUBTYPE=$ARGV[0];	## H1N1seasonal:1 H1N1pdm:2 H3N2:3
$ALLE_FILE=$ARGV[1];	## exist:1 non-exist:0
$SEQ_FILE=$ARGV[2];	## exist:1 non-exist:0
$STRAIN=$ARGV[3];
$DEFINITION=$ARGV[4];
$SOURCE=$ARGV[5];
$HOST=$ARGV[6];
$PASSAGE=$ARGV[7];
$COMMENT=$ARGV[8];
$SUBMITTER=$ARGV[9];

if ($SUBTYPE!=1 && $SUBTYPE!=2 && $SUBTYPE!=3)
{
	print "Error : please select the virus subtype before submission!\n";
	exit(0);
}

if ($ALLE_FILE!=1 && $SEQ_FILE!=1)
{
	print "Error : please upload either allele file or sequence file before submission!\n";
	exit(0);
}elsif ($ALLE_FILE==1 && $SEQ_FILE==1)
{
	print "Alarm : only the allele file will participate the further analysis by defauly when both allele and sequence files are uploaded!\n";
}

if ($SUBTYPE==1)
{

}elsif ($SUBTYPE==2)
{

}else
{
        if ($ALLE_FILE!=1)
        {
                system ("perl extract_alleles.pl 3 file_sequence.fa ../MUSCLE/muscle3.8.31_i86linux64 sequence_combined.fa sequence_combined.afa file_allele.txt");
		system ("rm sequence_combined.fa; rm sequence_combined.afa");
        }
	system ("");
}

