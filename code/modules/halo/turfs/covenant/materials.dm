
/material/nanolaminate
	name = "nanolaminate"
	display_name = "nanolaminate"

	shard_can_repair = 0 //I doubt you can melt nanolaminate with a hand welder.

	icon_base = "nanolaminate"
	door_icon_base = "nanolaminate"
	icon_reinf = "nanolaminate"
	stack_origin_tech = list(TECH_MATERIAL = 5)

	cut_delay = 120

	melting_point = 17273

	brute_armor = 15
	burn_armor = 10 //Not as defensive when burn applied.

	integrity = 600

	explosion_resistance = 50

	stack_type = /obj/item/stack/material/nanolaminate

	hardness = 80
	weight = 25

/obj/item/stack/material/nanolaminate
	name = "nanolaminate"
	singular_name = "nanolaminate sheets"
	icon = 'code/modules/halo/icons/materials/covenant/nanolaminate.dmi'
	icon_state = "nanolaminate"
	default_type = "nanolaminate"
	amount = 1
	max_amount = 50
	material = /material/nanolaminate
	stacktype = /obj/item/stack/material/nanolaminate

/obj/item/stack/material/nanolaminate/fifty
	amount = 50