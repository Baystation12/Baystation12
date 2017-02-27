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

	decay_rate = 5 // 5% chance of a turf decaying on lighting update/airflow (there's no actual tick for turfs)

/datum/universal_state/hell/OnShuttleCall(var/mob/user)
	return 1
	/*
	if(user)
		to_chat(user, "<span class='sinister'>All you hear on the frequency is static and panicked screaming. There will be no shuttle call today.</span>")
	return 0
	*/

/datum/universal_state/hell/DecayTurf(var/turf/T)
	if(!T.holy)
		T.cultify()
		for(var/obj/machinery/light/L in T.contents)
			new /obj/structure/cult/pylon(L.loc)
			qdel(L)
	return


/datum/universal_state/hell/OnTurfChange(var/turf/T)
	var/turf/space/S = T
	if(istype(S))
		S.color = "#FF0000"
	else
		S.color = initial(S.color)

// Apply changes when entering state
/datum/universal_state/hell/OnEnter()
	set background = 1
	garbage_collector.garbage_collect = 0

	//Separated into separate procs for profiling
	AreaSet()
	MiscSet()
	APCSet()
	KillMobs()
	OverlayAndAmbientSet()


/datum/universal_state/hell/proc/AreaSet()
	for(var/area/A)
		if(!istype(A,/area) || istype(A, /area/space))
			continue

		A.updateicon()

/datum/universal_state/hell/OverlayAndAmbientSet()
	spawn(0)
		for(var/atom/movable/lighting_overlay/L in world)
			L.update_lumcount(1, 0, 0)

		for(var/turf/space/T in turfs)
			OnTurfChange(T)

/datum/universal_state/hell/proc/MiscSet()
	for(var/turf/simulated/floor/T in turfs)
		if(!T.holy && prob(1))
			new /obj/effect/gateway/active/cult(T)

	for (var/obj/machinery/firealarm/alm in machines)
		if (!(alm.stat & BROKEN))
			alm.ex_act(2)

/datum/universal_state/hell/proc/APCSet()
	for (var/obj/machinery/power/apc/APC in machines)
		if (!(APC.stat & BROKEN) && !APC.is_critical)
			APC.chargemode = 0
			if(APC.cell)
				APC.cell.charge = 0
			APC.emagged = 1
			APC.queue_icon_update()

/datum/universal_state/hell/proc/KillMobs()
	for(var/mob/living/simple_animal/M in mob_list)
		if(M && !M.client)
			M.set_stat(DEAD)
