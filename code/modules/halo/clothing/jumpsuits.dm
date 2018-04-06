#define SHIP_MOB_OVERRIDE 'code/modules/halo/clothing/mob_jumpsuit_ship.dmi'
#define SHIP_ITEM_OVERRIDE 'code/modules/halo/clothing/item_jumpsuit_ship.dmi'


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
	armor = list(melee = 10, bullet = 10, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)

/obj/item/clothing/under/unsc/command

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
	icon_state = "greydress_com"
	item_state = "greydress_com"
	worn_state = "greydress_com_s"

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

#undef SHIP_MOB_OVERRIDE
#undef SHIP_ITEM_OVERRIDE