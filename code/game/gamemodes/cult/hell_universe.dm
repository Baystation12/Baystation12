/*

In short:
 * Random area alarms
 * All areas jammed
 * Random gateways spawning hellmonsters (and turn people into cluwnes if ran into)
 * Broken APCs/Fire Alarms
 * Scary music
 * Random tiles changing to culty tiles.

*/
/datum/universal_state/hell
	name = "Hell Rising"
	desc = "OH FUCK OH FUCK OH FUCK"

/datum/universal_state/hell/OnShuttleCall(var/mob/user)
	return 1
	/*
	if(user)
		to_chat(user, "<span class='sinister'>All you hear on the frequency is static and panicked screaming. There will be no shuttle call today.</span>")
	return 0
	*/


// Apply changes when entering state
/datum/universal_state/hell/OnEnter()
	set background = 1

	//Separated into separate procs for profiling
	MiscSet()
	KillMobs()
	SSskybox.change_skybox("narsie", new_use_stars = FALSE, new_use_overmap_details = FALSE)

/datum/universal_state/hell/proc/MiscSet()
	for(var/turf/simulated/floor/T)
		if(!T.holy && prob(1))
			new /obj/effect/gateway/active/cult(T)

/datum/universal_state/hell/proc/KillMobs()
	for(var/mob/living/simple_animal/M in SSmobs.mob_list)
		if(M && !M.client)
			M.set_stat(DEAD)
