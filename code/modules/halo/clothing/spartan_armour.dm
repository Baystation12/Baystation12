
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
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = HEAD
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 1
	armor = list(melee = 60,bullet = 35,laser = 25,energy = 25,bomb = 25,bio = 100,rad = 25)
	species_restricted = list("Spartan")

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light"
	brightness_on = 4
	on = 0
	item_state_slots = list(slot_l_hand_str = "syndicate-helm-black", slot_r_hand_str = "syndicate-helm-black")

/obj/item/clothing/suit/armor/special/spartan
	name = "MJOLNIR Powered Assault Armor Mark IV"
	desc = "a technologically-advanced combat exoskeleton system designed to vastly improve the strength, speed, agility, reflexes and durability of a SPARTAN-II, supersoldier in the field of combat."
	icon = 'code/modules/halo/clothing/spartan_armour.dmi'
	icon_state = "mk4-shell"
	item_state = "mk4-shell-worn"
	icon_override = 'code/modules/halo/clothing/spartan_armour.dmi'

	blood_overlay_type = "armor"
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 45, bomb = 60, bio = 100, rad = 25)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|FEET|ARMS|HANDS
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	flags_inv = HIDETAIL
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	species_restricted = list("Spartan")

	specials = list(/datum/armourspecials/gear/human_tank,\
		/datum/armourspecials/shields/spartan,
		/datum/armourspecials/shieldmonitor/)
		/*/datum/armourspecials/gear/mjolnir_gloves,\
		/datum/armourspecials/gear/mjolnir_boots,\
		/datum/armourspecials/gear/mjolnir_jumpsuit)*/
	allowed = list(/obj/item/weapon/tank)
	totalshields = 150
	item_state_slots = list(slot_l_hand_str = "syndicate-black", slot_r_hand_str = "syndicate-black")
	var/list/available_abilities = list(\
		"Hologram Decoy Emitter" = /datum/armourspecials/holo_decoy,\
		"Personal Cloaking Device" = /datum/armourspecials/cloaking/limited,\
		"Personal Regeneration Field" = /datum/armourspecials/regeneration,\
		"Overshield Emitter" = /datum/armourspecials/overshield,\
		"Upper Body Strength Enhancements" = /datum/armourspecials/superstrength,\
		"Leg Speed and Agility Enhancements" = /datum/armourspecials/superspeed\
		)

/obj/item/clothing/under/spartan_internal/get_mob_overlay(mob/user_mob, slot)
	var/image/I = ..()
	if(gender == FEMALE)
		I.icon_state += "_f"
	return I

/obj/item/clothing/suit/armor/special/spartan/equipped(var/mob/user, var/slot)
	..()

	spawn(0)
		if(user && user.client && specials.len <= 2 && available_abilities.len)
			var/ability_type_string = input(user, "Choose the armour ability of your MJOLNIR","MJOLNIR Armour Ability") in available_abilities
			var/ability_type = available_abilities[ability_type_string]
			specials.Add(new ability_type(src))