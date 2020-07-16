
/obj/machinery/research/protolathe
	name = "\improper protolathe"
	icon_state = "protolathe"
	state_base = "protolathe"

	flags = OPENCONTAINER
	var/design_build_flag = PROTOLATHE

	var/list/design_queue = list()

	var/list/all_designs = list()
	var/list/designs_by_name = list()

	var/output_dir = 0

	var/mat_efficiency = 1
	var/speed = 1
	var/craft_parallel = 1
	var/instant_ready = TRUE
	var/max_storage = 60

/obj/machinery/research/protolathe/New()
	. = ..()

	//default value
	create_reagents(120)

	//initialize the ui
	ui_SelectDesign()

/obj/machinery/research/protolathe/Initialize()
	. = ..()

	//we are going to manually call late initialize so that the techprints and designs have been initialized properly
	if(GLOB.tech_initialized)
		LateInitialize()
	else
		GLOB.tech_lateloaders.Add(src)

/obj/machinery/research/protolathe/LateInitialize()

	//grab the base list of craftable stuff
	for(var/design_type in GLOB.UNSC.get_base_designs())
		//get the template
		var/datum/research_design/D = GLOB.designs_by_type[design_type]

		if(D.build_type != design_build_flag)
			continue

		//start tracking it
		all_designs.Add(D)
		designs_by_name[D.name] = D

		//add a ui entry
		ui_AddDesign(D)
