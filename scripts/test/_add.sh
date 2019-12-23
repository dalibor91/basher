#!/bin/bash

#### bshr -r tuser
#### bshr -r tuser -su test

echo " > Test print user"
ADD_ALIAS="tuser" ADD_DESCRIPTION="printuser" bshr -a scripts/test/user.sh

#### bshr -r targ --args 1 2 3 4

echo " > Test print arguments"
ADD_ALIAS="targ" ADD_DESCRIPTION="print arguments" bshr -a scripts/test/arguments.sh

#### bshr -r tenv -env /tmp/env

echo " > Test print env"
echo -e "TEST=1\nTEST2=2" > /tmp/env
ADD_ALIAS="tenv" ADD_DESCRIPTION="printenv" bshr -a scripts/test/printenv.sh
