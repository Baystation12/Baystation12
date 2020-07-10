
//Physical shield object define//
/obj/item/weapon/gauntlet_shield //The shield object that appears when you activate the gauntlet.
	name = "Handheld Shield"
	desc = "A shimmering shield"

	icon = SHIELD_GAUNTLET_ICON
	icon_state = "shield"
	item_state = "shield"

	item_icons = list(\
		slot_l_hand_str = SHIELD_GAUNTLET_ICON_INHAND_L,
		slot_r_hand_str = SHIELD_GAUNTLET_ICON_INHAND_R)

	canremove = 0
	var/obj/item/clothing/gloves/shield_gauntlet/creator_gauntlet

/obj/item/weapon/gauntlet_shield/New(var/loc, var/obj/created_by)
	. = ..()
	creator_gauntlet = created_by

/obj/item/weapon/gauntlet_shield/equipped(var/mob/living/carbon/human/user)
	if(istype(user) && user.gloves != creator_gauntlet)
		user.drop_from_inventory(src)
		qdel(src)
	else
		. = ..()

/obj/item/weapon/gauntlet_shield/dropped()
	creator_gauntlet.hand_dropped()
	. = ..()
	qdel(src)

/obj/item/weapon/gauntlet_shield/shield_gauntlet/examine(var/mob/user)
	return creator_gauntlet.examine(user)
