#!/bin/bash
#SBATCH --cpus-per-task 24

cd /<directory>/

module load ncbi-sra/3.0.2
module load BBmap

fasterq-dump SRR24601093 --split-files

# Step 1 - We identified an SRA read file of Apis cerana that contained Syntretus reads (SRR24601093). To isolate Syntretus mitochondrial reads, we mapped the entire A. cerana read set against just the Apis cerana mitochondrial genome with minratio set to .95 and outputted only unmapped reads.


bbmap.sh in1=SRR24601093_1.fastq in2=SRR24601093_2.fastq ref=Apis_cerana_mitochondria.fasta covstats=/coverage/SRR24601093_cerana_coverage.txt fast minratio=0.95 maxindel=1 strictmaxindel=t outu=/bbmap_output/SRR24601093_unmapped.fastq


# Step 2 We then mapped the unmapped reads output against the Syntretus perlmani mitochondrial genome with minratio set to .50 and outputted mapped reads.


bbmap.sh in=bbmap_output/SRR24601093_unmapped.fastq ref=Syntretus_perlmani_mitochondria.fasta covstats=/coverage/SRR24601093_perlmani_coverage.txt fast minratio=0.50 maxindel=1 strictmaxindel=t outm=/bbmap_output/SRR24601093_mapped.fastq
