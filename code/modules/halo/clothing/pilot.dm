#define SHIP_MOB_OVERRIDE 'code/modules/halo/clothing/mob_jumpsuit_ship.dmi'
#define SHIP_ITEM_OVERRIDE 'code/modules/halo/clothing/item_jumpsuit_ship.dmi'

//old
/obj/item/clothing/under/unsc/pilot
	desc = "UNSC pilot undersuit"
	name = "UNSC pilot undersuit"
	icon_state = "unscgrey"
	item_state = "unscgrey"
	worn_state = "unsc_pilot"

/obj/item/clothing/head/helmet/pilot
	name = "UNSC pilot helmet"
	desc = "Standard protective helmet for UNSC pilots."
	icon = 'code/modules/halo/clothing/item_jumpsuit_ship.dmi'
	icon_override = 'code/modules/halo/clothing/mob_jumpsuit_ship.dmi'
	icon_state = "pilot"
	item_state = "unsc_pilot"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 20, bio = 0, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	/*cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = 3*/

	integrated_hud = /obj/item/clothing/glasses/hud/tactical

//NEW

/obj/item/clothing/under/unsc/newpilot
	name = "UNSC Pilot uniform"
	icon = 'code/modules/halo/clothing/mob_jumpsuit_ship.dmi'
	icon_override = 'code/modules/halo/clothing/mob_jumpsuit_ship.dmi'
	icon_state = "unsc_pilot_clothes-obj"
	item_state = "unsc_pilot_clothes-obj"
	worn_state = "unsc_pilot_clothes"

/obj/item/clothing/head/helmet/newpilot
	name = "UNSC Pilot helm"
	desc = "Standard protective helmet for UNSC pilots."
	icon = 'code/modules/halo/clothing/mob_jumpsuit_ship.dmi'
	icon_override = 'code/modules/halo/clothing/mob_jumpsuit_ship.dmi'
	icon_state = "unsc_pilot_helmet-obj"
	item_state = "unsc_pilot_helmet"
	item_flags = THICKMATERIAL
	action_button_name = "Adjust Visor"
	flash_protection = FLASH_PROTECTION_MODERATE
	body_parts_covered = HEAD
	armor = list(melee = 50, bullet = 15, laser = 50,energy = 10, bomb = 20, bio = 0, rad = 0)
	flags_inv = HIDEEARS
	var/up = 0

/obj/item/clothing/head/helmet/newpilot/attack_self()
	toggle()

/obj/item/clothing/head/helmet/newpilot/verb/toggle()
	set category = "Object"
	set name = "Adjust Visor"
	set src in usr

	if(usr.canmove && !usr.incapacitated())
		if(src.up)
			src.up = !src.up
			flags_inv |= HIDEEYES
			body_parts_covered |= EYES
			item_state = initial(item_state)
			flash_protection = initial(flash_protection)
			to_chat(usr, "You flip the [src]'s down.")
		else
			src.up = !src.up
			flags_inv &= ~HIDEEYES
			body_parts_covered &= ~EYES
			item_state = "[initial(item_state)]up"
			flash_protection = FLASH_PROTECTION_NONE
			to_chat(usr, "You push the [src]'s up out of your face.")
		update_clothing_icon()
		usr.update_action_buttons()


	integrated_hud = /obj/item/clothing/glasses/hud/tactical

#undef SHIP_MOB_OVERRIDE
#undef SHIP_ITEM_OVERRIDE