//Spacesuit
//Note: Everything in modules/clothing/spacesuits should have the entire suit grouped together.
//      Meaning the the suit is defined directly after the corrisponding helmet. Just like below!
/obj/item/clothing/head/helmet/space
	name = "Space helmet"
	icon_state = "space"
	desc = "A special helmet designed for work in a hazardous, low-pressure environment."
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES | BLOCKHAIR | HEADCOVERSMOUTH | STOPSPRESSUREDMAGE | THICKMATERIAL
	item_state = "space"
	permeability_coefficient = 0.01
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 50)
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|HIDEFACE
	body_parts_covered = HEAD|FACE|EYES
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	species_restricted = list("exclude","Diona","Vox")

/obj/item/clothing/suit/space
	name = "Space suit"
	desc = "A suit that protects against low pressure environments. \"NSS EXODUS\" is written in large block letters on the back."
	icon_state = "space"
	item_state = "s_suit"
	w_class = 4//bulky item
	gas_transfer_coefficient = 0.01
	permeability_coefficient = 0.02
	flags = FPRINT | TABLEPASS | STOPSPRESSUREDMAGE | THICKMATERIAL
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank/emergency_oxygen,/obj/item/device/suit_cooling_unit)
	slowdown = 3
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 50)
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.9
	species_restricted = list("exclude","Diona","Vox")

	var/list/supporting_limbs //If not-null, automatically splints breaks. Checked when removing the suit.

/obj/item/clothing/suit/space/equipped(mob/M)
	check_limb_support()
	..()

/obj/item/clothing/suit/space/dropped()
	check_limb_support()
	..()

// Some space suits are equipped with reactive membranes that support
// broken limbs - at the time of writing, only the ninja suit, but
// I can see it being useful for other suits as we expand them. ~ Z
// The actual splinting occurs in /datum/organ/external/proc/fracture()
/obj/item/clothing/suit/space/proc/check_limb_support()

	// If this isn't set, then we don't need to care.
	if(!supporting_limbs || !supporting_limbs.len)
		return

	var/mob/living/carbon/human/H = src.loc

	// If the holder isn't human, or the holder IS and is wearing the suit, it keeps supporting the limbs.
	if(!istype(H) || H.wear_suit == src)
		return

	// Otherwise, remove the splints.
	for(var/datum/organ/external/E in supporting_limbs)
		E.status &= ~ ORGAN_SPLINTED
	supporting_limbs = list()