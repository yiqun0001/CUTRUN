#!/bin/bash
#SBATCH --job-name=my_job
#SBATCH --out="slurm-%j.out"
#SBATCH --cpus-per-task=20
#SBATCH --mem=100G
#SBATCH --mail-type=ALL

# path to your yq built by build.sh
image=/home/yj286/docker/yq
# path to your samples
dir=/home/yj286/project/CUTRUN/Sample_133T5KF
# path to src
src_dir=/home/yj286/docker/src/

apptainer exec $image fastqc $dir/*_R1_001.fastq.gz $dir/*_R2_001.fastq.gz

apptainer exec $image java -jar $src_dir/Trimmomatic-0.36/trimmomatic-0.36.jar PE -phred33 $dir/*_R1_001.fastq.gz $dir/*_R2_001.fastq.gz $dir/paired_r1.fq.gz $dir/unpaired_r1.fq.gz $dir/paired_r2.fq.gz $dir/unpaired_r2.fq.gz ILLUMINACLIP:$src_dir/Trimmomatic-0.36/adapters/TruSeq3-PE.fa:2:15:4:1:true MINLEN:20

apptainer exec $image bowtie2 --dovetail --threads 8 -x $src_dir/index/mm10 -1 $dir/paired_r1.fq.gz -2 $dir/paired_r2.fq.gz | apptainer exec $image samtools view -bS -> $dir/paired.bam

apptainer exec $image java -jar $src_dir/picard.jar SortSam I=$dir/paired.bam O=$dir/sorted_paired.bam SORT_ORDER=coordinate VALIDATION_STRINGENCY=LENIENT

apptainer exec $image java -jar $src_dir/picard.jar MarkDuplicates I=$dir/sorted_paired.bam O=$dir/marked_dup_paired.bam M=$dir/marked_dup_paired.txt VALIDATION_STRINGENCY=LENIENT

apptainer exec $image samtools view -F 1024 -f 2 -b $dir/marked_dup_paired.bam -o $dir/removed_dup_paired.bam

apptainer exec $image samtools index $dir/removed_dup_paired.bam $dir/removed_dup_paired.bai

apptainer exec $image bamCoverage -b $dir/removed_dup_paired.bam -o $dir/deeptools_coverage.bw
