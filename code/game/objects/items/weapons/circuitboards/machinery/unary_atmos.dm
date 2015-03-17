#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

/obj/item/weapon/circuitboard/unary_atmos
	board_type = "machine"

/obj/item/weapon/circuitboard/unary_atmos/construct(var/obj/machinery/atmospherics/unary/U)
	//TODO: Move this stuff into the relevant constructor when pipe/construction.dm is cleaned up.
	U.initialize()
	U.build_network()
	if (U.node)
		U.node.initialize()
		U.node.build_network()

/obj/item/weapon/circuitboard/unary_atmos/heater
	name = T_BOARD("gas heating system")
	build_path = "/obj/machinery/atmospherics/unary/heater"
	origin_tech = "powerstorage=2;engineering=1"
	frame_desc = "Requires 5 Pieces of Cable, 1 Matter Bin, and 2 Capacitors."
	req_components = list(
							"/obj/item/stack/cable_coil" = 5,
							"/obj/item/weapon/stock_parts/matter_bin" = 1,
							"/obj/item/weapon/stock_parts/capacitor" = 2)

/obj/item/weapon/circuitboard/unary_atmos/cooler
	name = T_BOARD("gas cooling system")
	build_path = "/obj/machinery/atmospherics/unary/freezer"
	origin_tech = "magnets=2;engineering=2"
	frame_desc = "Requires 2 Pieces of Cable, 1 Matter Bin, 1 Micro Manipulator, and 2 Capacitors."
	req_components = list(
							"/obj/item/stack/cable_coil" = 2,
							"/obj/item/weapon/stock_parts/matter_bin" = 1,
							"/obj/item/weapon/stock_parts/capacitor" = 2,
							"/obj/item/weapon/stock_parts/manipulator" = 1)
