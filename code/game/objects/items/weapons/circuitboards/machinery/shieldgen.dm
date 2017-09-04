#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it!
#endif
// New shields
/obj/item/weapon/circuitboard/shield_generator
	name = T_BOARD("advanced shield generator")
	board_type = "machine"
	build_path = /obj/machinery/power/shield_generator
	origin_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/smes_coil = 1,
							/obj/item/weapon/stock_parts/console_screen = 1)

/obj/item/weapon/circuitboard/shield_diffuser
	name = T_BOARD("shield diffuser")
	board_type = "machine"
	build_path = /obj/machinery/shield_diffuser
	origin_tech = list(TECH_MAGNET = 4, TECH_POWER = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1)
