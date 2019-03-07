/obj/item/weapon/circuitboard/fusion/core_control
	name = "circuit board (fusion core controller)"
	build_path = /obj/machinery/computer/fusion/core_control
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)

/obj/item/weapon/circuitboard/kinetic_harvester
	name = "internal circuitry (kinetic harvester)"
	build_path = /obj/machinery/kinetic_harvester
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_MATERIAL = 4)
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator/pico = 2,
		/obj/item/weapon/stock_parts/matter_bin/super = 1,
		/obj/item/weapon/stock_parts/console_screen = 1,
		/obj/item/stack/cable_coil = 5
		)

/obj/item/weapon/circuitboard/fusion_fuel_compressor
	name = "circuit board (fusion fuel compressor)"
	build_path = /obj/machinery/fusion_fuel_compressor
	board_type = "machine"
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 4, TECH_MATERIAL = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator/pico = 2,
							/obj/item/weapon/stock_parts/matter_bin/super = 2,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5
							)

/obj/item/weapon/circuitboard/fusion_fuel_control
	name = "circuit board (fusion fuel controller)"
	build_path = /obj/machinery/computer/fusion/fuel_control
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)

/obj/item/weapon/circuitboard/gyrotron_control
	name = "circuit board (gyrotron controller)"
	build_path = /obj/machinery/computer/fusion/gyrotron
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4)

/obj/item/weapon/circuitboard/fusion_core
	name = "internal circuitry (fusion core)"
	build_path = /obj/machinery/power/fusion_core
	board_type = "machine"
	origin_tech = list(TECH_BLUESPACE = 2, TECH_MAGNET = 4, TECH_POWER = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator/pico = 2,
							/obj/item/weapon/stock_parts/micro_laser/ultra = 1,
							/obj/item/weapon/stock_parts/subspace/crystal = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5
							)

/datum/design/circuit/fusion/core/bluespace_confinement
	name = "internal circuitry (bluespace-confined fusion core)"
	build_path = /obj/machinery/power/fusion_core/bluespace_confinement
	board_type = "machine"
	origin_tech = list(TECH_BLUESPACE = 4, TECH_MAGNET = 5, TECH_POWER = 5)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator/pico = 2,
							/obj/item/weapon/stock_parts/micro_laser/ultra = 1,
							/obj/item/weapon/stock_parts/subspace/crystal = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5
							// some advanced fusion product material
							)

/obj/item/weapon/circuitboard/fusion_injector
	name = "internal circuitry (fusion fuel injector)"
	build_path = /obj/machinery/fusion_fuel_injector
	board_type = "machine"
	origin_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 4, TECH_MATERIAL = 4)
	req_components = list(
							/obj/item/weapon/stock_parts/manipulator/pico = 2,
							/obj/item/weapon/stock_parts/scanning_module/phasic = 1,
							/obj/item/weapon/stock_parts/matter_bin/super = 1,
							/obj/item/weapon/stock_parts/console_screen = 1,
							/obj/item/stack/cable_coil = 5
							)

/obj/item/weapon/circuitboard/gyrotron
	name = "internal circuitry (gyrotron)"
	build_path = /obj/machinery/power/emitter/gyrotron
	board_type = "machine"
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_MATERIAL = 4)
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator/nano = 2,
		/obj/item/weapon/gun/energy/gun/nuclear = 1
		/obj/item/stack/cable_coil = 5
		)

/obj/item/weapon/circuitboard/efficient_gyrotron
	name = "internal circuitry (efficient gyrotron)"
	build_path = /obj/machinery/power/emitter/gyrotron/efficient
	board_type = "machine"
	origin_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5, TECH_MATERIAL = 5)
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator/pico = 2,
		/obj/item/weapon/gun/energy/gun/nuclear = 1
		/obj/item/stack/cable_coil = 5
		// some advanced fusion product material
		)

/obj/item/weapon/circuitboard/overclocked_gyrotron/
	name = "internal circuitry (overclocked gyrotron)"
	build_path = /obj/machinery/power/emitter/gyrotron/overclocked
	board_type = "machine"
	origin_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5, TECH_MATERIAL = 5)
	req_components = list(
		/obj/item/weapon/stock_parts/manipulator/pico = 2,
		/obj/item/weapon/gun/energy/gun/nuclear = 1
		/obj/item/stack/cable_coil = 5
		// some advanced fusion product material
		)

/datum/design/circuit/fusion
	name = "fusion core control console"
	id = "fusion_core_control"
	build_path = /obj/item/weapon/circuitboard/fusion/core_control
	sort_string = "LAAAD"
	req_tech = list(TECH_POWER = 3, TECH_ENGINEERING = 3, TECH_MATERIAL = 3)

/datum/design/circuit/fusion/fuel_compressor
	name = "fusion fuel compressor"
	id = "fusion_fuel_compressor"
	build_path = /obj/item/weapon/circuitboard/fusion_fuel_compressor
	sort_string = "LAAAE"

/datum/design/circuit/fusion/fuel_control
	name = "fusion fuel control console"
	id = "fusion_fuel_control"
	build_path = /obj/item/weapon/circuitboard/fusion_fuel_control
	sort_string = "LAAAF"

/datum/design/circuit/fusion/gyrotron_control
	name = "gyrotron control console"
	id = "gyrotron_control"
	build_path = /obj/item/weapon/circuitboard/gyrotron_control
	sort_string = "LAAAG"

/datum/design/circuit/fusion/core
	name = "fusion core"
	id = "fusion_core"
	build_path = /obj/item/weapon/circuitboard/fusion_core
	sort_string = "LAAAH"

/datum/design/circuit/fusion/core/bluespace_confinement
	name = "bluespace-confinement fusion core"
	id = "fusion_core"
	build_path = /obj/item/weapon/circuitboard/fusion_core/bluespace_confinement
	sort_string = "LAAAI"

/datum/design/circuit/fusion/injector
	name = "fusion fuel injector"
	id = "fusion_injector"
	build_path = /obj/item/weapon/circuitboard/fusion_injector
	sort_string = "LAAAJ"

/datum/design/circuit/fusion/kinetic_harvester
	name = "fusion toroid kinetic harvester"
	id = "fusion_kinetic_harvester"
	build_path = /obj/item/weapon/circuitboard/kinetic_harvester
	sort_string = "LAAAK"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_MATERIAL = 4)

/datum/design/circuit/fusion/gyrotron
	name = "gyrotron"
	id = "fusion_gyrotron"
	build_path = /obj/item/weapon/circuitboard/gyrotron
	sort_string = "LAAAL"
	req_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 4, TECH_MATERIAL = 4)

/datum/design/circuit/fusion/efficient_gyrotron
	name = "efficient gyrotron"
	id = "fusion_efficient_gyrotron"
	build_path = /obj/item/weapon/circuitboard/efficient_gyrotron
	sort_string = "LAAAM"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5, TECH_MATERIAL = 5)

/datum/design/circuit/fusion/overclocked_gyrotron
	name = "overclocked gyrotron"
	id = "fusion_overclocked_gyrotron"
	build_path = /obj/item/weapon/circuitboard/overclocked_gyrotron
	sort_string = "LAAAN"
	req_tech = list(TECH_DATA = 5, TECH_ENGINEERING = 5, TECH_MATERIAL = 5)