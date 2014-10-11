#!/bin/sh

if [ $# -lt 1 ]; then
	echo "usage: prepare-volumes dir[:mode[:uid[:gid]]] ..." 1>&2
	exit 1
fi

for spec in $*; do
	echo $spec | {
		IFS=: read dir mode uid gid
		mkdir -p $dir
		[ -n "$mode" ] && chmod $mode $dir
		[ -n "$uid" ] && chown $uid:$gid $dir
	}
done
