#!/bin/bash
wd=`pwd`
project=`basename ${wd}`
BIRed='\033[1;91m'
BIGreen='\033[1;92m' 
Color_Off='\033[0m'

F=`awk -F":" '$1~/^Forward_read_file_tail/{print $2}' "${wd}/tail_name.txt"|sed 's/ //g'`
R=`awk -F":" '$1~/^Reverse_read_file_tail/{print $2}' "${wd}/tail_name.txt"|sed 's/ //g'`
re='^[0-9]+([.][0-9]+)?$'

if  [[ ! -d "raw" || -z "`ls raw`" ]]
	then 
		echo -e "${BIRed}Error: please put fastq.gz files in a directory named \"raw\" under project folder.${Color_Off}"
		exit
fi

if ! [ -z "$F" ] 
	then 
		if  ! [ -z "$R" ]
			then
				for i in `ls  "${wd}"/raw/*`;do basename $i ;done |sed -e "s/${F}//g;s/${R}//g" |sort |uniq > "${wd}/list.txt.tmp"
				awk '{print $0}' "${wd}/list.txt.tmp" "${wd}/list.txt.tmp" |sort|awk -v F="${F}" -v R="${R}" 'NR%2==1{OFS=",";print $1,$1F,"forward"} NR%2==0{OFS=",";print $1,$1R,"reverse"}' >"${wd}/${project}_manifest.csv"
			else
				for i in `ls  "${wd}"/raw/*`;do basename $i ;done |sed -e "s/${F}//g" |sort |uniq > "${wd}/list.txt.tmp"
				awk '{print $0}' "${wd}/list.txt.tmp" |sort|awk  -v F="${F}" '{OFS=",";print $1,$1F,"forward"}' >"${wd}/${project}_manifest.csv"
		fi
	else
		echo -e "${BIRed}Error: please enter file tail (e.g. _L001_R1.fastq.gz) in \"tail_name.txt\" file.${Color_Off}"
		exit
fi
echo -e "${BIGreen}${project}_manifest.csv has been successfully generated at ${wd}/.${Color_Off}"

rm ${wd}/*.tmp 2>/dev/null



#Step 1: create a folder with desired project name.
#Step 2: put gen_ma.sh and tail_name.txt in the project folder.
#Step 3: create "raw" folders to store input fastq.gz under project folders. The example folder stucture is shown below.
#Step 4: edit the "tail_name.txt". If input data is single-end, remember to keep it blank after "Reverse_read_file_tail: ".
#Step 5: enter "bash gen_ma.bash" in terminal under the project folder.

#This script will generate manifest.csv with project name as prefix, e.g. projectA_manifest.csv.
#This program was tested under Ubuntu Linux 18.04.2 x86_64, CentOS Linux 7.2.1511 x86_64 and macOS High Sierra 10.13.6.

#.
#└── projectB
#    ├── gen_ma.bash
#    ├── raw
#    │   ├── sample1_L001_R1.fastq.gz
#    │   ├── sample1_L001_R2.fastq.gz
#    │   ├── sample2_L001_R1.fastq.gz
#    │   ├── sample2_L001_R2.fastq.gz
#    │   ├── sample3_L001_R1.fastq.gz
#    │   ├── sample3_L001_R2.fastq.gz
#    │   ├── sample4_L001_R1.fastq.gz
#    │   ├── sample4_L001_R2.fastq.gz
#    │   ├── sample5_L001_R1.fastq.gz
#    │   └── sample5_L001_R2.fastq.gz
#    ├── README
#    └── tail_name.txt

