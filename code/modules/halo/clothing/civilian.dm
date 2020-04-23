
/obj/item/clothing/suit/armor/vest/police//heavy armor
	name = "heavy ballistic suit"
	desc = "Tactical police armored vest designed for bullet and explosive resistance with coverage including the arms, upper and lower torso, and neck. Used in defence against excessive force."
	icon_state = "gcpd-armor-h"
	item_state = "gcpd-armor-h"
	w_class = ITEM_SIZE_HUGE
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)//the badge
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(melee = 40, bullet = 35, laser = 15, energy = 15, bomb = 40, bio = 20, rad = 15)//energy resist to stay nerfed, let the UNSC fight covies not the police. -Deso
	icon = 'code/modules/halo/clothing/gcpd.dmi'
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/clothing/gcpd_leftinhands.dmi',
		slot_r_hand_str = 'code/modules/halo/clothing/gcpd_rightinhands.dmi',
		)

/obj/item/clothing/suit/armor/vest/police/New()
	. =..()
	slowdown_per_slot[slot_wear_suit] = 2

/obj/item/clothing/suit/armor/vest/police_medium//medium armor
	name = "medium ballistic vest"
	desc = "A heavy vest designed for dangerous operations that features full upper and lower torso coverage. For room clearing and armed civilians."
	armor = list(melee = 35, bullet = 30, laser = 15, energy = 15, bomb = 30, bio = 10, rad = 15)
	armor_thickness = 15
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO//in case the parent ever gets touched, this will stay like this
	icon = 'code/modules/halo/clothing/gcpd.dmi'
	icon_state = "gcpd-armor-m"
	item_state = "gcpd-armor-m"
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/clothing/gcpd_leftinhands.dmi',
		slot_r_hand_str = 'code/modules/halo/clothing/gcpd_rightinhands.dmi',
		)

/obj/item/clothing/suit/armor/vest/police_medium/New()//speeds are factoring other gear and chasing people on foot, meant to encourage using lighter armors to reduce meta
	. = ..()
	slowdown_per_slot[slot_wear_suit] = -1

/obj/item/clothing/suit/storage/vest/tactical/police//light armor
	name = "light ballistic vest"
	desc = "Lightweight ballistic vest designed to reduce damage from low caliber rounds or stab wounds specifically to the upper torso where your important guts are. For your average beatcop."
	armor = list(melee = 35, bullet = 20, laser = 10, energy = 10, bomb = 20, bio = 10, rad = 15)
	armor_thickness = 3
	valid_accessory_slots = list(ACCESSORY_SLOT_INSIGNIA)
	icon = 'code/modules/halo/clothing/gcpd.dmi'
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/clothing/gcpd_leftinhands.dmi',
		slot_r_hand_str = 'code/modules/halo/clothing/gcpd_rightinhands.dmi',
		)
	icon_state = "gcpd-armor-l"
	item_state = "gcpd-armor-l"
	body_parts_covered = UPPER_TORSO

/obj/item/clothing/suit/storage/vest/tactical/police/New()
	. = ..()
	slowdown_per_slot[slot_wear_suit] = -2

/obj/item/clothing/mask/balaclava/tactical/police
	name = "police balaclava"
	desc = "A soft kevlar face mask designed to conceal an identity and offer some very minimal protection to the face and neck."
	//armor is just 5 bullet/10 melee, shouldn't be buffed
	icon = 'code/modules/halo/clothing/gcpd.dmi'
	icon_state = "gcpd-mask"
	item_state = "gcpd-mask"

/obj/item/clothing/glasses/police
	icon = 'code/modules/halo/clothing/gcpd.dmi'
	icon_state = "gcpd-shades"
	name = "ballistic glasses"
	desc = "Tinted to reduce glare and strenghtened to protect eyeballs from shrapnel."
	flash_protection = FLASH_PROTECTION_MAJOR
	armor = list(melee = 20, bullet = 15, laser = 20, energy = 15, bomb = 20, bio = 0, rad = 0)//stats copied from tacgoggles

/obj/item/clothing/under/police
	name = "police uniform"
	desc = "A gray uniform worn by the GCPD with some soft kevlar and strike padding in important places."
	icon_state = "gcpd-jumpsuit"
	worn_state = "gcpd-jumpsuit"
	starting_accessories = list(/obj/item/clothing/accessory/department/medical, /obj/item/clothing/accessory/holster/thigh)
	armor = list(melee = 20, bullet = 5, laser = 0, energy = 0, bomb = 5, bio = 0, rad = 0)
	icon = 'code/modules/halo/clothing/gcpd.dmi'
	item_icons = list(
		slot_l_hand_str = 'code/modules/halo/clothing/gcpd_leftinhands.dmi',
		slot_r_hand_str = 'code/modules/halo/clothing/gcpd_rightinhands.dmi',
		)

/obj/item/clothing/shoes/dutyboots
	name = "duty boots"
	desc = "A pair of all-purpose gray steel-toed synthleather boots."
	icon = 'code/modules/halo/clothing/gcpd.dmi'
	icon_state = "gcpd-boots"
	armor = list(melee = 40, bullet = 20, laser = 0, energy = 15, bomb = 20, bio = 20, rad = 20)
	siemens_coefficient = 0.7
	can_hold_knife = 1
	body_parts_covered = FEET|LEGS

/obj/item/clothing/head/helmet/swat/police//light
	icon = 'code/modules/halo/clothing/gcpd.dmi'
	icon_state = "gcpd-helmet"
	item_state = "gcpd-helmet"
	name = "impact helmet"
	desc = "A lightweight helmet tailored towards protecting the wearer from blows to the head with minor shrapnel protection. Goes with the light ballistic vest."
	armor = list(melee = 30, bullet = 10, laser = 5, energy = 5, bomb = 10, bio = 5, rad = 5)

/obj/item/clothing/head/helmet/swat/police/medium//<
	icon_state = "gcpd-helmet-googles"
	item_state = "gcpd-helmet-googles"
	name = "ballistic helmet"
	desc = "Heavier helmet designed to be worn with the medium ballistic vest with more focus on protecting the eyes and head from shrapnel and bullets."
	armor = list(melee = 20, bullet = 30, laser = 10, energy = 10, bomb = 30, bio = 10, rad = 15)
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD|EYES

/obj/item/clothing/head/helmet/gas//copied code from gas masks and applied it to helmets for variability //not sure if best place for it
	var/gas_filter_strength = 1			//For gas mask filters
	var/list/filtered_gases = list("phoron", "sleeping_agent")
	item_flags = BLOCK_GAS_SMOKE_EFFECT|AIRTIGHT

/obj/item/clothing/head/helmet/gas/proc/filter_air(datum/gas_mixture/air)
	var/datum/gas_mixture/filtered = new

	for(var/g in filtered_gases)
		if(air.gas[g])
			filtered.gas[g] = air.gas[g] * gas_filter_strength
			air.gas[g] -= filtered.gas[g]

	air.update_values()
	filtered.update_values()

	return filtered

/obj/item/clothing/head/helmet/gas/police/heavy//<
	icon = 'code/modules/halo/clothing/gcpd.dmi'
	icon_state = "gcpd-helmet-visor"
	item_state = "gcpd-helmet-visor"
	name = "EH252 police variant"
	desc = "Fully enclosed with tear gas filters designed to protect the entirety of the head from ballistics and shrapnel. Goes with the heavy ballistic suit."
	item_flags = THICKMATERIAL|BLOCK_GAS_SMOKE_EFFECT|AIRTIGHT
	body_parts_covered = HEAD|FACE|EYES
	flags_inv = HIDEFACE|BLOCKHAIR
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.5

/obj/item/clothing/head/soft/police
	icon = 'code/modules/halo/clothing/gcpd.dmi'
	icon_state = "gcpd-hat"
	item_state = "gcpd-hat"
	name = "police cap"
	desc = "A soft patrol cap to identify officers or show support."

/obj/item/clothing/gloves/thick/swat/police //swat subtype with no armor adjustments because hand meta is cancer
	name = "police gloves"
	desc = "Gray gloves with impact and shrapnel resistance with inbuilt fire retardant."
	icon = 'code/modules/halo/clothing/gcpd.dmi'
	icon_state = "gcpd-gloves"
	item_state = "gcpd-gloves"

//Emsville

/obj/item/clothing/under/marshall
	name = "Marshall's uniform"
	desc = "A tan uniform worn by the Emsville Marshalls."
	icon_state = "tanutility"
	worn_state = "tanutility"
	starting_accessories = list(/obj/item/clothing/accessory/holster/thigh)
	armor = list(melee = 20, bullet = 5, laser = 0, energy = 0, bomb = 5, bio = 0, rad = 0)

/obj/item/clothing/head/soft/emsville_marshall
	name = "Marshall's Hat"
	desc = "A hat worn by Marshalls, to signify their status. Reinforced a little with internal armour."
	armor = list(melee = 10,bullet = 20, laser = 20, energy = 20, bomb = 0, bio = 10, rad = 0)

/obj/item/clothing/head/helmet/emsville_marshall
	name = "Marshall's Helmet"
	desc = "A helmet worn by Marshalls, to signify their status."
	armor = list(melee = 30, bullet = 30, laser = 30,energy = 20, bomb = 25, bio = 0, rad = 0)
	icon = 'icons/obj/clothing/hats.dmi'
	icon_state = "helmet"
	item_icons = list("slot_l_hand"='icons/mob/items/lefthand_hats.dmi',"slot_r_hand"='icons/mob/items/righthand_hats.dmi')
	item_state_slots = list("slot_l_hand" = "helmet","slot_r_hand" = "helmet")

/obj/item/clothing/suit/storage/marine/emsville_marshall
	name = "Marshall's Armour"
	desc = "Armour worn by Marshalls, so signify their status."
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 40, bullet = 55, laser = 45, energy = 45, bomb = 40, bio = 25, rad = 25) //Somewhat boosted because it doesn't cover the arms.
	armor_thickness = 20
	icon = 'icons/obj/clothing/suits.dmi'
	icon_state = "bulletproofvest"
	item_state = null
	icon_override = null

/obj/item/clothing/suit/storage/marine/emsville_marshall/civ
	name = "Civilian Armour"
	desc = "Armour worn by Civilians, for safety against various hazards"
	body_parts_covered = UPPER_TORSO|LOWER_TORSO
	armor = list(melee = 35, bullet = 45, laser = 40, energy = 40, bomb = 40, bio = 25, rad = 25)

/obj/item/clothing/shoes/marine/emsville_marshall
	name = "Marshall's Shoes"
	desc = "Shoes worn by Marshalls, to signify their status. Has inlays for to provide extra leg-armour."
	body_parts_covered = FEET | LEGS
	armor = list(melee = 40, bullet = 40, laser = 5, energy = 30, bomb = 15, bio = 0, rad = 0)
	armor_thickness = 20
	icon = 'icons/obj/clothing/shoes.dmi'
	icon_state = "jackboots"
	item_state = "jackboots"
	icon_override = null

/obj/item/clothing/gloves/thick/unsc/emsville_marshall //Covers the arms, but weaker.
	name = "Marshall's Gloves and Armguards"
	desc = "Gloves and jumpsuit inlays designed to reinforce the arms and hands of Marshalls."
	body_parts_covered = HANDS | ARMS
