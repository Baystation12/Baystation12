//Stuff that doesn't fit into any category goes here

/obj/item/stock_parts/circuitboard/aicore
	name = "circuit board (AI core)"
	origin_tech = list(TECH_DATA = 4, TECH_BIO = 2)
	board_type = "other"


/obj/item/stock_parts/circuitboard/drone_pad
	name = "circuit board (transport drone landing pad)"
	build_path = /obj/machinery/drone_pad
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 2)
	req_components = list(
		/obj/item/stock_parts/scanning_module = 4,
		/obj/item/stock_parts/subspace/crystal = 1)
	additional_spawn_components = null
