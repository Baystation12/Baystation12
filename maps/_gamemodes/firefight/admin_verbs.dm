
/hook/startup/proc/firefight_admin_verbs()
	admin_verbs_fun.Add(/client/proc/firefight_endless)
	admin_verbs_hideable.Add(/client/proc/firefight_endless)
	return 1

/client/proc/firefight_endless()
	set category = "Fun"
	set name = "Endless Wave Spawns"
	if(!check_rights(R_FUN))
		return

	var/datum/game_mode/firefight/F = ticker.mode
	if(istype(F))
		if(F.evac_stage)
			to_chat(usr,"<span class='warning'>It's too late to activate Endless Wave Spawns once evac has started.</span>")
		else if(F.current_wave < F.max_waves)
			F.current_wave = F.max_waves + 1
			message_admins("[key_name_admin(src)] has activated Endless Wave Spawns. By the rings, this is too much...")
			command_announcement.Announce("Objective: Survive","Evacuation has been disabled")

		else
			F.current_wave = F.max_waves - 1
			message_admins("[key_name_admin(src)] has deactivated Endless Wave Spawns. The game will end next wave.")
			command_announcement.Announce("Survive for one more wave...","Evacuation is coming")
	else
		to_chat(usr,"<span class='warning'>Error: the current gamemode is [F.name] | [F.type] but \
			Endless Wave Spawns can only be used on Firefight, Stranded or Crusade gamemode.</span>")
