
/datum/research_design/drive
	name = "basic hard drive"
	product_type = /obj/item/weapon/computer_hardware/hard_drive
	build_type = IMPRINTER
	required_materials = list("steel" = 1, "glass" = 1, "plastic" = 10)
	required_objs = list(/obj/item/crystal)
	required_reagents = list(/datum/reagent/acid = 20)
	complexity = 5

/datum/research_design/drive_advanced
	name = "advanced hard drive"
	product_type = /obj/item/weapon/computer_hardware/hard_drive/advanced
	build_type = IMPRINTER
	required_materials = list("plasteel" = 1, "rglass" = 1, "plastic" = 10)
	required_objs = list(/obj/item/crystal)
	required_reagents = list(/datum/reagent/acid/hydrochloric = 20)
	complexity = 15

/datum/research_design/drive_super
	name = "super hard drive"
	product_type = /obj/item/weapon/computer_hardware/hard_drive/super
	build_type = IMPRINTER
	required_materials = list("osmium-carbide plasteel" = 1, "phglass" = 1, "plastic" = 10)
	required_objs = list(/obj/item/crystal)
	required_reagents = list(/datum/reagent/nitric_acid = 20)
	complexity = 25

/datum/research_design/drive_cluster
	name = "cluster hard drive"
	product_type = /obj/item/weapon/computer_hardware/hard_drive/cluster
	build_type = IMPRINTER
	required_materials = list("duridium" = 1, "rphglass" = 1, "plastic" = 10)
	required_objs = list(/obj/item/crystal)
	required_reagents = list(/datum/reagent/acid/polyacid = 20)
	complexity = 25
