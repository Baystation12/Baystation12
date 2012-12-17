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


//Cleaned up my footsteps code to no longer contain references to butts and the like -Nernums
/turf/simulated/Entered(atom/A, atom/OL)
	var/footstepsound
	if (istype(A,/mob/living/carbon))
		var/mob/living/carbon/M = A
		if(M.lying)
			return
		if(istype(M, /mob/living/carbon/human))			// Split this into two seperate if checks, when non-humans were being checked it would throw a null error -- TLE
			//clown shoes
			if(istype(M:shoes, /obj/item/clothing/shoes/clown_shoes))
				if(M.m_intent == "run")
					if(M.footstep >= 2)
						M.footstep = 0
					else
						M.footstep++
					if(M.footstep == 0)
						playsound(src, "clownstep", 30, 1) // this will get annoying very fast.
				else
					playsound(src, "clownstep", 10, 1)


			//shoes
			if(istype(src, /turf/space))
				footstepsound = "silent"
			/*else if(istype(src, /turf/simulated/floor/spacedome/grass))
				footstepsound = "grassfootsteps"
			else if(istype(src, /turf/simulated/floor/spacedome/sand))
				footstepsound = "sandfootsteps"
			else if(istype(src, /turf/simulated/floor/spacedome/water))
				footstepsound = "waterfootsteps"
			else if(istype(src, /turf/simulated/floor/spacedome/concrete))
				footstepsound = "concretefootsteps"
			else
				if(icon == "natureicons.dmi")
					footstepsound = "concretefootsteps"
				else
					footstepsound = "erikafootsteps"*/
			else
				footstepsound = "erikafootsteps"

			if(istype(M:shoes, /obj/item/clothing/shoes))
				if(M.m_intent == "run")
					if(M.footstep >= 2)
						M.footstep = 0
					else
						M.footstep++
					if(M.footstep == 0)
						playsound(src, footstepsound, 30, 1) // this will get annoying very fast.
				else
					playsound(src, footstepsound, 10, 1)



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
				else if(!istype(M, /mob/living/carbon/metroid))
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

			if(2) //lube
				if(!istype(M, /mob/living/carbon/metroid))
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
