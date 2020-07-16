
/datum/research_design/lantern
	name = "mining lantern"
	desc = "An upgraded version of the standard flashlight for industrial uses."
	product_type = /obj/item/device/flashlight/lantern
	build_type = PROTOLATHE
	complexity = 3
	required_reagents = list(/datum/reagent/phosphorus = 5)
	required_materials = list("steel" = 10)
	required_objs = list(/obj/item/device/flashlight)

/datum/research_design/drill
	name = "mining drill"
	desc = "A basic, upgradeable tool for extracting ore out of the ground."
	product_type = /obj/item/weapon/pickaxe
	build_type = PROTOLATHE
	complexity = 3
	required_materials = list("steel" = 10, "plasteel" = 5)
	required_objs = list(/obj/item/weapon/stock_parts/capacitor)

/datum/research_design/adv_drill
	name = "advanced mining drill"
	desc = "Upgraded with osmium-carbide tips allow for faster mining."
	product_type = /obj/item/weapon/pickaxe/drill
	build_type = PROTOLATHE
	complexity = 5
	required_materials = list("plasteel" = 10, "osmium-carbide plasteel" = 5)
	required_objs = list(\
		/obj/item/weapon/pickaxe,\
		/obj/item/weapon/stock_parts/capacitor/adv,\
		/obj/item/weapon/stock_parts/manipulator)

/datum/research_design/diamonddrill
	name = "diamond mining drill"
	desc = "Upgraded with diamond tips allow for faster mining."
	product_type = /obj/item/weapon/pickaxe/diamonddrill
	build_type = PROTOLATHE
	complexity = 7
	required_materials = list("osmium-carbide plasteel" = 10, "diamond" = 5)
	required_objs = list(
		/obj/item/weapon/pickaxe/drill,\
		/obj/item/weapon/stock_parts/capacitor/super,\
		/obj/item/weapon/stock_parts/manipulator/nano)

/datum/research_design/jackhammer
	name = "sonic jackhammer"
	desc = "Upgraded sonic disintegrators replace physical drill tips for faster mining."
	product_type = /obj/item/weapon/pickaxe/jackhammer
	build_type = PROTOLATHE
	complexity = 9
	required_materials = list("duridium" = 10)
	required_objs = list(\
		/obj/item/weapon/pickaxe/diamonddrill,\
		/obj/item/weapon/stock_parts/manipulator/pico)

/datum/research_design/plasmacutter
	name = "plasma cutter"
	desc = "Reverse engineered plasma technology allows for instant ore extraction."
	product_type = /obj/item/weapon/pickaxe/plasmacutter
	build_type = PROTOLATHE
	complexity = 11
	required_materials = list("duridium" = 10, "nanolaminate" = 5)
	required_objs = list(/obj/item/plasma_core)
