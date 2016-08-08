#!/bin/sh

# TODO: verify $1 is a valid git commit

echo "Be sure master is current with Linus' master branch"
echo "master: $(git log --oneline --no-decorate master -1)"
echo "$1: $(git log --oneline --no-decorate $1 -1)"
echo

git cherry -v master $1 | grep -e "^-"
if [ $? -eq 0 ]; then
	echo -e "\nERROR: The commits listed above have already been merged!"
	exit -1
fi

echo "No previously merged commits were detected"
