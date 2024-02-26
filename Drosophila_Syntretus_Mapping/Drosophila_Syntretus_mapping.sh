#!/bin/bash
#SBATCH --cpus-per-task 24

cd /<directory>/

module load ncbi-sra/3.0.2
module load BBmap

file_path="DEST_SRA.txt"

sed -i 's/\r$//' "$file_path"

while IFS= read -r line || [[ -n "$line" ]]
do
 fasterq-dump "$line" --split-files
 bbmap.sh in1="$line"_1.fastq in2="$line"_2.fastq ref=Drosophila_Syntretus_mitochondria.fasta covstats=/coverage/"$line"_coverage.txt fast minratio=0.90 maxindel=1 strictmaxindel=t outm=/bbmap_output/"$line".fastq 
 rm "$line"_1.fastq
 rm "$line"_2.fastq
done < "$file_path"

