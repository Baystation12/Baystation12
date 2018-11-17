
/obj/item/clothing/under/spartan_internal
	name = "Neural undersuit"
	desc = "To be worn under powered assault armour"
	icon = 'code/modules/halo/clothing/spartan_gear.dmi'
	icon_state = "neuralsuit"
	icon_override = 'code/modules/halo/clothing/spartan_gear.dmi'
	species_restricted = list("Spartan")

/obj/item/clothing/under/spartan_internal/get_mob_overlay(mob/user_mob, slot)
	var/image/I = ..()
	if(gender == FEMALE)
		I.icon_state += "_f"
	return I

/obj/item/clothing/shoes/magboots/spartan
	name = "Mjolnir boots"
	desc = "To be worn in conjunction with the Mjolnir Powered Assault Armour."
	icon = 'code/modules/halo/clothing/spartan_gear.dmi'
	icon_override = 'code/modules/halo/clothing/spartan_gear.dmi'
	icon_state = "neuralboots_obj0"
	icon_base = "neuralboots_obj"
	item_state = "neuralboots"
	force = 5
	armor = list(melee = 40, bullet = 40, laser = 5, energy = 20, bomb = 40, bio = 0, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS
	can_hold_knife = 1
	cold_protection = FEET
	min_cold_protection_temperature = SHOE_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = FEET
	max_heat_protection_temperature = SHOE_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = list("Spartan")

/obj/item/clothing/gloves/spartan
	name = "Mjolnir gloves"
	desc = "To be worn in conjunction with the Mjolnir Powered Assault Armour."
	icon = 'code/modules/halo/clothing/spartan_gear.dmi'
	icon_override = 'code/modules/halo/clothing/spartan_gear.dmi'
	icon_state = "neuralgloves_obj"
	item_state = "neuralgloves"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	body_parts_covered = HANDS
	armor = list(melee = 30, bullet = 40, laser = 10, energy = 25, bomb = 20, bio = 0, rad = 0)
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
	species_restricted = list("Spartan")
