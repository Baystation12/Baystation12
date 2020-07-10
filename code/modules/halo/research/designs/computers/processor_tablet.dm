
/datum/research_design/processor_small
	name = "standard microprocessor"
	product_type = /obj/item/weapon/computer_hardware/processor_unit/small
	build_type = IMPRINTER
	required_materials = list("steel" = 1, "glass" = 1)
	required_reagents = list(/datum/reagent/acid = 20)
	complexity = 10

/datum/research_design/processor_quantum_small
	name = "quantum microprocessor"
	product_type = /obj/item/weapon/computer_hardware/processor_unit/quantum/small
	build_type = IMPRINTER
	required_materials = list("steel" = 1, "glass" = 1)
	required_reagents = list(/datum/reagent/acid = 20)
	complexity = 20

/datum/research_design/processor_photonic_small
	name = "photonic microprocessor"
	product_type = /obj/item/weapon/computer_hardware/processor_unit/photonic/small
	build_type = IMPRINTER
	required_materials = list("steel" = 1, "glass" = 1)
	required_reagents = list(/datum/reagent/acid = 20)
	required_objs = list(/obj/item/crystal/pink)
	complexity = 30
