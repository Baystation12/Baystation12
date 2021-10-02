/obj/item/clothing/accessory/fire_overpants
	name = "fire overpants"
	desc = "some overpants made of fire-resistant synthetic fibers. To be worn over the uniform."
	icon_state = "fire_overpants"
	gas_transfer_coefficient = 0.90
	permeability_coefficient = 0.50

	armor = list(laser = ARMOR_LASER_MINOR, energy = ARMOR_ENERGY_MINOR, bomb = ARMOR_BOMB_MINOR)
	body_parts_covered = LOWER_TORSO | LEGS
	body_location = LOWER_TORSO | LEGS
	slowdown = 0.5

	heat_protection = LOWER_TORSO | LEGS
	cold_protection = LOWER_TORSO | LEGS

	max_heat_protection_temperature = FIRESUIT_MAX_HEAT_PROTECTION_TEMPERATURE
	max_pressure_protection = FIRESUIT_MAX_PRESSURE
