#! /bin/bash

DME=baystation12 # DME file/BYOND project to compile and run
PORT=5000 # Port to run Dream Daemon on
GIT=false # true, false, or any valid command; return value decides whether git is called to update the code
REPO=upstream # Repo to fetch and pull from when updating
BRANCH=dev # Branch to pull when updating
GITDIR=. # Directory of code or git repo
EXTRA_DM_SH_ARGS=""

cd ../ # serverdir/

exec 5>&1 # duplicate fd 5 to fd 1 (stdout); this allows us to echo the log during compilation, but also capture it for saving to logs in the case of a failure

[[ -e stopserver ]] && rm stopserver
while [[ ! -e stopserver ]]; do
	MAP="$(cat use_map || echo "exodus")"

	[[ -e _preupdate.sh && -x _preupdate.sh ]] && eval "$(cat _preupdate.sh)" # Pull hook, in THIS ENVIRONMENT

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
	else
		echo "Compilation successful; running gulp..."
		cd "$GITDIR/tgui"
		Goutput="$(gulp | tee /dev/fd/5)"
		Gret=$?
		cd - # from $GITDIR/tgui
		if [[ $Gret != 0 ]]; then
			d="$(date '+%X %x')"
			echo "Gulp failed; saving log to 'data/logs/compile_failure_$d.txt'!"
			echo $Goutput >> "data/logs/compile_failure_$d.txt"
		fi
	fi

	# Retrieve compile files
	if [[ "$GITDIR" != "." ]]; then
		cp "$GITDIR/$DME.dmb" .
		cp "$GITDIR/$DME.rsc" .
		cp -r "$GITDIR/nano" .
		[[ ! -e btime.so && -e "$GITDIR/btime.so" ]] && cp "$GITDIR/btime.so" .
		[[ ! -e tgui/assets ]] && mkdir -p tgui/assets
		cp -r "$GITDIR/tgui/assets" ./tgui
	fi

	[[ -e _postupdate.sh && -x _postupdate.sh ]] && eval "$(cat _postupdate.sh)" # Copy hook, in THIS ENVIRONMENT

	# Reboot or start server
	if ! ps -p $pid 2> /dev/null > /dev/null; then
		DreamDaemon $DME $PORT -trusted &
		pid=$!
		trap "kill -s SIGTERM $pid" EXIT
	else
		kill -s SIGUSR1 $pid # Reboot DD
	fi

	# Wait for end of round or server death
	while [[ ! -e reboot_called ]] && ps -p $pid > /dev/null; do
		sleep 15
	done
	[[ -e reboot_called ]] && rm reboot_called

	# Execute at-update commands
	if [[ -e atupdate && -x atupdate ]]; then
		eval "$(cat atupdate)" # in THIS ENVIRONMENT, i.e. branch changes can be done by `echo 'BRANCH=dev-freeze' > atupdate`
		rm atupdate
	fi
done

kill -s SIGTERM $pid
