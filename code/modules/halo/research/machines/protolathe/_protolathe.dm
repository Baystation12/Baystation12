
/obj/machinery/research/protolathe
	name = "\improper protolathe"
	icon_state = "protolathe"
	var/icon_base = "protolathe"

	flags = OPENCONTAINER
	var/max_storage = 100000
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

/obj/machinery/research/protolathe/New()
	. = ..()

	//internal components
	//todo: make this buildable (override the protolathe circuitboard)
	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/protolathe(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)
	component_parts += new /obj/item/weapon/reagent_containers/glass/beaker(src)

	//update the stats
	RefreshParts()

	//initialize the ui
	ui_SelectDesign()

/obj/machinery/research/protolathe/Initialize()
	. = ..()

	//we are going to manually call late initialize so that the techprints and designs have been initialized properly
	if(Master.current_runlevel > RUNLEVEL_INIT)
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
		max_storage += M.rating * 30

	//work out the speed and efficiency
	var/manipulation = 0
	craft_parallel = 0
	for(var/obj/item/weapon/stock_parts/manipulator/M in component_parts)
		manipulation += M.rating
		craft_parallel += M.rating / 2
	mat_efficiency = 1 - (manipulation - 2) / 8
	speed = manipulation / 2

/obj/machinery/research/protolathe/examine(var/mob/user)
	. = ..()
	if(output_dir)
		to_chat(user,"<span class='info'>It is set to output to the [dir2text(output_dir)]</span>")
	else
		to_chat(user,"<span class='info'>It is set to output to it's own tile.</span>")
