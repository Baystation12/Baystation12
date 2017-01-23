/mob/living/carbon/proc/handle_viruses()

	if(status_flags & GODMODE)	return 0	//godmode

	if(bodytemperature > 406)
		for (var/ID in virus2)
			var/datum/disease2/disease/V = virus2[ID]
			V.cure(src)

	if(life_tick % 3) //don't spam checks over all objects in view every tick.
		for(var/obj/effect/decal/cleanable/O in view(1,src))
			if(istype(O,/obj/effect/decal/cleanable/blood))
				var/obj/effect/decal/cleanable/blood/B = O
				if(isnull(B.virus2))
					B.virus2 = list()
				if(B.virus2.len)
					for (var/ID in B.virus2)
						var/datum/disease2/disease/V = B.virus2[ID]
						infect_virus2(src,V)

			else if(istype(O,/obj/effect/decal/cleanable/mucus))
				var/obj/effect/decal/cleanable/mucus/M = O
				if(isnull(M.virus2))
					M.virus2 = list()
				if(M.virus2.len)
					for (var/ID in M.virus2)
						var/datum/disease2/disease/V = M.virus2[ID]
						infect_virus2(src,V)

	if(virus2.len)
		for (var/ID in virus2)
			var/datum/disease2/disease/V = virus2[ID]
			if(isnull(V)) // Trying to figure out a runtime error that keeps repeating
				CRASH("virus2 nulled before calling activate()")
			else
				V.activate(src)
			// activate may have deleted the virus
			if(!V) continue

			// check if we're immune
			var/list/common_antibodies = V.antigen & src.antibodies
			if(common_antibodies.len)
				V.dead = 1

	return