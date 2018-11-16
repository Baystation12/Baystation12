
GLOBAL_LIST_INIT(first_names_jiralhanae, world.file2list('code/modules/halo/species_items/first_jiralhanae.txt'))

/mob/living/carbon/human/covenant/Jiralhanae/New(var/new_loc)
	..(new_loc,"Jiralhanae")
	faction = "Covenant"

/datum/language/doisacci
	name = "Doisacci"
	desc = "The language of the Jiralhanae"
	native = 1
	colour = "vox"
	syllables = list("ung","ugh","uhh","hss","grss","grah","argh","hng","ung","uss","hoh","rog")
	key = "D"
	flags = RESTRICTED


/obj/item/clothing/under/covenant/jiralhanae
	name = "Jiralhanae Bodysuit"
	desc = "A Jiralhanae body suit. Looks itchy and covered in hair."
	icon = 'code/modules/halo/icons/species/jiralhanae.dmi'
	icon_state = "bodysuit_s"
	worn_state = "bodysuit"
	sprite_sheets = list("Jiralhanae" = 'code/modules/halo/icons/species/jiralhanae.dmi')
	species_restricted = list("Jiralhanae")
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|LEGS|ARMS


/obj/item/clothing/head/helmet/jiralhanae
	name = "Jiralhanae Helm"
	desc = "A crude metal cap made of a heavy, alien alloy."
	icon = 'code/modules/halo/icons/species/jiralhanae.dmi'
	icon_state = "Helmet"
	sprite_sheets = list("Jiralhanae" = 'code/modules/halo/icons/species/jiralhanae.dmi')
	armor = list(melee = 30, bullet = 20, laser = 10,energy = 10, bomb = 10, bio = 0, rad = 0)
	species_restricted = list("Jiralhanae")

/obj/item/clothing/head/helmet/jiralhanae/major
	name = "Jiralhanae Major Helm"
	icon_state = "Major Helmet"
	armor = list(melee = 35, bullet = 25, laser = 10,energy = 10, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/head/helmet/jiralhanae/captain
	name = "Jiralhanae Captain Helm"
	icon_state = "Captain Helmet"
	armor = list(melee = 40, bullet = 30, laser = 10,energy = 10, bomb = 10, bio = 0, rad = 0)


/obj/item/clothing/suit/armor/jiralhanae
	name = "Jiralhanae Chest Armour"
	desc = "A mysterious alien alloy fashioned into crude metal plating for protection of vital areas."
	species_restricted = list("Jiralhanae")
	icon = 'code/modules/halo/icons/species/jiralhanae.dmi'
	icon_state = "Chest/Arms Armor"
	sprite_sheets = list("Jiralhanae" = 'code/modules/halo/icons/species/jiralhanae.dmi')
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	armor = list(melee = 30, bullet = 20, laser = 10, energy = 10, bomb = 10, bio = 0, rad = 0)
	armor_thickness_modifiers = list()
	allowed = list(/obj/item/weapon/grenade/plasma, /obj/item/weapon/gun/energy/plasmapistol, /obj/item/weapon/gun/energy/plasmarifle, /obj/item/weapon/gun/energy/plasmarifle/brute)

/obj/item/clothing/suit/armor/jiralhanae/major
	name = "Jiralhanae Major Chest Armour"
	icon_state = "Major Chest"
	armor = list(melee = 35, bullet = 25, laser = 10, energy = 10, bomb = 10, bio = 0, rad = 0)

/obj/item/clothing/suit/armor/jiralhanae/captain
	name = "Jiralhanae Captain Chest Armour"
	icon_state = "Captain Chest"
	armor = list(melee = 40, bullet = 30, laser = 10, energy = 10, bomb = 10, bio = 0, rad = 0)
