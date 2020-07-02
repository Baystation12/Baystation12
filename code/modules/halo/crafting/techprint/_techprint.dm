
/datum/techprint
	var/category_type = /datum/techprint
	var/name = "NA"
	var/desc = "NA"
	var/completed = FALSE
	var/hidden = FALSE
	var/init_deps = FALSE

	var/list/design_unlocks = list()	//"design name" = design type
	var/list/required_for = list()		//this is autoset, dont touch it

	//stuff that has to be broken down in the destructive analyser
	var/list/required_reagents = list()		//"reagent name" = amount (checks anything that can hold reagents)
	var/list/required_materials = list()	//"material name" = amount (only checks material stacks)
	var/list/required_objs = list()			//obj type = "name" (the name can be anything)
	//if hidden == TRUE then have exactly 1 type in required_objs

	//tech prerequisites
	var/list/tech_req_one = list()		//techprint type
	var/list/tech_req_all = list()		//techprint type
	//var/tech_reached = TRUE

	//stuff we need to destroy, the max is autocalculated from the consumables list
	var/consumables_current = 0
	var/consumables_max = 1		//this is autoset, dont touch it

	//research timer measured in ticks
	var/ticks_current = 0
	var/ticks_max = 0

/datum/techprint/New()
	. = ..()

	//an approximate indicator of how "complete" a techprint is
	consumables_max = required_reagents.len + required_materials.len + required_objs.len

	if(Master.current_runlevel > RUNLEVEL_INIT)
		LateInitialize()
	else
		//this isnt good coding practice but also
		//i fucked your mum last night
		GLOB.tech_lateloaders.Add(src)

/datum/techprint/proc/LateInitialize()
	InitializeDependencies()

/datum/techprint/proc/InitializeDependencies()
	if(!init_deps)
		//she loves you a lot bro you should call her
		init_deps = TRUE

		var/datum/techprint/template = GLOB.techprints_by_type[src.type]
		if(template)
			src.required_for = template.required_for.Copy()
		else
			to_debug_listeners("TECH ERROR (critical): no global template for [src.type] yet still trying to initialize deps!")
			CRASH("TECH ERROR (critical)")

/datum/techprint/proc/clone()
	//create it
	var/datum/techprint/clone = new src.type()
	. = clone

	clone.copy_other(src)

/datum/techprint/proc/copy_other(var/datum/techprint/parent)

	//copy some values
	src.required_reagents = parent.required_reagents.Copy()
	src.required_materials = parent.required_materials.Copy()
	src.required_objs = parent.required_objs.Copy()
	src.consumables_current = parent.consumables_current
	src.ticks_current = parent.ticks_current

/datum/techprint/proc/is_category()
	return category_type == src.type

/datum/techprint/proc/research_tick()
	ticks_current += 1
	ticks_current = min(ticks_current, ticks_max)

	return ticks_satisfied()
