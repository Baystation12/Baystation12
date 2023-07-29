// Not meant to be findable/usable in game. Just for use with constructable frames.

/obj/item/stock_parts/circuitboard/wmd
	name = "circuit board (mass explosive device)"
	build_path = /obj/machinery/nuclearbomb/wmd
	board_type = "machine"
	origin_tech = list(
		TECH_COMBAT = 1
	)
	req_components = list(
		/obj/item/stock_parts/capacitor = 3,
		/obj/item/stock_parts/console_screen = 1,
		/obj/item/stock_parts/power/battery/buildable/stock = 1,
		/obj/item/cell/high = 1
	)
