/obj/item/clothing/under/knight_internal
	name = "Internal Mesh"
	desc = "A mesh of gravity manipulators that holds a Knight's chassis together."
	icon = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi'
	icon_state = "chest_chassis"
	item_state = " "
	icon_override = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi'
	species_restricted = list("Knight")

/obj/item/clothing/head/helmet/knight
	name = "Knight Helmet"
	desc = "Covers the face of a Promethean Knight. Sometimes removed as a fear-inducing method."
	icon = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi'
	icon_override = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi'
	icon_state = "knighthelmet_obj"
	item_state = "knighthelmet"
	sprite_sheets = list("Knight" = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi')

	flash_protection = FLASH_PROTECTION_MAJOR
	armor = list(melee = 60, bullet = 40, laser = 30,energy = 30, bomb = 25, bio = 30, rad = 30)
	armor_thickness = 25
	unacidable = 1
	canremove = 1
	species_restricted = list("Knight")

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

/obj/item/weapon/storage/backpack/knight
	name = "Knight Slipspace Unit"
	desc = "This unit allows a Promethean Knight to perform small scale instantenous teleportations, as well as store items."
	icon = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi'
	icon_override = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi'
	icon_state = "knightwing_obj"
	item_state = "knightwing"
	sprite_sheets = list("Knight" = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi')
	canremove = 0
	unacidable = 1

/obj/item/weapon/storage/belt/knight
	name = "Knight Munitions Storage"
	desc = "A slipspace storage unit that is often filled with munitions for a Knight's weaponry"
	icon = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi'
	icon_state = "belt"
	item_state = " "
	storage_slots = 8
	sprite_sheets = list("Knight" = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi')

	can_hold = list(/obj/item/ammo_magazine,/obj/item/ammo_box,/obj/item/ammo_casing)

/obj/item/clothing/suit/armor/special/knight_armour
	name = "Knight Chassis"
	desc = "The chassis of a Promethean Knight"
	icon = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi'
	icon_override = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi'
	icon_state = "chest_chassis"
	item_state = " "
	sprite_sheets = list("Knight" = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi')

	armor = list(melee = 55, bullet = 50, laser = 55, energy = 55, bomb = 40, bio = 25, rad = 25)
	armor_thickness = 25
	max_suitstore_w_class = ITEM_SIZE_HUGE
	unacidable = 0
	canremove = 1

	species_restricted = list("Knight")

/obj/item/clothing/shoes/magboots/knight_boots
	name = "Knight Legs"
	desc = "Armoured legs, to be fitted to the chassis of a Promethean Knight"
	icon = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi'
	icon_override = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi'
	icon_state = "leg0"
	icon_base = "leg"
	item_state = " "
	sprite_sheets = list("Knight" = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi')

	armor = list(melee = 40, bullet = 40, laser = 5, energy = 20, bomb = 50, bio = 0, rad = 0)
	canremove = 0
	unacidable = 1
	species_restricted = list("Knight")

/obj/item/clothing/gloves/knight_gauntlets
	name = "Knight Gauntlets"
	desc = "Gauntlets and hardlight projectors, to be fitted to the chassis of a Promethean Knight"
	icon = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi'
	icon_override = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi'
	icon_state = "gauntlet"
	item_state = " "
	sprite_sheets = list("Knight" = 'code/modules/halo/forerunner/species/knight/knight_armour.dmi')
	canremove = 0
	unacidable = 1
	species_restricted = list("Knight")
	slot_flags = SLOT_GLOVES | SLOT_DENYPOCKET

	action_button_name = "Toggle Hardlight Blade"

	var/obj/myblade

/obj/item/clothing/gloves/knight_gauntlets/Initialize()
	. = ..()
	myblade = new /obj/item/weapon/melee/hardlight_blade/gauntletbound(src)

/obj/item/clothing/gloves/knight_gauntlets/proc/toggle_blade(var/mob/living/carbon/human/h)
	if(!istype(h))
		return
	if((locate(myblade) in h.contents))
		h.drop_from_inventory(myblade)
		return
	if(!h.put_in_active_hand(myblade))
		if(!h.put_in_inactive_hand(myblade))
			to_chat(h,"<span class = 'notice'>You need one hand free to use [src.name]</span>")

	h.update_inv_l_hand()
	h.update_inv_r_hand()

/obj/item/clothing/gloves/knight_gauntlets/ui_action_click()
	var/mob/living/carbon/human/h = loc
	if(istype(h))
		toggle_blade(usr)