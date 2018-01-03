# MADE
MADE (Measuring Adaptive Distance and vaccine Efficacy using allelic barcodes) is a computational package calibrating the strength of passage adaptation happened in a given isolate (strain). The strength of passage adaptation is defined as Adaptive Distance (AD) between the center of the major cluster of all isolates in the database and the strain of interest under principle component analysis (PCA) (See Chen et al for details). Since adaptive distance is found to be negatively correlated with vaccine efficacy, MADE will also predict potential vaccine efficacy of the input isolate using its nucleotide sequence.  


## Background
Vaccine efficacy for influenza A H3N2 virus has dropped rapidly in the past few years. Antigenic drift and passage adaptation (mutations occurring during vaccine production) are known to cause mismatches between vaccine and circulating strains, leading to low effective vaccines. 

Passage adaptation refers to mutations accumulated during virus propagation in the growth medium (e.g. embryonated eggs or mammalian cell lines). It has been well known that the seed precursor influenza virus used for vaccine production must be generated in eggs and subsequent vaccine production will also often be generated using embryonated eggs. Both of these two factors will lead to egg passage adaptation during vaccine production.

When selecting a candidate isolate as the vaccine strain, WHO only considers the antigenic property of the isolate, trying to match the vaccine to the antigenic characteristics of the circulating strains. Since antigenic properties of the circulating strains shift every 3.3 years [Koel et al 2013], antigenic drift might not be a major determining factor for the recent reduction in vaccine efficacy. As shown in Chen et al study, passage adaptation in embryonated egg is found to be a major determinant of vaccine efficacy. MADE implemented the latest idea from Chen et al work measuring the strength of passage adaptation and predict vaccine efficacy for an input isolate. 

Let’s briefly summarize conceptual steps behind MADE: 

1)	Using a large dataset (32,278 H3N2 HA1 sequences) curated from Global Initiative on Sharing All Influenza Data (GISAID) EpiFlu database, we employed a probabilistic approach known as the mutational mapping to infer the possible evolutionary histories of the dataset. 

2)	Given the inferred evolutionary history, we developed two statistical tests known as the enrichment and convergent test to identify codon positions driven by passage adaptation in embryonated egg.  Applying these statistical tests, we identified 14 codons driven by passage adaptation in embryonated egg. 

3)	Statistical analysis found that substitutions happened in the 14 codons are highly convergent. In other words, egg passage medium will drive repeated evolution of certain amino acid changes (e.g. from X to Y). This will lead to alleles specific to the egg passage strains. In this case, Y allele will show high frequency in the egg passaged strains (defined as Pegg) comparing to the background (in all strains, defined as Pall). Using the ratio between Pegg and Pall, we defined the enrichment score for every allele observed at the 14 codons. 

4)	In order to quantitatively measure the strength of passage adaptation, enrichment scores (ES) of the alleles at these 14 codon positions were calculated first. Among all 32,278 sequences, the alleles observed at the 14 codons will define a 14 dimensional enrichment scores for each isolate. Projecting the 14 dimensional space into a PCA map, we found that most of the isolates are clustered together in a major cluster. Interestingly, egg passaged strains show high deviation from the major cluster reflecting the effect of passage adaptation.  We defined the adaptive distance (AD) as the distance between the isolate of interest and the center of the major cluster. As shown in Chen et al study, Adaptive distance (AD) negatively correlate with the vaccine efficacy. Using historical data from 2010-2015, MADE will predict the vaccine efficacy based on the adaptive distance calibrated for the isolate of interest. 
 

## Installing

MADE is written in perl and R.

MADE can be downloaded from github: https://github.com/chenh1gis/MADE


## Running
 
To run the program, two background files containing enrichment scores and one file (defined as the allele file) containing the alleles at the 14 codon positions for the isolate are of interest. User can either directly provide the allele file (Input files) or generate it using perl script "extract_14alleles.pl" from a nucleotide sequence file (Input files). "MADE.R" will produce two output files describing the correlation between adaptive distance and predicted vaccine efficacy of candidate vaccine virus isolate (Output files).


### Input files

#### 14 alleles file (e.g. 14alleles.txt)

14 alleles over 14 codon positions (including 138, 145, 156, 158, 159, 160, 183, 186, 190, 193, 194, 219, 226 and 246) should be listed in two columns as following:

    Codon   AminoAcid
     138        S
     145        N 
     156        H

Note: Please be aware that if any allele state is missing or its enrichment score is not recorded in file "enrichment_scores_329codons", the analysis will be terminated immediately.

Alternatively, 14 alleles file is generated from a H3N2 HA1 nucleotide sequence file (e.g. H3N2_HA1_nucleotide_sequence.fa) following the standard FASTA file format:
    
    >Seq_ID
    
    CAAAAACTTCCTGGAAATGACAACAGCACGGCAACGCTGTGCCTTGGGCA...

Note: 1) Please be very careful about the starting codons, and guarantee that the sequence starts from "QNL...".
2) Please be aware that if any allele state is missing or its enrichment score is not recorded in file "enrichment_scores_329codons", the analysis will be terminated immediately.
3) The corresponding alleles file will be generated using "extract_14alleles.pl".


### Output files

#### PCA & Scatterplot (e.g. Correlation_AdaptiveDistance_VE.pdf)

PCA figure describes the distribution of 32,278 background virus strains (represented by 32,278 dots) in terms of the first and second PCA dimensions. The dot highlighted in black color represents the candidate vaccine virus isolate under current analysis.

Scatterplot figure describes the strongly negative correlation between adaptive distance and vaccine efficacy. R square value labeled at the topright is provided as well. The adaptive distance and predicted vaccine efficacy of the candidate vaccine virus isolate are also described in the figure.

#### Adaptive distance & predicted vaccine efficacy (e.g. Value_AdaptiveDistance_VE.txt)

Adaptive distance and predicted vaccine efficacy of the candidate vaccine virus isolate are listed.


### Commands

* Extract the 14 allelic states from the nucleotide sequence, using the option:

    `perl extract_14alleles.pl [input_sequence_file] [output_allele_file]`

* Calculate adaptive distances and predict the vaccine efficacy of candidate vaccine virus isolate, using the option:

    Unix command:
    
    `Rscript MADE.R [input_14alleles_file] [output_correlation_file] [output_value_file]`

    Windows CMD command:
   
    `Rscript.exe MADE.R [input_14alleles_file] [output_correlation_file] [output_value_file]`


### Examples

* Extract the 14 allelic states from the nucleotide sequence, using the option:

    `perl extract_14alleles.pl H3N2_HA1_nucleotide_sequence.fa 14alleles.txt`
    
    Note: Please make sure that the input file "H3N2_HA1_sequence.fa" is accessible under current directory.

* Calculate adaptive distances and predicted vaccine efficacy of candidate vaccine virus isolate, using the option:

    Unix command:
    
    `Rscript MADE.R 14alleles.txt Correlation_AdaptiveDistance_VE.pdf Value_AdaptiveDistance_VE.txt`
    
    Windows CMD command:
    
    `"C:\Program Files\R\R-3.4.1\bin\Rscript.exe" MADE.R 14alleles.txt Correlation_AdaptiveDistance_VE.pdf Value_AdaptiveDistance_VE.txt`
    
    Note: Please make sure the alleles file "14alleles.txt" and two background enrichment scores files "enrichment_scores_329codons" and 
    "14alleles_background_strains" are all accessible under current directory.


### Background files

Two background files containing enrichment scores are necessary for "MADE.R".

#### File I : enrichment_scores_329codons

All alleles and their enrichment scores across 329 codon positions are recorded.

#### File II : 14alleles_background_strains

Enrichment scores of 14 alleles over 14 codon positions are extracted for 32,278 background and 61 vaccine virus strains.


## Author

* Hui Chen : chenh1@gis.a-star.edu.sg


## Corresponding author

*   Weiwei Zhai : zhaiww1@gis.a-star.edu.sg


## License

This project is licensed under the GNU GPLv3 License - see the
[LICENSE](LICENSE) file for details.
