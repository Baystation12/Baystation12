
/datum/research_design/plastique
	name = "C-12 Breaching Charge"
	product_type = /obj/item/weapon/plastique
	build_type = PROTOLATHE
	required_materials = list("steel" = 10)
	required_reagents = list(
		/datum/reagent/nitroglycerin = 20,\
		/datum/reagent/toxin/plasticide = 20,\
		/datum/reagent/toxin/phoron = 5)
	required_objs = list(\
		/obj/item/device/assembly/timer,\
		/obj/item/device/assembly/igniter)
	complexity = 18
