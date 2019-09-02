#Step 1: create a folder with desired project name.
#Step 2: put gen_ma_me.sh and tail_name.txt in the project folder.
#Step 3: create condition folders as following, and put the input fastq.gz into coresponding folders. The example folder below has two conditions: body-site (categorical) and days (numeric). Alternatively, you may use touch command or soft links to reduce storage and to accelerate.
#Step 4: edit the "tail_name.txt". If input data is single-end, remember to keep it blank after "Reverse_read_file_tail: ".
#Step 5: enter "bash gen_ma_me.bash" in terminal under the project folder.

#Output files include metadata.tsv and manifest.csv with project name as prefix, e.g. projectA_metadata.tsv and projectA_manifest.csv.
#This program was tested under Ubuntu Linux 18.04.2 x86_64, CentOS Linux 7.2.1511 x86_64, macOS High Sierra 10.13.6 and Windows 7 x86_64 with cygwin installation.


└── projectA
    ├── body-site
    │   ├── gut
    │   │   ├── sample1_L001_R1.fastq.gz
    │   │   ├── sample1_L001_R2.fastq.gz
    │   │   ├── sample2_L001_R1.fastq.gz
    │   │   ├── sample2_L001_R2.fastq.gz
    │   │   ├── sample3_L001_R1.fastq.gz
    │   │   ├── sample3_L001_R2.fastq.gz
    │   │   ├── sample4_L001_R1.fastq.gz
    │   │   └── sample4_L001_R2.fastq.gz
    │   ├── left-palm
    │   │   ├── sample5_L001_R1.fastq.gz
    │   │   ├── sample5_L001_R2.fastq.gz
    │   │   ├── sample6_L001_R1.fastq.gz
    │   │   ├── sample6_L001_R2.fastq.gz
    │   │   ├── sample7_L001_R1.fastq.gz
    │   │   └── sample7_L001_R2.fastq.gz
    │   └── tongue
    │       ├── sample8_L001_R1.fastq.gz
    │       ├── sample8_L001_R2.fastq.gz
    │       ├── sample9_L001_R1.fastq.gz
    │       └── sample9_L001_R2.fastq.gz
    ├── days
    │   ├── 10
    │   │   ├── sample1_L001_R1.fastq.gz
    │   │   ├── sample1_L001_R2.fastq.gz
    │   │   ├── sample2_L001_R1.fastq.gz
    │   │   ├── sample2_L001_R2.fastq.gz
    │   │   ├── sample3_L001_R1.fastq.gz
    │   │   └── sample3_L001_R2.fastq.gz
    │   ├── 20
    │   │   ├── sample4_L001_R1.fastq.gz
    │   │   ├── sample4_L001_R2.fastq.gz
    │   │   ├── sample5_L001_R1.fastq.gz
    │   │   ├── sample5_L001_R2.fastq.gz
    │   │   ├── sample6_L001_R1.fastq.gz
    │   │   └── sample6_L001_R2.fastq.gz
    │   └── 30
    │       ├── sample7_L001_R1.fastq.gz
    │       ├── sample7_L001_R2.fastq.gz
    │       ├── sample8_L001_R1.fastq.gz
    │       ├── sample8_L001_R2.fastq.gz
    │       ├── sample9_L001_R1.fastq.gz
    │       └── sample9_L001_R2.fastq.gz
    ├── gen_ma_me.sh
    ├── README
    └── tail_name.txt



