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
