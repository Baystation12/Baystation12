/datum/map/bolt_saferooms()
	for(var/atype in typesof(/area/crew_quarters/safe_room))
		var/area/A = locate(atype)
		if(istype(A))
			for(var/obj/machinery/door/airlock/vault/bolted/V in A.contents)
				if(!V.locked)
					V.lock()

/datum/map/unbolt_saferooms()
	for(var/atype in typesof(/area/crew_quarters/safe_room))
		var/area/A = locate(atype)
		if(istype(A))
			for(var/obj/machinery/door/airlock/vault/bolted/V in A.contents)
				if(V.locked)
					V.unlock()

/datum/map/make_maint_all_access(var/radstorm = 0)
	maint_all_access = TRUE
	if(radstorm)
		priority_announcement.Announce("Требование о доступе для технических тунелей было отозвано на всех технических шлюзах. Шлюзы бункеров безопасности были разблокированы.", "Attention!")
		GLOB.using_map.unbolt_saferooms()
	else
		priority_announcement.Announce("Требование о доступе для технических тунелей было отозвано на всех технических шлюзах.", "Attention!")

/datum/map/revoke_maint_all_access(var/radstorm = 0)
	maint_all_access = FALSE
	if(radstorm)
		priority_announcement.Announce("Требование о доступе для технических тунелей было поднято на всех технических шлюзах. Шлюзы бункеров безопасности были зыкрыты болтами.", "Attention!")
		GLOB.using_map.bolt_saferooms()
	else
		priority_announcement.Announce("Требование о доступе для технических тунелей было поднято на всех технических шлюзах.", "Attention!")

/datum/map/proc/request_synth()
	var/datum/job/synthetic/synth = SSjobs.get_by_path(/datum/job/synthetic)
	var/success
	if(synth.total_positions == 0)
		priority_announcement.Announce("ЭКСО Синтетик был запрошен для пробуждения из Криогенного Хранилища командным составом судна.", "Attention!")
		synth.total_positions = 1
		success = 1
		return success
	else
		return

/datum/map/torch/roundend_player_status()
	for(var/mob/Player in GLOB.player_list)
		if(Player.mind && !isnewplayer(Player))
			if(Player.stat != DEAD)
				var/turf/playerTurf = get_turf(Player)
				if(evacuation_controller.round_over() && evacuation_controller.emergency_evacuation)
					if(isStationLevel(playerTurf.z))
						to_chat(Player, "<span class='info'><b>You managed to survive, but were marooned on [station_name()] as [Player.real_name]...</b></span>")
					else if (isEscapeLevel(playerTurf.z))
						to_chat(Player, "<font color='green'><b>You managed to survive the events on [station_name()] as [Player.real_name].</b></font>")
					else
						to_chat(Player, "<span class='info'><b>You managed to survive, but were marooned in the sector as [Player.real_name]...</b></span>")
				else if(issilicon(Player))
					to_chat(Player, "<font color='green'><b>You remain operational after the events on [station_name()] as [Player.real_name].</b></font>")
				else if (isNotStationLevel(playerTurf.z))
					to_chat(Player, "<span class='info'><b>You managed to survive, but were marooned in the sector as [Player.real_name]...</b></span>")
				else
					to_chat(Player, "<span class='info'><b>You got through just another workday on [station_name()] as [Player.real_name].</b></span>")
			else
				if(isghost(Player))
					var/mob/observer/ghost/O = Player
					if(!O.started_as_observer)
						to_chat(Player, "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>")
				else
					to_chat(Player, "<font color='red'><b>You did not survive the events on [station_name()]...</b></font>")

/datum/map/torch/roundend_summary(list/data)
	var/desc
	var/survivors = data["surviving_total"]
	var/escaped_total = data["escaped_total"]
	var/marooned_total = data["left_behind_total"]
	var/ghosts = data["ghosts"]
	var/offship_players = data["offship_players"]

	if(survivors > 0)
		desc += "There [survivors > 1 ? "were <b>[survivors] survivors</b>" : "was <b>one survivor</b>"]"
		desc += " (<b>[escaped_total > 0 ? escaped_total : "none"] escaped, [marooned_total] marooned</b>),"
		data += " [offship_players > 1 ? "<b>[offship_players] off-ship players</b>" : "<b>one off-ship player</b>"]"
		data += " and <b>[ghosts] ghosts</b>.<br>"
	else
		desc += "There were <b>no survivors</b>, <b>[offship_players] off-ship players</b>, (<b>[ghosts] ghosts</b>)."

	return desc

/datum/map/proc/toggle_crew_sensors(var/new_mode = 0, var/force = FALSE)
	if(ntnet_global && ntnet_global.check_function(NTNET_SYSTEMCONTROL))	// No network - no remote control
		var/tracked = crew_repository.scan()
		for(var/obj/item/clothing/under/suit in tracked)
			var/turf/pos = get_turf(suit)
			if(pos && (pos.z in GLOB.using_map.map_levels))
				if(force || (suit.sensor_mode < new_mode))
					suit.sensor_mode = new_mode
