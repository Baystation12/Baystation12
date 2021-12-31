/obj/machinery/autolathe/ammo_fabricator
	name = "ammunition fabricator"
	desc = "Fabricates many types of ammunition, magazines and boxes."
	icon = 'code/modules/halo/machinery/ammolathe_1.dmi'
	icon_state = "ammolathe"

	machine_recipes = newlist(\
	/datum/autolathe/recipe/m6d_m224,
	/datum/autolathe/recipe/ma5b_m118,
	/datum/autolathe/recipe/ma37_m118,
	/datum/autolathe/recipe/ma3_m118,
	/datum/autolathe/recipe/m443_fmj,
	/datum/autolathe/recipe/mc9mm,
	/datum/autolathe/recipe/shotgun_box,
	/datum/autolathe/recipe/shotgun_box/slugs,
	/datum/autolathe/recipe/a556
	)

/obj/machinery/autolathe/ammo_fabricator/oni_fab
	desc = "An ammunition fabricator with a data-disk permenantly welded in. You'd assume the ammunition range is less than most, but includes more powerful ammunition."
	machine_recipes = newlist(\
	/datum/autolathe/recipe/m6d_m224,
	/datum/autolathe/recipe/m6s_m224,
	/datum/autolathe/recipe/ma5b_m118,
	/datum/autolathe/recipe/m443_fmj,
	)
	req_access = list(access_unsc_oni)

/obj/machinery/autolathe/ammo_fabricator/kig_yar
	name = "Ammunition Fabrication Machine"
	desc = "Brought along by the Kig-Yar, this machine is loaded with ammunition manufacturing recipes for covenant ammunition"
	icon = 'code/modules/halo/covenant/manufactory/machines.dmi'
	icon_state = "dispenser"

	machine_recipes = newlist(\
	/datum/autolathe/recipe/blamite_needles,
	/datum/autolathe/recipe/cov_carbine_mag,
	/datum/autolathe/recipe/needlerifle_mag
	)