/obj/item/clothing/suit/sc_labcoat
	name = "robotic bathrobe"
	desc = "A suit that protects against minor chemical spills."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "sc_labcoat"
	item_state = "sc_labcoat"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	allowed = list(/obj/item/device/scanner/gas,/obj/item/stack/medical,/obj/item/reagent_containers/dropper,/obj/item/reagent_containers/syringe,/obj/item/reagent_containers/hypospray,/obj/item/device/scanner/health,/obj/item/device/flashlight/pen,/obj/item/reagent_containers/glass/bottle,/obj/item/reagent_containers/glass/beaker,/obj/item/reagent_containers/pill,/obj/item/storage/pill_bottle,/obj/item/paper)
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 50, rad = 0)

/obj/item/clothing/suit/storage/toggle/civilian
	name = "black jacket"
	desc = "A black jacket for real white men."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "black_jacket_o"
	//icon_open = "black_jacket_o"
	//icon_closed = "black_jacket_c"

/obj/item/clothing/suit/officerdnavyjacket
	name = "officer navy jacket"
	desc = "The utility jacket of the SCG Fleet, made from an insulated materials."
	icon = 'icons/obj/clothing/obj_suit.dmi'
	icon_state = "officerdnavyjacket"
	body_parts_covered = UPPER_TORSO

/obj/item/clothing/suit/storage/hoscoat
	name = "armored trenchcoat"
	desc = "A trenchcoat augmented with a special alloy for some protection and style."
	icon_state = "hostrench"
	item_state = "hostrench"
	armor = list(melee = 65, bullet = 30, laser = 50, energy = 10, bomb = 25, bio = 0, rad = 0)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	siemens_coefficient = 0.6
	allowed = list(/obj/item/gun/energy,/obj/item/device/radio,/obj/item/reagent_containers/spray/pepper,/obj/item/gun/projectile,/obj/item/ammo_magazine,/obj/item/ammo_casing,/obj/item/melee/baton,/obj/item/handcuffs,/obj/item/gun/magnetic)

/obj/item/clothing/suit/storage/janjacket
	name = "janitor jacket"
	desc = "A janitor's jacket. Gives unbelivable protection versus depression about your job."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "janitor_jacket"
	body_parts_covered = UPPER_TORSO|ARMS
	allowed = list(/obj/item/device/flashlight,/obj/item/device/lightreplacer,/obj/item/storage/bag/trash,/obj/item/grenade/chem_grenade/cleaner,/obj/item/reagent_containers/spray/cleaner, /obj/item/mop, /obj/item/reagent_containers/glass/bucket)

/obj/item/clothing/suit/storage/tgbomber/militaryjacket
	name = "military jacket"
	desc = "A canvas jacket styled classical American military garb. Feels sturdy, yet comfortable."
	icon_state = "militaryjacket"

/obj/item/clothing/suit/armor/pcarrier/mainkraft/plastic
	name = "plastic plate carrier"
	desc = "Someone made it out of plastic with their own hands. There you can hang a sheet of armor."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "plvest"

/obj/item/clothing/suit/armor/pcarrier/mainkraft/plastic/New()
	..()
	slowdown_per_slot[slot_wear_suit] = 0.75

/obj/item/clothing/suit/lux_tunic
	name = "luxury tunic"
	desc = "A luxury suit for some high-ranked officer."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "admiral_tunic"
	item_state = "admiral_tunic"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS|LEGS
	valid_accessory_slots = list(ACCESSORY_SLOT_MEDAL)
	allowed = list(/obj/item/gun/energy, /obj/item/gun/projectile, /obj/item/melee/baton)

/obj/item/clothing/suit/storage/toggle/agent_jacket/security
	name = "private security jacket"
	desc = "A black leather jacket with \"SECURITY\" inscription at back. Belonged to a guard in a warehouse."


/obj/item/clothing/suit/anime_white
	name = "white dress"
	desc = "Just a nice looking dress."
	icon = 'packs/infinity/icons/obj/clothing/obj_under.dmi'
	item_icons = list(
		slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi',
		slot_r_hand_str = 'packs/infinity/icons/mob/onmob/righthand.dmi',
		slot_l_hand_str = 'packs/infinity/icons/mob/onmob/lefthand.dmi')
	icon_state = "anime_white"
	item_state = "anime_white"

/obj/item/clothing/suit/anime_blue
	name = "blue dress"
	desc = "Just a nice looking dress."
	icon = 'packs/infinity/icons/obj/clothing/obj_under.dmi'
	item_icons = list(
		slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi')
	icon_state = "anime_blue"
	item_state = "anime_blue"

/obj/item/clothing/suit/snakeskin
	name = "snakeskin coat"
	desc = "A stylish snakeskin coat."
	icon = 'maps/sierra/icons/obj/clothing/obj_suit.dmi'
	item_icons = list(
		slot_wear_suit_str = 'maps/sierra/icons/mob/onmob/onmob_suit.dmi') //sprite by CeUvi#1236
	icon_state = "snakeskin"
	item_state = "snakeskin"
	body_parts_covered = UPPER_TORSO|ARMS

/obj/item/clothing/under/rank/adjutant
	name = "adjutant's uniform"
	desc = "It's made of a special fiber that gives protection against strong language."
	icon = 'packs/infinity/icons/obj/clothing/obj_under.dmi'
	item_icons = list(slot_w_uniform_str = 'packs/infinity/icons/mob/onmob/onmob_under.dmi')
	icon_state = "adjutant"
	item_state = "adjutant"
	worn_state = "adjutant"
