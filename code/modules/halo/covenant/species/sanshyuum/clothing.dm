
#define SANSHYUUM_ARMOUR_ICON 'code/modules/halo/covenant/species/sanshyuum/r_sanshyuum.dmi'

/obj/item/clothing/suit/prophet_robe
	name = "San Shyuum Robe"
	desc = "A robe shaped for a San Shyuum."
	icon = SANSHYUUM_ARMOUR_ICON
	icon_override = SANSHYUUM_ARMOUR_ICON
	icon_state = "robe"
	item_state = "robe"
	species_restricted = list("San Shyuum")
	unacidable = 1

/obj/item/clothing/under/prophet_internal
	name = "San Shyuum Undersuit"
	desc = "To be worn under San Shyuum robes"
	icon = 'code/modules/halo/clothing/spartan_gear.dmi'
	icon_state = ""
	icon_override = 'code/modules/halo/clothing/spartan_gear.dmi'
	species_restricted = list("San Shyuum")

/obj/item/clothing/suit/armor/special/shielded_prophet_robe
	name = "San Shyuum Robe - Reinforced"
	desc = "A robe shaped for a San Shyuum, with shield generating apparatus inlaid into the fabric to provide more protection."
	icon = SANSHYUUM_ARMOUR_ICON
	icon_override = SANSHYUUM_ARMOUR_ICON
	icon_state = "robe"
	item_state = "robe"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	species_restricted = list("San Shyuum")
	specials = list(/datum/armourspecials/shields,/datum/armourspecials/gear/prophet_jumpsuit)
	totalshields = 270 //Ultra tier

/obj/item/clothing/suit/armor/special/shielded_prophet_robe/santa
	name = "Cheerful Robe"
	desc = "A robe made to spread the cheer of the forerunners across all of space."
	icon_state = "santa_prophet_robes_obj"
	item_state = "santa_prophet_robes_worn"

/obj/item/clothing/head/helmet/santa_hat
	name = "Cheerful Hat"
	desc = "A hat made to spread the cheer of the forerunners across all of space."
	icon = SANSHYUUM_ARMOUR_ICON
	icon_override = SANSHYUUM_ARMOUR_ICON
	icon_state = "santa_prophet_hat_obj"
	item_state = "santa_prophet_hat_worn"
	species_restricted = list("San Shyuum")
	body_parts_covered = HEAD
	item_flags = THICKMATERIAL
	unacidable = 1

	integrated_hud = /obj/item/clothing/glasses/hud/tactical/covenant

/obj/item/weapon/storage/backpack/sangheili/santa
	name = "Cheerful Bag"
	desc = "A bag made to spread the cheer of the forerunners across all of space."
	icon = SANSHYUUM_ARMOUR_ICON
	icon_override = SANSHYUUM_ARMOUR_ICON
	icon_state = "santa_bag_obj"
	item_state = null

	item_icons = list(
		slot_l_hand_str = SANSHYUUM_ARMOUR_ICON,
		slot_r_hand_str = SANSHYUUM_ARMOUR_ICON,
		)
	item_state_slots = list(
	slot_l_hand_str = "santa_prophet_bag_left_inhands",
	slot_r_hand_str = "santa_prophet_bag_right_inhands" )

/datum/language/sanshyuum
	name = "Janjur Qomi"
	desc = "The language of the SanShyuum"
	native = 1
	colour = "sanshyuum"
	syllables = list("nnse","nee","kooree","keeoh","cheenoh","rehmah","nnteh","hahdeh","nnrah","kahwah","ee","hoo","roh","usoh","ahnee","ruh","eerayrah","sohruh","eesah")
	key = "P"
	flags = RESTRICTED

/decl/hierarchy/outfit/lesser_prophet
	name = "Lesser Prophet"
	suit = /obj/item/clothing/suit/armor/special/shielded_prophet_robe
	l_ear = /obj/item/device/radio/headset/covenant
	//
	id_type = /obj/item/weapon/card/id/prophet
	id_slot = slot_wear_id
