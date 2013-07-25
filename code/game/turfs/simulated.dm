/turf/simulated
	name = "station"
	var/wet = 0
	var/image/wet_overlay = null

	var/thermite = 0
	oxygen = MOLES_O2STANDARD
	nitrogen = MOLES_N2STANDARD
	var/to_be_destroyed = 0 //Used for fire, if a melting temperature was reached, it will be destroyed
	var/max_fire_temperature_sustained = 0 //The max temperature of the fire which it was subjected to

/turf/simulated/New()
	..()
	levelupdate()

/turf/simulated/Entered(atom/A, atom/OL)
	if(movement_disabled && usr.ckey != movement_disabled_exception)
		usr << "\red Movement is admin-disabled." //This is to identify lag problems
		return

	if (istype(A,/mob/living/carbon))
		var/mob/living/carbon/M = A
		if(M.lying)	return
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = M
			if(istype(H.shoes, /obj/item/clothing/shoes/clown_shoes))
				var/obj/item/clothing/shoes/clown_shoes/O = H.shoes
				if(H.m_intent == "run")
					if(O.footstep >= 2)
						O.footstep = 0
						playsound(src, "clownstep", 50, 1) // this will get annoying very fast.
					else
						O.footstep++
				else
					playsound(src, "clownstep", 20, 1)

			var/list/bloodDNA = null
			if(H.shoes)
				var/obj/item/clothing/shoes/S = H.shoes
				if(S.track_blood && S.blood_DNA)
					bloodDNA = S.blood_DNA
					S.track_blood--
			else
				if(H.track_blood && H.feet_blood_DNA)
					bloodDNA = H.feet_blood_DNA
					H.track_blood--

			if (bloodDNA)
				var/obj/effect/decal/cleanable/blood/footprints/here = new(src)
				here.icon_state = "blood1"
				here.dir = H.dir
				here.blood_DNA |= bloodDNA.Copy()
				var/turf/simulated/from = get_step(H,reverse_direction(H.dir))
				if(from)
					var/obj/effect/decal/cleanable/blood/footprints/there = new(from)
					there.icon_state = "blood2"
					there.dir = H.dir
					there.blood_DNA |= bloodDNA.Copy()

			bloodDNA = null

		switch (src.wet)
			if(1)
				if(istype(M, /mob/living/carbon/human)) // Added check since monkeys don't have shoes
					if ((M.m_intent == "run") && !(istype(M:shoes, /obj/item/clothing/shoes) && M:shoes.flags&NOSLIP))
						M.stop_pulling()
						step(M, M.dir)
						M << "\blue You slipped on the wet floor!"
						playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
						M.Stun(8)
						M.Weaken(5)
					else
						M.inertia_dir = 0
						return
				else if(!istype(M, /mob/living/carbon/slime))
					if (M.m_intent == "run")
						M.stop_pulling()
						step(M, M.dir)
						M << "\blue You slipped on the wet floor!"
						playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
						M.Stun(8)
						M.Weaken(5)
					else
						M.inertia_dir = 0
						return

			if(2) //lube		//can cause infinite loops - needs work
				if(!istype(M, /mob/living/carbon/slime))
					M.stop_pulling()
					step(M, M.dir)
					spawn(1) step(M, M.dir)
					spawn(2) step(M, M.dir)
					spawn(3) step(M, M.dir)
					spawn(4) step(M, M.dir)
					M.take_organ_damage(2) // Was 5 -- TLE
					M << "\blue You slipped on the floor!"
					playsound(src.loc, 'sound/misc/slip.ogg', 50, 1, -3)
					M.Weaken(10)

	..()

//returns 1 if made bloody, returns 0 otherwise
/turf/simulated/add_blood(mob/living/carbon/human/M as mob)
	if (!..())
		return 0

	for(var/obj/effect/decal/cleanable/blood/B in contents)
		if(!B.blood_DNA[M.dna.unique_enzymes])
			B.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
		if (M.virus2.len)
			B.virus2 |= virus_copylist(M.virus2)
		return 1 //we bloodied the floor

	//if there isn't a blood decal already, make one.
	var/obj/effect/decal/cleanable/blood/newblood = new /obj/effect/decal/cleanable/blood(src)
	newblood.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
	if (M.virus2.len)
		newblood.virus2 |= virus_copylist(M.virus2)
	return 1 //we bloodied the floor


// Only adds blood on the floor -- Skie
/turf/simulated/proc/add_blood_floor(mob/living/carbon/M as mob)
	if( istype(M, /mob/living/carbon/monkey) || istype(M, /mob/living/carbon/human))
		var/obj/effect/decal/cleanable/blood/this = new /obj/effect/decal/cleanable/blood(src)
		this.blood_DNA[M.dna.unique_enzymes] = M.dna.b_type
		if (M.virus2.len)
			this.virus2 = virus_copylist(M.virus2)

	else if( istype(M, /mob/living/carbon/alien ))
		var/obj/effect/decal/cleanable/xenoblood/this = new /obj/effect/decal/cleanable/xenoblood(src)
		this.blood_DNA["UNKNOWN BLOOD"] = "X*"

	else if( istype(M, /mob/living/silicon/robot ))
		new /obj/effect/decal/cleanable/oil(src)