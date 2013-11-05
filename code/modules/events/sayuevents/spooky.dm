/datum/event/ghosts
	announceWhen	= 70
	oneShot			= 1

/datum/event/ghosts/setup()
	announceWhen = rand(60, 180)

/datum/event/ghosts/announce()
	command_alert("Unknown quasi-aetheric entities have been detected near [station_name()], please stand-by.", "Lifesign Alert?")


/datum/event/ghosts/start()
	var/p = 100
	if(player_list.len <= 3)
		p = 25
	else if(player_list.len <= 6)
		p = 50
	for(var/obj/effect/landmark/C in landmarks_list)
		if(C.name == "carpspawn" && prob(p))
			new /mob/living/simple_animal/hostile/retaliate/ghost(C.loc)