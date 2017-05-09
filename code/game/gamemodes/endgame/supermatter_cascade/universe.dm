var/global/universe_has_ended = 0


/datum/universal_state/supermatter_cascade
 	name = "Supermatter Cascade"
 	desc = "Unknown harmonance affecting universal substructure, converting nearby matter to supermatter."

 	decay_rate = 5 // 5% chance of a turf decaying on lighting update/airflow (there's no actual tick for turfs)

/datum/universal_state/supermatter_cascade/OnShuttleCall(var/mob/user)
	if(user)
		to_chat(user, "<span class='sinister'>All you hear on the frequency is static and panicked screaming. There will be no shuttle call today.</span>")
	return 0

/datum/universal_state/supermatter_cascade/OnTurfChange(var/turf/T)
	var/turf/space/S = T
	if(istype(S))
		S.color = "#0066FF"
	else
		S.color = initial(S.color)

/datum/universal_state/supermatter_cascade/DecayTurf(var/turf/T)
	if(istype(T,/turf/simulated/wall))
		var/turf/simulated/wall/W=T
		W.melt()
		return
	if(istype(T,/turf/simulated/floor))
		var/turf/simulated/floor/F=T
		// Burnt?
		if(!F.burnt)
			F.burn_tile()
		else
			if(!istype(F,/turf/simulated/floor/plating))
				F.break_tile_to_plating()
		return

// Apply changes when entering state
/datum/universal_state/supermatter_cascade/OnEnter()
	set background = 1
	garbage_collector.garbage_collect = 0
	to_world("<span class='sinister' style='font-size:22pt'>You are blinded by a brilliant flash of energy.</span>")
	sound_to(world, sound('sound/effects/cascade.ogg'))

	for(var/mob/M in player_list)
		M.flash_eyes()

	if(evacuation_controller.cancel_evacuation())
		priority_announcement.Announce("The evacuation has been aborted due to bluespace distortion.")

	AreaSet()
	MiscSet()
	APCSet()
	OverlayAndAmbientSet()

	// Disable Nar-Sie.
	cult.allow_narsie = 0

	PlayerSet()

	new /obj/singularity/narsie/large/exit(pick(endgame_exits))
	spawn(rand(30,60) SECONDS)
		var/txt = {"
There's been a galaxy-wide electromagnetic pulse.  All of our systems are heavily damaged and many personnel are dead or dying. We are seeing increasing indications of the universe itself beginning to unravel.

[station_name()], you are the only facility nearby a bluespace rift, which is near your research outpost. You are hereby directed to enter the rift using all means necessary, quite possibly as the last of your species alive.

You have five minutes before the universe collapses. Good l\[\[###!!!-

AUTOMATED ALERT: Link to [command_name()] lost.

The access requirements on the Asteroid Shuttles' consoles have now been revoked.
"}
		priority_announcement.Announce(txt,"SUPERMATTER CASCADE DETECTED")

		for(var/obj/machinery/computer/shuttle_control/C in machines)
			if(istype(C, /obj/machinery/computer/shuttle_control/research) || istype(C, /obj/machinery/computer/shuttle_control/mining))
				C.req_access = list()
				C.req_one_access = list()

		spawn(5 MINUTES)
			ticker.station_explosion_cinematic(0,null) // TODO: Custom cinematic
			universe_has_ended = 1
		return

/datum/universal_state/supermatter_cascade/proc/AreaSet()
	for(var/area/A)
		if(!istype(A,/area) || istype(A, /area/space) || istype(A,/area/beach))
			continue

		A.updateicon()

/datum/universal_state/supermatter_cascade/OverlayAndAmbientSet()
	spawn(0)
		for(var/atom/movable/lighting_overlay/L in world)
			if(L.z in using_map.admin_levels)
				L.update_lumcount(1,1,1)
			else
				L.update_lumcount(0.0, 0.4, 1)

		for(var/turf/space/T in turfs)
			OnTurfChange(T)

/datum/universal_state/supermatter_cascade/proc/MiscSet()
	for (var/obj/machinery/firealarm/alm in machines)
		if (!(alm.stat & BROKEN))
			alm.ex_act(2)

/datum/universal_state/supermatter_cascade/proc/APCSet()
	for (var/obj/machinery/power/apc/APC in machines)
		if (!(APC.stat & BROKEN) && !APC.is_critical)
			APC.chargemode = 0
			if(APC.cell)
				APC.cell.charge = 0
			APC.emagged = 1
			APC.queue_icon_update()

/datum/universal_state/supermatter_cascade/proc/PlayerSet()
	for(var/datum/mind/M in player_list)
		if(!istype(M.current,/mob/living))
			continue
		if(M.current.stat!=2)
			M.current.Weaken(10)
			M.current.flash_eyes()

		clear_antag_roles(M)
