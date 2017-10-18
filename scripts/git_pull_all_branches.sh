for i in $(git branch -r | grep -v 'origin/HEAD'); do branch=$(echo $i | awk '{ a=$1; gsub("origin/", "", a); print a }'); git checkout $branch; git pull; done
