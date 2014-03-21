var/icon/lighting_dbg = icon('icons/Testing/Zone.dmi', "created")

atom/var/lights_verbose = 0

obj/machinery/light/verb/ShowInfluence()
	set src in world

	lights_verbose = 1
	usr << "<b>[src]</b>"
	if(light)
		usr << "Intensity: [light.intensity]"
		usr << "Radius: [light.radius]"

		for(var/turf/T in light.lit_turfs)
			T.overlays += lighting_dbg
		spawn(50)
			for(var/turf/T in light.lit_turfs)
				T.overlays -= lighting_dbg

turf/verb/ShowData()
	set src in world

	usr << "<b>[src]</b>"
	usr << "[MAX_VALUE(lightSE)][MAX_VALUE(lightSW)][MAX_VALUE(lightNW)][MAX_VALUE(lightNE)]"
	usr << "Lit Value: [lit_value]"
	usr << "Max Brightness: [max_brightness]"

	usr << "Lit By: "
	for(var/light/light in lit_by)
		usr << " - [light.atom] \[[lit_by[light]]\][(lit_by[light] == max_brightness ? "(MAX)" : "")]"
		light.atom.overlays += lighting_dbg
	spawn(50)
		for(var/light/light in lit_by)
			light.atom.overlays -= lighting_dbg