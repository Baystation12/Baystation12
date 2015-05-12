#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

/obj/item/weapon/circuitboard/recharge_station
	name = T_BOARD("cyborg recharging station")
	build_path = "/obj/machinery/recharge_station"
	board_type = "machine"
	origin_tech = "programming=3;engineering=3"
	req_components = list(
							"/obj/item/stack/cable_coil" = 5,
							"/obj/item/weapon/stock_parts/capacitor" = 2,
							"/obj/item/weapon/stock_parts/manipulator" = 2,
							"/obj/item/weapon/cell" = 1)