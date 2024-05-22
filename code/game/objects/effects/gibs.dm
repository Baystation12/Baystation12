/proc/gibs(atom/location, datum/dna/MobDNA, gibber_type = /obj/gibspawner/generic, fleshcolor, bloodcolor)
	new gibber_type(location,MobDNA,fleshcolor,bloodcolor)

/obj/gibspawner
	var/sparks = 0 //whether sparks spread on Gib()
	var/list/gibtypes = list()
	var/list/gibamounts = list()
	var/list/gibdirections = list() //of lists
	var/fleshcolor //Used for gibbed humans.
	var/bloodcolor //Used for gibbed humans.
	var/datum/dna/MobDNA


/obj/gibspawner/New(location, datum/dna/_MobDNA, _fleshcolor, _bloodcolor)
	..()
	if (_fleshcolor)
		fleshcolor = _fleshcolor
	if (_bloodcolor)
		bloodcolor = _bloodcolor
	if (_MobDNA)
		MobDNA = _MobDNA


/obj/gibspawner/Initialize()
	..()
	Gib(loc)
	return INITIALIZE_HINT_QDEL


/obj/gibspawner/proc/Gib(atom/location)
	if (length(gibtypes) != length(gibamounts) || length(gibamounts) != length(gibdirections))
		log_error("Gib list length mismatch!")
		return
	if (sparks)
		var/datum/effect/spark_spread/s = new
		s.set_up(2, 1, get_turf(location))
		s.start()
	var/spread = isturf(location)
	var/humanGibs = istype(src, /obj/gibspawner/human)
	var/obj/decal/cleanable/blood/gibs/gib
	for (var/i = length(gibtypes) to 1 step -1)
		if (!gibamounts[i])
			continue
		for (var/j = gibamounts[i] to 1 step -1)
			var/gibType = gibtypes[i]
			gib = new gibType(location)
			if (fleshcolor)
				gib.fleshcolor = fleshcolor
			if (bloodcolor)
				gib.basecolor = bloodcolor
			gib.update_icon()
			gib.blood_DNA = list()
			if (humanGibs)
				gib.blood_DNA["Non-human DNA"] = "A+"
			else if (MobDNA)
				gib.blood_DNA[MobDNA.unique_enzymes] = MobDNA.b_type
			if (!spread)
				continue
			var/list/directions = gibdirections[i]
			if (length(directions))
				addtimer(new Callback(gib, TYPE_PROC_REF(/obj/decal/cleanable/blood/gibs, streak), directions), 0)
	qdel(src)
