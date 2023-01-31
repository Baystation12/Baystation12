/datum/random_map/noise/tundra
	descriptor = "tundra"
	smoothing_iterations = 1

/datum/random_map/noise/tundra/replace_space
	descriptor = "tundra (replacement)"
	target_turf_type = /turf/space

/datum/random_map/noise/tundra/get_map_char(value)
	var/val = min(9,max(0,round((value/cell_range)*10)))
	if(isnull(val)) val = 0
	switch(val)
		if(0)
			return SPAN_COLOR("#000099", "~")
		if(1)
			return SPAN_COLOR("#0000bb", "~")
		if(2)
			return SPAN_COLOR("#0000dd", "~")
		if(3)
			return SPAN_COLOR("#66aa00", pick(list(".",",")))
		if(4)
			return SPAN_COLOR("#77cc00", pick(list(".",",")))
		if(5)
			return SPAN_COLOR("#88dd00", pick(list(".",",")))
		if(6)
			return SPAN_COLOR("#99ee00", pick(list(".",",")))
		if(7)
			return SPAN_COLOR("#00bb00", pick(list("T","t")))
		if(8)
			return SPAN_COLOR("#00dd00", pick(list("T","t")))
		if(9)
			return SPAN_COLOR("#00ff00", pick(list("T","t")))

/datum/random_map/noise/tundra/get_appropriate_path(value)
	var/val = min(9,max(0,round((value/cell_range)*10)))
	if(isnull(val)) val = 0
	switch(val)
		if(0 to 4)
			return /turf/simulated/floor/beach/water/ocean
		else
			return /turf/simulated/floor/snow

/datum/random_map/noise/tundra/get_additional_spawns(value, turf/T)
	var/val = min(9,max(0,round((value/cell_range)*10)))
	if(isnull(val)) val = 0
	switch(val)
		if(2)
			if(prob(5))
				new /mob/living/simple_animal/passive/crab(T)
		if(6)
			if(prob(60))
				var/grass_path = pick(typesof(/obj/structure/flora/grass)-/obj/structure/flora/grass)
				new grass_path(T)
			if(prob(5))
				var/mob_type = pick(list(/mob/living/simple_animal/passive/lizard, /mob/living/simple_animal/passive/mouse))
				new mob_type(T)
		if(7)
			if(prob(60))
				new /obj/structure/flora/bush(T)
			else if(prob(30))
				new /obj/structure/flora/tree/pine(T)
			else if(prob(20))
				new /obj/structure/flora/tree/dead(T)
		if(8)
			if(prob(70))
				new /obj/structure/flora/tree/pine(T)
			else if(prob(30))
				new /obj/structure/flora/tree/dead(T)
			else
				new /obj/structure/flora/bush(T)
		if(9)
			new /obj/structure/flora/tree/pine(T)
