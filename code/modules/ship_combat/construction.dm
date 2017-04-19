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
	origin_tech = list(TECH_DATA = 2, TECH_COMAT = 1, TECH_MATERIAL = 2)

/*****
*MISC*
******/

/obj/item/weapon/circuitboard/space_battle/missile_computer
	name = T_BOARD("missile targetting computer")

	build_path = /obj/machinery/space_battle/computer/targeting

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

/obj/item/weapon/circuitboard/space_battle/engine_control
	name = T_BOARD("engine control")
	build_path = /obj/machinery/space_battle/computer/engine_control
	req_components = list(/obj/item/stack/cable_coil = 15,
						  /obj/item/weapon/stock_parts/capacitor = 2,
						  /obj/item/stack/material/steel = 5,
						  /obj/item/upgrade_module = 1)

/obj/item/weapon/circuitboard/space_battle/warp_pad
	name = T_BOARD("warp pad")
	build_path = /obj/machinery/space_battle/warp_pad
	req_components = list(/obj/item/stack/cable_coil = 50,
						  /obj/item/weapon/stock_parts/capacitor = 5,
						  /obj/item/weapon/cell = 1,
						  /obj/item/stack/material/steel = 5,
						  /obj/item/upgrade_module = 1)
	origin_tech = list(TECH_DATA = 4, TECH_ENGINEERING = 3, TECH_BLUESPACE = 2)

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

/obj/item/weapon/circuitboard/space_battle/sensor/scanning
	name = T_BOARD("scanning sensor")
	build_path = /obj/machinery/space_battle/missile_sensor/scanning

/obj/item/weapon/circuitboard/space_battle/sensor/thermal
	name = T_BOARD("thermal sensor")
	build_path = /obj/machinery/space_battle/missile_sensor/thermal

/obj/item/weapon/circuitboard/space_battle/sensor/xray
	name = T_BOARD("xray sensor")
	build_path = /obj/machinery/space_battle/missile_sensor/xray

/obj/item/weapon/circuitboard/space_battle/sensor/microwave
	name = T_BOARD("microwave sensor")
	build_path = /obj/machinery/space_battle/missile_sensor/microwave

/obj/item/weapon/circuitboard/space_battle/sensor/guidance
	name = T_BOARD("guidance sensor")
	build_path = /obj/machinery/space_battle/missile_sensor/guidance

/obj/item/weapon/circuitboard/space_battle/sensor/radar
	name = T_BOARD("radar sensor")
	build_path = /obj/machinery/space_battle/missile_sensor/radar

/obj/item/weapon/circuitboard/space_battle/sensor/advguidance
	name = T_BOARD("advanced guidance sensor")
	build_path = /obj/machinery/space_battle/missile_sensor/advguidance

/obj/item/weapon/circuitboard/space_battle/sensor/hub
	name = T_BOARD("hub sensor port")
	build_path = /obj/machinery/space_battle/missile_sensor/hub

/obj/item/weapon/circuitboard/space_battle/sensor/dish
	name = T_BOARD("external sensor dish")
	build_path = /obj/machinery/space_battle/missile_sensor/dish/built

/obj/item/weapon/circuitboard/space_battle/sensor/gravity
	name = T_BOARD("active gravity sensor")
	build_path = /obj/machinery/space_battle/missile_sensor/ship_sensor/gravity

/obj/item/weapon/circuitboard/space_battle/sensor/em
	name = T_BOARD("active em sensor")
	build_path = /obj/machinery/space_battle/missile_sensor/ship_sensor/em

/obj/item/weapon/circuitboard/space_battle/sensor/thermal
	name = T_BOARD("active thermal sensor")
	build_path = /obj/machinery/space_battle/missile_sensor/ship_sensor/thermal
