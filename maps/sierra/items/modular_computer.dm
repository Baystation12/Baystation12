/obj/item/modular_computer/pda/wrist
	name = "wrist computer"
	desc = "A wrist-mounted modular personal computer. Very stylish."
	icon = 'maps/sierra/icons/obj/wrist_computer.dmi'
	icon_state = "wc_base"
	color = COLOR_GUNMETAL
	item_state_slots = list(slot_wear_id_str = "wc_base")
	light_color = COLOR_GREEN
	var/stripe_color

	slot_flags = SLOT_ID | SLOT_BELT

	icon_state_unpowered = "wc_base"
	item_icons = list(slot_wear_id_str = 'maps/sierra/icons/mob/wrist_computer.dmi')
	item_state = "wc_base"

	interact_sounds = list('maps/sierra/sound/items/ui_pipboy_select.wav')

/obj/item/modular_computer/pda/wrist/get_mob_overlay(mob/user_mob, slot)
	var/image/ret = ..()
	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	if(slot == slot_wear_id_str)
		if(enabled)
			var/image/I = image(icon = ret.icon, icon_state = "wc_screen")
			I.appearance_flags |= RESET_COLOR
			I.color = (bsod || os.updating) ? "#0000ff" : "#00ff00"
			ret.AddOverlays(I)
		else
			ret.AddOverlays(image(icon = ret.icon, icon_state = "wc_screen_off"))
		if(stripe_color)
			var/image/I = image(icon = ret.icon, icon_state = "wc_stripe")
			I.appearance_flags |= RESET_COLOR
			I.color = stripe_color
			AddOverlays(I)
	return ret

/obj/item/modular_computer/pda/wrist/on_update_icon()
	var/datum/extension/interactive/ntos/os = get_extension(src, /datum/extension/interactive/ntos)
	icon_state = icon_state_unpowered
	ClearOverlays()

	if(os)
		var/image/_screen_overlay = os.get_screen_overlay()
		AddOverlays(overlay_image(_screen_overlay.icon, _screen_overlay.icon_state, flags = RESET_COLOR))

	if(enabled)
		set_light(light_strength, 0.2, l_color = (bsod || os.updating) ? "#0000ff" : light_color)

	if(enabled && os)
		var/image/_screen_overlay = os.get_screen_overlay()
		AddOverlays(emissive_appearance(_screen_overlay.icon, _screen_overlay.icon_state))
	else
		set_light(0)

	if(stripe_color)
		var/image/I = image(icon = icon, icon_state = "wc_stripe")
		I.appearance_flags |= RESET_COLOR
		I.color = stripe_color
		AddOverlays(I)

	var/mob/living/carbon/human/H = loc
	if(istype(H) && H.wear_id == src)
		H.update_inv_wear_id()

/obj/item/modular_computer/pda/wrist/AltClick(mob/user)
	if(!CanPhysicallyInteract(user) || !card_slot?.stored_card)
		return ..()

	card_slot.eject_id(user)
	return TRUE

/obj/item/modular_computer/pda/wrist/attack_hand(mob/user)
	if(loc == user)
		if(user.incapacitated() || user.restrained())
			return
		var/mob/living/carbon/human/H = user
		if(istype(H) && src == H.wear_id)
			return attack_self(user)
	return ..()

/obj/item/modular_computer/pda/wrist/MouseDrop(obj/over_object)
	if(ishuman(usr))
		if(loc != usr) return
		if(usr.restrained() || usr.incapacitated()) return
		if (!usr.unEquip(src)) return
		usr.put_in_hands(src)
		src.add_fingerprint(usr)
		return
	return ..()

// wrist box
/obj/item/storage/box/wrist
	name = "box of spare wrist computers"
	desc = "A box of spare wrist microcomputers."
	icon_state = "pda"
	startswith = list(/obj/item/modular_computer/pda/wrist = 5)

// wrist types

/obj/item/modular_computer/pda/wrist/medical
	color = COLOR_OFF_WHITE
	stripe_color = COLOR_BLUE_GRAY

/obj/item/modular_computer/pda/wrist/chemistry
	color = COLOR_OFF_WHITE
	stripe_color = COLOR_BLUE_GRAY

/obj/item/modular_computer/pda/wrist/engineering
	stripe_color = COLOR_ORANGE

/obj/item/modular_computer/pda/wrist/security
	stripe_color = COLOR_MAROON

/obj/item/modular_computer/pda/wrist/forensics
	stripe_color = COLOR_MAROON

/obj/item/modular_computer/pda/wrist/science
	stripe_color = COLOR_RESEARCH

/obj/item/modular_computer/pda/wrist/heads
	color = PIPE_COLOR_BLACK
	stripe_color = COLOR_BLUE_GRAY

/obj/item/modular_computer/pda/wrist/heads/paperpusher
	stored_pen = /obj/item/pen/fancy

/obj/item/modular_computer/pda/wrist/heads/hop
	stripe_color = COLOR_SKY_BLUE

/obj/item/modular_computer/pda/wrist/heads/hos
	stripe_color = COLOR_MAROON

/obj/item/modular_computer/pda/wrist/heads/ce
	color = COLOR_OFF_WHITE
	stripe_color = COLOR_ORANGE

/obj/item/modular_computer/pda/wrist/heads/cmo
	color = COLOR_OFF_WHITE
	stripe_color = COLOR_BLUE_GRAY

/obj/item/modular_computer/pda/wrist/heads/rd
	stripe_color = COLOR_RESEARCH

/obj/item/modular_computer/pda/wrist/captain
	color = PIPE_COLOR_BLACK
	stripe_color = COLOR_YELLOW

/obj/item/modular_computer/pda/wrist/ert
	color = PIPE_COLOR_BLACK
	stripe_color = COLOR_YELLOW

/obj/item/modular_computer/pda/wrist/cargo
	stripe_color = COLOR_PALE_YELLOW

/obj/item/modular_computer/pda/wrist/syndicate
	color = PIPE_COLOR_BLACK
	stripe_color = COLOR_MAROON

/obj/item/modular_computer/pda/wrist/roboticist
	stripe_color = COLOR_ORANGE

/obj/item/modular_computer/pda/wrist/explorer
	color = PIPE_COLOR_BLACK
	stripe_color = COLOR_INDIGO

/obj/item/modular_computer/pda/wrist/grey
	color = COLOR_GRAY

/obj/item/modular_computer/pda/wrist/lila
	color = null
	icon_state = "wrist-lila"
	icon_state_unpowered = "wrist-lila"

/obj/item/modular_computer/pda/wrist/lila/black
	icon_state = "wrist-lila-black"
	icon_state_unpowered = "wrist-lila-black"

// Laptop icon override

/obj/item/modular_computer/laptop
	icon = 'maps/sierra/icons/obj/modular_laptop.dmi'

/obj/item/modular_computer/laptop/verb/rotatelaptop()
	set name = "Rotate laptop"
	set category = "Object"
	set src in view(1)

	if(usr.stat == DEAD)
		if(!round_is_spooky())
			to_chat(src, "<span class='warning'>The veil is not thin enough for you to do that.</span>")
			return

	src.set_dir(turn(src.dir, -90))

/obj/item/modular_computer/laptop/update_verbs()
	..()
	verbs |= /obj/item/modular_computer/laptop/verb/rotatelaptop
