
/datum/research_design/portable_drive
	name = "basic data crystal"
	product_type = /obj/item/weapon/computer_hardware/hard_drive/portable
	build_type = IMPRINTER
	required_materials = list("steel" = 1, "glass" = 1, "plastic" = 5)
	required_reagents = list(/datum/reagent/acid = 20)
	complexity = 5

/datum/research_design/portable_drive_advanced
	name = "advanced data crystal"
	product_type = /obj/item/weapon/computer_hardware/hard_drive/portable/advanced
	build_type = IMPRINTER
	required_materials = list("plasteel" = 1, "rglass" = 1, "plastic" = 5)
	required_reagents = list(/datum/reagent/acid/hydrochloric = 20)
	complexity = 15

/datum/research_design/portable_drive_super
	name = "super data crystal"
	product_type = /obj/item/weapon/computer_hardware/hard_drive/portable/super
	build_type = IMPRINTER
	required_materials = list("osmium-carbide plasteel" = 1, "phglass" = 1, "plastic" = 5)
	required_reagents = list(/datum/reagent/nitric_acid = 20)
	complexity = 25
