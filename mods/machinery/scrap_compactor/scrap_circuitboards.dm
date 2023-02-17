/obj/item/stock_parts/circuitboard/crusher
	name = T_BOARD("crusher")
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3)
	build_path = /obj/machinery/crusher_base
	req_components = list(
		/obj/item/stock_parts/matter_bin = 3,
		/obj/item/stock_parts/manipulator = 3,
		/obj/item/reagent_containers/glass/beaker = 3
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/pile_ripper
	name = T_BOARD("pile ripper")
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 3)
	build_path = /obj/machinery/pile_ripper
	req_components = list(
		/obj/item/stock_parts/manipulator = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

/obj/item/stock_parts/circuitboard/recycler
	name = T_BOARD("recycler")
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 3)
	build_path = /obj/machinery/recycler
	req_components = list(
		/obj/item/stock_parts/manipulator = 1
	)
	additional_spawn_components = list(
		/obj/item/stock_parts/power/apc/buildable = 1
	)

// RnD console designs

/datum/design/circuit/scrap_crusher
	name = "crusher"
	id = "crusher"
	req_tech = list(TECH_ENGINEERING = 3, TECH_MATERIAL = 3, TECH_DATA = 3)
	build_path = /obj/item/stock_parts/circuitboard/crusher
	sort_string = "KCASA"

/datum/design/circuit/scrap_ripper
	name = "pile ripper"
	id = "pile_ripper"
	req_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 2)
	build_path = /obj/item/stock_parts/circuitboard/pile_ripper
	sort_string = "KCASB"

/datum/design/circuit/srcap_recycler
	name = "recycler"
	id = "recycler"
	req_tech = list(TECH_ENGINEERING = 3, TECH_DATA = 2)
	build_path = /obj/item/stock_parts/circuitboard/recycler
	sort_string = "KCASC"
