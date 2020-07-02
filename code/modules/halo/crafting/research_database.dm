
/datum/computer_file/research_db
	filetype = "RDB"
	filename = "techprints"
	size = 0.15
	var/list/all_techprints = list()
	var/list/techprints_by_type = list()
	var/list/techprints_by_name = list()

	var/list/ready_techprints = list()
	var/list/locked_techprints = list()
	var/list/completed_techprints = list()

/datum/computer_file/research_db/New(var/initialize_default = FALSE)
	. = ..()

	if(initialize_default)
		if(Master.current_runlevel > RUNLEVEL_INIT)
			LateInitialize()
		else
			GLOB.tech_lateloaders.Add(src)

/datum/computer_file/research_db/proc/LateInitialize()
	build_tree(GLOB.UNSC.get_base_techprints())

/datum/computer_file/research_db/clone()
	var/datum/computer_file/research_db/temp = ..()
	. = temp

	//copy all the techs
	for(var/datum/techprint/T in all_techprints)
		var/datum/techprint/clone = T.clone()
		temp.all_techprints.Add(clone)
		temp.techprints_by_type[clone.type] = clone
		temp.techprints_by_name[clone.name] = clone

	for(var/datum/techprint/parent in ready_techprints)
		var/datum/techprint/child = temp.techprints_by_type[parent.type]
		temp.ready_techprints.Add(child)

	for(var/datum/techprint/parent in locked_techprints)
		var/datum/techprint/child = temp.techprints_by_type[parent.type]
		temp.locked_techprints.Add(child)

	for(var/datum/techprint/parent in completed_techprints)
		var/datum/techprint/child = temp.techprints_by_type[parent.type]
		temp.completed_techprints.Add(child)

/datum/computer_file/research_db/proc/build_tree(var/list/source_list)
	var/list/working_list = source_list.Copy()

	var/list/bonus_techs = list()
	. = bonus_techs

	while(working_list.len)
		var/check_type = working_list[1]
		working_list -= check_type

		if(check_type in techprints_by_type)
			continue

		var/datum/techprint/T = GLOB.techprints_by_type[check_type]
		if(T.is_category())
			continue

		//create this techprint, add it to tree, create its ui etc
		var/datum/techprint/new_techprint = add_techprint(check_type)
		bonus_techs.Add(new_techprint)

		//add all techs which are unlocked by this one
		for(var/child_type in new_techprint.required_for)
			var/datum/techprint/template_techprint = GLOB.techprints_by_type[child_type]

			if(template_techprint.hidden)
				continue

			//if it has hidden tech requirements, dont add them
			var/do_continue = 0
			for(var/uncle_type in template_techprint.tech_req_one + template_techprint.tech_req_all)
				var/datum/techprint/template_techprint_uncle = GLOB.techprints_by_type[uncle_type]
				if(template_techprint_uncle.hidden)
					do_continue = 1
					break

			if(do_continue)
				continue

			working_list.Add(child_type)

/datum/computer_file/research_db/proc/add_techprint(var/techprint_type)
	var/datum/techprint/new_techprint = new techprint_type()

	all_techprints.Add(new_techprint)
	techprints_by_type[new_techprint.type] = new_techprint
	techprints_by_name[new_techprint.name] = new_techprint

	//is this tech ready to begin researching?
	if(new_techprint.prereqs_satisfied(src))
		ready_techprints.Add(new_techprint)
	else
		locked_techprints.Add(new_techprint)

	//increase our file size a bit
	src.size += rand(0.75, 1.25)

	return new_techprint

/datum/computer_file/research_db/proc/complete_techprint(var/datum/techprint/finished_techprint, \
	var/datum/nano_module/program/experimental_analyzer/NM)
	. = list()

	//update its status
	finished_techprint.completed = TRUE

	//if this was a hidden tech, it will enable some techs which are missing
	if(finished_techprint.hidden)
		var/list/to_add = finished_techprint.required_for.Copy()
		to_debug_listeners("Adding newly discovered techs: [english_list(to_add)]")

		//return any newly added techs
		. = build_tree(to_add)

	//update techprint availability in our own tree
	for(var/check_type in finished_techprint.required_for)
		var/datum/techprint/check_techprint = techprints_by_type[check_type]
		if(!check_techprint)
			to_debug_listeners("TECH ERROR: Unable to find [check_type] in research_db while updating tech tree availability \
				after completing [finished_techprint.type]")

		if(check_techprint)
			//this techprint is currently locked
			if(locked_techprints.Find(check_techprint))

				//is the techprint ready to unlock?
				if(check_techprint.prereqs_satisfied(src))
					locked_techprints -= check_techprint
					ready_techprints += check_techprint

					//update the UI
					NM.ui_UnlockTech(check_techprint)
					NM.ui_AvailTech(check_techprint)
