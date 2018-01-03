#!/usr/bin/perl

##########################################################################
## Author: Hui Chen
## Created Time: 2017-8-17 09:40:44
## File Name: extract_allele.pl
##########################################################################
#use strict;
#use warnings;

$SUBTYPE=$ARGV[0];
$FILE=$ARGV[1];
$PATH=$ARGV[2];
$COMBINED=$ARGV[3];
$ALIGNED=$ARGV[4];
$OUTFILE=$ARGV[5];

if ($SUBTYPE==1)
{
	@CODON=(89,97,129,134,161,185,186,221,222,226);
}
elsif ($SUBTYPE==2)
{
	@CODON=(21,127,129,183,190,191,222,223,225);
}
elsif ($SUBTYPE==3)
{
	@CODON=(138,145,156,158,159,160,183,186,190,193,194,219,226,246);
}
else
{
	print "Please re-run this script and input the correct parameter of different influenza subtypes:\n1:H1N1pdm\n2:H1N1seasonal\n3:H3N2\n";
	exit(0);
}

%Genetic_code=('TCA'=>'S','TCC'=>'S','TCG'=>'S','TCT'=>'S','TTC'=>'F','TTT'=>'F','TTA'=>'L','TTG'=>'L','TAC'=>'Y','TAT'=>'Y','TAA'=>'-','TAG'=>'-','TGC'=>'C','TGT'=>'C','TGA'=>'-','TGG'=>'W','CTA'=>'L','CTC'=>'L','CTG'=>'L','CTT'=>'L','CCA'=>'P','CCC'=>'P','CCG'=>'P','CCT'=>'P','CAC'=>'H','CAT'=>'H','CAA'=>'Q','CAG'=>'Q','CGA'=>'R','CGC'=>'R','CGG'=>'R','CGT'=>'R','ATA'=>'I','ATC'=>'I','ATT'=>'I','ATG'=>'M','ACA'=>'T','ACC'=>'T','ACG'=>'T','ACT'=>'T','AAC'=>'N','AAT'=>'N','AAA'=>'K','AAG'=>'K','AGC'=>'S','AGT'=>'S','AGA'=>'R','AGG'=>'R','GTA'=>'V','GTC'=>'V','GTG'=>'V','GTT'=>'V','GCA'=>'A','GCC'=>'A','GCG'=>'A','GCT'=>'A','GAC'=>'D','GAT'=>'D','GAA'=>'E','GAG'=>'E','GGA'=>'G','GGC'=>'G','GGG'=>'G','GGT'=>'G');

if ($SUBTYPE==1)
{
	$filename="H1N1seasonal_HA1_ref.fa";
	if (-e $filename)
	{
		open (REF,"$filename");
	}
	else
	{
		print ("ERROR: the reference file \"H1N1seasonal_HA1_ref.fa\" is not under current directory.");
		exit(0);	
	}
}
elsif ($SUBTYPE==2)
{
        $filename="H1N1pdm_HA1_ref.fa";
        if (-e $filename)
        {
                open (REF,"$filename");
        }
        else
        {
                print ("ERROR: the reference file \"H1N1pdm_HA1_ref.fa\" is not under current directory.");
                exit(0);
        }
}
else
{
        $filename="H3N2_HA1_ref.fa";
        if (-e $filename)
        {
                open (REF,"$filename");
        }
        else
        {
                print ("ERROR: the reference file \"H3N2_HA1_ref.fa\" is not under current directory.");
                exit(0);
        }
}

open (FILE,"$FILE");
open (COMBINED,"$COMBINED");
$title=<FILE>;
chomp $title;
$seq=<FILE>;
chomp $seq;
close FILE;
if ($title!~/>/) 
{
	print "ERROR: the format of sequence title is wrong, please update the sequence file \"$FILE\" in correct fasta format\n"; exit(0);
}
if ($seq!~/[A|T|C|G]/ && $seq!~/[a|c|t|g]/)
{
	print "ERROR: amniguous character is observed in sequence, please update the sequence file \"$FILE\" in correct fasta format\n"; exit(0);
}
else
{
	open (COMBINED,">$COMBINED");
	print COMBINED "$title\n$seq\n";
	$title_ref=<REF>;
	$seq_ref=<REF>;
	print COMBINED $title_ref;
	print COMBINED $seq_ref; 
	close COMBINED;
}

system("$PATH -in $COMBINED -out $ALIGNED");
print "\nSequence alignment has finished!\n";

$seq=$seq_ref="";
open (ALIGN,"$ALIGNED");
$title=<ALIGN>;
chomp $title;
$line=<ALIGN>;
chomp $line;
while ($line!~/\>/)
{
	$seq=$seq.$line;
	$line=<ALIGN>;
	chomp $line;
}
$title_ref=$line;
while ($line=<ALIGN>)
{
	chomp $line;
	$seq_ref=$seq_ref.$line;
}
$len=length($seq_ref);
for ($index=0;$index<$len;$index++)
{
	$string=substr($seq_ref,0,$index+1);
	$string1=$string;
	$string1=~s/-//g;
	$length=length($string1);
	$INDEX{$length-1}=$index;
}
close ALIGN;

foreach $codon(@CODON)
{
	$char1=substr($seq,$INDEX{($codon-1)*3},1);
	$char2=substr($seq,$INDEX{($codon-1)*3+1},1);
	$char3=substr($seq,$INDEX{($codon-1)*3+2},1);
	if ($char1 eq '-' || $char2 eq '-' || $char3 eq '-')
	{
        	print "ERROR: the sequence of H3 HA1 is not complete and information of some codons are missing!\n";
	        exit(0);
	}
	else
	{
		$CHAR{$codon}=$char1.$char2.$char3;
	}
}

open (ALLE,">$OUTFILE");
print ALLE "CODON\tAminoAcid\n";
foreach $codon(@CODON)	
{
	print ALLE "$codon\t$Genetic_code{$CHAR{$codon}}\n";
}
close ALLE;
