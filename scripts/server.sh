#! /bin/bash

[[ -z $DME ]] && DME=baystation12 # DME file/BYOND project to compile and run
[[ -z $PORT ]] && PORT=5000 # Port to run Dream Daemon on
[[ -z $GIT ]] && GIT=false # true, false, or any valid command; return value decides whether git is called to update the code
[[ -z $REPO ]] && REPO=upstream # Repo to fetch and pull from when updating
[[ -z $BRANCH ]] && BRANCH=dev # Branch to pull when updating
[[ -z $GITDIR ]] && GITDIR=. # Directory of code or git repo, relative to $SERVERDIR
[[ -z $EXTRA_DM_SH_ARGS ]] && EXTRA_DM_SH_ARGS="" # Extra args to pass to dm.sh
[[ -z $SERVERDIR ]] && SERVERDIR=../ # Location of the server, relative to the directory this script is called with a pwd of
[[ -z $GULP_PATH ]] && GULP_PATH=gulp # Location of gulp executable

cd $SERVERDIR

cleanup() { # $1: server pid
	rm server_running
	[[ $1 != "" ]] && kill -s SIGTERM $1
}

if [[ -e server_running ]]; then
	echo "Server already running!"
	exit 1
fi
touch server_running
trap "cleanup" EXIT

exec 5>&1 # duplicate fd 5 to fd 1 (stdout); this allows us to echo the log during compilation, but also capture it for saving to logs in the case of a failure

[[ -e stopserver ]] && rm stopserver
while [[ ! -e stopserver ]]; do
	MAP="$(cat use_map || echo "torch")"

	# Any part of the update process can set this to immediately halt all further updating and kill the script
	# This is NOT for trivial errors; only set this if the error is such that the server should NOT be started
	UPDATE_FAIL=0

	[[ -e _preupdate.sh && -x _preupdate.sh ]] && eval "$(cat _preupdate.sh)" # Pull hook, in THIS ENVIRONMENT

	[[ $UPDATE_FAIL != 0 ]] && exit $UPDATE_FAIL

	# Update
	cd "$GITDIR"
	if $GIT; then
		git fetch $REPO
		git checkout $BRANCH && git pull $REPO $BRANCH
	fi

	# Compile
	echo "Compiling..."
	DMoutput="$(./scripts/dm.sh $EXTRA_DM_SH_ARGS -M$MAP $DME.dme | tee /dev/fd/5)" # duplicate output to fd 5 (which is redirected to stdout at the top of this script)
	DMret=$?
	cd - # from $GITDIR
	if [[ $DMret != 0 ]]; then
		d="$(date '+%X %x')"
		echo "Compilation failed; saving log to 'data/logs/compile_failure_$d.txt'!"
		echo $DMoutput >> "data/logs/compile_failure_$d.txt"
		UPDATE_FAIL=1 # this is probably fatal
	else
		echo "Compilation successful; running gulp..."
		cd "$GITDIR/tgui"
		Goutput="$($GULP_PATH | tee /dev/fd/5)"
		Gret=$?
		cd - # from $GITDIR/tgui
		if [[ $Gret != 0 ]]; then # tgui might be borked but it shouldn't totally break stuff, so no UPDATE_FAIL here
			d="$(date '+%X %x')"
			echo "Gulp failed; saving log to 'data/logs/compile_failure_$d.txt'!"
			echo $Goutput >> "data/logs/compile_failure_$d.txt"
		fi
	fi

	[[ $UPDATE_FAIL != 0 ]] && exit $UPDATE_FAIL

	# Retrieve compile files
	if [[ "$GITDIR" != "." ]]; then
		cp "$GITDIR/$DME.dmb" .
		cp "$GITDIR/$DME.rsc" .
		cp -r "$GITDIR/nano" .
		[[ ! -e btime.so && -e "$GITDIR/btime.so" ]] && cp "$GITDIR/btime.so" .
		[[ ! -e tgui/assets ]] && mkdir -p tgui/assets
		cp -r "$GITDIR/tgui/assets" ./tgui
		[[ ! -e .git/logs ]] && mkdir -p .git/logs
		cp "$GITDIR/.git/HEAD" ./.git/HEAD
		cp "$GITDIR/.git/logs/HEAD" ./.git/logs/HEAD
	fi

	[[ -e _postupdate.sh && -x _postupdate.sh ]] && eval "$(cat _postupdate.sh)" # Copy hook, in THIS ENVIRONMENT

	[[ $UPDATE_FAIL != 0 ]] && exit $UPDATE_FAIL

	# Reboot or start server
	if ! ps -p $pid 2> /dev/null > /dev/null; then
		if [[ -e _start_dd.sh ]]; then
			pid="$(./_start_dd.sh $DME $PORT)" # call out to external script for DD
		else
			DreamDaemon $DME $PORT -trusted &
			pid=$!
		fi
		trap "cleanup $pid" EXIT
	else
		kill -s SIGUSR1 $pid # Reboot DD
	fi

	# Wait for end of round or server death
	while [[ ! -e reboot_called ]] && ps -p $pid > /dev/null; do
		sleep 15
	done
	[[ -e reboot_called ]] && rm reboot_called

	[[ -e stopserver ]] && exit 0

	# Execute at-update commands
	if [[ -e atupdate && -x atupdate ]]; then
		eval "$(cat atupdate)" # in THIS ENVIRONMENT, i.e. branch changes can be done by `echo 'BRANCH=dev-freeze' > atupdate`
		rm atupdate
	fi
done

cleanup $pid
