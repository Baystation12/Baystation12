/decl/hierarchy/supply_pack/supply
	name = "Supplies - Comissary"
	containertype = /obj/structure/closet/crate

/decl/hierarchy/supply_pack/supply/toner
	name = "Refills - Toner cartridges"
	contains = list(/obj/item/device/toner = 3)
	cost = 10
	containername = "\improper Toner cartridges"

/decl/hierarchy/supply_pack/supply/cardboard_sheets
	name = "Material - cardboard sheets (50)"
	contains = list(/obj/item/stack/material/cardboard/fifty)
	cost = 10
	containername = "\improper Cardboard sheets crate"

/decl/hierarchy/supply_pack/supply/cardboard_sheets
	name = "Stationery - sticky notes (50)"
	contains = list(/obj/item/sticky_pad/random)
	cost = 10
	containername = "\improper Sticky notes crate"

/decl/hierarchy/supply_pack/supply/wpaper
	name = "Cargo - Wrapping paper"
	contains = list(/obj/item/stack/package_wrap/twenty_five = 3)
	cost = 10
	containername = "\improper Wrapping paper"

/decl/hierarchy/supply_pack/supply/tapes
	name = "Medium - Blank Tapes (14)"
	contains = list (/obj/item/weapon/storage/box/tapes)
	cost = 10
	containername = "\improper Blank tapes crate"

/decl/hierarchy/supply_pack/supply/scanner_module
	name = "Electronics - Paper scanner module crate"
	contains = list(/obj/item/weapon/computer_hardware/scanner/paper = 4)
	cost = 20
	containername = "\improper Paper scanner module crate"

/decl/hierarchy/supply_pack/supply/spare_pda
	name = "Electronics - Spare PDAs"
	contains = list(/obj/item/modular_computer/pda = 3)
	cost = 10
	containername = "\improper Spare PDA crate"

/decl/hierarchy/supply_pack/supply/eftpos
	contains = list(/obj/item/device/eftpos)
	name = "Electronics - EFTPOS scanner"
	cost = 10
	containername = "\improper EFTPOS crate"

/decl/hierarchy/supply_pack/supply/water
	name = "Refills - Bottled water crate"
	contains = list (/obj/item/weapon/storage/box/water = 2)
	cost = 12
	containername = "\improper Bottled water crate"

/decl/hierarchy/supply_pack/supply/sodas
	num_contained = 2
	contains = list(/obj/item/weapon/storage/box/cola,
					/obj/item/weapon/storage/box/cola/spacewind,
					/obj/item/weapon/storage/box/cola/drgibb,
					/obj/item/weapon/storage/box/cola/starkist,
					/obj/item/weapon/storage/box/cola/spaceup,
					/obj/item/weapon/storage/box/cola/lemonlime,
					/obj/item/weapon/storage/box/cola/icedtea,
					/obj/item/weapon/storage/box/cola/grapejuice,
					/obj/item/weapon/storage/box/cola/sodawater)
	name = "Refills - Soda can crate"
	cost = 10
	containername = "\improper Soda can crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/supply/snacks
	num_contained = 2
	contains = list(/obj/item/weapon/storage/box/snack,
					/obj/item/weapon/storage/box/snack/jerky,
					/obj/item/weapon/storage/box/snack/noraisin,
					/obj/item/weapon/storage/box/snack/cheesehonks,
					/obj/item/weapon/storage/box/snack/tastybread,
					/obj/item/weapon/storage/box/snack/candy,
					/obj/item/weapon/storage/box/snack/chips)
	name = "Refills - Snack foods crate"
	cost = 10
	containername = "\improper Snack foods crate"
	supply_method = /decl/supply_method/randomized

/decl/hierarchy/supply_pack/supply/coolanttank
	name = "Liquid - Coolant tank crate"
	contains = list(/obj/structure/reagent_dispensers/coolanttank)
	cost = 16
	containertype = /obj/structure/largecrate
	containername = "\improper coolant tank crate"

/decl/hierarchy/supply_pack/supply/fueltank
	name = "Liquid - Fuel tank crate"
	contains = list(/obj/structure/reagent_dispensers/fueltank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "\improper fuel tank crate"

/decl/hierarchy/supply_pack/supply/watertank
	name = "Liquid - Water tank crate"
	contains = list(/obj/structure/reagent_dispensers/watertank)
	cost = 8
	containertype = /obj/structure/largecrate
	containername = "\improper water tank crate"