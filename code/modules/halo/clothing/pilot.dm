
/obj/item/clothing/under/unsc/pilot
	desc = "UNSC pilot undersuit"
	name = "UNSC pilot undersuit"
	icon_state = "unsc_pilot_s"
	item_state = "g_suit"
	worn_state = "unsc_pilot"

/obj/item/clothing/head/helmet/pilot
	name = "UNSC pilot helmet"
	desc = "Standard protective helmet for UNSC pilots."
	icon_state = "marine"
	item_state = "unscpilot"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	/*cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = 3*/
