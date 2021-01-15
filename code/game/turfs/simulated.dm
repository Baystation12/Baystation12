/turf/simulated
	name = "station"
	var/wet = 0
	var/image/wet_overlay = null

	//Mining resources (for the large drills).
	var/has_resources
	var/list/resources

	var/thermite = 0
	initial_gas = list(GAS_OXYGEN = MOLES_O2STANDARD, GAS_NITROGEN = MOLES_N2STANDARD)
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to
	var/dirt = 0

	var/timer_id

// This is not great.
/turf/simulated/proc/wet_floor(var/wet_val = 1, var/overwrite = FALSE)
	if(wet_val < wet && !overwrite)
		return

	if(!wet)
		wet = wet_val
		wet_overlay = image('icons/effects/water.dmi',src,"wet_floor")
		overlays += wet_overlay

	timer_id = addtimer(CALLBACK(src,/turf/simulated/proc/unwet_floor),8 SECONDS, TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT|TIMER_OVERRIDE)

/turf/simulated/proc/unwet_floor(var/check_very_wet = TRUE)
	if(check_very_wet && wet >= 2)
		wet--
		timer_id = addtimer(CALLBACK(src,/turf/simulated/proc/unwet_floor), 8 SECONDS, TIMER_STOPPABLE|TIMER_UNIQUE|TIMER_NO_HASH_WAIT|TIMER_OVERRIDE)
		return

	wet = 0
	if(wet_overlay)
		overlays -= wet_overlay
		wet_overlay = null

/turf/simulated/clean_blood()
	for(var/obj/effect/decal/cleanable/blood/B in contents)
		B.clean_blood()
	..()

/turf/simulated/New()
	..()
	if(istype(loc, /area/chapel))
		holy = 1
	levelupdate()

/turf/simulated/proc/AddTracks(var/typepath,var/bloodDNA,var/comingdir,var/goingdir,var/bloodcolor=COLOR_BLOOD_HUMAN)
	var/obj/effect/decal/cleanable/blood/tracks/tracks = locate(typepath) in src
	if(!tracks)
		tracks = new typepath(src)
	tracks.AddTracks(bloodDNA,comingdir,goingdir,bloodcolor)

/turf/simulated/proc/update_dirt()
	dirt = min(dirt+0.5, 101)
	var/obj/effect/decal/cleanable/dirt/dirtoverlay = locate(/obj/effect/decal/cleanable/dirt, src)
	if (dirt > 50)
		if (!dirtoverlay)
			dirtoverlay = new/obj/effect/decal/cleanable/dirt(src)
		dirtoverlay.alpha = min((dirt - 50) * 5, 255)

/turf/simulated/remove_cleanables()
	dirt = 0
	. = ..()

/turf/simulated/Entered(atom/A, atom/OL)
	. = ..()
	if (istype(A))
		A.OnSimulatedTurfEntered(src)

/atom/proc/OnSimulatedTurfEntered(turf/simulated/T)
	set waitfor = FALSE
	return

/mob/living/OnSimulatedTurfEntered(turf/simulated/T)
	// Dirt overlays.
	T.update_dirt()
	
	if(lying)
		return

	if(T.wet)
		if(buckled || (MOVING_DELIBERATELY(src) && prob(min(100, 100/(T.wet/10))) ) )
			return

		// skillcheck for slipping
		if(!prob(min(100, skill_fail_chance(SKILL_HAULING, 100, SKILL_MAX+1)/(3/T.wet))))
			return

		var/slip_dist = 1
		var/slip_stun = 6
		var/floor_type = "wet"

		if(2 <= T.wet) // Lube
			floor_type = "slippery"
			slip_dist = 4
			slip_stun = 10

		if(slip("the [floor_type] floor", slip_stun))
			for(var/i = 1 to slip_dist)
				step(src, dir)
				sleep(1)
		else
			inertia_dir = 0
	else
		inertia_dir = 0


/mob/living/carbon/human/OnSimulatedTurfEntered(turf/simulated/T)
	var/list/bloodDNA = null
	var/bloodcolor=""
	var/obj/item/clothing/shoes/S = get_equipped_item(slot_shoes)
	if(istype(S))
		S.handle_movement(src, MOVING_QUICKLY(src))
		if(S.track_blood && S.blood_DNA)
			bloodDNA = S.blood_DNA
			bloodcolor = S.blood_color
			S.track_blood--
	else
		if(track_blood && feet_blood_DNA)
			bloodDNA = feet_blood_DNA
			bloodcolor = feet_blood_color
			track_blood--

	var/move_trail = species.get_move_trail(src)
	if (bloodDNA && move_trail)
		T.AddTracks(move_trail, bloodDNA, dir, 0, bloodcolor) // Coming
		var/turf/simulated/from = get_step(src, reverse_direction(dir))
		if(istype(from) && from)
			from.AddTracks(move_trail, bloodDNA, 0, dir, bloodcolor) // Going
		bloodDNA = null

	..()

//returns 1 if made bloody, returns 0 otherwise
/turf/simulated/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0

	if(istype(M))
		for(var/obj/effect/decal/cleanable/blood/B in contents)
			if(!B.blood_DNA)
				B.blood_DNA = list()
			if(!B.blood_DNA[M.dna.unique_enzymes])
				B.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
			return 1 //we bloodied the floor
		blood_splatter(src,M.get_blood(M.vessel),1)
		return 1 //we bloodied the floor
	return 0

// Only adds blood on the floor -- Skie
/turf/simulated/proc/add_blood_floor(mob/living/carbon/M as mob)
	if( istype(M, /mob/living/carbon/alien ))
		var/obj/effect/decal/cleanable/blood/xeno/this = new /obj/effect/decal/cleanable/blood/xeno(src)
		this.blood_DNA["UNKNOWN BLOOD"] = "X*"
	else if( istype(M, /mob/living/silicon/robot ))
		new /obj/effect/decal/cleanable/blood/oil(src)

/turf/simulated/proc/can_build_cable(var/mob/user)
	return 0

/turf/simulated/attackby(var/obj/item/thing, var/mob/user)
	if(isCoil(thing) && can_build_cable(user))
		var/obj/item/stack/cable_coil/coil = thing
		coil.turf_place(src, user)
		return
	return ..()

/turf/simulated/Initialize()
	if(GAME_STATE >= RUNLEVEL_GAME)
		fluid_update()
	. = ..()
