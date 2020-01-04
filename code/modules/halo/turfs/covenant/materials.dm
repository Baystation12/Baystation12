


/* NANOLAMINATE */

/material/nanolaminate
	name = "nanolaminate"
	display_name = "nanolaminate"

	shard_can_repair = 0 //I doubt you can melt nanolaminate with a hand welder.

	icon_base = "nanolaminate"
	//door_icon_base = "nanolaminate"
	icon_reinf = "reinf_over"
	stack_origin_tech = list(TECH_MATERIAL = 5)

	cut_delay = 120 SECONDS

	melting_point = 17273

	brute_armor = 15
	burn_armor = 10 //Not as defensive when burn applied.

	integrity = 650

	explosion_resistance = 30

	stack_type = /obj/item/stack/material/nanolaminate

	hardness = 80
	weight = 25

/material/nanolaminate/generate_recipes()
	..()
	recipes += new/datum/stack_recipe("nanolaminate floor tile", /obj/item/stack/tile/covenant, 1, 4, 20)

/obj/item/stack/material/nanolaminate
	name = "nanolaminate"
	singular_name = "nanolaminate sheets"
	icon = 'code/modules/halo/icons/materials/covenant/materials.dmi'
	icon_state = "nanolaminate"
	default_type = "nanolaminate"
	amount = 1
	max_amount = 50
	material = /material/nanolaminate
	stacktype = /obj/item/stack/material/nanolaminate

/obj/item/stack/material/nanolaminate/ten
	amount = 10

/obj/item/stack/material/nanolaminate/fifty
	amount = 50



/* DURIDIUM */

/material/duridium
	name = "duridium"
	display_name = "refined duridium"

	shard_can_repair = 0 //I doubt you can melt nanolaminate with a hand welder.

	icon_base = "duridium"
	door_icon_base = "duridium"
	icon_reinf = "duridium"
	stack_origin_tech = list(TECH_MATERIAL = 5)

	cut_delay = 120

	melting_point = 17273

	brute_armor = 15
	burn_armor = 10 //Not as defensive when burn applied.

	integrity = 600

	explosion_resistance = 50

	stack_type = /obj/item/stack/material/duridium

	hardness = 80
	weight = 25

/obj/item/stack/material/duridium
	name = "refined duridium"
	singular_name = "refined duridium sheets"
	icon = 'code/modules/halo/icons/materials/covenant/materials.dmi'
	icon_state = "duridium"
	default_type = "duridium"
	amount = 1
	max_amount = 50
	material = /material/duridium
	stacktype = /obj/item/stack/material/duridium

/obj/item/stack/material/duridium/ten
	amount = 10

/obj/item/stack/material/duridium/fifty
	amount = 50



/* KEMOCITE */

/material/kemocite
	name = "kemocite"
	display_name = "compressed kemocite"
	shard_can_repair = 0 //I doubt you can melt nanolaminate with a hand welder.
	icon_base = "kemocite"
	stack_origin_tech = list(TECH_MATERIAL = 5)
	stack_type = /obj/item/stack/material/kemocite

/obj/item/stack/material/kemocite
	name = "compressed kemocite"
	singular_name = "compressed kemocite ingots"
	icon = 'code/modules/halo/icons/materials/covenant/materials.dmi'
	icon_state = "kemocite_ingot"
	default_type = "kemocite"
	amount = 1
	max_amount = 50
	material = /material/kemocite
	stacktype = /obj/item/stack/material/kemocite

/obj/item/stack/material/kemocite/ten
	amount = 10

/obj/item/stack/material/kemocite/fifty
	amount = 50



/* DRONE BIOMASS */

/material/drone_biomass
	name = "drone biomass"
	display_name = "drone biomass"
	icon_base = "diona"
