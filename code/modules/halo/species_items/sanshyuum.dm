
/mob/living/carbon/human/covenant/sanshyuum/New(var/new_loc)
	. = ..(new_loc,"San Shyuum")

/obj/item/clothing/suit/prophet_robe
	name = "San Shyuum Robe"
	desc = "A robe shaped for a San Shyuum."
	icon = 'code/modules/halo/icons/species/r_sanshyuum.dmi'
	icon_override = 'code/modules/halo/icons/species/r_sanshyuum.dmi'
	icon_state = "robe"
	item_state = "robe"
	species_restricted = list("San Shyuum")

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
	icon = 'code/modules/halo/icons/species/r_sanshyuum.dmi'
	icon_override = 'code/modules/halo/icons/species/r_sanshyuum.dmi'
	icon_state = "robe"
	item_state = "robe"
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 0, rad = 0)
	species_restricted = list("San Shyuum")
	specials = list(/datum/armourspecials/shields,/datum/armourspecials/gear/prophet_jumpsuit)
	totalshields = 175 //Between Ultra and Zealot, but they don't have any armour to protect them once it goes down.

/datum/language/sanshyuum
	name = "Janjur Qomi"
	desc = "The language of the SanShyuum"
	native = 1
	colour = "vox"
	syllables = list("nnse","nee","kooree","keeoh","cheenoh","rehmah","nnteh","hahdeh","nnrah","kahwah","ee","hoo","roh","usoh","ahnee","ruh","eerayrah","sohruh","eesah")
	key = "P"
	flags = RESTRICTED

/decl/hierarchy/outfit/lesser_prophet
	name = "Lesser Prophet"
	suit = /obj/item/clothing/suit/armor/special/shielded_prophet_robe
	l_ear = /obj/item/device/radio/headset/covenant