/*
 * Defines the helmets, gloves and shoes for rigs.
 */

/obj/item/clothing/head/helmet/space/rig
	name = "helmet"
	flags = FPRINT | TABLEPASS | HEADCOVERSEYES | BLOCKHAIR | HEADCOVERSMOUTH | THICKMATERIAL
	flags_inv = 		 HIDEEARS
	body_parts_covered = HEAD
	heat_protection =    HEAD
	cold_protection =    HEAD
	brightness_on = 4
	species_restricted = null

/obj/item/clothing/gloves/rig
	name = "gauntlets"
	flags = FPRINT | TABLEPASS | THICKMATERIAL
	body_parts_covered = HANDS
	heat_protection =    HANDS
	cold_protection =    HANDS
	species_restricted = null
	gender = PLURAL

/obj/item/clothing/shoes/magboots/rig
	name = "boots"
	cold_protection = FEET
	heat_protection = FEET
	species_restricted = null
	gender = PLURAL
	icon_base = null

/obj/item/clothing/suit/space/rig
	name = "chestpiece"
	allowed = list(/obj/item/device/flashlight,/obj/item/weapon/tank,/obj/item/device/suit_cooling_unit)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	heat_protection =    UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	cold_protection =    UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	flags_inv =          HIDEJUMPSUIT|HIDETAIL
	flags =              FPRINT | TABLEPASS | STOPSPRESSUREDMAGE | THICKMATERIAL | AIRTIGHT
	slowdown = 0
	breach_threshold = 35
	can_breach = 1
	supporting_limbs = list()

//TODO: move this to modules
/obj/item/clothing/head/helmet/space/rig/proc/prevent_track()
	return 0

/obj/item/clothing/gloves/rig/Touch(var/atom/A, var/proximity)

	if(!A || !proximity)
		return 0

	var/mob/living/carbon/human/H = loc
	if(!istype(H) || !H.back)
		return 0

	var/obj/item/weapon/rig/suit = H.back
	if(!suit || !istype(suit) || !suit.installed_modules.len)
		return 0

	for(var/obj/item/rig_module/module in suit.installed_modules)
		if(module.active && module.activates_on_touch)
			if(module.engage(A))
				return 1

	return 0