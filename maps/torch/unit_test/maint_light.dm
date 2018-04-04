/datum/unit_test/maint_no_lights
	name = "AREA: There should be no lights in Torch maintenance"

/datum/unit_test/maint_no_lights/start_test()
	var/list/light_types = typesof(/obj/machinery/light)
	var/maint_lights = 0

	for(var/area/maintenance/torch/A)
		if(A.light_exempt) continue
		for(var/obj/machinery/light/L in A.contents)
			if(L.type in light_types)
				log_bad("There is a light in maint area [A] at ([L.x], [L.y], [L.z])")
				maint_lights++

	if(maint_lights)
		fail("Found [maint_lights] maint lights\s.")
	else
		pass("All maint areas are lightless.")

	return 1