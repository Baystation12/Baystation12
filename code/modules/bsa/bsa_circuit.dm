/obj/item/weapon/stock_parts/circuitboard/bsa
	name = T_BOARD("bluespace artillery control")
	build_path = /obj/machinery/computer/ship/bsa
	origin_tech = list(TECH_ENGINEERING = 2, TECH_COMBAT = 2, TECH_BLUESPACE = 2)

/obj/item/weapon/stock_parts/circuitboard/bsafront
	name = T_BOARD("bluespace particle beam generator mark VI.")
	build_path = /obj/machinery/bsa/front
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2, TECH_COMBAT = 2, TECH_BLUESPACE = 2)
	req_components = list (
		/obj/item/weapon/stock_parts/manipulator/pico = 5
	)

/obj/item/weapon/stock_parts/circuitboard/bsamiddle
	name = T_BOARD("bluespace fusor mark VI.")
	build_path = /obj/machinery/bsa/middle
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2, TECH_COMBAT = 2, TECH_BLUESPACE = 2)
	req_components = list (
		/obj/item/weapon/stock_parts/subspace/crystal = 10
	)

/obj/item/weapon/stock_parts/circuitboard/bsaback
	name = T_BOARD("bluespace material deconstructor mark VI.")
	build_path = /obj/machinery/bsa/back
	board_type = "machine"
	origin_tech = list(TECH_ENGINEERING = 2, TECH_COMBAT = 2, TECH_BLUESPACE = 2)
	req_components = list (
		/obj/item/weapon/stock_parts/capacitor/super = 5
	)