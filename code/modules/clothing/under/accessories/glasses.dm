/obj/item/clothing/accessory/glasses
	w_class = ITEM_SIZE_TINY
	slot = ACCESSORY_SLOT_GLASSES
	body_location = EYES
	slot_flags = EMPTY_BITFIELD
	icon = 'icons/obj/clothing/glasses_accessory.dmi'
	accessory_icons = list(
		slot_glasses_str = 'icons/obj/clothing/glasses_accessory.dmi'
	)
	var/prescription = 0
	var/vision_flags = EMPTY_BITFIELD
	var/darkness_view = 0
	var/see_invisible = -1
	var/light_protection = 0
	var/obj/screen/overlay
	var/can_toggle
	var/toggled


/obj/item/clothing/accessory/glasses/Initialize()
	. = ..()
	if (!can_toggle)
		verbs -= /obj/item/clothing/accessory/glasses/verb/toggle


/obj/item/clothing/accessory/glasses/on_attached(obj/item/clothing/C, mob/user)
	..()
	if (can_toggle)
		parent.verbs += /obj/item/clothing/accessory/glasses/verb/toggle


/obj/item/clothing/accessory/glasses/on_removed(mob/user)
	if (can_toggle && parent)
		parent.verbs -= /obj/item/clothing/accessory/glasses/verb/toggle
	..()


/obj/item/clothing/accessory/glasses/verb/toggle()
	set name = "Toggle Clip-ons"
	set category = "Object"
	set src in usr
	if (!ishuman(usr) || usr.stat)
		return
	var/obj/item/clothing/accessory/glasses/G = src
	if (!istype(G))
		G = locate() in src
		if (!G)
			return
	G.toggled = !G.toggled
	G.on_toggle(usr)


/obj/item/clothing/accessory/glasses/proc/on_toggle(mob/user)
	return


/obj/item/clothing/accessory/glasses/shades
	name = "clip-on sunglasses"
	desc = "Peek geek."
	icon_state = "shades"
	overlay_state = "shades_worn"
	can_toggle = TRUE
	darkness_view = -1
	flash_protection = FLASH_PROTECTION_MINOR
	accessory_flags = ACCESSORY_REMOVABLE | ACCESSORY_HIGH_VISIBILITY | ACCESSORY_INV_USE_ICON
	flags_inv = HIDEEYES
	body_parts_covered = EYES


/obj/item/clothing/accessory/glasses/shades/on_toggle(mob/living/carbon/human/user)
	darkness_view = toggled ? 0 : initial(darkness_view)
	flash_protection = toggled ? 0 : initial(flash_protection)
	flags_inv = toggled ? 0 : initial(flags_inv)
	update_clothing_icon()
	if (user)
		if (istype(user))
			user.update_equipment_vision()
		user.visible_message(
			SPAN_ITALIC("\The [user] flips \the [src] [toggled ? "up" : "down"]."),
			SPAN_ITALIC("You flip \the [src] [toggled ? "up" : "down"]."),
			range = 5
		)





/obj/item/clothing/accessory/glasses/shades/update_clothing_icon()
	icon_state = "[initial(icon_state)][toggled ? "_toggled" : ""]"
	overlay_state = "[initial(overlay_state)][toggled ? "_toggled" : ""]"
	..()


/obj/item/clothing/accessory/glasses/shades/on_attached(obj/item/clothing/parent, mob/living/carbon/human/user)
	..()
	if (istype(user))
		user.update_equipment_vision()


/obj/item/clothing/accessory/glasses/shades/on_removed(mob/user)
	darkness_view = initial(darkness_view)
	flash_protection = initial(flash_protection)
	flags_inv = initial(flags_inv)
	toggled = FALSE
	update_clothing_icon()
	..()


/datum/gear/accessory/glasses
	display_name = "Glasses Accessories"
	description = "Stuff you can clip to your glasses."
	path = /obj/item/clothing/accessory/glasses


/datum/gear/accessory/glasses/New()
	..()
	var/list/options = list()
	options["clip-on shades"] = /obj/item/clothing/accessory/glasses/shades
	gear_tweaks += new /datum/gear_tweak/path (options)
