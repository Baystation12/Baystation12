#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif

/obj/item/weapon/circuitboard/bluespacerelay
	name = T_BOARD("bluespacerelay")
	build_path = "/obj/machinery/bluespacerelay"
	board_type = "machine"
	origin_tech = "bluespace=4,programming=4"
	frame_desc = "Requires 30 Cable Coil, 1 Hyperwave Filter and 1 Ansible Crystal, and 2 Micro-Manipulators"
	req_components = list(
							"/obj/item/stack/cable_coil" = 30,
							"/obj/item/weapon/stock_parts/manipulator" = 2,
							"/obj/item/weapon/stock_parts/subspace/filter" = 1,
							"/obj/item/weapon/stock_parts/subspace/crystal" = 1,
						  )