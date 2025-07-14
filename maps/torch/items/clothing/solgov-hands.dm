/obj/item/clothing/gloves/thick/duty/solgov
	name = "solgov duty gloves parent object"
	desc = "You should never see this."
	icon_state = null
	item_icons = list(slot_gloves_str = 'maps/torch/icons/mob/onmob_hands_solgov.dmi')
	icon = 'maps/torch/icons/obj/obj_hands_solgov.dmi'
	sprite_sheets = list(
		SPECIES_UNATHI = 'maps/torch/icons/mob/unathi/onmob_hands_solgov_unathi.dmi'
	)

/obj/item/clothing/gloves/thick/duty/solgov/eng
	name = "engineering duty gloves"
	desc = "These black duty gloves are made from durable synthetic materials, and have a lovely orange accent color."
	icon_state = "duty_gloves_eng"
	item_state = "duty_gloves_eng"

/obj/item/clothing/gloves/thick/duty/solgov/cmd
	name = "command duty gloves"
	desc = "These black duty gloves are made from durable synthetic materials, and have a lovely gold accent color."
	icon_state = "duty_gloves_cmd"
	item_state = "duty_gloves_cmd"

/obj/item/clothing/gloves/thick/duty/solgov/exp
	name = "exploration duty gloves"
	desc = "These black duty gloves are made from durable synthetic materials, and have a lovely purple accent color."
	icon_state = "duty_gloves_exp"
	item_state = "duty_gloves_exp"

/obj/item/clothing/gloves/thick/duty/solgov/sci
	name = "science duty gloves"
	desc = "These black duty gloves are made from durable synthetic materials, and have a lovely heather accent color."
	icon_state = "duty_gloves_sci"
	item_state = "duty_gloves_sci"

/obj/item/clothing/gloves/thick/duty/solgov/med
	name = "medical duty gloves"
	desc = "These black duty gloves are made from durable synthetic materials, and have a lovely blue accent color."
	icon_state = "duty_gloves_med"
	item_state = "duty_gloves_med"

/obj/item/clothing/gloves/thick/duty/solgov/sec
	name = "security duty gloves"
	desc = "These black duty gloves are made from durable synthetic materials, and have a lovely red accent color."
	icon_state = "duty_gloves_sec"
	item_state = "duty_gloves_sec"

/obj/item/clothing/gloves/thick/duty/solgov/svc
	name = "service duty gloves"
	desc = "These black duty gloves are made from durable synthetic materials, and have a lovely green accent color."
	icon_state = "duty_gloves_svc"
	item_state = "duty_gloves_svc"

/obj/item/clothing/gloves/thick/duty/solgov/sup
	name = "supply duty gloves"
	desc = "These black duty gloves are made from durable synthetic materials, and have a lovely brown accent color."
	icon_state = "duty_gloves_sup"
	item_state = "duty_gloves_sup"

/obj/item/clothing/gloves/thick/duty/solgov/fleet
	name = "fleet duty gloves"
	desc = "These black duty gloves are made from durable synthetic materials. Standard issue to all ranks in the SCG Fleet."
	icon_state = "fleet_gloves"
	item_state = "fleet_gloves"

/obj/item/clothing/gloves/thick/duty/solgov/fleet/combat // Combat gloves but fleet style
	name = "fleet combat gloves"
	desc = "These thick tactical gloves are somewhat resistant to fire and impact. They will also protect the wearer from electrical shocks"
	siemens_coefficient = 0
	permeability_coefficient = 0.05
	force = 5
	armor = list(
		melee = ARMOR_MELEE_RESISTANT,
		bullet = ARMOR_BALLISTIC_MINOR,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_SMALL,
		bomb = ARMOR_BOMB_MINOR,
		bio = ARMOR_BIO_MINOR)
	cold_protection = HANDS
	min_cold_protection_temperature = GLOVES_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HANDS
	max_heat_protection_temperature = GLOVES_MAX_HEAT_PROTECTION_TEMPERATURE
