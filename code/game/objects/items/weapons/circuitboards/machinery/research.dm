#ifndef T_BOARD
#error T_BOARD macro is not defined but we need it! 
#endif

obj/item/weapon/circuitboard/rdserver
	name = T_BOARD("R&D server")
	build_path = "/obj/machinery/r_n_d/server"
	board_type = "machine"
	origin_tech = "programming=3"
	req_components = list(
							"/obj/item/stack/cable_coil" = 2,
							"/obj/item/weapon/stock_parts/scanning_module" = 1)

/obj/item/weapon/circuitboard/destructive_analyzer
	name = T_BOARD("destructive analyzer")
	build_path = "/obj/machinery/r_n_d/destructive_analyzer"
	board_type = "machine"
	origin_tech = "magnets=2;engineering=2;programming=2"
	req_components = list(
							"/obj/item/weapon/stock_parts/scanning_module" = 1,
							"/obj/item/weapon/stock_parts/manipulator" = 1,
							"/obj/item/weapon/stock_parts/micro_laser" = 1)

/obj/item/weapon/circuitboard/autolathe
	name = T_BOARD("autolathe")
	build_path = "/obj/machinery/autolathe"
	board_type = "machine"
	origin_tech = "engineering=2;programming=2"
	req_components = list(
							"/obj/item/weapon/stock_parts/matter_bin" = 3,
							"/obj/item/weapon/stock_parts/manipulator" = 1,
							"/obj/item/weapon/stock_parts/console_screen" = 1)

/obj/item/weapon/circuitboard/protolathe
	name = T_BOARD("protolathe")
	build_path = "/obj/machinery/r_n_d/protolathe"
	board_type = "machine"
	origin_tech = "engineering=2;programming=2"
	req_components = list(
							"/obj/item/weapon/stock_parts/matter_bin" = 2,
							"/obj/item/weapon/stock_parts/manipulator" = 2,
							"/obj/item/weapon/reagent_containers/glass/beaker" = 2)


/obj/item/weapon/circuitboard/circuit_imprinter
	name = T_BOARD("circuit imprinter")
	build_path = "/obj/machinery/r_n_d/circuit_imprinter"
	board_type = "machine"
	origin_tech = "engineering=2;programming=2"
	req_components = list(
							"/obj/item/weapon/stock_parts/matter_bin" = 1,
							"/obj/item/weapon/stock_parts/manipulator" = 1,
							"/obj/item/weapon/reagent_containers/glass/beaker" = 2)

/obj/item/weapon/circuitboard/mechfab
	name = "Circuit board (Exosuit Fabricator)"
	build_path = "/obj/machinery/mecha_part_fabricator"
	board_type = "machine"
	origin_tech = "programming=3;engineering=3"
	req_components = list(
							"/obj/item/weapon/stock_parts/matter_bin" = 2,
							"/obj/item/weapon/stock_parts/manipulator" = 1,
							"/obj/item/weapon/stock_parts/micro_laser" = 1,
							"/obj/item/weapon/stock_parts/console_screen" = 1)
