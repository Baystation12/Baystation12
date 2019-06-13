#define SUIT_CYCLER_BOARD(name_val, suffix) \
/obj/item/weapon/stock_parts/circuitboard/cycler/##suffix{ \
	name = T_BOARD(name_val + " suit cycler"); \
	board_type = "machine"; \
	build_path = /obj/machinery/suit_cycler/##suffix; \
	origin_tech = list(TECH_ENGINEERING = 4, TECH_MATERIAL = 4, TECH_POWER = 2); \
	req_components = list(\
							/obj/item/weapon/stock_parts/matter_bin = 2,\
							/obj/item/weapon/stock_parts/micro_laser = 2,\
							/obj/item/weapon/stock_parts/manipulator = 2)\
}

SUIT_CYCLER_BOARD("engineering", engineering/alt)
SUIT_CYCLER_BOARD("mining", mining)
SUIT_CYCLER_BOARD("science", science)
SUIT_CYCLER_BOARD("security", security/alt)
SUIT_CYCLER_BOARD("medical", medical/alt)
SUIT_CYCLER_BOARD("pilot", pilot)