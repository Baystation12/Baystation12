
/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/glasses.dmi'
	//w_class = ITEM_SIZE_SMALL
	//slot_flags = SLOT_EYES
	//var/vision_flags = 0
	//var/darkness_view = 0//Base human is 2
	var/prescription = 0
	var/toggleable = 0
	var/off_state = "degoggles"
	var/active = 1
	var/activation_sound = 'sound/items/goggles_charge.ogg'
	var/obj/screen/overlay = null
	var/obj/item/clothing/glasses/hud/hud = null	// Hud glasses, if any

/obj/item/clothing/glasses/New()
	..()
	if(ispath(hud))
		hud = new hud(src)

/obj/item/clothing/glasses/Destroy()
	qdel(hud)
	hud = null
	. = ..()

/obj/item/clothing/glasses/attack_self(mob/user)
	if(toggleable && !user.incapacitated())
		if(active)
			active = 0
			icon_state = off_state
			user.update_inv_glasses()
			flash_protection = FLASH_PROTECTION_NONE
			tint = TINT_NONE
			to_chat(usr, "You deactivate the optical matrix on the [src].")
		else
			active = 1
			icon_state = initial(icon_state)
			user.update_inv_glasses()
			if(activation_sound)
				sound_to(usr, activation_sound)

			flash_protection = initial(flash_protection)
			tint = initial(tint)
			to_chat(usr, "You activate the optical matrix on the [src].")
		user.update_action_buttons()

/obj/item/clothing/glasses/meson
	name = "Optical Meson Scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	item_state = "glasses"
	action_button_name = "Toggle Goggles"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	toggleable = 1
	vision_flags = SEE_TURFS
	see_invisible = SEE_INVISIBLE_NOLIGHTING

/obj/item/clothing/glasses/meson/New()
	..()
	overlay = global_hud.meson

/obj/item/clothing/glasses/meson/prescription
	name = "prescription mesons"
	desc = "Optical Meson Scanner with prescription lenses."
	prescription = 6

/obj/item/clothing/glasses/science
	name = "Science Goggles"
	desc = "The goggles do nothing!"
	icon_state = "purple"
	item_state = "glasses"
	action_button_name = "Toggle Goggles"
	toggleable = 1

/obj/item/clothing/glasses/science/New()
	..()
	overlay = global_hud.science

/obj/item/clothing/glasses/night
	name = "Night Vision Goggles"
	desc = "You can totally see in the dark now!"
	icon_state = "night"
	item_state = "glasses"
	origin_tech = list(TECH_MAGNET = 2)
	darkness_view = 7
	action_button_name = "Toggle Goggles"
	toggleable = 1
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	off_state = "denight"

/obj/item/clothing/glasses/night/New()
	..()
	overlay = global_hud.nvg

/obj/item/clothing/glasses/tacgoggles //made their own thing, with more extreme flash protection and medium NV, but no more sechud
	name = "tactical goggles"
	desc = "Self-polarizing goggles with light amplification for dark environments. Made from durable synthetic."
	icon_state = "swatgoggles"
	origin_tech = list(TECH_MAGNET = 2)
	darkness_view = 5
	action_button_name = "Toggle Goggles"
	toggleable = 1
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	flash_protection = FLASH_PROTECTION_MAJOR
	armor = list(melee = 20, bullet = 20, laser = 20, energy = 15, bomb = 20, bio = 0, rad = 0)
	siemens_coefficient = 0.6

/obj/item/clothing/glasses/eyepatch
	name = "eyepatch"
	desc = "Yarr."
	icon_state = "eyepatch"
	item_state = "eyepatch"
	body_parts_covered = 0

/obj/item/clothing/glasses/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"
	item_state = "headset" // lol
	body_parts_covered = 0

/obj/item/clothing/glasses/material
	name = "Optical Material Scanner"
	desc = "Very confusing glasses."
	icon_state = "material"
	item_state = "glasses"
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	action_button_name = "Toggle Goggles"
	toggleable = 1
	vision_flags = SEE_OBJS

/obj/item/clothing/glasses/regular
	name = "Prescription Glasses"
	desc = "Made by Nerd. Co."
	icon_state = "glasses"
	item_state = "glasses"
	prescription = 7
	body_parts_covered = 0

/obj/item/clothing/glasses/regular/scanners
	name = "Scanning Goggles"
	desc = "A very oddly shaped pair of goggles with bits of wire poking out the sides. A soft humming sound emanates from it."
	icon_state = "uzenwa_sissra_1"

/obj/item/clothing/glasses/regular/hipster
	name = "Prescription Glasses"
	desc = "Made by Uncool. Co."
	icon_state = "hipster_glasses"
	item_state = "hipster_glasses"

/obj/item/clothing/glasses/threedglasses
	desc = "A long time ago, people used these glasses to makes images from screens threedimensional."
	name = "3D glasses"
	icon_state = "3d"
	item_state = "3d"
	body_parts_covered = 0

/obj/item/clothing/glasses/gglasses
	name = "Green Glasses"
	desc = "Forest green glasses, like the kind you'd wear when hatching a nasty scheme."
	icon_state = "gglasses"
	item_state = "gglasses"
	body_parts_covered = 0

/obj/item/clothing/glasses/sunglasses
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Enhanced shielding blocks many flashes."
	name = "sunglasses"
	icon_state = "sun"
	item_state = "sunglasses"
	darkness_view = -1
	flash_protection = FLASH_PROTECTION_MODERATE

/obj/item/clothing/glasses/welding
	name = "welding goggles"
	desc = "Protects the eyes from welders, approved by the mad scientist association."
	icon_state = "welding-g"
	item_state = "welding-g"
	action_button_name = "Flip Welding Goggles"
	matter = list(DEFAULT_WALL_MATERIAL = 1500, "glass" = 1000)
	var/up = 0
	flash_protection = FLASH_PROTECTION_MAJOR
	tint = TINT_HEAVY

/obj/item/clothing/glasses/welding/attack_self()
	toggle()


/obj/item/clothing/glasses/welding/verb/toggle()
	set category = "Object"
	set name = "Adjust welding goggles"
	set src in usr

	if(usr.canmove && !usr.incapacitated())
		if(src.up)
			src.up = !src.up
			flags_inv |= HIDEEYES
			body_parts_covered |= EYES
			icon_state = initial(icon_state)
			flash_protection = initial(flash_protection)
			tint = initial(tint)
			to_chat(usr, "You flip \the [src] down to protect your eyes.")
		else
			src.up = !src.up
			flags_inv &= ~HIDEEYES
			body_parts_covered &= ~EYES
			icon_state = "[initial(icon_state)]up"
			flash_protection = FLASH_PROTECTION_NONE
			tint = TINT_NONE
			to_chat(usr, "You push \the [src] up out of your face.")
		update_clothing_icon()
		usr.update_action_buttons()

/obj/item/clothing/glasses/welding/superior
	name = "superior welding goggles"
	desc = "Welding goggles made from more expensive materials, strangely smells like potatoes."
	icon_state = "rwelding-g"
	item_state = "rwelding-g"
	tint = TINT_MODERATE

/obj/item/clothing/glasses/sunglasses/blindfold
	name = "blindfold"
	desc = "Covers the eyes, preventing sight."
	icon_state = "blindfold"
	item_state = "blindfold"
	tint = TINT_BLIND

/obj/item/clothing/glasses/sunglasses/blindfold/tape
	name = "length of tape"
	desc = "It's a robust DIY blindfold!"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "tape_cross"
	item_state = null
	w_class = ITEM_SIZE_TINY

/obj/item/clothing/glasses/sunglasses/prescription
	name = "prescription sunglasses"
	prescription = 5

/obj/item/clothing/glasses/sunglasses/big
	desc = "Strangely ancient technology used to help provide rudimentary eye cover. Larger than average enhanced shielding blocks many flashes."
	icon_state = "bigsunglasses"
	item_state = "bigsunglasses"

/obj/item/clothing/glasses/sunglasses/sechud
	name = "HUDSunglasses"
	desc = "Sunglasses with a HUD."
	icon_state = "sunhud"
	hud = /obj/item/clothing/glasses/hud/security

/obj/item/clothing/glasses/sunglasses/sechud/goggles //now just a more "military" set of HUDglasses for the Torch
	name = "HUD goggles"
	desc = "Flash-resistant goggles with an inbuilt heads-up display."
	icon_state = "goggles"

/obj/item/clothing/glasses/sunglasses/sechud/toggle
	name = "HUD aviators"
	desc = "Modified aviator glasses that can be switch between HUD and flash protection modes."
	icon_state = "sec_hud"
	off_state = "sec_flash"
	action_button_name = "Toggle Mode"
	var/on = 1
	toggleable = 1
	activation_sound = 'sound/effects/pop.ogg'

	var/hud_holder

/obj/item/clothing/glasses/sunglasses/sechud/toggle/New()
	..()
	hud_holder = hud

/obj/item/clothing/glasses/sunglasses/sechud/toggle/Destroy()
	qdel(hud_holder)
	hud_holder = null
	hud = null
	. = ..()

/obj/item/clothing/glasses/sunglasses/sechud/toggle/attack_self(mob/user)
	if(toggleable && !user.incapacitated())
		on = !on
		if(on)
			flash_protection = FLASH_PROTECTION_NONE
			src.hud = hud_holder
			to_chat(user, "You switch the [src] to HUD mode.")
		else
			flash_protection = initial(flash_protection)
			src.hud = null
			to_chat(user, "You switch \the [src] to flash protection mode.")
		update_icon()
		sound_to(user, activation_sound)
		user.update_inv_glasses()
		user.update_action_buttons()

/obj/item/clothing/glasses/sunglasses/sechud/toggle/update_icon()
	if(on)
		icon_state = initial(icon_state)
	else
		icon_state = off_state

/obj/item/clothing/glasses/thermal
	name = "Optical Thermal Scanner"
	desc = "Thermals in the shape of glasses."
	icon_state = "thermal"
	item_state = "glasses"
	action_button_name = "Toggle Goggles"
	origin_tech = list(TECH_MAGNET = 3)
	toggleable = 1
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	flash_protection = FLASH_PROTECTION_REDUCED

	emp_act(severity)
		if(istype(src.loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/M = src.loc
			to_chat(M, "<span class='danger'>The Optical Thermal Scanner overloads and blinds you!</span>")
			if(M.glasses == src)
				M.eye_blind = 3
				M.eye_blurry = 5
				// Don't cure being nearsighted
				if(!(M.disabilities & NEARSIGHTED))
					M.disabilities |= NEARSIGHTED
					spawn(100)
						M.disabilities &= ~NEARSIGHTED
		..()

/obj/item/clothing/glasses/thermal/New()
	..()
	overlay = global_hud.thermal

/obj/item/clothing/glasses/thermal/syndi	//These are now a traitor item, concealed as mesons.	-Pete
	name = "Optical Meson Scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	origin_tech = list(TECH_MAGNET = 3, TECH_ILLEGAL = 4)

/obj/item/clothing/glasses/thermal/plain
	toggleable = 0
	activation_sound = null
	action_button_name = null

/obj/item/clothing/glasses/thermal/plain/monocle
	name = "Thermoncle"
	desc = "A monocle thermal."
	icon_state = "thermoncle"
	flags = null //doesn't protect eyes because it's a monocle, duh

	body_parts_covered = 0

/obj/item/clothing/glasses/thermal/plain/eyepatch
	name = "Optical Thermal Eyepatch"
	desc = "An eyepatch with built-in thermal optics."
	icon_state = "eyepatch"
	item_state = "eyepatch"
	body_parts_covered = 0

/obj/item/clothing/glasses/thermal/plain/jensen
	name = "Optical Thermal Implants"
	desc = "A set of implantable lenses designed to augment your vision."
	icon_state = "thermalimplants"
	item_state = "syringe_kit"

/obj/item/clothing/glasses/tajblind
	name = "embroidered veil"
	desc = "An Ahdominian made veil that allows the user to see while obscuring their eyes."
	icon_state = "tajblind"
	item_state = "tajblind"
	action_button_name = "Switch Vision Mode"
	var/up = 0
	flash_protection = FLASH_PROTECTION_NONE
	tint = TINT_NONE

/obj/item/clothing/glasses/tajblind/attack_self()
	toggle()


/obj/item/clothing/glasses/tajblind/verb/toggle()
	set category = "Object"
	set name = "Switch Vision Mode"
	set src in usr

	if(usr.canmove && !usr.incapacitated())
		if(src.up)
			src.up = !src.up
			flags_inv |= HIDEEYES
			body_parts_covered |= EYES
			icon_state = initial(icon_state)
			flash_protection = initial(flash_protection)
			tint = initial(tint)
			to_chat(usr, "You activate \the [src], allowing you to see.")
		else
			src.up = !src.up
			flags_inv &= HIDEEYES
			body_parts_covered &= EYES
			icon_state = initial(icon_state)
			flash_protection = FLASH_PROTECTION_MAJOR
			tint = TINT_BLIND
			to_chat(usr, "You deactivate \the [src], obscuring your vision.")
		update_clothing_icon()
		usr.update_action_buttons()

/obj/item/clothing/glasses/tajblind/sec
	name = "sleek veil"
	desc = "An Ahdominian made veil that allows the user to see while obscuring their eyes. This one has an in-built security HUD."
	icon_state = "tajblind_sec"
	item_state = "tajblind_sec"
	flash_protection = FLASH_PROTECTION_MAJOR
	hud = /obj/item/clothing/glasses/hud/security


/obj/item/clothing/glasses/tajblind/med
	name = "lightweight veil"
	desc = "An Ahdominian made veil that allows the user to see while obscuring their eyes. This one has an installed medical HUD."
	icon_state = "tajblind_med"
	item_state = "tajblind_med"
	hud = /obj/item/clothing/glasses/hud/health

/obj/item/clothing/glasses/tajblind/meson
	name = "industrial veil"
	desc = "An Ahdominian made veil that allows the user to see while obscuring their eyes. This one has installed mesons."
	icon_state = "tajblind_meson"
	item_state = "tajblind_meson"
	vision_flags = SEE_TURFS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
/obj/item/clothing/glasses/tajblind/meson/New()
	..()
	overlay = global_hud.meson
