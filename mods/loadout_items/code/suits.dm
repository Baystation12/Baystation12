// Fancy Jackets (referenses to films, games, etc)

/obj/item/clothing/suit/storage/drive_jacket
	name = "drive jacket"
	desc = "Stylish jacket for a real hero. Just like me."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "drive_jacket"
	item_state = "drive_jacket"

/obj/item/clothing/suit/storage/toggle/the_jacket
	name = "the jacket"
	desc = "Old fashioned jacket. For lonely ride across southern city. Or for working on hotline may be?"
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "the_jacket"

/obj/item/clothing/suit/storage/leon_jacket
	name = "patterned leather jacket"
	desc = "A black leather jacket wit some bizarre patterns."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "leon_jacket"
	item_state = "leon_jacket"

/obj/item/clothing/suit/storage/toggle/longjacket
	name = "long jacket"
	desc = "A long gray jacket"
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "longjacket_o"

/obj/item/clothing/suit/storage/tgbomber
	name = "modern bomber jacket"
	desc = "A leather bomber jacket."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "bomberjacket"
	body_parts_covered = UPPER_TORSO|ARMS
	cold_protection = UPPER_TORSO|ARMS
	min_cold_protection_temperature = T0C - 20

/obj/item/clothing/suit/storage/brand_jacket
	name = "blue brand jacket"
	desc = "What a fiery coloration."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "brand_jacket"
	item_state = "brand_jacket"

/obj/item/clothing/suit/storage/brand_orange_jacket
	name = "orange brand jacket"
	desc = "What a fiery coloration."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "brand_orange_jacket"
	item_state = "brand_orange_jacket"

/obj/item/clothing/suit/storage/brand_rjacket
	name = "red brand jacket"
	desc = "What a fiery coloration."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "brand_rjacket"
	item_state = "brand_rjacket"

/obj/item/clothing/suit/storage/hooded/faln_jacket
	name = "faln jacket"
	desc = "A very special piece of sports apparel, this jacket is warm, completely water and wind proof, and provides the air circulation through the membrane in its inner shell."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "papaleroy_faln_jacket"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	action_button_name = "Toggle Hood"
	hoodtype = /obj/item/clothing/head/faln_jacket_hood

/obj/item/clothing/head/faln_jacket_hood
	name = "faln jacket hood"
	desc = "A hood attached to a faln jacket hood."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_head_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "papaleroy_faln_jacket_hood"
	body_parts_covered = HEAD
	flags_inv = HIDEEARS | BLOCKHAIR

//Pullower

/obj/item/clothing/suit/storage/old_pullover
	name = "old pullover"
	desc = "old style pullover"
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "pullover"
	item_state = "pullover"

// Coats

/obj/item/clothing/suit/storage/long_coat
	name = "long coat"
	desc = "Just a blank fabric black longcoat. It's surprisingly light."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "long_coat"
	item_state = "long_coat"

/obj/item/clothing/suit/storage/gentlecoat
	name = "gentlecoat"
	desc = "A tweed tailcoat purposed for some wannabe gentleman."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "gentlecoat"
	item_state = "gentlecoat"

/obj/item/clothing/suit/storage/tailcoat
	name = "tailcoat"
	desc = "A very delicate tailcoat, it imbues its wearer with vibe of snobbery and excessive self-importance."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "papaleroy_tailcoat"
	item_state = "papaleroy_tailcoat"

/obj/item/clothing/suit/storage/jensencoat
	name = "short trenchcoat"
	desc = "You may've never asked for this."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "jensencoat"
	item_state = "jensencoat"

// Kimonio

/obj/item/clothing/suit/storage/kimono
	name = "kimono"
	desc = "Traditional Japanese garb, purposed for wearing by women."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "kimono"
	item_state = "kimono"
	body_parts_covered = UPPER_TORSO

/obj/item/clothing/suit/storage/kimono/blue
	name = "blue kimono"
	desc = "Traditional Japanese garb, purposed for wearing by women."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "blue_kimono"
	item_state = "blue_kimono"

/obj/item/clothing/suit/storage/kimono/red_short
	name = "red short kimono"
	desc = "Traditional Japanese garb, purposed for wearing by women. This one is shortened for some extra style points."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "red_short_kimono"
	item_state = "red_short_kimono"

/obj/item/clothing/suit/storage/kimono/black
	name = "black kimono"
	desc = "Traditional Japanese garb, purposed for wearing by women."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "black_kimono"
	item_state = "black_kimono"

// First responder jacket
	
/obj/item/clothing/suit/storage/toggle/fr_jacket/highvis
	name = "first responder jacket"
	icon = 'mods/loadout_items/icons/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'mods/loadout_items/icons/onmob_suit.dmi')

/obj/item/clothing/suit/storage/toggle/fr_jacket/highvis/New()
	. = ..()
	sprite_sheets[SPECIES_UNATHI] = 'mods/loadout_items/icons/unathi/onmob_suit_unathi.dmi'
	
// Unathi garments

/obj/item/clothing/suit/storage/security
	name = "Big Security Jacket"
	desc = "A pretty big jacket with deep pockets, favored by unathi mercenaries. It's too big to fit anyone, but unathi."
	icon = 'mods/loadout_items/icons/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'mods/loadout_items/icons/onmob_suit.dmi')
	sprite_sheets = list(
		SPECIES_UNATHI = 'mods/loadout_items/icons/onmob_suit.dmi'
	)
	icon_state = "unathi_secjacket"
	item_state = "unsecjacket"

	species_restricted = list(SPECIES_UNATHI)
	w_class = ITEM_SIZE_NORMAL
	allowed = list(
		/obj/item/gun,
		/obj/item/ammo_magazine,
		/obj/item/ammo_casing,
		/obj/item/melee/baton,
		/obj/item/handcuffs,
		/obj/item/tank/oxygen_emergency,
		/obj/item/tank/oxygen_emergency_extended,
		/obj/item/tank/nitrogen_emergency
	)
	siemens_coefficient = 0.9
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	
//Aurora stuff
/obj/item/clothing/suit/storage/dominia
	name = "Avalon greatcoat"
	desc = "This is a great coat in the style of Avalon nobility. It's the latest fashion across the Kingdom's territories."
	icon = 'mods/loadout_items/icons/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'mods/loadout_items/icons/onmob_suit.dmi')
	icon_state = "greatcoat_red"
	item_state = "greatcoat_red"

/obj/item/clothing/suit/storage/dominia/gold
	icon_state = "greatcoat_gold"
	item_state = "greatcoat_gold"

/obj/item/clothing/suit/storage/dominia/black
	icon_state = "greatcoat_black"
	item_state = "greatcoat_black"

/obj/item/clothing/suit/storage/dominia/coat
	name = "Avalon coat"
	desc = "This is a coat in the style of Avalon nobility. It's the latest fashion across the Kingdom's territories."
	icon_state = "coat_red"
	item_state = "coat_red"

/obj/item/clothing/suit/storage/dominia/coat/gold
	icon_state = "coat_gold"
	item_state = "coat_gold"

/obj/item/clothing/suit/storage/dominia/coat/black
	icon_state = "coat_black"
	item_state = "coat_black"

/obj/item/clothing/suit/storage/dominia/consular
	name = "Avalon consular's greatcoat"
	desc = "An Avalon greatcoat issued to members of His Majesty's Chancellery, designed in the typical Avalonian fashion."
	icon_state = "dominia_consular_greatcoat"
	item_state = "dominia_consular_greatcoat"

/obj/item/clothing/suit/storage/dominia/consular/coat
	name = "Avalon consular's coat"
	desc = "An Avalon coat issued to members of His Majesty's Chancellery, designed in the typical Avalonian fashion."
	icon_state = "dominia_consular_coat"
	item_state = "dominia_consular_coat"

/obj/item/clothing/suit/storage/dominia/consular/red
	icon_state = "dominia_consular_greatcoat_red"
	item_state = "dominia_consular_greatcoat_red"

/obj/item/clothing/suit/storage/dominia/consular/coat/red
	icon_state = "dominia_consular_coat_red"
	item_state = "dominia_consular_coat_red"
