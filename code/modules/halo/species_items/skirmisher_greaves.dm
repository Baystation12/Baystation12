
/obj/item/clothing/shoes/skirmisher
	name = "T'Voan Skirmisher greaves"
	desc = "T'voan Kig'Yar greaves for lower limb protection."
	icon = 'code/modules/halo/icons/species/skirm_clothing.dmi'
	icon_state = "minorboot"
	item_state = "minor_greaves"
	force = 5
	armor = list(melee = 40, bullet = 40, laser = 5, energy = 20, bomb = 40, bio = 0, rad = 0)
	item_flags = NOSLIP
	siemens_coefficient = 0.6
	body_parts_covered = FEET|LEGS
	species_restricted = list("Tvaoan Kig-Yar")
	sprite_sheets = list("Tvaoan Kig-Yar" = 'code/modules/halo/icons/species/skirm_clothing.dmi')

/obj/item/clothing/shoes/skirmisher/major
	name = "T'Voan Major greaves"
	icon_state = "majorboot"
	item_state = "major_greaves"

/obj/item/clothing/shoes/skirmisher/murmillo
	name = "T'Voan Murmillo greaves"
	icon_state = "murmilloboot"
	item_state = "murmillo_greaves"

/obj/item/clothing/shoes/skirmisher/commando
	name = "T'Voan Commando greaves"
	icon_state = "commandoboot"
	item_state = "commando_greaves"

/obj/item/clothing/shoes/skirmisher/champion
	name = "T'Voan Champion greaves"
	icon_state = "championboot"
	item_state = "champion_greaves"
