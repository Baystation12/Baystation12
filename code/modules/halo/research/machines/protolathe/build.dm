


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
