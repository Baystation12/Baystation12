/proc/gibs(atom/location, var/list/viruses, var/datum/dna/MobDNA, gibber_type = /obj/effect/gibspawner/generic, var/fleshcolor, var/bloodcolor)
	new gibber_type(location,viruses,MobDNA,fleshcolor,bloodcolor)

/obj/effect/gibspawner
	var/sparks = 0 //whether sparks spread on Gib()
	var/virusProb = 20 //the chance for viruses to spread on the gibs
	var/list/gibtypes = list()
	var/list/gibamounts = list()
	var/list/gibdirections = list() //of lists
	var/fleshcolor //Used for gibbed humans.
	var/bloodcolor //Used for gibbed humans.

	New(location, var/list/viruses, var/datum/dna/MobDNA, var/fleshcolor, var/bloodcolor)
		..()

		if(fleshcolor) src.fleshcolor = fleshcolor
		if(bloodcolor) src.bloodcolor = bloodcolor
		Gib(loc,viruses,MobDNA)

	proc/Gib(atom/location, var/list/viruses = list(), var/datum/dna/MobDNA = null)
		if(gibtypes.len != gibamounts.len || gibamounts.len != gibdirections.len)
			world << "\red Gib list length mismatch!"
			return

		var/obj/effect/decal/cleanable/blood/gibs/gib = null
		for(var/datum/disease/D in viruses)
			if(D.spread_type == SPECIAL)
				del(D)

		if(sparks)
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(2, 1, get_turf(location)) // Not sure if it's safe to pass an arbitrary object to set_up, todo
			s.start()

		for(var/i = 1, i<= gibtypes.len, i++)
			if(gibamounts[i])
				for(var/j = 1, j<= gibamounts[i], j++)
					var/gibType = gibtypes[i]
					gib = new gibType(location)

					// Apply human species colouration to masks.
					if(fleshcolor)
						gib.fleshcolor = fleshcolor
					if(bloodcolor)
						gib.basecolor = bloodcolor

					gib.update_icon()

					if(viruses.len > 0)
						for(var/datum/disease/D in viruses)
							if(prob(virusProb))
								var/datum/disease/viruus = D.Copy(1)
								gib.viruses += viruus
								viruus.holder = gib

					gib.blood_DNA = list()
					if(MobDNA)
						gib.blood_DNA[MobDNA.unique_enzymes] = MobDNA.b_type
					else if(istype(src, /obj/effect/gibspawner/human)) // Probably a monkey
						gib.blood_DNA["Non-human DNA"] = "A+"
					if(istype(location,/turf/))
						var/list/directions = gibdirections[i]
						if(directions.len)
							gib.streak(directions)

		del(src)