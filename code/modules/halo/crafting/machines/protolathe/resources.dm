
/obj/machinery/research/protolathe/proc/get_free_storage()
	return max_storage - components_storage_used - material_storage_used

/obj/machinery/research/protolathe/proc/check_resources(var/datum/research_design/D)
	. = TRUE

	//check materials
	for(var/check_name in D.required_materials)
		var/amount = stored_materials[check_name]
		if(!amount || amount < D.required_materials[check_name])
			return FALSE

	//check reagents
	for(var/reagent_type in D.required_reagents)
		if(!reagents.has_reagent(reagent_type, D.required_reagents[reagent_type]))
			return FALSE

	//check components
	for(var/check_type in D.required_objs)
		var/amount = stored_components[check_type]
		if(!amount)
			return FALSE

/obj/machinery/research/protolathe/proc/use_resources(var/datum/research_design/D)
	//to_debug_listeners("/obj/machinery/research/protolathe/proc/use_resources([D.type])")

	//check materials
	for(var/check_name in D.required_materials)
		//reduce the stored amount
		consume_material(check_name, D.required_materials[check_name])

	//check reagents
	for(var/reagent_type in D.required_reagents)
		//reagents have their own handling
		reagents.remove_reagent(reagent_type, D.required_reagents[reagent_type])

	//check components
	for(var/check_type in D.required_objs)
		//special handling
		consume_obj(check_type, D.required_objs[check_type])

	//only update the ui if we have to
	if(D.required_materials)
		UpdateMaterialsString()
	if(D.required_reagents)
		UpdateReagentsString()
	if(D.required_objs)
		UpdateComponentsString()

/obj/machinery/research/protolathe/proc/free_resources(var/datum/research_design/D, var/proportion = 1)

	//check materials
	for(var/check_name in D.required_materials)
		if(!stored_materials[check_name])
			stored_materials[check_name] = 0
		stored_materials[check_name] += D.required_materials[check_name] * proportion

	//check reagents
	for(var/reagent_type in D.required_reagents)
		reagents.add_reagent(reagent_type, D.required_reagents[reagent_type] * proportion)

	//check components
	for(var/check_type in D.required_objs)
		if(!stored_components[check_type])
			stored_components[check_type] = 0
		stored_components[check_type] += D.required_objs[check_type] * proportion

	//only update the ui if we have to
	if(D.required_materials)
		UpdateMaterialsString()
	if(D.required_reagents)
		UpdateReagentsString()
	if(D.required_objs)
		UpdateComponentsString()
