#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

/obj/item/weapon/circuitboard/shield_gen_ex
	name = T_BOARD("hull shield generator")
	board_type = "machine"
	build_path = "/obj/machinery/shield_gen/external"
	origin_tech = list(TECH_BLUESPACE = 4, TECH_PHORON = 3)
	req_components = list(
							"/obj/item/weapon/stock_parts/manipulator/pico" = 2,
							"/obj/item/weapon/stock_parts/subspace/transmitter" = 1,
							"/obj/item/weapon/stock_parts/subspace/crystal" = 1,
							"/obj/item/weapon/stock_parts/subspace/amplifier" = 1,
							"/obj/item/weapon/stock_parts/console_screen" = 1,
							"/obj/item/stack/cable_coil" = 5)

/obj/item/weapon/circuitboard/shield_gen
	name = T_BOARD("bubble shield generator")
	board_type = "machine"
	build_path = "/obj/machinery/shield_gen"
	origin_tech = list(TECH_BLUESPACE = 4, TECH_PHORON = 3)
	req_components = list(
							"/obj/item/weapon/stock_parts/manipulator/pico" = 2,
							"/obj/item/weapon/stock_parts/subspace/transmitter" = 1,
							"/obj/item/weapon/stock_parts/subspace/crystal" = 1,
							"/obj/item/weapon/stock_parts/subspace/amplifier" = 1,
							"/obj/item/weapon/stock_parts/console_screen" = 1,
							"/obj/item/stack/cable_coil" = 5)

/obj/item/weapon/circuitboard/shield_cap
	name = T_BOARD("shield capacitor")
	board_type = "machine"
	build_path = "/obj/machinery/shield_capacitor"
	origin_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	req_components = list(
							"/obj/item/weapon/stock_parts/manipulator/pico" = 2,
							"/obj/item/weapon/stock_parts/subspace/filter" = 1,
							"/obj/item/weapon/stock_parts/subspace/treatment" = 1,
							"/obj/item/weapon/stock_parts/subspace/analyzer" = 1,
							"/obj/item/weapon/stock_parts/console_screen" = 1,
							"/obj/item/stack/cable_coil" = 5)
