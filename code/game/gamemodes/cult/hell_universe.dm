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

	convert_all_parallax()
	//Separated into separate procs for profiling
	MiscSet()
	KillMobs()

/datum/universal_state/hell/proc/MiscSet()
	for(var/turf/simulated/floor/T in turfs)
		if(!T.holy && prob(1))
			new /obj/effect/gateway/active/cult(T)

/datum/universal_state/hell/proc/KillMobs()
	for(var/mob/living/simple_animal/M in mob_list)
		if(M && !M.client)
			M.set_stat(DEAD)

// Parallax.

/datum/universal_state/hell/convert_parallax(obj/screen/plane_master/parallax_spacemaster/PS)
	PS.color = list(
	0,0,0,0,
	0,0,0,0,
	0,0,0,0,
	1,0,0,1)

/datum/universal_state/hell/proc/convert_all_parallax()
	for(var/client/C in clients)
		var/obj/screen/plane_master/parallax_spacemaster/PS = locate() in C.screen
		if(PS)
			convert_parallax(PS)
	CHECK_TICK