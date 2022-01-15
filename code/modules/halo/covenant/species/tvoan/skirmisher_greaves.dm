#define SKIRMISHER_CLOTHING_PATH 'code/modules/halo/covenant/species/tvoan/skirm_clothing.dmi'

/obj/item/clothing/shoes/skirmisher
	name = "Kig\'Yar Minor greaves"
	desc = "Kig'Yar greaves for lower limb protection."
	icon = SKIRMISHER_CLOTHING_PATH
	icon_override = SKIRMISHER_CLOTHING_PATH
	icon_state = "minorboot"
	item_state = "minor_greaves"
	force = 5
	armor = list(melee = 40, bullet = 40, laser = 40, energy = 40, bomb = 40, bio = 0, rad = 0)
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS
	species_restricted = list("Kig-Yar", "Tvaoan Kig-Yar")
	matter = list("nanolaminate" = 1)
	stepsound = 'code/modules/halo/sounds/walk_sounds/marine_boots.ogg'

/obj/item/clothing/shoes/skirmisher/major
	name = "Kig\'Yar Major greaves"
	icon_state = "majorboot"
	item_state = "major_greaves"

/obj/item/clothing/shoes/skirmisher/murmillo
	name = "T\'Vaoan Kig\'Yar Murmillo greaves"
	icon_state = "murmilloboot"
	item_state = "murmillo_greaves"
	species_restricted = list("Tvaoan Kig-Yar")

/obj/item/clothing/shoes/skirmisher/commando
	name = "T\'Vaoan Kig\'Yar Commando greaves"
	icon_state = "commandoboot"
	item_state = "commando_greaves"
	species_restricted = list("Tvaoan Kig-Yar")

/obj/item/clothing/shoes/skirmisher/champion
	name = "T\'Vaoan Kig\'Yar Champion greaves"
	icon_state = "championboot"
	item_state = "champion_greaves"
	species_restricted = list("Tvaoan Kig-Yar")

#undef SKIRMISHER_CLOTHING_PATH