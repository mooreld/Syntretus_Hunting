# Identifying Syntretus infections
Several thousands of insects are sampled from the wild each year to have their genomes sequenced. Occassionally, the researchers producing this sequence data will also unknowingly produce sequence data of other 'passengers' (e.g. viruses, microbial symbionts and parasites). These unintended sequencing outcomes can be a treasure trove for researchers who study host-symbiont relationships as it can provide not only sequencing data of the infecing organism, but also expand provide data on host range and geographic range. For the purposes of this study, we sought to identify _Syntretus_ [Braconidae:Euphorinae] wasp infections in publically available read data of two known potential hosts including _Drosophila_ and _Apis_ _cerena_. Due to the sheer number of SRA files we needed to explore and their large file sizes, it was inefficient for us to do individual blast searches of each individual SRA file. Instead, we developed a 'for loop' that takes a .txt list of SRA accessions and downloads each one at a time to be screened for _Syntretus_ markers. Specifically, the code uses the fasterq-dump function of ncbi-sra/3.0.2 to upload the next SRA accession in the list. The uploaded SRA read file is then submitted to BBmap/38.35 software where the reads are mapped against both the host mitochondrial genome and the _Syntretus_ mitochondrial genome. The outputs of BBmap/38.35 are coverage statistics and mapped reads. Once the mapping is finished, the SRA read file is deleted to make room for the next. As the 'for loop' implies, this continues up until the last SRA accession in the list.

We review the coverage statistics output (covstats) to determine if any reads mapped to the _Syntretus_ mitochondrial genome. All positive hits are further investigated with sequence analysis software (e.g. Geneious)

This code can be adapted to search for any foreign reads within a series of SRA read sets so long as 1) the user has a series of SRA accessions they want to investigate and 2) the user has a DNA reference for the infecting organism (e.g. we use mitochondrial DNA).

We screened SRA read sets for two potenital _Syntretus_ hosts including _Drosophila_ and _Apis_. We have created folders containing the code, SRA accessions and Mitochondrial references for both. Additionally, _Syntretus_ and _Apis_ share sequence similarity due to being relatively closely related (i.e. both are Hymenopterans). Therefore, it required a more sensitive approach to cleanly seperate _Syntretus_ reads from _Apis cerana_ reads. We created a seperate folder for this code as well. Descriptions for each folder are included below.

Required bioinformatic tools for these codes include BBmap/38.35 and ncbi-sra/3.0.2 (or most up to date versions).

## Drosophila_Syntretus_Mapping Folder
In this folder we have included the code (Drosophila_Syntretus_mapping.sh), the list of SRA accessions (DEST_SRA.txt), and the mitochondrial genomes of both _Syntretus perlmani_ and _Drosophila melanogaster_ (Drosophila_Syntretus_Mitochondria.fasta). We included the _Drosophila melanogaster_ mitochondrial genome in the mapping process to act as a positive control. All SRA reads were acquired from **Drosophila Evolution over Space and Time** databse published by Kapun et al., 2021. It took us over a week to go through all the DEST SRA accessions - if the user is just interested in read sets that possess _Syntretus_ reads, then they can refer to Table S_ which lists those specific accessions.

When we identify _Syntretus_ reads within a _Drosophila_ read set, we re-download the SRA read file and run it through BBmap again with the same minratio still set at .90 but using only the _Syntretus_ mitochondrial genome as the reference sequence (i.e. not _Syntretus_ **and** _Drosophila_ as we did in the first run). This is how we get an ouput of mapped reads with just _Syntretus_ reads. We do not worry about _Drosophila_ reads being included in this final output because the sequence similarity between _Syntretus_ and _Drosophila_ is so low. 

## Apis_Syntretus_Mapping Folder
In this folder we have included the code (Apis_Syntretus_mapping.sh), the list of SRA accessions (Apis_cerana_SRA.txt), and the mitochondrial genomes of both _Syntretus perlmani_ and _Apis cerana_ (Apis_Syntretus_Mitochondria.fasta). We included the _Apis cerana_ mitochondrial genome in the mapping process to act as a positive control.

In the case of 'Drosophila_Syntretus_Mapping', we extracted just _Syntretus_ reads by mapping the whole read sets using only the _Syntretus_ mitochondrial genome as the reference sequence. We could do this because there is low similarity between _Drosophila_ and _Syntretus_ and therefor, _Drosophila_ reads are unlikely to map. However, in this particular case _Apis_ and _Syntretus_ both belong to the order Hymenoptera and are more likely to possess regions of high similarity. Additionally, the _Syntretus_ species that infects _Apis cerana_ is distinct from the species _Syntretus perlmani_ and therefor, a lower minratio threshold is required to map _Syntretus_ reads from the _Apis cerana_ read set. For these reasons, we have taken a simple two step mapping process to exclude _Apis_ reads from our final _Syntretus_ read ouput which is described in the final folder 'Apis_Syntretus_Mapping_Sensitive'. 

## Apis_Syntretus_Mapping_Sensitive Folder
In this folder we have included the code (Apis_sensitive_mapping.sh), the _Apis cerana_ mitochondrial genome (Apis_cerana_mitochondria.fasta), and the _Syntretus perlmani_ mitochondrial genome (Syntretus_perlmani_mitochondria.fasta). Due to the similaritie between the _Syntretus_ and _Apis_ mitochondrial genomes, we seperated the mapping into two steps. The first step was to map reads with high similarity to just the _Apis cerana_ mitochondrial genome and output 'unmapped reads' only. The second step was to map the 'unmappped reads' against the _Syntretus perlmani_ mitochondrial genome with a low threshold for similarity and output 'mapped reads' only. This final 'mapped reads' output consists of almost entirely reads belonging to _Syntretus_.
