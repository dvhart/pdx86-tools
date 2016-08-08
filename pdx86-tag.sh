#!/bin/bash
usage() {
	echo Usage: $(basename $0) VERSION COMMIT
	echo "e.g. $(basename $0) 4.4-2 for-next"
}

if [ $# -ne 2 ]; then
	echo $#
	usage
	exit 1
fi

VERSION=$1
COMMIT=$2

# Perform a sanity check before creating the tag
pdx86-cherry.sh master $2
if [ $? -ne 0 ]; then
	exit 1
fi

TAG="platform-drivers-x86-v$VERSION"

which tempfile &> /dev/null
if [ $? -eq 0 ]; then
	TMP=$(tempfile -p pdx86 -s .tag)
else
	which mktemp &> /dev/null
	if [ $? -eq 0 ]; then
		TMP=$(mktemp --suffix=.tag pdx86-XXX)
	fi
fi
if [ -z "$TMP" ]; then
	echo "ERROR: Failed to create a suitable temp file"
	exit 1
fi


PREFIX=''
(
echo -e "platform-drivers-x86 for $VERSION\n";
echo "SHORT SUMMARY OF CHANGES FOR LINUS";
git log --pretty='format:%s' master..$COMMIT | \
while read line || [[ -n "$line" ]]; do
	NEW_PREFIX=$(echo $line | cut -d ':' -f 1)
	SUBJECT=$(echo $line | sed -e 's/^[^:]*: *\(.*\)/\1/')
	if [ ! "$PREFIX" = "$NEW_PREFIX" ]; then
		PREFIX="$NEW_PREFIX"
		echo -e "\n$PREFIX:"
	fi
	echo " - $SUBJECT"
done
) > $TMP
$EDITOR $TMP
git tag -s -F $TMP -a platform-drivers-x86-v$VERSION $COMMIT
if [ $? -ne 0 ]; then
	echo "git tag failed. Edited tag message saved in $TMP."
	exit 1
fi

echo "Created tag: $TAG"
echo "Push with 'git push pdx86 $TAG'"
rm $TMP
