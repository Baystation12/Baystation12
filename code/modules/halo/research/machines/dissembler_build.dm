
/obj/item/weapon/circuitboard/dissembler
	name = T_BOARD("component dissembler")
	build_path = /obj/machinery/research/component_dissembler
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4)
	req_components = list(
		/obj/item/stack/material/steel = 20,
		/obj/item/stack/material/glass = 10,
		/obj/item/stack/material/plastic = 10,
		/obj/item/stack/cable_coil = 5,
		/obj/item/weapon/stock_parts/scanning_module/adv = 1,
		/obj/item/weapon/stock_parts/micro_laser/high = 1)

/obj/item/weapon/circuitboard/dissembler/construct(var/obj/machinery/M)
	. = ..()

	//check for free space
	var/turf/start = get_turf(M)
	var/turf/adjacent = get_step(start, EAST)
	if(adjacent.contains_dense_objects())
		spawn(0)
			M.visible_message("<span class='notice'>[M] cannot be built here as it requires a free space to the east.</span>")
			M.dismantle()
