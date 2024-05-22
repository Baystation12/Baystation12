/datum/admin_secret_item/fun_secret/break_all_lights/execute(mob/user)

	var/choice = input("Which lights to break?") in list("Changed my mind", "My area", "My Z-Level", "Station", "All lights")
	switch(choice)
		if ("My area")
			var/area/usr_area = get_area(user)
			if (!usr_area) return to_chat(user, SPAN_DANGER("Invalid area!"))
			for (var/obj/machinery/power/apc/apc in usr_area)
				apc.overload_lighting()

		if ("My Z-Level")
			var/user_z = get_z(user)
			if (!user_z) return to_chat(user, SPAN_DANGER("Invalid Z-Level!"))
			for (var/obj/machinery/power/apc/apc as anything in SSmachines.get_machinery_of_type(/obj/machinery/power/apc))
				if (apc.z == user_z) apc.overload_lighting()

		if ("Station")
			for (var/obj/machinery/power/apc/apc as anything in SSmachines.get_machinery_of_type(/obj/machinery/power/apc))
				if (apc.z in GLOB.using_map.station_levels)
					apc.overload_lighting()

		if ("All lights")
			lightsout(0, 0)

/datum/admin_secret_item/fun_secret/fix_all_lights/execute(mob/user)

	var/choice = input("Which lights to fix?") in list("Changed my mind", "My area", "My Z-Level", "Station", "All lights")
	switch(choice)
		if ("My area")
			var/area/usr_area = get_area(user)
			if (!usr_area) return to_chat(user, SPAN_DANGER("Invalid area!"))
			for (var/obj/machinery/light/light in usr_area)
				light.fix()

		if ("My Z-Level")
			var/user_z = get_z(user)
			if (!user_z) return to_chat(user, SPAN_DANGER("Invalid Z-Level!"))
			for (var/obj/machinery/light/light as anything in SSmachines.get_machinery_of_type(/obj/machinery/light))
				if (light.z == user_z) light.fix()

		if ("Station")
			for (var/obj/machinery/light/light as anything in SSmachines.get_machinery_of_type(/obj/machinery/light))
				if (light.z in GLOB.using_map.station_levels)
					light.fix()

		if ("All lights")
			for (var/obj/machinery/light/light as anything in SSmachines.get_machinery_of_type(/obj/machinery/light))
				light.fix()
