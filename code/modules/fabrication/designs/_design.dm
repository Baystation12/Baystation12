/datum/fabricator_recipe
	var/name
	var/path
	var/hidden
	var/category = "General"
	var/list/resources
	var/list/fabricator_types = list(
		FABRICATOR_CLASS_GENERAL
	)
	var/build_time = 5 SECONDS
	var/ignore_materials = list(
		MATERIAL_WASTE = TRUE
	)

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
				var/material/M = SSmaterials.get_material_by_name(material)
				if(istype(M) && !ignore_materials[M.name])
					resources[material] = I.matter[material] * FABRICATOR_EXTRA_COST_FACTOR
			qdel(I)
