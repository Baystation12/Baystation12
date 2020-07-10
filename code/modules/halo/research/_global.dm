
GLOBAL_LIST_EMPTY(all_techprints)
GLOBAL_LIST_EMPTY(techprints_by_type)
GLOBAL_LIST_EMPTY(techprints_by_name)
GLOBAL_LIST_EMPTY(techprints_hidden)
GLOBAL_LIST_EMPTY(tech_lateloaders)
GLOBAL_VAR_INIT(tech_initialized, FALSE)

/proc/init_global_techprints()

	//see below
	init_global_designs()

	//create a global template for each techprint
	for(var/techprint_type in typesof(/datum/techprint) - /datum/techprint)
		//create it
		var/datum/techprint/new_techprint = new techprint_type()

		//is this a category? skip it
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

			//there should only be 1 entry in required_objs for hidden techs
			if(new_techprint.required_objs.len > 1)
				to_debug_listeners("TECH ERROR: hidden techprint [new_techprint.type] \
					has more than 1 destroy trigger (len:[new_techprint.required_objs.len])! \
					[english_list(new_techprint.required_objs)]")

			for(var/checktype in new_techprint.required_objs)

				//they are indexed by the "destroy" type
				//so if there is 2 hidden techs with the same destroy type, it's a problem
				var/datum/techprint/conflicting = GLOB.techprints_hidden[checktype]
				if(conflicting)
					to_debug_listeners("TECH ERROR: destruct obj [checktype] for [new_techprint.type] \
						is already used by [conflicting.type]")
					continue
				GLOB.techprints_hidden[checktype] = new_techprint
				break

	//setup tech dependancies
	for(var/datum/techprint/new_techprint in GLOB.all_techprints)

		//check everything we require
		for(var/req_type in new_techprint.tech_req_one + new_techprint.tech_req_all)
			//grab that template, and tell it we need it
			var/datum/techprint/req_tech = GLOB.techprints_by_type[req_type]
			if(req_tech)
				if(!req_tech.required_for)
					req_tech.required_for = list()
				req_tech.required_for |= new_techprint.type
			else
				to_debug_listeners("TECH ERROR: tech dependency [req_type] for [new_techprint.type] \
					does not exist")

		//as these are templates, it replaces the standard dependency initialization
		new_techprint.init_deps = TRUE
		if(!new_techprint.required_for)
			new_techprint.required_for = list()

		//dont bother doing any other initialization stuff for these template techprints, its just ui all the way down

	GLOB.tech_initialized = TRUE

	//these dont need to be initialized
	GLOB.tech_lateloaders -= GLOB.all_techprints

	//woohoo
	for(var/T in GLOB.tech_lateloaders)
		T:LateInitialize()
	GLOB.tech_lateloaders = list()

GLOBAL_LIST_EMPTY(all_designs)
GLOBAL_LIST_EMPTY(designs_by_type)
GLOBAL_LIST_EMPTY(designs_by_name)

/proc/init_global_designs()
	for(var/new_type in typesof(/datum/research_design))
		var/datum/research_design/D = new new_type()

		//is this a category? skip it
		if(D.is_category())
			//dont track this one
			qdel(D)
			continue

		GLOB.all_designs.Add(D)
		GLOB.designs_by_type[D.type] = D
		GLOB.designs_by_name[D.name] = D

//for testing
/obj/item/weapon/reagent_containers/glass/beaker/silicate/New()
	. = ..()

	reagents.add_reagent(/datum/reagent/silicate, 10)
	update_icon()
