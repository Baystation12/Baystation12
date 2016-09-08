/obj/item/weapon/circuitboard/space_battle
	name = T_BOARD("industrial machinery")
	build_path = /obj/machinery/space_battle
	board_type = "machine"
	origin_tech = list(TECH_DATA = 2, TECH_POWER = 2, TECH_COMBAT = 3, TECH_ENGINEERING = 2)
	req_components = list(	/obj/item/weapon/stock_parts/matter_bin = 1,
							/obj/item/weapon/stock_parts/micro_laser = 1,
							/obj/item/stack/cable_coil = 2,
							/obj/item/weapon/stock_parts/capacitor = 1,
							/obj/item/upgrade_module = 1)

/*****
*MISC*
******/

/obj/item/weapon/circuitboard/space_battle/missile_computer
	name = T_BOARD("missile targetting computer")

	build_path = /obj/machinery/space_battle/missile_computer

	req_components = list(/obj/item/stack/cable_coil = 10,
						  /obj/item/weapon/stock_parts/capacitor = 2,
						  /obj/item/weapon/stock_parts/micro_laser = 1,
						  /obj/item/weapon/stock_parts/manipulator = 2,
						  /obj/item/stack/material/glass/reinforced = 10,
						  /obj/item/stack/material/steel = 5,
						  /obj/item/upgrade_module = 1)

/obj/item/weapon/circuitboard/space_battle/missile_launch_tube
	name = T_BOARD("missile launch tube")
	build_path = /obj/machinery/space_battle/tube
	req_components = list(/obj/item/stack/cable_coil = 30,
						  /obj/item/weapon/stock_parts/capacitor = 2,
						  /obj/item/weapon/stock_parts/micro_laser = 2,
						  /obj/item/weapon/stock_parts/manipulator = 2,
						  /obj/item/weapon/stock_parts/matter_bin = 1,
						  /obj/item/stack/material/steel = 15,
						  /obj/item/stack/material/plasteel = 5,
						  /obj/item/upgrade_module = 1)

/obj/item/weapon/circuitboard/space_battle/ecm
	name = T_BOARD("electronic counter measures")
	build_path = /obj/machinery/space_battle/ecm
	req_components = list(/obj/item/stack/cable_coil = 30,
						  /obj/item/weapon/stock_parts/capacitor = 2,
						  /obj/item/weapon/stock_parts/micro_laser = 1,
						  /obj/item/weapon/stock_parts/manipulator = 2,
						  /obj/item/weapon/cell = 1,
						  /obj/item/weapon/component/ecm = 1,
						  /obj/item/stack/material/steel = 10,
						  /obj/item/upgrade_module = 1)

/obj/item/weapon/circuitboard/space_battle/fueled_engine
	name = T_BOARD("fueled engine")
	build_path = /obj/machinery/space_battle/engine/fuelled
	req_components = list(/obj/item/stack/cable_coil = 15,
						  /obj/item/weapon/stock_parts/capacitor = 2,
						  /obj/item/weapon/cell = 2,
						  /obj/item/weapon/component/engine/fuel = 1,
						  /obj/item/stack/material/steel = 10,
						  /obj/item/upgrade_module = 1)

/obj/item/weapon/circuitboard/space_battle/electric_engine
	name = T_BOARD("electric engine")
	build_path = /obj/machinery/space_battle/engine/electric
	req_components = list(/obj/item/stack/cable_coil = 15,
						  /obj/item/weapon/stock_parts/capacitor = 2,
						  /obj/item/weapon/cell = 2,
						  /obj/item/weapon/component/engine/ion = 1,
						  /obj/item/stack/material/steel = 15,
						  /obj/item/upgrade_module = 1)

/********
*SENSORS*
*********/
/obj/item/weapon/circuitboard/space_battle/sensor
	name = T_BOARD("sensor")
	build_path = /obj/machinery/space_battle/missile_sensor
	req_components = list(/obj/item/stack/cable_coil = 15,
						  /obj/item/weapon/stock_parts/capacitor = 2,
						  /obj/item/weapon/cell = 1,
						  /obj/item/stack/material/steel = 15,
						  /obj/item/upgrade_module = 1)

/obj/item/weapon/circuitboard/space_battle/sensor/tracking
	name = T_BOARD("tracking sensor")
	build_path = /obj/machinery/space_battle/missile_sensor/tracking

/obj/item/weapon/circuitboard/space_battle/sensor/scanner/scanning
	name = T_BOARD("scanning sensor")
	build_path = /obj/machinery/space_battle/missile_sensor/scanning

/obj/item/weapon/circuitboard/space_battle/sensor/scanner/thermal
	name = T_BOARD("thermal sensor")
	build_path = /obj/machinery/space_battle/missile_sensor/thermal

/obj/item/weapon/circuitboard/space_battle/sensor/scanner/xray
	name = T_BOARD("xray sensor")
	build_path = /obj/machinery/space_battle/missile_sensor/xray

/obj/item/weapon/circuitboard/space_battle/sensor/scanner/microwave
	name = T_BOARD("microwave sensor")
	build_path = /obj/machinery/space_battle/missile_sensor/microwave

/obj/item/weapon/circuitboard/space_battle/sensor/scanner/guidance
	name = T_BOARD("guidance sensor")
	build_path = /obj/machinery/space_battle/missile_sensor/guidance

/obj/item/weapon/circuitboard/space_battle/sensor/scanner/radar
	name = T_BOARD("radar sensor")
	build_path = /obj/machinery/space_battle/missile_sensor/radar

/obj/item/weapon/circuitboard/space_battle/sensor/scanner/advguidance
	name = T_BOARD("advanced guidance sensor")
	build_path = /obj/machinery/space_battle/missile_sensor/advguidance

/obj/item/weapon/circuitboard/space_battle/sensor/scanner/hub
	name = T_BOARD("hub sensor port")
	build_path = /obj/machinery/space_battle/missile_sensor/hub

/obj/item/weapon/circuitboard/space_battle/sensor/scanner/dish
	name = T_BOARD("external sensor dish")
	build_path = /obj/machinery/space_battle/missile_sensor/dish