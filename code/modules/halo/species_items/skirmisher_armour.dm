
/obj/item/clothing/suit/armor/special/skirmisher
	name = "T'Voan Skirmisher harness"
	desc = "A protective harness for use during combat by  T'voan Kig'Yar."
	icon = 'code/modules/halo/icons/species/skirm_clothing.dmi'
	icon_state = "minor_obj"
	item_state = "minor"
	sprite_sheets = list("Tvaoan Kig-Yar" = 'code/modules/halo/icons/species/skirm_clothing.dmi')
	species_restricted = list("Tvaoan Kig-Yar")
	armor = list(melee = 75, bullet = 65, laser = 20, energy = 20, bomb = 40, bio = 25, rad = 20)
	armor_thickness_modifiers = list()
	body_parts_covered = UPPER_TORSO|LOWER_TORSO

/obj/item/clothing/suit/armor/special/skirmisher/major
	name = "T'Voan Major harness"
	icon_state = "major_obj"
	item_state = "major"

/obj/item/clothing/suit/armor/special/skirmisher/murmillo
	name = "T'Voan Murmillo harness"
	icon_state = "murmillo_obj"
	item_state = "murmillo"

/obj/item/clothing/suit/armor/special/skirmisher/commando
	name = "T'Voan Commando harness"
	icon_state = "commando_obj"
	item_state = "commando"
	specials = list(/datum/armourspecials/holo_decoy)

/obj/item/clothing/suit/armor/special/skirmisher/champion
	name = "T'Voan Champion harness"
	icon_state = "champion_obj"
	item_state = "champion"
	specials = list(/datum/armourspecials/holo_decoy)
