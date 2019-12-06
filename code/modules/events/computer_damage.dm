/datum/event/computer_damage/start()
	var/number_of_victims = 0
	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			number_of_victims = 4
		if(EVENT_LEVEL_MODERATE)
			number_of_victims = 8
		if(EVENT_LEVEL_MAJOR)
			number_of_victims = 16
	var/list/victims = list()
	for(var/obj/machinery/computer/modular/C in SSmachines.machinery)
		if((C.z in affecting_z) && C.use_power == POWER_USE_ACTIVE && C.get_component_of_type(/obj/item/weapon/stock_parts/computer/hard_drive))
			victims += C
	while(number_of_victims && victims.len)
		number_of_victims--
		var/obj/machinery/computer/modular/victim = pick_n_take(victims)
		if(prob(50))
			victim.visible_message("<span class='warning'>[victim] emits some ominous clicks.</span>")
			var/obj/item/weapon/stock_parts/computer/hard_drive/HDD = victim.get_component_of_type(/obj/item/weapon/stock_parts/computer/hard_drive)
			if(prob(60))
				HDD.take_damage(HDD.damage_failure)
			else
				HDD.take_damage(HDD.damage_malfunction)
