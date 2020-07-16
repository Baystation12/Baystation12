
/obj/machinery/research/protolathe
	var/reagents_string = "None"
	//var/list/ui_reagents = list()
	var/list/stored_reagents
	var/list/reagents_strings

	var/components_string = "None"
	var/list/ui_components = list()

	var/materials_string = "None"
	var/list/ui_materials = list()
	var/list/materials_strings = list()

/obj/machinery/research/protolathe/proc/UpdateMaterialsString()
	materials_strings = format_materials_list(stored_materials)
	ui_materials = list()
	for(var/index = 1, index <= materials_strings.len, index++)
		var/list/entry = list("info" = materials_strings[index], "matname" = stored_materials[index])

		ui_materials.len++
		ui_materials[ui_materials.len] = entry

	//materials_string = english_list(materials_strings, nothing_text = "None")

/obj/machinery/research/protolathe/proc/UpdateReagentsString()
	stored_reagents = list()
	for(var/datum/reagent/R in reagents.reagent_list)
		stored_reagents[R.type] = R.volume

	reagents_strings = format_reagents_list(stored_reagents)
	reagents_string = english_list(reagents_strings, nothing_text = "None")

/obj/machinery/research/protolathe/proc/UpdateComponentsString()
	ui_components = list()

	//we just put in a custom obj name here so its east
	for(var/obj_type in stored_components)
		var/obj_name = components_types_names[obj_type]

		//now add the item to the ui list
		var/atom/A = obj_type
		var/list/entry = list("info" = "[obj_name] x [initial(A.name)]", "type" = obj_type)
		ui_components.len++
		ui_components[ui_components.len] = entry


	//components_string = english_list(components_strings, nothing_text = "None")

/obj/machinery/research/protolathe/proc/ui_UpdateDesignEfficiencies()

	for(var/datum/research_design/D in all_designs)
		//only update strings if we have to
		if(D.consumables_string)
			D.UpdateConsumablesString(mat_efficiency)
