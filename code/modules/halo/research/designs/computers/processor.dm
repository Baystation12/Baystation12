
/datum/research_design/processor
	name = "standard processor"
	product_type = /obj/item/weapon/computer_hardware/processor_unit
	build_type = IMPRINTER
	required_materials = list("steel" = 1, "glass" = 1)
	required_reagents = list(/datum/reagent/acid = 20)
	complexity = 5

/datum/research_design/processor_quantum
	name = "quantum processor"
	product_type = /obj/item/weapon/computer_hardware/processor_unit/quantum
	build_type = IMPRINTER
	required_materials = list("steel" = 1, "glass" = 1)
	required_reagents = list(/datum/reagent/acid = 20)
	complexity = 15

/datum/research_design/processor_photonic
	name = "photonic processor"
	product_type = /obj/item/weapon/computer_hardware/processor_unit/photonic
	build_type = IMPRINTER
	required_materials = list("steel" = 1, "glass" = 1)
	required_reagents = list(/datum/reagent/acid = 20)
	required_objs = list(/obj/item/crystal/pink)
	complexity = 25
