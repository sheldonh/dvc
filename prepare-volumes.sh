#!/bin/sh

ARGS=$(getopt -o fr -- "$@")
if [ $? -ne 0 ]; then
	exit 1
fi
eval set -- "$ARGS"

run=0
force=0

while true; do
	case "$1" in
	-f)
		force=1
		shift
		;;
	-r)
		run=1
		shift
		;;
	--)
		shift
		break
		;;
	esac
done

if [ $# -lt 1 ]; then
	echo "usage: prepare-volumes [-fr] dir[:mode[:uid[:gid]]] ..." 1>&2
	exit 1
fi

trap "exit 1" TERM
export break_pid=$$

for spec in $*; do
	echo $spec | {
		IFS=: read dir mode uid gid
		if [ $force = 0 ]; then
			mounted=$(mount | awk '$3 == "/data" {print $3}' | wc -l)
			if [ $mounted = 0 ]; then
				echo "prepare-volumes: error: $dir is not a docker volume" 1>&2
				kill -s TERM $break_pid
			fi
		fi
		mkdir -p $dir
		[ -n "$mode" ] && chmod $mode $dir
		[ -n "$uid" ] && chown $uid:$gid $dir
	}
done

trap - TERM

echo Volumes prepared: $*
if [ $run = 0 ]; then
	echo Terminating with success.
	exit 0
else
	echo Sleeping forever.
	exec /bin/sh -c "while sleep 60; do :; done"
fi
