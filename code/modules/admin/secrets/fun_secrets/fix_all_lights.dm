/datum/admin_secret_item/fun_secret/fix_all_lights
	name = "Fix All Lights"

/datum/admin_secret_item/fun_secret/fix_all_lights/execute(mob/user)
	. = ..()
	if (!.)
		return

	var/choice = input("Which lights to fix?") in list("Changed my mind", "My area", "My Z-Level", "Station", "All lights")
	switch (choice)
		if ("My area")
			var/area/usr_area = get_area(user)
			if (!usr_area) return to_chat(user, SPAN_DANGER("Invalid area!"))
			for (var/obj/machinery/light/light in usr_area)
				light.fix()

		if ("My Z-Level")
			var/user_z = get_z(user)
			if (!user_z) return to_chat(user, SPAN_DANGER("Invalid Z-Level!"))
			for (var/obj/machinery/light/light in SSmachines.machinery)
				if (light.z == user_z) light.fix()

		if ("Station")
			for (var/obj/machinery/light/light in SSmachines.machinery)
				if (light.z in GLOB.using_map.station_levels)
					light.fix()

		if ("All lights")
			for (var/obj/machinery/light/light in SSmachines.machinery)
				light.fix()
