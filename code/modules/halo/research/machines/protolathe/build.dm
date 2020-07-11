


/* CONSTRUCTION AND DECONSTRUCTION PROCS */

/obj/machinery/research/protolathe
	circuit_type = /obj/item/weapon/circuitboard/protolathe

/obj/machinery/research/protolathe/dismantle()
	//todo: is this correct
	for(var/obj/I in component_parts)
		if(istype(I, /obj/item/weapon/reagent_containers/glass/beaker))
			reagents.trans_to_obj(I, reagents.total_volume)

	for(var/mat_name in stored_materials)
		eject_materials(mat_name)

	. = ..()

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



/* CIRCUITBOARD */

/obj/item/weapon/circuitboard/protolathe
	name = T_BOARD("protolathe")
	build_path = /obj/machinery/research/protolathe
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4)
	req_components = list(
		/obj/item/stack/material/glass = 20,
		/obj/item/stack/material/plastic = 5,
		/obj/item/weapon/stock_parts/matter_bin = 2,
		/obj/item/weapon/stock_parts/manipulator = 2,
		/obj/item/weapon/reagent_containers/glass/beaker = 2,
		/obj/item/weapon/stock_parts/console_screen = 1)
