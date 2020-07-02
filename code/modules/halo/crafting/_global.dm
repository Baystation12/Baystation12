
GLOBAL_LIST_EMPTY(all_techprints)
GLOBAL_LIST_EMPTY(techprints_by_type)
GLOBAL_LIST_EMPTY(techprints_by_name)
GLOBAL_LIST_EMPTY(techprints_hidden)
GLOBAL_LIST_EMPTY(tech_lateloaders)

/proc/init_global_techprints()

	//see below
	init_global_designs()

	for(var/techprint_type in typesof(/datum/techprint) - /datum/techprint)
		//create it
		var/datum/techprint/new_techprint = new techprint_type()

		//is this a category?
		if(new_techprint.is_category())
			//dont track this one
			qdel(new_techprint)
			continue

		//start tracking it
		GLOB.all_techprints.Add(new_techprint)
		GLOB.techprints_by_type[techprint_type] = new_techprint
		GLOB.techprints_by_name[new_techprint.name] = new_techprint

		//special handling for secret techprints
		if(new_techprint.hidden)
			for(var/checktype in new_techprint.required_objs)
				var/datum/techprint/conflicting = GLOB.techprints_hidden[checktype]
				if(conflicting)
					to_debug_listeners("TECH ERROR: destruct obj [checktype] for [new_techprint.type] \
						is already used by [conflicting.type]")
				GLOB.techprints_hidden[checktype] = new_techprint

	//setup tech dependancies
	for(var/datum/techprint/new_techprint in GLOB.all_techprints)
		//check everything we require
		for(var/req_type in new_techprint.tech_req_one + new_techprint.tech_req_all)
			//grab that template, and tell it we need it
			var/datum/techprint/req_tech = GLOB.techprints_by_type[req_type]
			req_tech.required_for |= new_techprint.type

		//as these are templates, it replaces the standard dependency initialization
		new_techprint.init_deps = TRUE

		//dont bother doing any other initialization stuff for these template techprints, its just ui all the way down

	//woohoo
	for(var/T in GLOB.tech_lateloaders)
		T:LateInitialize()

GLOBAL_LIST_EMPTY(all_designs)
GLOBAL_LIST_EMPTY(designs_by_type)
GLOBAL_LIST_EMPTY(designs_by_name)

/proc/init_global_designs()
	for(var/new_type in typesof(/datum/research_design) - /datum/research_design)
		var/datum/research_design/D = new new_type()

		GLOB.all_designs.Add(D)
		GLOB.designs_by_type[D.type] = D
		GLOB.designs_by_name[D.name] = D
