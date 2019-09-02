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
