#!/bin/bash
#SBATCH --cpus-per-task 24

cd /<directory>/

module load ncbi-sra/3.0.2
module load BBmap

#Stores our list of SRA accessions as a variable
file_path="Apis_cerana_SRA.txt"

#This code trims the white space at the end of each accession which was added with each return (\r)
sed -i 's/\r$//' "$file_path"

#'While loop' that reads each SRA accession line by line, downloads the given accession as split read files, runs the split read files through bbmap and then deletes them when finished
while IFS= read -r line || [[ -n "$line" ]]
do
 fasterq-dump "$line" --split-files
 bbmap.sh in1="$line"_1.fastq in2="$line"_2.fastq ref=Apis_Syntretus_mitochondria.fasta covstats=/coverage/"$line"_coverage.txt fast minratio=0.85 maxindel=1 strictmaxindel=t outm=/bbmap_output/"$line".fastq 
 rm "$line"_1.fastq
 rm "$line"_2.fastq
done < "$file_path"

