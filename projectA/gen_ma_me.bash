#!/bin/bash
wd=`pwd`
project=`basename ${wd}`
BIRed='\033[1;91m'
BIGreen='\033[1;92m' 
Color_Off='\033[0m'

F=`awk -F":" '$1~/^Forward_read_file_tail/{print $2}' "${wd}/tail_name.txt"|sed 's/ //g'`
R=`awk -F":" '$1~/^Reverse_read_file_tail/{print $2}' "${wd}/tail_name.txt"|sed 's/ //g'`
re='^[0-9]+([.][0-9]+)?$'

if ! [ -z "$F" ] 
	then 
		if  ! [ -z "$R" ]
			then
				for i in `ls  */*/*`;do basename $i ;done |sed -e "s/${F}//g;s/${R}//g" |sort |uniq > "${wd}/list.txt.tmp"
				awk '{print $0}' "${wd}/list.txt.tmp" "${wd}/list.txt.tmp" |sort|awk -v F="${F}" -v R="${R}" 'NR%2==1{OFS=",";print $1,$1F,"forward"} NR%2==0{OFS=",";print $1,$1R,"reverse"}' >"${wd}/${project}_manifest.csv"
				for i in `ls -d */`;do cd "${wd}/${i}" ;class=`echo $i|sed 's/\///' 2>/dev/null` ;value=`ls */* |awk 'BEGIN{FS="\/"} NR==1{OFS="\t";print $1}' 2>/dev/null`;[[ ${value} =~ $re ]] && type="numeric" || type="categorical" ;ls */* |awk 'BEGIN{FS="\/"} {OFS="\t"; print $2,$1}' 2>/dev/null|sed -e "s/${F}//g;s/${R}//g"|sort|uniq|awk -v type="${type}" -v class="${class}"  'BEGIN{OFS="\t"; print "#q2:types",type"\nsample-id",class}  {OFS="\t";print }'|sort -k 1,1 >"${wd}/${class}.class.tmp"; cd ${wd};done
			else
				for i in `ls  */*/*`;do basename $i ;done |sed -e "s/${F}//g" |sort |uniq > "${wd}/list.txt.tmp"
				awk '{print $0}' "${wd}/list.txt.tmp" |sort|awk  -v F="${F}" '{OFS=",";print $1,$1F,"forward"}' >"${wd}/${project}_manifest.csv"
				for i in `ls -d */`;do cd "${wd}/${i}" ;class=`echo $i|sed 's/\///' 2>/dev/null` ;value=`ls */* |awk 'BEGIN{FS="\/"} NR==1{OFS="\t";print $1}' 2>/dev/null`;[[ ${value} =~ $re ]] && type="numeric" || type="categorical" ;ls */* |awk 'BEGIN{FS="\/"} {OFS="\t"; print $2,$1}' 2>/dev/null|sed -e "s/${F}//g"|sort|uniq|awk -v type="${type}" -v class="${class}"  'BEGIN{OFS="\t"; print "#q2:types",type"\nsample-id",class}  {OFS="\t";print }'|sort -k 1,1 >"${wd}/${class}.class.tmp"; cd ${wd};done
		fi
	else
		echo -e "${BIRed}Error: please enter file tail (e.g. _L001_R1.fastq.gz) in \"tail_name.txt\" file.${Color_Off}"
		exit
fi

awk 'NR==1{print "sample-id"} NR==1{print "#q2:types"} {print $0}' "${wd}/list.txt.tmp" |nl|sort -k 2,2 >"${wd}/index.tmp"

for i in  "${wd}/"*.class.tmp;do join  -1 2 -2 1 -e"NA" -t $'\t' -a1 -o 2.2 "${wd}/index.tmp" ${i} > "${i}.join.tmp";done

paste "${wd}/index.tmp" "${wd}/"*.class.tmp.join.tmp|sort -k 1,1g |cut -f 2- >"${wd}/${project}_metadata.tsv"

echo -e "${BIGreen}${project}_metadata.tsv and ${project}_manifest.csv have been successfully generated at ${wd}/.${Color_Off}"

rm ${wd}/*.tmp 2>/dev/null




#Step 1: create a folder with desired project name.
#Step 2: put gen_ma_me.sh and tail_name.txt in the project folder.
#Step 3: create condition folders as following, and put the input fastq.gz into coresponding folders. The example folder below has two conditions: body-site (categorical) and days (numeric).
#Step 4: edit the "tail_name.txt". If input data is single-end, remember to keep it blank after "Reverse_read_file_tail: ".
#Step 5: enter "bash gen_ma_me.bash" in terminal under the project folder.

#Output files include metadata.tsv and manifest.csv with project name as prefix, e.g. projectA_metadata.tsv and projectA_manifest.csv.
#This program was tested under Ubuntu Linux 18.04.2 x86_64, CentOS Linux 7.2.1511 x86_64 and macOS High Sierra 10.13.6.


#└── projectA
#    ├── body-site
#    │   ├── gut
#    │   │   ├── sample1_L001_R1.fastq.gz
#    │   │   ├── sample1_L001_R2.fastq.gz
#    │   │   ├── sample2_L001_R1.fastq.gz
#    │   │   ├── sample2_L001_R2.fastq.gz
#    │   │   ├── sample3_L001_R1.fastq.gz
#    │   │   ├── sample3_L001_R2.fastq.gz
#    │   │   ├── sample4_L001_R1.fastq.gz
#    │   │   └── sample4_L001_R2.fastq.gz
#    │   ├── left-palm
#    │   │   ├── sample5_L001_R1.fastq.gz
#    │   │   ├── sample5_L001_R2.fastq.gz
#    │   │   ├── sample6_L001_R1.fastq.gz
#    │   │   ├── sample6_L001_R2.fastq.gz
#    │   │   ├── sample7_L001_R1.fastq.gz
#    │   │   └── sample7_L001_R2.fastq.gz
#    │   └── tongue
#    │       ├── sample8_L001_R1.fastq.gz
#    │       ├── sample8_L001_R2.fastq.gz
#    │       ├── sample9_L001_R1.fastq.gz
#    │       └── sample9_L001_R2.fastq.gz
#    ├── days
#    │   ├── 10
#    │   │   ├── sample1_L001_R1.fastq.gz
#    │   │   ├── sample1_L001_R2.fastq.gz
#    │   │   ├── sample2_L001_R1.fastq.gz
#    │   │   ├── sample2_L001_R2.fastq.gz
#    │   │   ├── sample3_L001_R1.fastq.gz
#    │   │   └── sample3_L001_R2.fastq.gz
#    │   ├── 20
#    │   │   ├── sample4_L001_R1.fastq.gz
#    │   │   ├── sample4_L001_R2.fastq.gz
#    │   │   ├── sample5_L001_R1.fastq.gz
#    │   │   ├── sample5_L001_R2.fastq.gz
#    │   │   ├── sample6_L001_R1.fastq.gz
#    │   │   └── sample6_L001_R2.fastq.gz
#    │   └── 30
#    │       ├── sample7_L001_R1.fastq.gz
#    │       ├── sample7_L001_R2.fastq.gz
#    │       ├── sample8_L001_R1.fastq.gz
#    │       ├── sample8_L001_R2.fastq.gz
#    │       ├── sample9_L001_R1.fastq.gz
#    │       └── sample9_L001_R2.fastq.gz
#    ├── gen_ma_me.sh
#    ├── README
#    └── tail_name.txt




