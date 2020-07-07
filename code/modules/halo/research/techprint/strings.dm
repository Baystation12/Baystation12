
/* String Updates */
/* These won't always need to be updated, so they're here for optimisation purposes*/

/datum/techprint/proc/UpdateConsumablesString()
	var/list/consumables = list()

	consumables += format_materials_list(required_materials)
	consumables += format_reagents_list(required_reagents)

	//we just put in a custom obj name here so its east
	for(var/entry in required_objs)
		consumables += required_objs[entry]

	consumables_string = english_list(consumables, nothing_text = "None")

/datum/techprint/proc/UpdateReqsString()
	reqs_string = ""

	var/list/req_one = list()
	for(var/techprint_type in tech_req_one)
		var/datum/techprint/req_techprint = GLOB.techprints_by_type[techprint_type]
		req_one += req_techprint.name

	if(req_one.len)
		reqs_string += "<em>One of:</em> [english_list(req_one)]"

	var/list/req_all = list()
	for(var/techprint_type in tech_req_all)
		var/datum/techprint/req_techprint = GLOB.techprints_by_type[techprint_type]
		req_all += req_techprint.name

	if(req_all.len)
		if(length(reqs_string))
			reqs_string += ", "
		reqs_string += "<em>All of:</em> [english_list(req_all)]"

	if(!length(reqs_string))
		reqs_string = "None"

/datum/techprint/proc/UpdateDesignsString()

	var/list/design_names = list()
	for(var/design_type in design_unlocks)
		var/datum/research_design/template = GLOB.designs_by_type[design_type]
		if(template)
			design_names.Add(template.name)
		else
			to_debug_listeners("TECHPRINT ERROR: Unable to identify design key \'[design_type]\' for [src.type]")

	designs_string = english_list(design_names, nothing_text = "None")
