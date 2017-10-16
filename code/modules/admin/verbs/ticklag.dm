//Merged Doohl's and the existing ticklag as they both had good elements about them ~Carn

/client/proc/ticklag()
	set category = "Debug"
	set name = "Set Ticklag"
	set desc = "Sets a new tick lag. Recommend you don't mess with this too much! Stable, time-tested ticklag value is 0.9"

	if(!check_rights(R_DEBUG))	return

	var/newtick = input("Sets a new tick lag. Please don't mess with this too much! The stable, time-tested ticklag value is 0.9","Lag of Tick", world.tick_lag) as num|null
	//I've used ticks of 2 before to help with serious singulo lags
	if(newtick && newtick <= 2 && newtick > 0)
		log_admin("[key_name(src)] has modified world.tick_lag to [newtick]", 0)
		message_admins("[key_name(src)] has modified world.tick_lag to [newtick]", 0)
		world.tick_lag = newtick
		feedback_add_details("admin_verb","TICKLAG") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		to_chat(src, "<span class='warning'>Error: ticklag(): Invalid world.ticklag value. No changes made.</span>")

//replaces the old Ticklag verb, fps is easier to understand
/client/proc/set_server_fps()
	set category = "Debug"
	set name = "Set Server FPS"
	set desc = "Sets game speed in frames-per-second. Can potentially break the game"

	if(!check_rights(R_DEBUG))
		return

	var/new_fps = round(input("Sets game frames-per-second. Can potentially break the game (default: [config.fps])","FPS", world.fps) as num|null)

	if(new_fps <= 0)
		to_chat(src, "<span class='danger'>Error: set_server_fps(): Invalid world.fps value. No changes made.</span>")
		return
	if(new_fps > config.fps*1.5)
		if(alert(src, "You are setting fps to a high value:\n\t[new_fps] frames-per-second\n\tconfig.fps = [config.fps]","Warning!","Confirm","ABORT-ABORT-ABORT") != "Confirm")
			return

	var/msg = "[key_name(src)] has modified world.fps to [new_fps]"
	log_admin(msg, 0)
	message_admins(msg, 0)

	world.fps = new_fps