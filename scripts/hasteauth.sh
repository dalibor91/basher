#!/bin/bash

_rc_file="${HOME}/.hasterc"


if ! [ -f "${_rc_file}" ];
then
    echo "
HASTERC_AUTH=''
HASTERC_DOMAIN='paste.dalibor.me'
HASTERC_PROTOCOL='https'
" >> ${_rc_file};
fi

# load variables
source ${_rc_file}

_auth_header="authorization:"
if [ -f ${HASTERC_AUTH} ];
then
    _auth_header="${_auth_header} Basic `cat ${HASTERC_AUTH}`"
fi

if [ "`which curl`" = "" ];
then
    echo "CURL is not installed!"
fi

key=$(curl -s -X POST "${HASTERC_PROTOCOL}://${HASTERC_DOMAIN}/documents" -H "${_auth_header}" --data "`cat`" | python -c 'import json, sys; f=json.loads(sys.stdin.read()); print(f["key"] if "key" in f else "")')

echo "${HASTERC_PROTOCOL}://${HASTERC_DOMAIN}/${key}"
