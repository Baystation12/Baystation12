/obj/item/weapon/stock_parts/circuitboard/replicator
	name = T_BOARD("food replicator")
	build_path = /obj/machinery/food_replicator
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2)
	req_components = list(
		/obj/item/weapon/stock_parts/matter_bin = 1,
		/obj/item/weapon/stock_parts/manipulator = 1,
		/obj/item/weapon/stock_parts/micro_laser = 1)
	additional_spawn_components = list(
		/obj/item/weapon/stock_parts/console_screen = 1,
		/obj/item/weapon/stock_parts/keyboard = 1,
		/obj/item/weapon/stock_parts/power/apc/buildable = 1
	)