


/* NANOLAMINATE */

/material/forerunner_alloy
	name = "forerunner alloy"
	display_name = "forerunner alloy"

	shard_can_repair = 0

	icon_base = "forerunner_alloy"
	icon_reinf = "reinf_over"
	stack_origin_tech = list(TECH_MATERIAL = 5)

	cut_delay = 5 MINUTES

	melting_point = 17273

	brute_armor = 20
	burn_armor = 20

	integrity = 1000

	explosion_resistance = 30

	stack_type = /obj/item/stack/material/forerunner_alloy

	hardness = 80
	weight = 25

/obj/item/stack/material/forerunner_alloy
	name = "forerunner alloy"
	singular_name = "forerunner alloy sheet"
	icon = 'code/modules/halo/icons/materials/forerunner/materials.dmi'
	icon_state = "alloy"
	default_type = "alloy"
	amount = 1
	max_amount = 50
	material = /material/nanolaminate
	stacktype = /obj/item/stack/material/nanolaminate