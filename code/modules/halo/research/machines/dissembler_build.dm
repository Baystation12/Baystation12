/obj/machinery/research/component_dissembler
	circuit_type = /obj/item/weapon/circuitboard/dissembler

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
		/obj/item/weapon/stock_parts/scanning_module = 1,
		/obj/item/weapon/stock_parts/micro_laser = 1)

/obj/item/weapon/circuitboard/dissembler/construct(var/obj/machinery/M)

	//check for free space
	var/turf/start = get_turf(M)
	var/turf/adjacent = get_step(start, EAST)

	//check if there is an empty frame there
	var/obj/machinery/constructable_frame/C = locate() in adjacent
	if(!C || C.state != CONSTRUCT_CABLE)
		spawn(0)
			M.visible_message("<span class='notice'>[M] cannot be built here \
				as it requires an empty constructable frame to the east.</span>")
			M.dismantle()
			var/obj/machinery/constructable_frame/D = locate() in adjacent
			qdel(D)
		return ..()

	M.density = 0	//quick hack to ignore these
	C.density = 0

	//dont want anything blocking the second slot
	if(adjacent.contains_dense_objects())
		spawn(0)
			M.visible_message("<span class='notice'>[M] cannot be built here as it requires a free space to the east.</span>")
			M.dismantle()
	M.density = 1

	//boom
	qdel(C)

	. = ..()

/obj/machinery/research/component_dissembler/dismantle()
	//put a second frame next to us
	var/turf/start = get_turf(src)
	var/turf/adjacent = get_step(start, EAST)
	new /obj/machinery/constructable_frame/machine_frame(adjacent)

	. = ..()
