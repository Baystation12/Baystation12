/datum/event/computer_damage/start()
	computer_damage_event(severity)

/proc/computer_damage_event(var/severity)
	var/number_of_victims = 0
	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			number_of_victims = 4
		if(EVENT_LEVEL_MODERATE)
			number_of_victims = 8
		if(EVENT_LEVEL_MAJOR)
			number_of_victims = 16
	var/list/victims = list()
	for(var/obj/item/modular_computer/console/C in SSobj.processing) //yep they're in obj, yep gross
		if((C.z in GLOB.using_map.station_levels) && C.enabled && C.hard_drive)
			victims += C
	while(number_of_victims && victims.len)
		number_of_victims--
		var/obj/item/modular_computer/console/victim = pick_n_take(victims)
		if(prob(50))
			victim.bsod = 1
			victim.update_icon()
		else
			victim.visible_message("<span class='warning'>[victim] emits some ominous clicks.</span>")
			if(prob(60))
				victim.hard_drive.take_damage(victim.hard_drive.damage_failure)
			else
				victim.hard_drive.take_damage(victim.hard_drive.damage_malfunction)
