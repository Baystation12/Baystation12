
datum/game_mode/nations
	name = "nations"
	config_tag = "nations"
	required_players_secret = 25
	var/const/waittime_l = 3000 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 6000 //upper bound on time before intercept arrives (in tenths of seconds)




/datum/game_mode/nations/post_setup()
	spawn (rand(waittime_l, waittime_h))
		remove_flags()
		spawn(50)
			spawn_flags()
			send_intercept()

/datum/game_mode/nations/send_intercept()
	command_alert("Due to recent and COMPLETELY UNFOUNDED allegations of massive fraud and insider trading \
					affecting trillions of investors, the Nanotrasen Corporation has decided to liquidate all \
					assets of the Centcom Division in order to pay the massive legal fees that will be incurred \
					during the following centuries long court process. Therefore, all current employment contracts \
					are IMMEDIATELY TERMINATED. Nanotrasen will be unable to send a rescue shuttle to carry you home,\
					however they remain willing for the time being to continue trading cargo. Have a pleasant \
					day.", "FINAL TRANSMISSION, CENTCOM COMMAND.")


/datum/game_mode/nations/proc/remove_flags()
	for(var/obj/item/flag/F in world)
		del(F)

/datum/game_mode/nations/proc/spawn_flags()

	for(var/obj/effect/landmark/nations/N in landmarks_list)
		switch(N.name)
			if("Atmosia")
				new /obj/item/flag/nation/atmos(get_turf(N))
			if("Brigston")
				new /obj/item/flag/nation/sec(get_turf(N))
			if("Cargonia")
				new /obj/item/flag/nation/cargo(get_turf(N))
			if("Command")
				new /obj/item/flag/nation/command(get_turf(N))
			if("Medistan")
				new /obj/item/flag/nation/med(get_turf(N))
			if("Scientopia")
				new /obj/item/flag/nation/rnd(get_turf(N))

