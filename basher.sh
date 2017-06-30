#!/bin/bash


BASER_DIR=$(echo ~)
BASER_DIR="${BASER_DIR}/.basher"

function dieOnFail() {
	if [ ! $1 -eq 0 ];
	then
		if [ "$2" == "" ];
		then
			echo "$2"
		fi
		exit 1
	fi
}

function check() {
	if [ ! -d "${1}/.basher" ];
	then
		mkdir "${1}/.basher"
		dieOnFail $? "Unable to create local dir"
	fi

        if [ ! -d "${1}/.basher/scripts" ];
        then
                mkdir "${1}/.basher/scripts"
		dieOnFail $? "Unable to create scripts directory"
        fi

        if [ ! -d "${1}/.basher/aliases" ];
        then
                mkdir "${1}/.basher/aliases"
		dieOnFail $? "Unable to create aliases directory"
        fi
}


function fetch() {
	if [ ! "$1" == "" ];
	then
		local date=$(date +"%Y_%m_%d_%H_%M_%S")
		local log_path="${BASER_DIR}/scripts/${date}.log"
		local scr_path="${BASER_DIR}/scripts/${date}.sh"

		echo "Downlaoded from" >> "$log_path"
		echo $1 > "$log_path"
		echo "Description: "
		read -r entered_desc
		echo $entered_desc >> "${log_path}"

		wget -O "${scr_path}" $1
		dieOnFail $? "Unable to download script"

		file_alias="-"
		until [[ ! "$file_alias" =~ [^a-zA-Z0-9_] ]];
		do
			echo "Enter command name to run like:"
			read -r file_alias
			if [ -f "${BASER_DIR}/aliases/${file_alias}" ];
			then
				echo "Alias already exists"
			fi
		done


		ln -s "${scr_path}" "${BASER_DIR}/aliases/${file_alias}"
		dieOnFail $? "Unable to create symbolic link"
	fi;
}

function use() {
echo "
	$1 list
		lists all availible options
	$1 fetch "url"
		downloads script from url and saves it
	$1 run <alias> [arguments]
		runs some script


";
}



check $(dirname "${BASER_DIR}")

if [ "$1" == "run" ];
then
	if [ ! -f "${BASER_DIR}/aliases/${2}" ];
	then
		print "Alias does not exists"
	fi;

	shift
	shift

	/bin/bash $(readlink "${BASER_DIR}/aliases/${2}") $@
elif [ "$1" == "list" ];
then
	for al in $(ls "${BASER_DIR}/aliases/");
	do
		echo "Alias: ${al}"
	done;
elif [ "$1" == "add" ];
then
	fetch $2
else
	use $0
fi;
