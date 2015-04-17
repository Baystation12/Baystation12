
/datum/universal_state/supermatter_cascade
 	name = "Supermatter Cascade"
 	desc = "Unknown harmonance affecting universal substructure, converting nearby matter to supermatter."

 	decay_rate = 5 // 5% chance of a turf decaying on lighting update/airflow (there's no actual tick for turfs)

/datum/universal_state/supermatter_cascade/OnShuttleCall(var/mob/user)
	if(user)
		user << "<span class='sinister'>All you hear on the frequency is static and panicked screaming. There will be no shuttle call today.</span>"
	return 0

/datum/universal_state/supermatter_cascade/OnTurfChange(var/turf/T)
	var/turf/space/spess = T
	if(istype(spess))
		spess.overlays += "end01"

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
	world << "<span class='sinister' style='font-size:22pt'>You are blinded by a brilliant flash of energy.</span>"

	world << sound('sound/effects/cascade.ogg')

	for(var/mob/M in player_list)
		flick("e_flash", M.flash)

	if(emergency_shuttle.can_recall())
		priority_announcement.Announce("The emergency shuttle has returned due to bluespace distortion.")
		emergency_shuttle.recall()

	AreaSet()
	OverlaySet()
	MiscSet()
	APCSet()
	AmbientSet()

	// Disable Nar-Sie.
	cult.allow_narsie = 0
	PlayerSet()

	new /obj/singularity/narsie/large/exit(pick(endgame_exits))
	spawn(rand(30,60) SECONDS)
		var/txt = {"
There's been a galaxy-wide electromagnetic pulse.  All of our systems are heavily damaged and many personnel are dead or dying. We are seeing increasing indications of the universe itself beginning to unravel.

[station_name()], you are the only facility nearby a bluespace rift, which is near your research outpost. You are hereby directed to enter the rift using all means necessary, quite possibly as the last of your species alive.

You have five minutes before the universe collapses. Good l\[\[###!!!-

AUTOMATED ALERT: Link to [command_name()] lost."}
		priority_announcement.Announce(txt,"SUPERMATTER CASCADE DETECTED")
		sleep(5 MINUTES)
		ticker.declare_completion()
		ticker.station_explosion_cinematic(0,null) // TODO: Custom cinematic

		world << "<B>Resetting in 30 seconds!</B>"

		feedback_set_details("end_error","Universe ended")

		if(blackbox)
			blackbox.save_all_data_to_sql()

		sleep(300)
		log_game("Rebooting due to universal collapse")
		world.Reboot()
		return

/datum/universal_state/supermatter_cascade/proc/AreaSet()
	for(var/area/ca in world)
		var/area/A=ca.master
		if(A.z in config.admin_levels)
			continue
		if(!istype(A,/area) || istype(A,/area/space))
			continue

		// Reset all alarms.
		A.fire     = null
		A.atmos    = 1
		A.atmosalm = 0
		A.poweralm = 1

		// Slap on random alerts
		if(prob(25))
			switch(rand(1,4))
				if(1)
					A.fire=1
				if(2)
					A.atmosalm=1

		A.updateicon()

/datum/universal_state/supermatter_cascade/proc/OverlaySet()
	for(var/turf/space/spess in world)
		spess.overlays += "end01"

/datum/universal_state/supermatter_cascade/proc/AmbientSet()
	for(var/turf/T in world)
		if(istype(T, /turf/space))	continue
		if(!(T.z in config.admin_levels))
			T.update_lumcount(1, 160, 255, 0, 0)

/datum/universal_state/supermatter_cascade/proc/MiscSet()
	for (var/obj/machinery/firealarm/alm in world)
		if (!(alm.stat & BROKEN))
			alm.ex_act(2)

/datum/universal_state/supermatter_cascade/proc/APCSet()
	for (var/obj/machinery/power/apc/APC in world)
		if (!(APC.stat & BROKEN))
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
			flick("e_flash", M.current.flash)

		clear_antag_roles(M)
