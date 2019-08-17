/datum/fabricator_recipe
	var/name
	var/path
	var/hidden
	var/category = "General"
	var/list/resources
	var/list/fabricator_types = list(FABRICATOR_CLASS_GENERAL)
	var/build_time = 5 SECONDS

/datum/fabricator_recipe/New()
	..()
	if(path)
		if(!name)
			var/obj/O = path
			name = initial(O.name)
		if(!resources)
			var/obj/item/I = new path
			resources = list()
			for(var/material in I.matter)
				resources[material] = I.matter[material] * FABRICATOR_EXTRA_COST_FACTOR
			qdel(I)
