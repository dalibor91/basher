#!/bin/bash


options_add=""
options_delete=""
options_remote=""
options_run=""
options_explain=""
options_edit=""
options_list=0
options_help=0
options_update=0
options_home_dir="${HOME}/.bshr"
options_scripts_dir="${options_home_dir}/scripts"
options_aliases_dir="${options_home_dir}/aliases"
options_describ_dir="${options_home_dir}/describe"
options_global_log="${options_home_dir}/log"
options_args=""
options_all_args=$@

function _log() {
    local msg=$(date +"[ %Y-%m-%d %H:%M:%S ] ")
    local msg="${msg}${1}"

    echo "${msg}" >> "${options_global_log}"
}

function _dieOnFail() {
    _log "_dieOnFail [ $1 ] [ $2 ]"
    if [ ! $1 -eq 0 ];
	then
		if [ ! "$2" = "" ]; then echo "$2"; fi
		exit 1;
	fi
}

function _parseParams() {
    while [[ $# -gt 0 ]];
    do
        local key=$1
        _log "key passed -> ${key}"
        if [ "${key}" = "--args" ];
        then
            shift
            options_args=$@
            break
        fi;

        case $key in 
            -a|--add)
               options_add=$2
               shift
               shift
               ;;
            -d|--delete)
               options_delete=$2
               shift
               shift
               ;;
	    -e|--edit)
	       options_edit=$2
	       shift
	       shift
	       ;;
            -E|--explain)
               options_explain=$2
               shift
               shift
               ;; 
            -H|--host)
               options_remote=$2
               shift
               shift
               ;;
            -r|--run)
               options_run=$2
               shift
               shift
               ;;
            -l|--list)
               options_list=1
               shift
               ;;
            -h|--help)
               options_help=1
               shift
               ;;
            --update)
               options_update=1
               shift
               ;;
            *)
                #unknown 
                #options_args="${options_args}${key} "
                echo "Unknown -> ${key}"
                shift
            ;;
        esac
    done;
}

function _checkDirectories() {
    if [ ! -d "$options_home_dir" ]; then mkdir "$options_home_dir"; _dieOnFail $? "Unable to create $options_home_dir"; fi;
    if [ ! -d "$options_scripts_dir" ]; then mkdir "$options_scripts_dir"; _dieOnFail $? "Unable to create $options_scripts_dir"; fi;
    if [ ! -d "$options_aliases_dir" ]; then mkdir "$options_aliases_dir"; _dieOnFail $? " Unable to create $options_aliases_dir"; fi;
    if [ ! -d "$options_describ_dir" ]; then mkdir "$options_describ_dir"; _dieOnFail $? " Unable to create $options_describ_dir"; fi;
}

function _addNewScript() {
    _log "_addNewScript()"

    local file_alias="-"
    until [[ ! "$file_alias" =~ [^a-zA-Z0-9_] ]];
    do
        echo "Enter alias:"
        read -r file_alias
        if [ -f "${options_aliases_dir}/${file_alias}" ];
        then
                echo "Alias already exists"
                local file_alias="-"
        fi
    done

    local descr="${options_describ_dir}/${file_alias}"

    echo "Added from ${2}" >> "${descr}"
    echo "Added to ${1}" >> "${descr}"

    echo "Description: "
    read _descr

    echo "${_descr}" >> "${descr}"

    ln -s "$1" "${options_aliases_dir}/${file_alias}" 

    _dieOnFail $? "Unable to add alias"
    
}

function _getAlias() {
    _log "_getAlias()"
    if [ -f "${options_aliases_dir}/$1" ]; then echo $(readlink "${options_aliases_dir}/$1"); fi;
}

function _process() {

    function _action_help() { 
        _log "Action help()"
        echo "BSHR is small script that enables you running and managing shell scripts with one command
    bshr
        -a|--add     <script>     - add script to basher, local or remote
        -e|--edit    <alias>      - edit script that you saved by some alias 
        -r|--remove  <alias>      - run script that you saved by some alias 
        -H|--host    <user@host>  - destination where to run script
        -e|--explain <alias>      - print description message
	--args                    - pass arguments to script 
        --update                  - update basher
        -l                        - list all scripts
        -h                        - this message
	
    Exapmple:
        bshr -a /tmp/test.sh
	bshr -r test 
	bshr -r test -H root@192.168.0.100
	bshr -r test --args \"pass to script\" \"also this\"
	bsht -r test -H root@192.168.0.100 --args \"additional" \"arg\"	
"; 
    }

    function _action_add() {
        _log "Action add()"
        if [ "$1" = "" ]; then echo "Nothing to add"; exit 2; fi;

        local script_path=$1
        local file_name=$(date +"%Y_%m_%d_%H_%M_%S.sh")
        
        if [[ "$script_path" =~ ^https?: ]];
        then 
            local _curl=$(which curl)
            local _wget=$(which wget)

            if [ "${_curl}${_wget}" = "" ]; then echo "Curl or wget are needed for download"; exit 3; fi;

            if [ ! "${_curl}" = "" ];
            then 
                _log "Add via curl to ${file_name}" 
                curl -s $1 > "${options_scripts_dir}/${file_name}"; _dieOnFail $? "Unable to download from $2";
                _addNewScript "${options_scripts_dir}/${file_name}" "$1"
            elif [ ! "$_wget" = "" ];
            then 
                _log "Add via wget to ${file_name}"
                wget -O "${options_scripts_dir}/${file_name}" $1; _dieOnFail $? "Unable to download from $2"
                _addNewScript "${options_scripts_dir}/${file_name}" "$1"
            fi;
        else
            if [ ! -f "$1" ]; then "File $1 does not exissts"; exit 5; fi;

            cp "$1" "${options_scripts_dir}/${file_name}"
            _dieOnFail $? "Unable to copy $1"
            _addNewScript "${options_scripts_dir}/${file_name}" "$1"
        fi;
    }

    function _action_list() {
        _log "Action list()"
        echo "Scripts found: "
        for item in $(ls "${options_aliases_dir}"); do echo " - ${item}"; done;
    }

    function _action_remove() {
        _log "Action remove()"
        local file_alias=$1
        local script=$(_getAlias $file_alias)
        _log "Remove ${script}"
        if [ "$script" = "" ]; then echo "Unable to find alias"; exit 6; fi
        _log "${options_aliases_dir}/${file_alias}"
        rm "${options_aliases_dir}/${file_alias}"
        _log "rm $script"
        rm "$script"
        if [ -f "${options_describ_dir}/${file_alias}" ]; 
        then 
            _log "${options_describ_dir}/${file_alias}"
            rm "${options_describ_dir}/${file_alias}"
        fi
    }

    function _action_explain() {
        _log "Action explain()"
        local file_alias=$1
        if [ -f "${options_describ_dir}/${file_alias}" ]; 
        then 
            _log "${options_describ_dir}/${file_alias}"
            cat "${options_describ_dir}/${file_alias}"
        fi
    }

    function _action_remote() {
        _log "Action remote(${1} ${2})"
        local script=$(_getAlias $1)
        if [ "${script}" = "" ]; then echo "Alias not found"; exit 7; fi;
        if [ "$2" = "" ]; then echo "Remote server not set"; exit 9; fi;
        if [ "`which ssh`" = "" ]; then echo "ssh command not found"; exit 8; fi;

        ssh "$2" "bash -s" -- < "${script}" "${options_args}"
    }

    function _action_run() {
        _log "Action run(${1})"
        local script=$(_getAlias $1)
        if [ "${script}" = "" ]; then echo "Alias not found"; exit 10; fi;
        local bsh=$(which bash) 
        eval "${bsh} ${script} ${options_args}" 
    }

    function _action_update() {
        local basher=$(which bshr)
        if [ ! "$basher" = "" ];
        then
            echo "Updating..."
            local abspath=$(readlink "$basher")
            curl -o "$abspath" "https://raw.githubusercontent.com/dalibor91/basher/master/basher.sh?timestamp=$(date +"%s")"
            if [ $? -eq 0 ];
            then
                echo "Updated."
            else
                echo "Update failed"
            fi
        fi
    }
    
    function _action_edit() {
    	local script=$(_getAlias $1)
	if [ "${script}" = "" ]; then echo "Alias not found"; exit 10; fi;
	
	if [ "$DEFAULT_EDITOR" ];
	then 
	   $DEFAULT_EDITOR "$script"
	else 
	   nano $script
	fi
    }

    if [ $options_help -eq 1 ]; then _action_help; fi;
    if [ $options_list -eq 1 ]; then _action_list; fi;
    if [ ! "$options_edit" = "" ]; then _action_edit $options_edit; fi;
    if [ ! "$options_delete" = "" ]; then _action_remove $options_delete ; fi;
    if [ ! "$options_add" = "" ]; then _action_add $options_add ; fi;
    if [ ! "$options_explain" = "" ]; then _action_explain $options_explain ; fi;
    if [ $options_update -eq 1 ]; 
    then 
        echo "Updating..."
        _action_update
	echo "Done updating"
	exit 
    fi;
    if [ ! "$options_remote" = "" ]; 
    then 
        _action_remote $options_run $options_remote; 
    elif [ ! "$options_run" = "" ];
    then 
        _action_run $options_run 
    fi
    
    if [ "${options_all_args}" = "" ]; then _action_list; fi;
    
}

#create directories 
_checkDirectories

#parse input params 
_parseParams $@


#echo "
#    Add    = ${options_add}
#    Remove = ${options_remove}
#    Remote = ${options_remote}
#    Run    = ${options_run}
#    List   = ${options_list}
#    Help   = ${options_help}
#    Explain= ${options_explain}
#    Update = ${options_update}
#    Args   = ${options_args}
#";

_process




exit;
