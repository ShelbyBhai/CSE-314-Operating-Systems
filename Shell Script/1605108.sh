#!/bin/bash
>output.csv
if [ $# -eq 2 ];then
    input=$2
    directory=$1
elif [ $# -eq 0 ];then
    echo "please run the script as: $0 input_file_name"
else
    input=$1
    directory="."
fi
rm -rf ./output_dir
mkdir ./output_dir
# output_dir_path="$(realpath ../output_dir)"
# root="$(realpath .)"
# base_root="${root##*/}"
# remove_from_root="${root%/*$base_root}"

if [ $# -eq 2 -o $# -eq 1 ];then
readable=$(file $input)
if [[ $readable == *"ASCII"* || $readable == *"UNICODE"* ]];then
# reading from input file
i=0
array=()
while read line
do
array[i]=$line
i=$((i + 1))
done <input.txt

IFS=$'\n'
all=($(find $directory -type f))
temp=()
dir=()
count=0

# printf "File Path\tLine Number\tLine Containing Searched String\n" >> output.csv
if [ ${array[0]} = "begin" ];then
    for((i=0;i<${#all[@]};i++))
    do
        if head -${array[1]} ${all[i]} | grep -niq ${array[2]};then
            matchedstring="$(head -${array[1]} ${all[i]} | grep -ni ${array[2]})"
            lineNum="$(grep -ni ${array[2]} ${all[i]} | head -n 1 | cut -d":" -f1)"
            matchedstring=${matchedstring:${#lineNum} + 1} 
            printf "${all[i]}\t${lineNum}\t${matchedstring}\n" >> output.csv
            dir="${all[i]}"
            dir=$(echo ${dir} | tr '/' '.')
            temp=$(basename "${all[i]}")
            file="${temp%.*}"
            ext="${temp##*.}"
            mdir=${dir:0:${#dir} - ${#temp}}
            if [ $file = $ext ];then
                if [ $# -eq 2 ];then
                    copy_loc="${directory}/../output_dir/${mdir}${file}${lineNum}"
                else
                    final_file="${mdir}${file}${lineNum}"
                    final_file=${final_file:2}
                    copy_loc="output_dir/${final_file}"
                fi
                cp ${all[i]} "$copy_loc"
                count=`expr $count + 1`
            else
                if [ $# -eq 2 ];then
                    copy_loc="${directory}/../output_dir/${mdir}${file}${lineNum}.${ext}"
                else
                    final_file="${mdir}${file}${lineNum}.${ext}"
                    final_file=${final_file:2}
                    copy_loc="output_dir/${final_file}"
                fi
                cp ${all[i]} "$copy_loc"
                count=`expr $count + 1`

            fi
        fi
    done    
elif [ ${array[0]} = "end" ];then
    for((i=0;i<${#all[@]};i++))
    do
        if tail -${array[1]}  ${all[i]} | grep -niq ${array[2]};then
        lineNum="$(grep -ni ${array[2]} ${all[i]} | tail -n 1 | cut -d":" -f1)"
        dir="${all[i]}"
        dir=$(echo ${dir} | tr '/' '.')
        temp=$(basename "${all[i]}")
        file="${temp%.*}"
        ext="${temp##*.}"
        mdir=${dir:0:${#dir} - ${#temp}}
            if [ $file = $ext ];then
            #     cp ${all[i]} $directory/../output_dir/"${mdir}${file}${lineNum}"
            #     count=`expr $count + 1`
            # else
            #     cp ${all[i]} $directory/../output_dir/"${mdir}${file}${lineNum}.${ext}"
            #     count=`expr $count + 1`
                if [ $# -eq 2 ];then
                    copy_loc="${directory}/../output_dir/${mdir}${file}${lineNum}"
                else
                    final_file="${mdir}${file}${lineNum}"
                    final_file=${final_file:2}
                    copy_loc="output_dir/${final_file}"
                fi
                cp ${all[i]} "$copy_loc"
                count=`expr $count + 1`
            else
                if [ $# -eq 2 ];then
                    copy_loc="${directory}/../output_dir/${mdir}${file}${lineNum}.${ext}"
                else
                    final_file="${mdir}${file}${lineNum}.${ext}"
                    final_file=${final_file:2}
                    copy_loc="output_dir/${final_file}"
                fi
                cp ${all[i]} "$copy_loc"
                count=`expr $count + 1`
            fi
        fi 
    done
fi
fi
fi

echo "Total Number of Files That Matched Criteria : $count"