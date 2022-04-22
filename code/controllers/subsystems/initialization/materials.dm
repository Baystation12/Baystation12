SUBSYSTEM_DEF(materials)
	name = "Materials"
	init_order = SS_INIT_MATERIALS
	flags = SS_NO_FIRE

	var/list/materials
	var/list/materials_by_name
	var/list/alloy_components
	var/list/alloy_products
	var/list/processable_ores


/datum/controller/subsystem/materials/UpdateStat(time)
	return


/datum/controller/subsystem/materials/Initialize(start_uptime)
	build_material_lists()


/datum/controller/subsystem/materials/proc/build_material_lists()

	if(LAZYLEN(materials))
		return

	materials =         list()
	materials_by_name = list()
	alloy_components =  list()
	alloy_products =    list()
	processable_ores =  list()

	for(var/type in subtypesof(/material))
		var/material/new_mineral = new type
		if(new_mineral.name)
			materials += new_mineral
			materials_by_name[lowertext(new_mineral.name)] = new_mineral
			if(new_mineral.ore_smelts_to || new_mineral.ore_compresses_to)
				processable_ores[new_mineral.name] = TRUE
			if(new_mineral.alloy_product && LAZYLEN(new_mineral.alloy_materials))
				alloy_products[new_mineral] = TRUE
				for(var/component in new_mineral.alloy_materials)
					processable_ores[component] = TRUE
					alloy_components[component] = TRUE


/datum/controller/subsystem/materials/proc/get_material_by_name(name)
	if(!materials_by_name)
		build_material_lists()
	. = materials_by_name[name]
	if(!.)
		log_error("Unable to acquire material by name '[name]'")

/proc/material_display_name(name)
	var/material/material = SSmaterials.get_material_by_name(name)
	if(material)
		return material.display_name
	return null
