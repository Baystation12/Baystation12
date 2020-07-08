#define SKIRMISHER_CLOTHING_PATH 'code/modules/halo/covenant/species/tvoan/skirm_clothing.dmi'

/obj/item/clothing/shoes/skirmisher
	name = "T\'Vaoan Skirmisher greaves"
	desc = "T\'vaoan Kig'Yar greaves for lower limb protection."
	icon = SKIRMISHER_CLOTHING_PATH
	icon_state = "minorboot"
	item_state = "minor_greaves"
	force = 5
	armor = list(melee = 40, bullet = 40, laser = 5, energy = 20, bomb = 40, bio = 0, rad = 0)
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS
	species_restricted = list("Tvaoan Kig-Yar")
	sprite_sheets = list("Tvaoan Kig-Yar" = SKIRMISHER_CLOTHING_PATH)
	matter = list("nanolaminate" = 1)

/obj/item/clothing/shoes/skirmisher/major
	name = "T\'Vaoan Major greaves"
	icon_state = "majorboot"
	item_state = "major_greaves"

/obj/item/clothing/shoes/skirmisher/murmillo
	name = "T\'Vaoan Murmillo greaves"
	icon_state = "murmilloboot"
	item_state = "murmillo_greaves"

/obj/item/clothing/shoes/skirmisher/commando
	name = "T\'Vaoan Commando greaves"
	icon_state = "commandoboot"
	item_state = "commando_greaves"

/obj/item/clothing/shoes/skirmisher/champion
	name = "T\'Vaoan Champion greaves"
	icon_state = "championboot"
	item_state = "champion_greaves"

#undef SKIRMISHER_CLOTHING_PATH