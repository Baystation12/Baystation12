/obj/item/clothing/accessory
	name = "tie"
	desc = "A neosilk clip-on tie."
	icon = 'icons/obj/clothing/obj_accessories.dmi'
	icon_state = "tie"
	item_state = ""	//no inhands
	slot_flags = SLOT_TIE
	w_class = ITEM_SIZE_SMALL
	var/accessory_flags = ACCESSORY_DEFAULT_FLAGS
	var/slot = ACCESSORY_SLOT_DECOR
	var/body_location = UPPER_TORSO //most accessories are here
	var/obj/item/clothing/parent //the suit the tie may be attached to
	var/image/inv_overlay = null	//overlay used when attached to clothing.
	var/list/mob_overlay = list()
	var/overlay_state = null
	var/list/accessory_icons = list(slot_w_uniform_str = 'icons/mob/onmob/onmob_accessories.dmi', slot_wear_suit_str = 'icons/mob/onmob/onmob_accessories.dmi')
	sprite_sheets = list(
		SPECIES_NABBER = 'icons/mob/species/nabber/onmob_accessories_gas.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_accessories_unathi.dmi'
		)
	var/list/on_rolled = list()	//used when jumpsuit sleevels are rolled ("rolled" entry) or it's rolled down ("down"). Set to "none" to hide in those states.
	var/slowdown //used when an accessory is meant to slow the wearer down when attached to clothing


/obj/item/clothing/accessory/Destroy()
	on_removed()
	return ..()


/obj/item/clothing/accessory/update_clothing_icon()
	..()
	if (parent)
		parent.update_clothing_icon()


/obj/item/clothing/accessory/proc/get_inv_overlay()
	if(!inv_overlay)
		var/tmp_icon_state = overlay_state
		if (!tmp_icon_state)
			tmp_icon_state = icon_state
		if(icon_override && ("[tmp_icon_state]_tie" in icon_states(icon_override)))
			inv_overlay = image(icon = icon_override, icon_state = "[tmp_icon_state]_tie", dir = SOUTH)
		else if("[tmp_icon_state]_tie" in icon_states(GLOB.default_onmob_icons[slot_tie_str]))
			inv_overlay = image(icon = GLOB.default_onmob_icons[slot_tie_str], icon_state = "[tmp_icon_state]_tie", dir = SOUTH)
		else
			inv_overlay = image(icon = GLOB.default_onmob_icons[slot_tie_str], icon_state = tmp_icon_state, dir = SOUTH)
	inv_overlay.color = color
	return inv_overlay


/obj/item/clothing/accessory/get_mob_overlay(mob/user_mob, slot)
	if(!istype(loc,/obj/item/clothing))	//don't need special handling if it's worn as normal item.
		return ..()
	var/bodytype = "Default"
	if(ishuman(user_mob))
		var/mob/living/carbon/human/user_human = user_mob
		if(user_human.species.get_bodytype(user_human) in sprite_sheets)
			bodytype = user_human.species.get_bodytype(user_human)

		var/tmp_icon_state = overlay_state? overlay_state : icon_state

		if(istype(loc,/obj/item/clothing/under))
			var/obj/item/clothing/under/C = loc
			if(on_rolled["down"] && C.rolled_down > 0)
				tmp_icon_state = on_rolled["down"]
			else if(on_rolled["rolled"] && C.rolled_sleeves > 0)
				tmp_icon_state = on_rolled["rolled"]

		var/use_sprite_sheet = accessory_icons[slot]
		if(sprite_sheets[bodytype])
			use_sprite_sheet = sprite_sheets[bodytype]

		if(icon_override && ("[tmp_icon_state]_mob" in icon_states(icon_override)))
			return overlay_image(icon_override, "[tmp_icon_state]_mob", color, RESET_COLOR)
		else
			return overlay_image(use_sprite_sheet, tmp_icon_state, color, RESET_COLOR)


//when user attached an accessory to S
/obj/item/clothing/accessory/proc/on_attached(var/obj/item/clothing/S, var/mob/user)
	if(!istype(S))
		return
	parent = S
	forceMove(parent)
	parent.overlays += get_inv_overlay()

	if(user)
		to_chat(user, "<span class='notice'>You attach \the [src] to \the [parent].</span>")
		src.add_fingerprint(user)


/obj/item/clothing/accessory/proc/on_removed(var/mob/user)
	if(!parent)
		return
	parent.overlays -= get_inv_overlay()
	parent = null
	if(user)
		usr.put_in_hands(src)
		src.add_fingerprint(user)
	else
		dropInto(loc)


//default attackby behaviour
/obj/item/clothing/accessory/attackby(obj/item/I, mob/user)
	..()


//default attack_hand behaviour
/obj/item/clothing/accessory/attack_hand(mob/user as mob)
	if(parent)
		return	//we aren't an object on the ground so don't call parent
	..()


/obj/item/clothing/accessory/get_pressure_weakness(pressure,zone)
	if(body_parts_covered & zone)
		return ..()
	return 1


/obj/item/clothing/accessory/toggleable/var/icon_closed


/obj/item/clothing/accessory/toggleable/New()
	if (!icon_closed)
		icon_closed = icon_state
	..()


/obj/item/clothing/accessory/toggleable/on_attached(obj/item/clothing/under/S, mob/user as mob)
	..()
	parent.verbs += /obj/item/clothing/accessory/toggleable/verb/toggle

/obj/item/clothing/accessory/toggleable/on_removed(mob/user as mob)
	if(parent)
		parent.verbs -= /obj/item/clothing/accessory/toggleable/verb/toggle
	..()


/obj/item/clothing/accessory/toggleable/verb/toggle()
	set name = "Toggle Buttons"
	set category = "Object"
	set src in usr
	if(usr.incapacitated())
		return 0
	var/obj/item/clothing/accessory/toggleable/H = null
	if (istype(src, /obj/item/clothing/accessory/toggleable))
		H = src
	else
		H = locate() in src
	if(H)
		H.do_toggle(usr)
	update_clothing_icon()


/obj/item/clothing/accessory/toggleable/proc/do_toggle(user)
	if(icon_state == icon_closed)
		icon_state = "[icon_closed]_open"
		to_chat(user, "You unbutton [src].")
	else
		icon_state = icon_closed
		to_chat(user, "You button up [src].")
	update_clothing_icon()
