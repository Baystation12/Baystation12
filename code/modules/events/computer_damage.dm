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
	for(var/obj/machinery/computer/modular/C as anything in SSmachines.get_machinery_of_type(/obj/machinery/computer/modular))
		if((C.z in affecting_z) && C.use_power == POWER_USE_ACTIVE && C.get_component_of_type(/obj/item/stock_parts/computer/hard_drive))
			victims += C
	while(number_of_victims && length(victims))
		number_of_victims--
		var/obj/machinery/computer/modular/victim = pick_n_take(victims)
		if(prob(50))
			victim.visible_message(SPAN_WARNING("[victim] emits some ominous clicks."))
			var/obj/item/stock_parts/computer/hard_drive/HDD = victim.get_component_of_type(/obj/item/stock_parts/computer/hard_drive)
			if(prob(60))
				HDD.set_damage_failure()
			else
				HDD.set_damage_malfunction()
