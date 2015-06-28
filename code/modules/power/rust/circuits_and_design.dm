//////////////////////////////////////
// RUST Core Control computer

/obj/item/weapon/circuitboard/rust_core_control
	name = "Circuit board (RUST core controller)"
	build_path = "/obj/machinery/computer/rust_core_control"
	origin_tech = list(TECH_DATA = 4, TECH_ENGINERING = 4)

//////////////////////////////////////
// RUST Fuel Control computer

/obj/item/weapon/circuitboard/rust_fuel_control
	name = "Circuit board (RUST fuel controller)"
	build_path = "/obj/machinery/computer/rust_fuel_control"
	origin_tech = list(TECH_DATA = 4, TECH_ENGINERING = 4)

//////////////////////////////////////
// RUST Fuel Port board

/obj/item/weapon/module/rust_fuel_port
	name = "Internal circuitry (RUST fuel port)"
	icon_state = "card_mod"
	origin_tech = list(TECH_ENGINERING = 4, TECH_MATERIAL = 5)

//////////////////////////////////////
// RUST Fuel Compressor board

/obj/item/weapon/module/rust_fuel_compressor
	name = "Internal circuitry (RUST fuel compressor)"
	icon_state = "card_mod"
	origin_tech = list(TECH_MATERIAL = 6, TECH_PHORON = 4)

//////////////////////////////////////
// RUST Tokamak Core board

/obj/item/weapon/circuitboard/rust_core
	name = "Internal circuitry (RUST tokamak core)"
	build_path = "/obj/machinery/power/rust_core"
	board_type = "machine"
	origin_tech = list(TECH_BLUESPACE = 3, TECH_PHORON = 4, TECH_MAGNET = 5, TECH_POWER = 6)
	req_components = list(
							"/obj/item/weapon/stock_parts/manipulator/pico" = 2,
							"/obj/item/weapon/stock_parts/micro_laser/ultra" = 1,
							"/obj/item/weapon/stock_parts/subspace/crystal" = 1,
							"/obj/item/weapon/stock_parts/console_screen" = 1,
							"/obj/item/stack/cable_coil" = 5)

//////////////////////////////////////
// RUST Fuel Injector board

/obj/item/weapon/circuitboard/rust_injector
	name = "Internal circuitry (RUST fuel injector)"
	build_path = "/obj/machinery/power/rust_fuel_injector"
	board_type = "machine"
	origin_tech = list(TECH_POWER = 3, TECH_ENGINERING = 4, TECH_PHORON = 4, TECH_MATERIAL = 6)
	req_components = list(
							"/obj/item/weapon/stock_parts/manipulator/pico" = 2,
							"/obj/item/weapon/stock_parts/scanning_module/phasic" = 1,
							"/obj/item/weapon/stock_parts/matter_bin/super" = 1,
							"/obj/item/weapon/stock_parts/console_screen" = 1,
							"/obj/item/stack/cable_coil" = 5)
