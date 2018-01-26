/obj/machinery/autolathe/ammo_fabricator
	name = "ammunition fabricator"
	desc = "Fabricates many types of ammunition, magazines and boxes."
	icon = 'code/modules/halo/machinery/ammolathe_1.dmi'
	icon_state = "ammolathe"
	use_power = 0 //Geminus doesn't have actual power circulation, I think.

	machine_recipes = newlist(/datum/autolathe/recipe/m255_sap_he,/datum/autolathe/recipe/m255_sap_hp,/datum/autolathe/recipe/m118_fmj_ap,/datum/autolathe/recipe/m634_sap,/datum/autolathe/recipe/a762_ap,/datum/autolathe/recipe/m112_ap_fs_ds,/datum/autolathe/recipe/m443_fmj)