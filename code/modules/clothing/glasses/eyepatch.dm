/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	desc = "Yarr."
	icon_state = "eyepatch"
	item_state = "eyepatch"
	body_parts_covered = 0
	var/flipped = FALSE // Indicates left or right eye; 0 = on the right

/obj/item/clothing/glasses/eyepatch/verb/flip_patch()
	set name = "Flip Patch"
	set category = "Object"
	set src in usr

	if (usr.stat || usr.restrained())
		return

	src.flipped = !src.flipped
	if(src.flipped)
		icon_state = "[icon_state]_r"
	else
		src.icon_state = initial(icon_state)
	to_chat (usr, "You change \the [src] to cover the [src.flipped ? "left" : "right"] eye.")
	update_clothing_icon()


/obj/item/clothing/glasses/eyepatch/hud
	name = "iPatch"
	desc = "For the technologically inclined pirate. It connects directly to the optical nerve of the user, replacing the need for that useless eyeball."
	gender = NEUTER
	icon_state = "hudpatch"
	item_state = "hudpatch"
	off_state = "hudpatch"
	action_button_name = "Toggle iPatch"
	toggleable = TRUE
	var/eye_color = COLOR_WHITE
	electric = TRUE

/obj/item/clothing/glasses/eyepatch/hud/Initialize()
	.  = ..()
	update_icon()

/obj/item/clothing/glasses/eyepatch/hud/attack_self()
	..()
	update_icon()

/obj/item/clothing/glasses/eyepatch/hud/on_update_icon()
	overlays.Cut()
	if(active)
		var/image/eye = overlay_image(icon, "[icon_state]_eye", flags=RESET_COLOR)
		eye.color = eye_color
		overlays += eye

/obj/item/clothing/glasses/eyepatch/hud/get_mob_overlay(mob/user_mob, slot)
	var/image/res = ..()
	if(active)
		var/image/eye = overlay_image(res.icon, "[icon_state]_eye", flags=RESET_COLOR)
		eye.color = eye_color
		eye.layer = ABOVE_LIGHTING_LAYER
		eye.plane = EFFECTS_ABOVE_LIGHTING_PLANE
		res.overlays += eye
	return res

/obj/item/clothing/glasses/eyepatch/hud/security
	name = "HUDpatch"
	desc = "A Security-type heads-up display that connects directly to the optical nerve of the user, replacing the need for that useless eyeball."
	hud = /obj/item/clothing/glasses/hud/security
	eye_color = COLOR_RED

/obj/item/clothing/glasses/eyepatch/hud/medical
	name = "MEDpatch"
	desc = "A Medical-type heads-up display that connects directly to the ocular nerve of the user, replacing the need for that useless eyeball."
	hud = /obj/item/clothing/glasses/hud/health
	eye_color = COLOR_CYAN

/obj/item/clothing/glasses/eyepatch/hud/meson
	name = "MESpatch"
	desc = "An optical meson scanner display that connects directly to the ocular nerve of the user, replacing the need for that useless eyeball."
	vision_flags = SEE_TURFS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	eye_color = COLOR_LIME

/obj/item/clothing/glasses/eyepatch/hud/meson/Initialize()
	. = ..()
	overlay = GLOB.global_hud.meson