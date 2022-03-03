#!/usr/bin/env bash

# Info:
# Script Author: Liron Hazan
# Orgainzation: Sela
# Contact me at liron.hazan@gmail.com
# Written Origanlly in: 27.02.2021
#--------------------------------------
# Exits Script if Bash is old
if [[ $BASH_VERSINFO -lt 4 ]]; then
	echo -e "error:\nCurrent Bash version: $BASH_VERSINFO\nRequired: 4+"
	exit 1
fi
#--------------------------------
# Color(& Style) Codes
# fg=Foreground   bg=Backgorund
fg_black="30";    bg_black="40"
fg_red="31";      bg_red="41"
fg_green="32";    bg_green="42"
fg_yellow="33";   bg_yellow="43"
fg_blue="34";     bg_blue="44"
fg_magenta="35";  bg_magenta="45"
fg_cyan="36";     bg_cyan="46"
fg_white="37";    bg_white="47"

style_reset="\033[0m";   style_bright="1";     style_dim="2";      style_italic="3"
style_underlined="4";    style_blinking="5";   style_inverted="7"  style_strikethrough="9"
nostyle="";              style_start="\033["
#-------------------------------------------------------------------------------------------
# Conditions:
# -----------
# length: minimum 10 chars
# Contains: alphabet and a number
# includes: small and capital letters
# Color output
#
# Requirements:
# --------------
# validaton: returns exit code - passed: 0 failed: 1
# validation failed: Errors Reports
# No human intervention
#------------------------------------------------------
# Function 1: Colorizes messages
color_message(){

local color_code=""
declare -i local i
declare -i local args_amount_without_message=$(($#-1))
declare local color_message=${!#}

for ((i=1; i<$(($args_number_without_message));i++))
do
	color_code+="${!i};"
done

color_code+="${!args_amount_without_message}m"
echo -e "${style_start}${color_code}${color_message}${style_reset}"
}
#------------------------------------------------------------------------------------
# Function 2: Shows Help for invalid Parameters Insertion & Update exit status to 1
show_help(){
	echo -e "$script_name [-f] [\"Your Password\"] [Filename]\n"
	echo -e "\tPassword Validator:"
	echo -e "\t  Validates password"
	echo -e "\n\tOptions:"
	echo -e "\t  -f validates password from file\n\n"
	echo -e "\texit status:"
	echo -e "\t  0 if validation passed"
	echo -e "\t  1 if validation failed"
	exit 1
}
#-------------------------------------------------
# Main Code Starts

declare -a pass_array
declare -a errormsg_array
declare -i errors_Counter=0
declare errors_report=""
declare password=""
script_name=$0

# Checks Number of Arguments:
# 1 Argument  Inserted: The 1st will be considered as password.
# 2 Arguments Inserted: if 1st paramater is "-f" & file exists, a read from file will occour.
# else show help (& update exit status to 1)
if [[ $# -eq 1 ]]; then 
	password=$1

elif [[ $# -eq 2 && $1 -eq "-f" && -a $2 ]]; then
        while read -r line ; do password=$line; done < $2

else
        show_help $script_name
fi


# Creates errors-status-Array & error-messages-array
condition1=$([[ $password =~ [0-9] ]];    echo $?) ; errmsg_1="No Digits"
condition2=$([[ $password =~ [a-zA-Z] ]]; echo $?) ; errmsg_2="No Alphabet Characters"
condition3=$([[ $password =~ [A-Z] ]];    echo $?) ; errmsg_3="No Upper Characters"
condition4=$([[ $password =~ [a-z] ]];    echo $?) ; errmsg_4="No Lower Characters"
condition5=$([[ ${#password} -ge 10 ]];   echo $?) ; errmsg_5="Lower Than 10 Characters"

pass_array=($condition1   $condition2  $condition3  $condition4  $condition5)
errmsg_array=("$errmsg_1" "$errmsg_2"  "$errmsg_3"  "$errmsg_4"  "$errmsg_5")

# Counts Errors & creating an error report
for (( i=0; i<${#pass_array[@]}; i++ )) 
	do
		if [[ ${pass_array[i]} -ne 0 ]] ; then
		        errors_report+="${errmsg_array[i]}\n"
			((errors_counter++))
		fi
	done


# Ends program with proper message & exit status
 if [[ $errors_counter -eq 0 ]]; then
 	color_message $fg_green "Validation Passed"
	exit 0
 else
	echo -e -n "\a"
	color_message $style_underlined $style_blinking $fg_white "Password Validation Failed:"
	color_message $style_underlined $style_blinking $fg_white "---------------------------"
	color_message $nostyle $fg_red "$errors_report"
	exit 1
 fi
