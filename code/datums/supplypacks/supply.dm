/decl/hierarchy/supply_pack/supply
	name = "Supplies - Comissary"
	containertype = /obj/structure/closet/crate

/decl/hierarchy/supply_pack/supply/toner
	name = "Refills - Toner cartridges"
	contains = list(/obj/item/device/toner = 3)
	cost = 10
	containername = "toner cartridges"

/decl/hierarchy/supply_pack/supply/cardboard_sheets
	name = "Material - cardboard sheets (50)"
	contains = list(/obj/item/stack/material/cardboard/fifty)
	cost = 10
	containername = "cardboard sheets crate"

/decl/hierarchy/supply_pack/supply/stickies
	name = "Stationery - sticky notes (50)"
	contains = list(/obj/item/sticky_pad/random)
	cost = 10
	containername = "\improper Sticky notes crate"

/decl/hierarchy/supply_pack/supply/wpaper
	name = "Cargo - Wrapping paper"
	contains = list(/obj/item/stack/package_wrap/twenty_five = 3)
	cost = 10
	containername = "wrapping paper"

/decl/hierarchy/supply_pack/supply/tapes
	name = "Medium - Blank Tapes (14)"
	contains = list (/obj/item/storage/box/tapes)
	cost = 10
	containername = "blank tapes crate"

/decl/hierarchy/supply_pack/supply/taperolls
	name = "G.O.S.H - Barricade Tapes (mixed)"
	contains = list (/obj/item/storage/box/taperolls)
	cost = 10
	containername = "barricade tape crate"

/decl/hierarchy/supply_pack/supply/bogrolls
	name = "Custodial - Toilet paper (12)"
	contains = list (/obj/item/storage/box/bogrolls = 2)
	cost = 10
	containername = "toilet paper crate"

/decl/hierarchy/supply_pack/supply/scanner_module
	name = "Electronics - Paper scanner modules"
	contains = list(/obj/item/stock_parts/computer/scanner/paper = 4)
	cost = 20
	containername = "paper scanner module crate"

/decl/hierarchy/supply_pack/supply/spare_pda
	name = "Electronics - Spare PDAs"
	contains = list(/obj/item/modular_computer/pda = 3)
	cost = 10
	containername = "spare PDA crate"

/decl/hierarchy/supply_pack/supply/eftpos
	contains = list(/obj/item/device/eftpos)
	name = "Electronics - EFTPOS scanner"
	cost = 10
	containername = "\improper EFTPOS crate"

/decl/hierarchy/supply_pack/supply/water
	name = "Refills - Bottled water"
	contains = list (/obj/item/storage/box/water = 2)
	cost = 12
	containername = "bottled water crate"

/decl/hierarchy/supply_pack/supply/sodas
	num_contained = 2
	contains = list(/obj/item/storage/box/cola,
					/obj/item/storage/box/cola/spacewind,
					/obj/item/storage/box/cola/drgibb,
					/obj/item/storage/box/cola/ionbru,
					/obj/item/storage/box/cola/spaceup,
					/obj/item/storage/box/cola/lemonlime,
					/obj/item/storage/box/cola/icedtea,
					/obj/item/storage/box/cola/grapejuice,
					/obj/item/storage/box/cola/sodawater,
					/obj/item/storage/box/cola/beastenergy,
				)
	name = "Refills - Soda cans"
	cost = 10
	containername = "soda can crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/supply/snacks
	num_contained = 2
	contains = list(/obj/item/storage/box/snack,
					/obj/item/storage/box/snack/jerky,
					/obj/item/storage/box/snack/noraisin,
					/obj/item/storage/box/snack/cheesehonks,
					/obj/item/storage/box/snack/tastybread,
					/obj/item/storage/box/snack/candy,
					/obj/item/storage/box/snack/chips)
	name = "Refills - Snack foods"
	cost = 10
	containername = "snack foods crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/supply/canned
	num_contained = 2
	contains = list(/obj/item/storage/box/canned,
					/obj/item/storage/box/canned/beef,
					/obj/item/storage/box/canned/beans,
					/obj/item/storage/box/canned/tomato,
)
	name = "Emergency - Canned foods"
	cost = 30
	containername = "canneds crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/supply/coolanttank
	name = "Liquid - Coolant tank"
	contains = list(/obj/structure/reagent_dispensers/coolanttank)
	cost = 16
	containertype = /obj/structure/largecrate
	containername = "coolant tank crate"

/decl/hierarchy/supply_pack/supply/fueltank
	name = "Liquid - Fuel tank"
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "fuel tank crate"

/decl/hierarchy/supply_pack/supply/watertank
	name = "Liquid - Water tank"
	contains = list(/obj/structure/reagent_dispensers/watertank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "water tank crate"

//replacement vendors
//Vending Machines
//I have decided against adding the adherent vendor because it is a modified machine as well as the security vendors, which should probably be under a bit more scrutiny than "whoever is deck tech at the time"

/decl/hierarchy/supply_pack/supply/snackvendor
	name = "Vendor - Getmoore Chocolate Co"
	contains = list(/obj/machinery/vending/snack{anchored = FALSE})
	cost = 150
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/snixvendor
	name = "Vendor - Snix Zakuson TCC"
	contains = list(/obj/machinery/vending/snix{anchored = FALSE})
	cost = 150
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/solvendor
	name = "Vendor - Mars Mart SCC"
	contains = list(/obj/machinery/vending/sol{anchored = FALSE})
	cost = 150
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/sodavendor
	name = "Vendor - Softdrinks Robust Industries LLC"
	contains = list(/obj/machinery/vending/cola{anchored = FALSE})
	cost = 150
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/lavatoryvendor
	name = "Vendor - Lavatory Essentials - Waffle Co"
	contains = list(/obj/machinery/vending/lavatory{anchored = FALSE})
	cost = 150
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/boozevendor
	name = "Vendor - Booze-o-mat - GrekkaTarg Boozeries"
	contains = list(/obj/machinery/vending/boozeomat{anchored = FALSE})
	cost = 150
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/gamevendor
	name = "Vendor - Games - Honk Co"
	contains = list(/obj/machinery/vending/games{anchored = FALSE})
	cost = 150
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/fitnessvendor
	name = "Vendor - Fitness - SwolMAX Bros"
	contains = list(/obj/machinery/vending/fitness{anchored = FALSE})
	cost = 150
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/cigarettevendor
	name = "Vendor - Cigarettes - Gideon Asbestos Mining Conglomerate"
	contains = list(/obj/machinery/vending/cigarette{anchored = FALSE})
	cost = 150
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/roboticsvendor
	name = "Vendor - Robotics - Dandytronics LLT"
	contains = list(/obj/machinery/vending/robotics{anchored = FALSE})
	cost = 150
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/engineeringvendor
	name = "Vendor - Engineering - Dandytronics LLT"
	contains = list(/obj/machinery/vending/engineering{anchored = FALSE})
	cost = 150
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/toolvendor
	name = "Vendor - Tools - YouTool Co"
	contains = list(/obj/machinery/vending/tool{anchored = FALSE})
	cost = 150
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/coffeevendor
	name = "Vendor - Coffee - Hot Drinks LCD"
	contains = list(/obj/machinery/vending/coffee{anchored = FALSE})
	cost = 150
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/dinnerwarevendor
	name = "Vendor - Dinnerwares - Plastic Tat Inc"
	contains = list(/obj/machinery/vending/dinnerware{anchored = FALSE})
	cost = 150
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/bodavendor
	name = "Vendor - BODA - Zakuson TCC"
	contains = list(/obj/machinery/vending/sovietsoda{anchored = FALSE})
	cost = 250
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"

/decl/hierarchy/supply_pack/supply/weebvendor
	name = "Vendor - Nippon-tan - ArigatoRobotics LCD"
	contains = list(/obj/machinery/vending/weeb{anchored = FALSE})
	cost = 50
	containertype = /obj/structure/largecrate
	containername = "\improper Vending Machine"
