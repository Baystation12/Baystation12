
/obj/item/clothing/glasses/hud/tactical/spartan_hud
	darkness_view = 7
	see_invisible = SEE_INVISIBLE_NOLIGHTING

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
	heat_protection = HEAD|FACE
	max_heat_protection_temperature = FIRE_HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = HEAD|FACE
	min_cold_protection_temperature = SPACE_HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	siemens_coefficient = 1
	flash_protection = FLASH_PROTECTION_MAJOR
	armor = list(melee = 60, bullet = 40, laser = 30,energy = 30, bomb = 25, bio = 30, rad = 30)
	species_restricted = list("Spartan")
	armor_thickness = 25

	action_button_name = "Toggle Helmet Light"
	light_overlay = "helmet_light_dual"
	brightness_on = 4
	unacidable = 1
	on = 0
	item_state_slots = list(slot_l_hand_str = "syndicate-helm-black", slot_r_hand_str = "syndicate-helm-black")

	integrated_hud = /obj/item/clothing/glasses/hud/tactical/spartan_hud



/obj/item/clothing/suit/armor/special/spartan
	name = "MJOLNIR Powered Assault Armor Mark IV"
	desc = "a technologically-advanced combat exoskeleton system designed to vastly improve the strength, speed, agility, reflexes and durability of a SPARTAN-II, supersoldier in the field of combat."
	icon = 'code/modules/halo/clothing/spartan_armour.dmi'
	icon_state = "mk4-shell"
	item_state = "mk4-shell-worn"
	icon_override = 'code/modules/halo/clothing/spartan_armour.dmi'

	blood_overlay_type = "armor"
	armor = list(melee = 55, bullet = 50, laser = 55, energy = 55, bomb = 40, bio = 25, rad = 25) //Two extra grace shots.
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS
	item_flags = STOPPRESSUREDAMAGE | THICKMATERIAL | AIRTIGHT
	flags_inv = HIDETAIL
	heat_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	cold_protection = UPPER_TORSO | LOWER_TORSO | LEGS | FEET | ARMS | HANDS
	min_cold_protection_temperature = SPACE_SUIT_MIN_COLD_PROTECTION_TEMPERATURE
	armor_thickness = 22 //gives 7 grace shots to this armour.
	species_restricted = list("Spartan")
	max_suitstore_w_class = ITEM_SIZE_HUGE
	unacidable = 1

	specials = list(/datum/armourspecials/shields/spartan,\
		/datum/armourspecials/shieldmonitor,\
		/datum/armourspecials/self_destruct)
		/*/datum/armourspecials/gear/mjolnir_gloves,\
		/datum/armourspecials/gear/mjolnir_boots,\
		/datum/armourspecials/gear/mjolnir_jumpsuit)*/
	totalshields = 140
	item_state_slots = list(slot_l_hand_str = "syndicate-black", slot_r_hand_str = "syndicate-black")

/obj/item/clothing/under/spartan_internal/get_mob_overlay(mob/user_mob, slot)
	var/image/I = ..()
	if(gender == FEMALE)
		I.icon_state += "_f"
	return I
