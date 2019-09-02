#Step 1: create a folder with desired project name.
#Step 2: put gen_ma.sh and tail_name.txt in the project folder.
#Step 3: create "raw" folders to store input fastq.gz under project folders. The example folder stucture is shown below.
#Step 4: edit the "tail_name.txt". If input data is single-end, remember to keep it blank after "Reverse_read_file_tail: ".
#Step 5: enter "bash gen_ma.bash" in terminal under the project folder.

#This script will generate manifest.csv with project name as prefix, e.g. projectA_manifest.csv.
#This program was tested under Ubuntu Linux 18.04.2 x86_64, CentOS Linux 7.2.1511 x86_64, macOS High Sierra 10.13.6 and Windows 7 x86_64 with cygwin installation

.
└── projectB
    ├── gen_ma.bash
    ├── raw
    │   ├── sample1_L001_R1.fastq.gz
    │   ├── sample1_L001_R2.fastq.gz
    │   ├── sample2_L001_R1.fastq.gz
    │   ├── sample2_L001_R2.fastq.gz
    │   ├── sample3_L001_R1.fastq.gz
    │   ├── sample3_L001_R2.fastq.gz
    │   ├── sample4_L001_R1.fastq.gz
    │   ├── sample4_L001_R2.fastq.gz
    │   ├── sample5_L001_R1.fastq.gz
    │   └── sample5_L001_R2.fastq.gz
    ├── README
    └── tail_name.txt

