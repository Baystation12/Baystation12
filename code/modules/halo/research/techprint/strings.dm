
/* String Updates */
/* These won't always need to be updated, so they're here for optimisation purposes*/

/datum/techprint/proc/UpdateConsumablesString()
	var/list/consumables = list()

	consumables += format_materials_list(required_materials)
	consumables += format_reagents_list(required_reagents)

	//we just put in a custom obj name here so its east
	for(var/obj_type in required_objs)
		var/atom/A = obj_type
		consumables += initial(A.name)

	consumables_string = english_list(consumables, nothing_text = "None")

/datum/techprint/proc/UpdateReqsString(var/datum/computer_file/research_db/R)

	if(!R)
		to_debug_listeners("TECH ERROR: [src.type]/proc/UpdateReqsString() was passed a null research database")
		return

	reqs_string = ""

	var/list/req_one = list()
	for(var/techprint_type in tech_req_one)
		var/datum/techprint/req_techprint = R ? R.techprints_by_type[techprint_type] : GLOB.techprints_by_type[techprint_type]
		if(req_techprint)
			req_one += req_techprint.name
		else
			req_one += "undiscovered techprint"

	if(req_one.len)
		reqs_string += "<em>One of:</em> [english_list(req_one, and_text = " or ")]"

	var/list/req_all = list()
	for(var/techprint_type in tech_req_all)
		var/datum/techprint/req_techprint = R ? R.techprints_by_type[techprint_type] : GLOB.techprints_by_type[techprint_type]
		if(req_techprint)
			req_all += req_techprint.name
		else
			req_all += "undiscovered techprint"

	if(req_all.len)
		if(length(reqs_string))
			reqs_string += ", "
		reqs_string += "<em>All of:</em> [english_list(req_all)]"

	if(!length(reqs_string))
		reqs_string = "None"

/datum/techprint/proc/UpdateDesignsString()

	var/list/design_names = list()
	for(var/design_type in design_unlocks)
		var/datum/research_design/D = design_type
		design_names.Add(initial(D.name))
		/*
		var/datum/research_design/template = GLOB.designs_by_type[design_type]
		if(template)
			design_names.Add(template.name)
		else
			to_debug_listeners("TECHPRINT ERROR: Unable to identify design key \'[design_type]\' for [src.type]")
			*/

	designs_string = english_list(design_names, nothing_text = "None")
