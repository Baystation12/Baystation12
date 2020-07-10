
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

	var/datum/research_design/currently_selected

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

/obj/machinery/research/protolathe/RefreshParts()

	//work out chemical storage
	var/reagent_volume = 0
	for(var/obj/item/weapon/reagent_containers/glass/G in component_parts)
		reagent_volume += G.reagents.maximum_volume
	create_reagents(reagent_volume)

	//work out material storage
	max_storage = 0
	for(var/obj/item/weapon/stock_parts/matter_bin/M in component_parts)
		max_storage += M.rating * 40

	//work out the speed and efficiency
	var/manipulation = 0
	var/old_efficiency = mat_efficiency
	mat_efficiency = 1.2	//this will go down to 1 with basic parts

	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)

		manipulation += M.rating

		//consume less resources here
		mat_efficiency -= M.rating / 10

		//cap it so there is still some mats required
		mat_efficiency = max(mat_efficiency, 0.1)

	//better manipulation improves both crafting speed and parallel crafting
	craft_parallel = manipulation / 2
	speed = manipulation / 2

	//only update ui strings if our efficiency has changed
	if(mat_efficiency != old_efficiency)
		ui_UpdateDesignEfficiencies()
