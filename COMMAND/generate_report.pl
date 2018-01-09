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
$EMAIL=$ARGV[10];

%Genetic_code=('TCA'=>'S','TCC'=>'S','TCG'=>'S','TCT'=>'S','TTC'=>'F','TTT'=>'F','TTA'=>'L','TTG'=>'L','TAC'=>'Y','TAT'=>'Y','TAA'=>'-','TAG'=>'-','TGC'=>'C','TGT'=>'C','TGA'=>'-','TGG'=>'W','CTA'=>'L','CTC'=>'L','CTG'=>'L','CTT'=>'L','CCA'=>'P','CCC'=>'P','CCG'=>'P','CCT'=>'P','CAC'=>'H','CAT'=>'H','CAA'=>'Q','CAG'=>'Q','CGA'=>'R','CGC'=>'R','CGG'=>'R','CGT'=>'R','ATA'=>'I','ATC'=>'I','ATT'=>'I','ATG'=>'M','ACA'=>'T','ACC'=>'T','ACG'=>'T','ACT'=>'T','AAC'=>'N','AAT'=>'N','AAA'=>'K','AAG'=>'K','AGC'=>'S','AGT'=>'S','AGA'=>'R','AGG'=>'R','GTA'=>'V','GTC'=>'V','GTG'=>'V','GTT'=>'V','GCA'=>'A','GCC'=>'A','GCG'=>'A','GCT'=>'A','GAC'=>'D','GAT'=>'D','GAA'=>'E','GAG'=>'E','GGA'=>'G','GGC'=>'G','GGG'=>'G','GGT'=>'G');

%SYMBOL=('t'=>'T','c'=>'C','a'=>'A','g'=>'G');

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

if ($ALLE_FILE==0 && $SEQ_FILE==1)
{
	open (SEQUENCE,"file_sequence.fa");
	while ($seq=<SEQUENCE>)
	{
		chomp $seq;
		if ($seq!~/>/)
		{
		if ($seq!~/[^ATCGatcg]/)
		{
			$seq=~s/a/A/g;
			$seq=~s/t/T/g;
			$seq=~s/c/C/g;
			$seq=~s/g/G/g;
			$aa=$AA=$SEQ="";
		        $len=length($seq);
		        for ($i=0;$i<$len/3;$i++)
		        {
		                $base=substr($seq,$i*3,1);
		                $base1=substr($seq,$i*3+1,1);
		                $base2=substr($seq,$i*3+2,1);
		                $BASE=$base.$base1.$base2;
                                $aa=$aa.$Genetic_code{$BASE};
			}
			$n=int($len/80);
			for ($i=0;$i<$n;$i++)
			{
				$seg=substr($seq,$i*80,80);
				$SEQ=$SEQ.$seg."\\n";
			}
			$seg=substr($seq,$n*80,$len-$n*80);
			$SEQ=$SEQ.$seg;
			$length=length($aa);
			$nn=int($length/80);
			for ($i=0;$i<$nn;$i++)
			{
				$seg=substr($aa,$i*80,80);
				$AA=$AA.$seg."\\n";				
			}
			$seg=substr($aa,$nn*80,$length-$nn*80);
			$AA=$AA.$seg;
			print "$seq\n$AA\n";
		}
		else
		{
			print "Error : ambiguous character is not acceptable for MADE!\n";
			exit(0);	
		}
		}
	}
	close SEQUENCE;
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
#	system ("R -e \"rmarkdown::render(\'MADE_report.Rmd\',output_file=\'test.html\',params=list(made=\'system_gene\',strain=\'$STRAIN\',def=\'$DEFINITION\',source=\'$SOURCE\',host=\'$HOST\',pass=\'$PASSAGE\',comm=\'$COMMENT\',sub=\'$SUBMITTER\',email=\'$EMAIL\',seq=\'$SEQ\',AA=\'$AA\'))\"");
#	system ("pandoc MADE_report.Rmd -o test.pdf")
	system ("R -e \"rmarkdown::render(\'MADE_report.Rmd\',output_format=\'all\',params=list(made=\'system_gene\',strain=\'$STRAIN\',def=\'$DEFINITION\',source=\'$SOURCE\',host=\'$HOST\',pass=\'$PASSAGE\',comm=\'$COMMENT\',sub=\'$SUBMITTER\',email=\'$EMAIL\',seq=\'$SEQ\',AA=\'$AA\'))\"");
#	system ("R -e \"rmarkdown::render(\'MADE_report.Rmd\',output_format=\'all\',params=list(made=\'system_gene\',strain=\'$STRAIN\',def=\'$DEFINITION\',source=\'$SOURCE\',host=\'$HOST\',pass=\'$PASSAGE\',comm=\'$COMMENT\',sub=\'$SUBMITTER\',email=\'$EMAIL\'))\"");
}
