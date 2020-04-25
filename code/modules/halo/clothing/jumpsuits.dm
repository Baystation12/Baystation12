#define SHIP_MOB_OVERRIDE 'code/modules/halo/clothing/mob_jumpsuit_ship.dmi'
#define SHIP_ITEM_OVERRIDE 'code/modules/halo/clothing/item_jumpsuit_ship.dmi'

//MAIN ONE
/obj/item/clothing/under/unsc
	desc = "standard issue command crew uniform"
	name = "command officer uniform"
	icon = SHIP_ITEM_OVERRIDE
	icon_override = SHIP_MOB_OVERRIDE
	icon_state = "unscgrey"
	item_state = "unscgrey"
	worn_state = "unsc_grey"
	item_icons = list(
		slot_l_hand_str = null,
		slot_r_hand_str = null,
		)
	armor = list(melee = 10, bullet = 10, laser = 0, energy = 10, bomb = 0, bio = 0, rad = 0)

//NEW  CLOTHES
/obj/item/clothing/under/unsc/grey
	desc = "Standard issue Command Crew uniform"
	name = "UNSC Command Uniform"
	icon_state = "unsc-working-uniform-grey-obj"
	item_state = "unsc-working-uniform-grey-obj"
	worn_state = "unsc-working-uniform-grey"

/obj/item/clothing/under/unsc/lblue
	desc = "Standard issue Medical Crew uniform"
	name = "UNSC Medical Uniform"
	icon_state = "unsc-working-uniform-lblue-obj"
	item_state = "unsc-working-uniform-lblue-obj"
	worn_state = "unsc-working-uniform-lblue"

/obj/item/clothing/under/unsc/blue
	desc = "Standard issue Science Crew uniform"
	name = "UNSC Medical Uniform"
	icon_state = "unsc-working-uniform-blue-obj"
	item_state = "unsc-working-uniform-blue-obj"
	worn_state = "unsc-working-uniform-blue"

/obj/item/clothing/under/unsc/brown
	desc = "Standard issue Logistics Crew uniform"
	name = "UNSC Logistics Uniform"
	icon_state = "unsc-working-uniform-brown-obj"
	item_state = "unsc-working-uniform-brown-obj"
	worn_state = "unsc-working-uniform-brown"

/obj/item/clothing/under/unsc/yellow
	desc = "Standard issue Bridge Crew uniform"
	name = "UNSC Bridge Crew Uniform"
	icon_state = "unsc-working-uniform-yellow-obj"
	item_state = "unsc-working-uniform-yellow-obj"
	worn_state = "unsc-working-uniform-yellow"

/obj/item/clothing/under/unsc/red
	desc = "Standard issue Crew uniform"
	name = "UNSC Crew Uniform"
	icon_state = "unsc-working-uniform-red-obj"
	item_state = "unsc-working-uniform-red-obj"
	worn_state = "unsc-working-uniform-red"

/obj/item/clothing/under/unsc/orange
	desc = "Standard issue Technician Crew uniform"
	name = "UNSC Technician Uniform"
	icon_state = "unsc-working-uniform-orange-obj"
	item_state = "unsc-working-uniform-orange-obj"
	worn_state = "unsc-working-uniform-orange"

//OLD CLOTHES
/obj/item/clothing/under/unsc/command

/obj/item/clothing/under/unsc/co
	desc = "Service Command Crew uniform"
	name = "UNSC Service Command Uniform"
	icon_state = "unsc-co-uniform-obj"
	item_state = "unsc-co-uniform-obj"
	worn_state = "unsc-co-uniform"

/obj/item/clothing/under/unsc/technician
	desc = "UNSC technician uniform"
	name = "technician uniform"
	icon_state = "unscorange"
	item_state = "unscorange"
	worn_state = "unsc_orange"

/obj/item/clothing/under/unsc/logistics
	desc = "UNSC logistics uniform"
	name = "logistics uniform"
	icon_state = "unscyellow"
	item_state = "unscyellow"
	worn_state = "unsc_yellow"

/obj/item/clothing/under/unsc/mechanic
	desc = "UNSC mechanic uniform"
	name = "mechanic uniform"
	icon_state = "unsclightbrown"
	item_state = "unsclightbrown"
	worn_state = "unsc_lightbrown"

/obj/item/clothing/under/unsc/tactical
	desc = "UNSC tactical uniform"
	name = "tactical uniform"
	icon_state = "unscred"
	item_state = "unscred"
	worn_state = "unsc_red"

/obj/item/clothing/under/unsc/medical
	desc = "UNSC navy hospitalman uniform"
	name = "medical uniform"
	icon_state = "unscblue"
	item_state = "unscblue"
	worn_state = "unsc_blue"

/obj/item/clothing/under/unsc/operations
	desc = "UNSC operations uniform"
	name = "operations uniform"
	//icon_state = "greydress_com"
	//item_state = "greydress_com"
	//worn_state = "greydress_com_s"

//doesn't fit colour scheme
/obj/item/clothing/under/unsc/highcom //this is intended for admin usage only!
	desc = "the ornate uniform of a high ranking UNSC fleet officer"
	name = "UNSC HIGHCOM uniform"
	icon_state = "lasky"
	item_state = "lasky"
	worn_state = "mob_lasky"

//doesn't fit colour scheme
/obj/item/clothing/under/unsc/cmo
	desc = "standard issue command uniform, medical variant"
	name = "CMO's uniform"
	icon_state = "unsccmo"
	item_state = "unsccmo"
	worn_state = "cmo_unsc"

//DRESS CLOTHES

/obj/item/clothing/under/unsc/dress
	name = "UNSC Navy Dress Uniform"
	desc = "A more formal uniform known to be worn during award ceremonies."
	icon_state = "unsc-dress-uniform-obj"
	item_state = "unsc-dress-uniform-obj"
	worn_state = "unsc-dress-uniform"

/obj/item/clothing/under/unsc/dress/admiral
	name = "UNSC Navy Admiral Uniform"
	desc = "A formal uniform known to be worn by admrials."
	icon_state = "unsc-admiral-uniform-obj"
	item_state = "unsc-admiral-uniform-obj"
	worn_state = "unsc-admiral-uniform"

/obj/item/clothing/shoes/dress/unsc
	name = "UNSC Navy Dress Shoes"
	desc = "A pair of clean dress shoes."
	icon = 'code/modules/halo/clothing/mob_jumpsuit_ship.dmi'
	icon_override = 'code/modules/halo/clothing/mob_jumpsuit_ship.dmi'
	icon_state = "unsc-dress-shoes-obj"
	item_state = "unsc-dress-shoes"

/obj/item/clothing/head/unsc
	name = "UNSC Navy Dress Cap"
	desc = "A soft cap decorated with an officer crest."
	icon = 'code/modules/halo/clothing/mob_jumpsuit_ship.dmi'
	icon_override = 'code/modules/halo/clothing/mob_jumpsuit_ship.dmi'
	icon_state = "unsc-dress-cap-obj"
	item_state = "unsc-dress-cap"

#undef SHIP_MOB_OVERRIDE
#undef SHIP_ITEM_OVERRIDE