#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

/obj/item/weapon/circuitboard/pacman
	name = T_BOARD("PACMAN-type generator")
	build_path = "/obj/machinery/power/port_gen/pacman"
	board_type = "machine"
	origin_tech = "programming=3;powerstorage=3;phorontech=3;engineering=3"
	req_components = list(
							"/obj/item/weapon/stock_parts/matter_bin" = 1,
							"/obj/item/weapon/stock_parts/micro_laser" = 1,
							"/obj/item/stack/cable_coil" = 2,
							"/obj/item/weapon/stock_parts/capacitor" = 1)

/obj/item/weapon/circuitboard/pacman/super
	name = T_BOARD("SUPERPACMAN-type generator")
	build_path = "/obj/machinery/power/port_gen/pacman/super"
	origin_tech = "programming=3;powerstorage=4;engineering=4"

/obj/item/weapon/circuitboard/pacman/mrs
	name = T_BOARD("MRSPACMAN-type generator")
	build_path = "/obj/machinery/power/port_gen/pacman/mrs"
	origin_tech = "programming=3;powerstorage=5;engineering=5"
