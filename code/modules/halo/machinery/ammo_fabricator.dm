/obj/machinery/autolathe/ammo_fabricator
	name = "ammunition fabricator"
	desc = "Fabricates many types of ammunition, magazines and boxes."
	icon = 'code/modules/halo/machinery/ammolathe_1.dmi'
	icon_state = "ammolathe"

	machine_recipes = newlist(\
	/datum/autolathe/recipe/m255_sap_he,
	/datum/autolathe/recipe/m255_sap_hp,
	/datum/autolathe/recipe/m118_ma5b,
	/datum/autolathe/recipe/m118_m392,
	/datum/autolathe/recipe/m118_ma37,
	/datum/autolathe/recipe/m634_sap,
	/datum/autolathe/recipe/a762_ap,
	///datum/autolathe/recipe/m112_ap_fs_ds, //Power weapons should not have replenishable ammo from most fabricators.
	/datum/autolathe/recipe/m443_fmj,
	/datum/autolathe/recipe/m762ma3,
	/datum/autolathe/recipe/mc9mm,
	/datum/autolathe/recipe/a556,
	/datum/autolathe/recipe/m392innie

	)

/obj/machinery/autolathe/ammo_fabricator/oni_fab
	desc = "An ammunition fabricator with a data-disk permenantly welded in. You'd assume the ammunition range is less than most, but includes more powerful ammunition."
	machine_recipes = newlist(\
	/datum/autolathe/recipe/m255_sap_he,
	/datum/autolathe/recipe/m255_sap_hp,
	/datum/autolathe/recipe/m118_ma5b,
	/datum/autolathe/recipe/m118_m392,
	/datum/autolathe/recipe/m112_ap_fs_ds,
	/datum/autolathe/recipe/m443_fmj
	)