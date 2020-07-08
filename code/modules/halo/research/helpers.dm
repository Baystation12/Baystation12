
/proc/format_materials_list(var/list/materials)
	var/list/strings = list()
	. = list("ERROR")

	for(var/mat_name in materials)
		var/material/M = get_material_by_name(mat_name)
		if(M)
			if(!materials[mat_name])
				materials[mat_name] = 0
				//to_debug_listeners("ERROR (minor): empty amount of material id \'[mat_name]\'")
			var/descriptor = materials[mat_name] == 1 ? M.sheet_singular_name : M.sheet_plural_name
			strings += "[M.display_name] ([materials[mat_name]] [descriptor])"
		else
			var/errormsg = "(MAJOR): unable to find material id \'[mat_name]\'"
			//to_debug_listeners(errormsg)
			CRASH(errormsg)

	return strings

/proc/format_reagents_list(var/list/reagents_list)
	var/list/strings = list()
	. = list("ERROR")

	//special handling to get the reagent name
	for(var/reagent_type in reagents_list)
		var/datum/reagent/R = GLOB.chemical_reagents_list[reagent_type]
		if(R)
			strings += "[R.name] ([reagents_list[reagent_type]]u)"
		else
			var/errormsg = "unable to find reagent type [reagent_type]"
			//to_debug_listeners(errormsg)
			CRASH(errormsg)

	return strings
