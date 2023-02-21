SUBSYSTEM_DEF(ambient_lighting) //A simple SS that handles updating ambient lights of away sites and such places
	name = "Ambient Lighting"
	wait = 1
	priority = SS_PRIORITY_LIGHTING
	init_order = SS_INIT_AMBIENT_LIGHT
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/list/queued = list()

/datum/controller/subsystem/ambient_lighting/UpdateStat(time)
	return ..() + " Queue:[length(queued)]"

/datum/controller/subsystem/ambient_lighting/Initialize(start_timeofday)
	fire(FALSE, TRUE)
	return ..()

/datum/controller/subsystem/ambient_lighting/fire(resumed = FALSE, no_mc_tick = FALSE)
	var/list/curr = queued
	var/starlight_enabled = config.starlight

	var/needs_ambience
	while (length(curr))
		var/turf/target = curr[length(curr)]
		LIST_DEC(curr)

		if(target && target.is_outside())
			needs_ambience = TURF_IS_DYNAMICALLY_LIT_UNSAFE(target)
			if (!needs_ambience)
				for (var/turf/T in RANGE_TURFS(target, 1))
					if(TURF_IS_DYNAMICALLY_LIT_UNSAFE(T))
						needs_ambience = TRUE
						break

			if (needs_ambience)
				var/obj/effect/overmap/visitable/sector/exoplanet/E = map_sectors["[target.z]"]
				if (istype(E))
					if (E.sun_brightness_modifier)
						E.update_sun() //Citadel seems to update entire planet ?
				else if (starlight_enabled) //Assume we can light up exterior maybe?
					target.set_ambient_light(SSskybox.background_color, 0.5)
		else if (TURF_IS_AMBIENT_LIT_UNSAFE(target))
			var/obj/effect/overmap/visitable/sector/exoplanet/E = map_sectors["[target.z]"]
			if (istype(E))
				if (E.sun_brightness_modifier && ((E.sun_apparent_color != null) && (E.sun_apparent_brightness != null)))
					target.replace_ambient_light(E.sun_apparent_color, null, E.sun_apparent_brightness, null)
			else if (starlight_enabled)
				target.replace_ambient_light(SSskybox.background_color, null, 0.5, null)

		if (no_mc_tick)
			CHECK_TICK
		else if (MC_TICK_CHECK)
			return
