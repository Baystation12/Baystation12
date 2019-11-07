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
		/material/waste = TRUE
	)

// Populate name and resources from the product type.
/datum/fabricator_recipe/New()
	..()
	if(!path)
		return
	if(!name)
		var/obj/O = path
		name = initial(O.name)
	if(!resources)
		resources = list()
	var/obj/item/I = new path
	if(length(I.matter))
		for(var/material in I.matter)
			var/material/M = SSmaterials.get_material_by_name(material)
			if(istype(M) && !ignore_materials[M.type])
				resources[M.type] = I.matter[material] * FABRICATOR_EXTRA_COST_FACTOR
	if(I.reagents && length(I.reagents.reagent_list))
		for(var/datum/reagent/R in I.reagents.reagent_list)
			resources[R.type] = R.volume * FABRICATOR_EXTRA_COST_FACTOR
	qdel(I)

