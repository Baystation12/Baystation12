#define VENDOR_BOARD(name_val, suffix) \
/obj/item/weapon/stock_parts/circuitboard/vending/##suffix{ \
	name = T_BOARD(name_val); \
	board_type = "machine"; \
	build_path = /obj/machinery/vending/##suffix; \
	origin_tech = list(TECH_ENGINEERING = 1, TECH_MATERIAL = 2); \
	req_components = list(\
							/obj/item/weapon/stock_parts/matter_bin = 2,\
							/obj/item/weapon/stock_parts/manipulator = 2)\
}

VENDOR_BOARD("Booze-O-Mat", boozeomat)
VENDOR_BOARD("Vendomat", assist)
VENDOR_BOARD("Hot Drinks machine", coffee)
VENDOR_BOARD("Getmore Chocolate Corp", snack)
VENDOR_BOARD("Robust Softdrinks", cola)
VENDOR_BOARD("SweatMAX", fitness)
VENDOR_BOARD("Cigarette machine", cigarette)
VENDOR_BOARD("NanoMed Plus", medical)
VENDOR_BOARD("Toximate 3000", phoronresearch)
VENDOR_BOARD("NanoMed", wallmed1)
VENDOR_BOARD("NanoMed Mini", wallmed2)
VENDOR_BOARD("SecTech", security)
VENDOR_BOARD("NutriMax", hydronutrients)
VENDOR_BOARD("MegaSeed Servitor", hydroseeds)
VENDOR_BOARD("Dinnerware", dinnerware)
VENDOR_BOARD("BODA", sovietsoda)
VENDOR_BOARD("YouTool", tool)
VENDOR_BOARD("Adherent Tool Dispenser", tool/adherent)
VENDOR_BOARD("Engi-Vend", engivend)
VENDOR_BOARD("Robco Tool Maker", engineering)
VENDOR_BOARD("Robotech Deluxe", robotics)
VENDOR_BOARD("container dispenser", containers)
VENDOR_BOARD("Smashing Fashions", fashionvend)
VENDOR_BOARD("Good Clean Fun", games)
VENDOR_BOARD("Lavatory Essentials", lavatory)
VENDOR_BOARD("Snix", snix)
VENDOR_BOARD("Hot Foods", hotfood)