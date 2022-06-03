/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/obj_eyes.dmi'
	sprite_sheets = list(
		SPECIES_VOX = 'icons/mob/species/vox/onmob_eyes_vox.dmi',
		SPECIES_VOX_ARMALIS = 'icons/mob/species/vox/onmob_eyes_vox_armalis.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/generated/onmob_eyes_unathi.dmi'
		)
	var/hud_type
	var/prescription = FALSE
	var/toggleable = FALSE
	var/off_state = "degoggles"
	var/active = TRUE
	var/activation_sound = 'sound/items/goggles_charge.ogg'
	var/deactivation_sound // set this if you want a sound on deactivation
	var/obj/screen/overlay = null
	var/obj/item/clothing/glasses/hud/hud = null	// Hud glasses, if any
	var/electric = FALSE //if the glasses should be disrupted by EMP

	var/toggle_on_message //set these in initialize if you want messages other than about the optical matrix
	var/toggle_off_message

/obj/item/clothing/glasses/Initialize()
	. = ..()
	if(toggleable)
		set_extension(src, /datum/extension/base_icon_state, icon_state)
	if(ispath(hud))
		hud = new hud(src)

/obj/item/clothing/glasses/Destroy()
	qdel(hud)
	hud = null
	. = ..()

/obj/item/clothing/glasses/needs_vision_update()
	return ..() || overlay || vision_flags || see_invisible || darkness_view

/obj/item/clothing/glasses/proc/activate(mob/user)
	if(toggleable && !active)
		var/datum/extension/base_icon_state/BIS = get_extension(src, /datum/extension/base_icon_state)
		active = TRUE
		icon_state = BIS.base_icon_state
		flash_protection = initial(flash_protection)
		tint = initial(tint)
		if(user)
			user.update_inv_glasses()
			user.update_action_buttons()
			if(activation_sound)
				sound_to(user, activation_sound)
			if(toggle_on_message)
				to_chat(user, toggle_on_message)
			else
				to_chat(user, "You activate the optical matrix on \the [src].")

		update_clothing_icon()
		update_vision()

/obj/item/clothing/glasses/proc/deactivate(mob/user, manual = TRUE)
	if(toggleable && active)
		active = FALSE
		icon_state = off_state
		if(user)
			if(manual)
				if(toggle_off_message)
					to_chat(user, toggle_off_message)
				else
					to_chat(user, "You deactivate the optical matrix on \the [src].")
				if(deactivation_sound)
					sound_to(user, deactivation_sound)
			user.update_inv_glasses()
			user.update_action_buttons()

		flash_protection = FLASH_PROTECTION_NONE
		tint = TINT_NONE
		update_clothing_icon()
		update_vision()

/obj/item/clothing/glasses/emp_act(severity)
	if(electric && active)
		if(istype(src.loc, /mob/living/carbon/human))
			var/mob/living/carbon/human/M = src.loc
			if(M.glasses != src)
				to_chat(M, SPAN_DANGER("\The [name] malfunction[gender != PLURAL ? "s":""], releasing a small spark."))
			else
				M.eye_blind = 2
				M.eye_blurry = 4
				to_chat(M, SPAN_DANGER("\The [name] malfunction[gender != PLURAL ? "s":""], blinding you!"))
				// Don't cure being nearsighted
				if(!(M.disabilities & NEARSIGHTED))
					M.disabilities |= NEARSIGHTED
					spawn(100)
						M.disabilities &= ~NEARSIGHTED
			if(toggleable)
				deactivate(M, FALSE)
	..()

/obj/item/clothing/glasses/attack_self(mob/user)
	if(toggleable && !user.incapacitated())
		if(active)
			deactivate(user)
		else
			activate(user)

/obj/item/clothing/glasses/inherit_custom_item_data(datum/custom_item/citem)
	. = ..()
	if(toggleable)
		if(citem.additional_data["icon_on"])
			set_icon_state(citem.additional_data["icon_on"])
		if(citem.additional_data["icon_off"])
			off_state = citem.additional_data["icon_off"]

/obj/item/clothing/glasses/meson
	name = "meson goggles"
	desc = "Used for seeing walls, floors, and stuff through anything."
	gender = NEUTER
	icon_state = "meson"
	item_state = "glasses"
	action_button_name = "Toggle Goggles"
	origin_tech = list(TECH_MAGNET = 2, TECH_ENGINEERING = 2)
	toggleable = TRUE
	vision_flags = SEE_TURFS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	electric = TRUE

/obj/item/clothing/glasses/meson/Initialize()
	. = ..()
	overlay = GLOB.global_hud.meson

/obj/item/clothing/glasses/meson/prescription
	name = "meson goggles"
	desc = "Used for seeing walls, floors, and stuff through anything. This set has corrective lenses."
	prescription = 5

/obj/item/clothing/glasses/science
	name = "science goggles"
	desc = "Goggles fitted with a portable analyzer capable of determining the fabricator training potential of an item or components of a machine. Sensitive to EMP."
	icon_state = "purple"
	item_state = "glasses"
	hud_type = HUD_SCIENCE
	toggleable = TRUE
	action_button_name = "Toggle Goggles"
	electric = TRUE

/obj/item/clothing/glasses/science/prescription
	name = "prescription science goggles"
	desc = "Science goggles with prescription lenses."
	prescription = 5

/obj/item/clothing/glasses/science/Initialize()
	. = ..()
	overlay = GLOB.global_hud.science

/obj/item/clothing/glasses/night
	name = "night vision goggles"
	desc = "You can totally see in the dark now!"
	icon_state = "night"
	item_state = "glasses"
	origin_tech = list(TECH_MAGNET = 2)
	darkness_view = 7
	action_button_name = "Toggle Goggles"
	toggleable = TRUE
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	off_state = "denight"
	electric = TRUE

/obj/item/clothing/glasses/night/Initialize()
	. = ..()
	overlay = GLOB.global_hud.nvg

/obj/item/clothing/glasses/tacgoggles
	name = "tactical goggles"
	desc = "Self-polarizing goggles with light amplification for dark environments. Made from durable synthetic."
	icon_state = "swatgoggles"
	origin_tech = list(TECH_MAGNET = 2, TECH_COMBAT = 4)
	darkness_view = 5
	action_button_name = "Toggle Goggles"
	toggleable = TRUE
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	siemens_coefficient = 0.6
	electric = TRUE

/obj/item/clothing/glasses/monocle
	name = "monocle"
	desc = "Such a dapper eyepiece!"
	icon_state = "monocle"
	item_state = "headset" // lol
	body_parts_covered = 0
	prescription = 5

/obj/item/clothing/glasses/material
	name = "optical material scanner"
	desc = "Very confusing glasses."
	gender = NEUTER
	icon_state = "material"
	item_state = "glasses"
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	action_button_name = "Toggle Goggles"
	toggleable = TRUE
	vision_flags = SEE_OBJS
	electric = TRUE

/obj/item/clothing/glasses/threedglasses
	name = "3D glasses"
	desc = "A long time ago, people used these glasses to makes images from screens threedimensional."
	icon_state = "3d"
	item_state = "3d"
	body_parts_covered = 0

/obj/item/clothing/glasses/welding
	name = "welding goggles"
	desc = "Protects the eyes from welders, approved by the mad scientist association."
	icon_state = "welding-g"
	item_state = "welding-g"
	action_button_name = "Flip Welding Goggles"
	matter = list(MATERIAL_STEEL = 1500, MATERIAL_GLASS = 1000)
	use_alt_layer = TRUE
	var/up = FALSE
	flash_protection = FLASH_PROTECTION_MAJOR
	tint = TINT_HEAVY

/obj/item/clothing/glasses/welding/attack_self()
	toggle()


/obj/item/clothing/glasses/welding/verb/toggle()
	set category = "Object"
	set name = "Adjust welding goggles"
	set src in usr

	if(!usr.incapacitated())
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
		update_vision()
		usr.update_action_buttons()

/obj/item/clothing/glasses/welding/superior
	name = "superior welding goggles"
	desc = "Welding goggles made from more expensive materials, strangely smells like potatoes."
	icon_state = "rwelding-g"
	item_state = "rwelding-g"
	tint = TINT_MODERATE

/obj/item/clothing/glasses/glare_dampeners
	name = "glare dampeners"
	desc = "Synthetic lenses over the eyes, protecting from bright lights."
	icon_state = "welding-g"
	item_state = "welding-g"
	use_alt_layer = TRUE
	flash_protection = FLASH_PROTECTION_MODERATE
	darkness_view = -1

/obj/item/clothing/glasses/augment_binoculars
	name = "adaptive binoculars"
	desc = "Digital lenses covering the eyes, capable of zooming in on distant targets."
	gender = PLURAL
	icon_state = "thermal"
	item_state = "glasses"
	action_button_name = "Toggle zoom"
	zoomdevicename = "lenses"
	electric = TRUE
	unacidable = TRUE

/obj/item/clothing/glasses/augment_binoculars/attack_self(mob/user)
	if(zoom)
		unzoom(user)
	else
		zoom(user)
