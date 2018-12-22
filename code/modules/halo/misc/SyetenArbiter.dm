/obj/item/clothing/suit/armor/special/sangheili/arbiter
	name = "Arbiter Combat Harness"
	desc = "A protective harness for use during combat by the arbiter."
	icon = 'icons/syetenarbiter.dmi'
	icon_state = "dogler-arbiter-suit_obj"
	item_state = "dogler-arbiter-suit_worn"
	sprite_sheets = list("Sangheili" = 'icons/syetenarbiter.dmi')
	species_restricted = list("Sangheili")
	armor = list(melee = 95, bullet = 80, laser = 60, energy = 60, bomb = 60, bio = 25, rad = 25)
	totalshields = 150
	specials = list(/datum/armourspecials/shields,/datum/armourspecials/shieldmonitor/sangheili)
	body_parts_covered = UPPER_TORSO|LOWER_TORSO|ARMS
	allowed = list(/obj/item/weapon/melee/energy/elite_sword, /obj/item/weapon/grenade/plasma, /obj/item/weapon/gun/energy/plasmapistol, /obj/item/weapon/gun/energy/plasmarifle)
	armor_thickness_modifiers = list()

/obj/item/clothing/head/special/sangheili/arbiter
	name = "Arbiter Helmet"
	desc = "A protective helmet for use during combat by an arbiter."
	icon = 'icons/syetenarbiter.dmi'
	icon_state = "dogler-arbiter-helm_obj"
	item_state = "dogler-arbiter-helm_worn"
	sprite_sheets = list("Sangheili" = 'icons/syetenarbiter.dmi')
	species_restricted = list("Sangheili")
	armor = list(melee = 40,bullet = 20,laser = 40,energy = 5,bomb = 25,bio = 0,rad = 0)
	armor_thickness_modifiers = list()
	body_parts_covered = HEAD | FACE

/obj/item/clothing/shoes/special/sangheili/arbiter
	name = "Arbiter Leg Armour"
	desc = "Protective leg armour for use by an arbiter."
	icon = 'icons/syetenarbiter.dmi'
	icon_state = "dogler-arbiter-boots_obj"
	item_state = "dogler-arbiter-boots_worn"
	sprite_sheets = list("Sangheili" = 'icons/syetenarbiter.dmi')
	species_restricted = list("Sangheili")
	armor = list(melee = 40, bullet = 60, laser = 5, energy = 5, bomb = 40, bio = 0, rad = 0)
	armor_thickness_modifiers = list()
	body_parts_covered = LEGS

/obj/item/clothing/gloves/special/sangheili/arbiter
	name = "Arbiter Gauntlets"
	desc = "Protective gloves for use by an arbiter."
	icon = 'icons/syetenarbiter.dmi'
	icon_state = "dogler-arbiter-gloves_obj"
	item_state = "dogler-arbiter-gloves_worn"
	sprite_sheets = list("Sangheili" = 'icons/syetenarbiter.dmi')
	species_restricted = list("Sangheili")
	armor = list(melee = 30, bullet = 40, laser = 10, energy = 25, bomb = 20, bio = 0, rad = 0)
	armor_thickness_modifiers = list()
	body_parts_covered = HANDS

/obj/item/clothing/mask/sangheili/arbiter
	name = "Arbiter Mask"
	desc = "A mask for covering your face."
	icon = 'icons/syetenarbiter.dmi'
	icon_state = "dogler-arbiter-mask_obj"
	item_state = "dogler-arbiter-mask_worn"
	sprite_sheets = list("Sangheili" = 'icons/syetenarbiter.dmi')
	species_restricted = list("Sangheili")
	body_parts_covered = FACE

/obj/item/weapon/melee/energy/energystave
	name = "Energy Stave"
	desc = "An energy stave with a shimmering blade."
	icon = 'icons/syetenarbiter.dmi'
	icon_state = "dogler-staff_obj"
	item_state = "dogler-staff_obj"
	force = 65
	throwforce = 12
	edge = 0
	sharp = 0

/obj/item/clothing/suit/armor/special/sangheili/arbiter/shielded
	name = "Arbiter Combat Harness (Arbiter)"
	icon_state = "dogler-arbiter-suit_obj"
	item_state = "dogler-arbiter-suit_worn"
	totalshields = 150
