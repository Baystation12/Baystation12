


/* CAPACITORS */

/datum/research_design/basic_capacitor
	build_type = PROTOLATHE
	required_materials = list("steel" = 50, "glass" = 10)
	required_reagents = list(/datum/reagent/lithium = 10)
	product_type = /obj/item/weapon/stock_parts/capacitor

/datum/research_design/adv_capacitor
	build_type = PROTOLATHE
	required_materials = list("steel" = 40, "plasteel" = 10, "glass" = 5, "phglass" = 5, "phoron" = 5)
	required_reagents = list(/datum/reagent/lithium = 10)
	product_type = /obj/item/weapon/stock_parts/capacitor/adv

/datum/research_design/super_capacitor
	build_type = PROTOLATHE
	required_materials = list("steel" = 30, "plasteel" = 10, "mhydrogen" = 10, "phglass" = 10, "phoron" = 5, "kemocite" = 5)
	required_reagents = list(/datum/reagent/lithium = 10)
	product_type = /obj/item/weapon/stock_parts/capacitor/super



/* MANIPULATORS */

/datum/research_design/micro_mani
	build_type = PROTOLATHE
	required_materials = list("steel" = 30)
	product_type = /obj/item/weapon/stock_parts/manipulator

/datum/research_design/nano_mani
	build_type = PROTOLATHE
	required_materials = list("steel" = 20, "plasteel" = 10, "diamond" = 1)
	product_type = /obj/item/weapon/stock_parts/manipulator/nano

/datum/research_design/pico_mani
	build_type = PROTOLATHE
	required_materials = list("steel" = 10, "plasteel" = 10, "diamond" = 1, "platinum" = 10)
	product_type = /obj/item/weapon/stock_parts/manipulator/pico



/* MATTER BINS */

/datum/research_design/basic_matter_bin
	build_type = PROTOLATHE
	required_materials = list("steel" = 80)
	required_reagents = list(/datum/reagent/mercury = 10)
	product_type = /obj/item/weapon/stock_parts/matter_bin

/datum/research_design/adv_matter_bin
	build_type = PROTOLATHE
	required_materials = list("plasteel" = 70, "mhydrogen" = 10)
	required_reagents = list(/datum/reagent/mercury = 10)
	product_type = /obj/item/weapon/stock_parts/matter_bin/adv

/datum/research_design/super_matter_bin
	build_type = PROTOLATHE
	required_materials = list("osmium-carbide plasteel" = 60, "mhydrogen" = 10, "duridium" = 10)
	required_reagents = list(/datum/reagent/mercury = 10)
	product_type = /obj/item/weapon/stock_parts/matter_bin/super



/* LASERS */

/datum/research_design/basic_micro_laser
	build_type = PROTOLATHE
	required_materials = list("steel" = 10, "phglass" = 10)
	required_reagents = list(/datum/reagent/silicate = 10)
	product_type = /obj/item/weapon/stock_parts/micro_laser

/datum/research_design/high_micro_laser
	build_type = PROTOLATHE
	required_materials = list("plasteel" = 10, "phglass" = 20)
	required_reagents = list(/datum/reagent/silicate = 10)
	product_type = /obj/item/weapon/stock_parts/micro_laser/high

/datum/research_design/ultra_micro_laser
	build_type = PROTOLATHE
	required_materials = list("osmium-carbide plasteel" = 10, "phglass" = 20, "duridium" = 10)
	required_reagents = list(/datum/reagent/silicate = 10)
	product_type = /obj/item/weapon/stock_parts/micro_laser/ultra



/* SENSORS */

/datum/research_design/basic_sensor
	build_type = PROTOLATHE
	required_materials = list("steel" = 50, "glass" = 10)
	required_reagents = list(/datum/reagent/radium = 10)
	product_type = /obj/item/weapon/stock_parts/scanning_module

/datum/research_design/adv_sensor
	build_type = PROTOLATHE
	required_materials = list("steel" = 40, "plasteel" = 10, "glass" = 5, "rglass" = 5)
	required_reagents = list(/datum/reagent/radium = 10)
	product_type = /obj/item/weapon/stock_parts/scanning_module/adv

/datum/research_design/phasic_sensor
	build_type = PROTOLATHE
	required_materials = list("steel" = 30, "osmium-carbide plasteel" = 10, "rglass" = 5, "phglass" = 5)
	required_reagents = list(/datum/reagent/radium = 10)
	product_type = /obj/item/weapon/stock_parts/scanning_module/phasic
