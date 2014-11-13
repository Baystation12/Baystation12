//Cortical borer spawn event - care of RobRichards1997 with minor editing by Zuhayr.
/datum/event/borer_infestation
	announceWhen = 400

	var/spawncount = 5
	var/successSpawn = 0        //So we don't make a command report if nothing gets spawned.

/datum/event/borer_infestation/setup()
	announceWhen = rand(announceWhen, announceWhen + 50)
	spawncount = rand(1, 3)

/datum/event/borer_infestation/announce()
	if(successSpawn)
		command_announcement.Announce("Unidentified lifesigns detected coming aboard [station_name()]. Secure any exterior access, including ducting and ventilation.", "Lifesign Alert", new_sound = 'sound/AI/aliens.ogg')

/datum/event/borer_infestation/start()
	var/list/vents = list()
	for(var/obj/machinery/atmospherics/unary/vent_pump/temp_vent in world)
		if(!temp_vent.welded && temp_vent.network && temp_vent.loc.z in config.station_levels)
			//Stops cortical borers getting stuck in small networks. See: Security, Virology
			if(temp_vent.network.normal_members.len > 50)
				vents += temp_vent

	var/list/candidates = get_alien_candidates()
	while(spawncount > 0 && vents.len && candidates.len)
		var/obj/vent = pick_n_take(vents)
		var/client/C = pick_n_take(candidates)

		var/mob/living/simple_animal/borer/new_borer = new(vent.loc)
		new_borer.key = C.key

		spawncount--
		successSpawn = 1