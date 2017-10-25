#!/bin/bash

for i in $(git branch -r | grep -v 'origin/HEAD');
do
        branch=$(echo $i | awk '{ a=$1; gsub("origin/", "", a); print a }');
        echo "Checkout ${branch}"
        git checkout $branch > /dev/null 2>&1

        if [ ! $? -eq 0 ];
        then
                echo "Unable to checkout ${branch}"
                exit 1
        fi

        git pull > /dev/null 2>&1

        if [ ! $? -eq 0 ];
        then
                echo "Unable to pull ${branch}"
                exit 1
        fi

done
git checkout master
