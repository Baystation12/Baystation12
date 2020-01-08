/obj/item/weapon/stock_parts/circuitboard/inertial_damper
	name = T_BOARD("inertial damper")
	board_type = "machine"
	build_path = /obj/machinery/inertial_damper
	origin_tech = list(TECH_ENGINEERING = 5, TECH_MAGNET = 3)
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1)
	additional_spawn_components = list(
		/obj/item/weapon/stock_parts/console_screen = 1,
		/obj/item/weapon/stock_parts/keyboard = 1,
		/obj/item/weapon/stock_parts/power/apc/buildable = 1
	)