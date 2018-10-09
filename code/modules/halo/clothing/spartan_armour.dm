
/obj/item/clothing/head/helmet/spartan
	name = "MJOLNIR Powered Assault Armor Helmet Mark IV"
	desc = "Ave, Imperator, morituri te salutant."
	icon = 'code/modules/halo/clothing/spartan_armour.dmi'
	icon_state = "mk4-helm"
	item_state = "mk4-helm-worn"
	icon_override = 'code/modules/halo/clothing/spartan_armour.dmi'

	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	flags_inv = HIDEMASK|HIDEEARS|HIDEEYES|BLOCKHAIR
	body_parts_covered = HEAD|FACE
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 1
	armor = list(melee = 50,bullet = 15,laser = 50,energy = 10,bomb = 25,bio = 0,rad = 0)
	species_restricted = list("Spartan")

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0

/obj/item/clothing/suit/armor/special/spartan
	name = "MJOLNIR Powered Assault Armor Mark IV"
	desc = "a technologically-advanced combat exoskeleton system designed to vastly improve the strength, speed, agility, reflexes and durability of a SPARTAN-II, supersoldier in the field of combat."
	icon = 'code/modules/halo/clothing/spartan_armour.dmi'
	icon_state = "mk4-shell"
	item_state = "mk4-shell-worn"
	icon_override = 'code/modules/halo/clothing/spartan_armour.dmi'

	blood_overlay_type = "armor"
	armor = list(melee = 80, bullet = 95, laser = 70, energy = 70, bomb = 60, bio = 25, rad = 25)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	flags_inv = HIDETAIL
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	species_restricted = list("Spartan")

	specials = list(/datum/armourspecials/gear/human_tank, /datum/armourspecials/shields/spartan, /datum/armourspecials/gear/spartan_boots, /datum/armourspecials/gear/spartan_gloves)
	allowed = list(/obj/item/weapon/tank)

/obj/item/clothing/under/spartan_internal/get_mob_overlay(mob/user_mob, slot)
	var/image/I = ..()
	if(gender == FEMALE)
		I.icon_state += "_f"
	return I
