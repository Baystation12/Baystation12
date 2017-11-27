// -- Spark Datum --
/datum/effect_system/sparks
	var/amount = 1 				// How many sparks should we make
	var/list/spread = list()	// Which directions we should create sparks.

// Using the spark procs is preferred to directly instancing this.
/datum/effect_system/sparks/New(var/atom/movable/loc, var/start_immediately = TRUE, var/amt = 1, var/list/spread_dirs = list())
	if(QDELETED(loc))
		return

	set_loc(loc)

	if (amt)
		amount = amt

	if (spread_dirs)
		spread = spread_dirs
	else
		spread = list()
		
	..(start_immediately)

/datum/effect_system/sparks/process()
	. = ..()

	var/total_sparks = 1
	if (location)
		var/obj/visual_effect/sparks/S = new(location, src, 0) //Trigger one on the tile it's on
		S.start()
		playsound(location, "sparks", 100, 1)
		QUEUE_VISUAL(S)	// Queue it.

		while (total_sparks <= src.amount)
			playsound(location, "sparks", 100, 1)
			var/direction = 0

			if (LAZYLEN(src.spread))
				direction = pick(src.spread)
			else
				direction = 0

			S = new /obj/visual_effect/sparks(location, src)
			S.start(direction)	
			QUEUE_VISUAL(S)
			total_sparks++
