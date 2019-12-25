// New shields
/obj/item/weapon/stock_parts/circuitboard/shield_generator
	name = T_BOARD("advanced shield generator")
	board_type = "machine"
	build_path = /obj/machinery/power/shield_generator
	origin_tech = list(TECH_MAGNET = 3, TECH_POWER = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/weapon/stock_parts/smes_coil = 1)
	additional_spawn_components = list(
		/obj/item/weapon/stock_parts/console_screen = 1,
		/obj/item/weapon/stock_parts/keyboard = 1,
		/obj/item/weapon/stock_parts/power/apc/buildable = 1
	)

/obj/item/weapon/stock_parts/circuitboard/shield_diffuser
	name = T_BOARD("shield diffuser")
	board_type = "machine"
	build_path = /obj/machinery/shield_diffuser
	origin_tech = list(TECH_MAGNET = 4, TECH_POWER = 2)
	req_components = list(
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1)
	additional_spawn_components = list(
		/obj/item/weapon/stock_parts/console_screen = 1,
		/obj/item/weapon/stock_parts/keyboard = 1,
		/obj/item/weapon/stock_parts/power/apc/buildable = 1
	)

/obj/item/weapon/stock_parts/circuitboard/pointdefense
	name = T_BOARD("point defense battery")
	board_type = "machine"
	desc = "Control systems for a Kuiper pattern point defense battery. Aim away from vessel."
	build_path = /obj/machinery/pointdefense
	origin_tech = list(TECH_ENGINEERING = 3, TECH_COMBAT = 2)
	req_components = list(
		/obj/item/mech_equipment/mounted_system/taser/laser = 1,
		/obj/item/weapon/stock_parts/manipulator = 2,
		/obj/item/weapon/stock_parts/capacitor = 2,
		
	)
	additional_spawn_components = list(
		/obj/item/weapon/stock_parts/power/terminal/buildable = 1,
		/obj/item/weapon/stock_parts/power/battery/buildable/responsive = 1,
		/obj/item/weapon/cell/high = 1
	)

/obj/item/weapon/stock_parts/circuitboard/pointdefense_control
	name = T_BOARD("fire assist mainframe")
	board_type = "machine"
	desc = "A control computer to synchronize point defense batteries."
	build_path = /obj/machinery/pointdefense_control
	origin_tech = list(TECH_ENGINEERING = 3, TECH_COMBAT = 2)