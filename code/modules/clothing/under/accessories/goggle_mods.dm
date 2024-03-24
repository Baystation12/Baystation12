/obj/item/clothing/accessory/glassesmod
	abstract_type = /obj/item/clothing/accessory/glassesmod
	name = "base glasses mod"
	desc = "A basic modification for ballistic goggles."
	icon_override = 'icons/mob/onmob/onmob_goggle_mod.dmi'
	var/obj/screen/overlay
	var/thermals = FALSE
	var/nvg = FALSE
	body_location = EYES
	accessory_icons = list(
		slot_tie_str = 'icons/mob/onmob/onmob_goggle_mod.dmi',
		slot_goggles_str = 'icons/mob/onmob/onmob_goggle_mod.dmi',
		slot_head_str = 'icons/mob/onmob/onmob_goggle_mod.dmi'
	)
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_goggle_mod_unathi.dmi',
		SPECIES_VOX = 'icons/mob/species/vox/onmob_goggle_mod_vox.dmi',
		SPECIES_HUMAN = 'icons/mob/onmob/onmob_goggle_mod.dmi'
	)
	activation_sound = 'sound/items/goggles_charge.ogg'

/obj/item/clothing/accessory/glassesmod/proc/process_hud(mob/M)
	return

/obj/item/clothing/accessory/glassesmod/get_mob_overlay(mob/user_mob, slot)
	if (slot == "slot_s_store")
		return null
	. = ..()

/obj/item/clothing/accessory/glassesmod/activate()
	. = ..()
	parent.CutOverlays(inv_overlay)
	inv_overlay = null
	inv_overlay = get_inv_overlay()
	parent.AddOverlays(inv_overlay)
	parent.update_vision()

/obj/item/clothing/accessory/glassesmod/deactivate()
	. = ..()
	parent.CutOverlays(inv_overlay)
	inv_overlay = null
	inv_overlay = get_inv_overlay()
	parent.AddOverlays(inv_overlay)
	parent.update_vision()

/obj/item/clothing/accessory/glassesmod/thermal
	name = "thermal sights"
	desc = "An older set of thermal vision goggles, modified to attach to a helmet."
	icon_state = "thermals"
	slot = ACCESSORY_SLOT_VISOR
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	toggleable = TRUE
	off_state = "thermoff"
	electric = TRUE
	thermals = TRUE
	tint = TINT_HEAVY
	activation_sound = 'sound/items/metal_clicking_4.ogg'
	deactivation_sound = 'sound/items/metal_clicking_4.ogg'


/obj/item/clothing/accessory/glassesmod/nvg
	name = "light-enhancing sights"
	desc = "An older set of light enhancing goggles, modified to attach to a helmet."
	icon_state = "nvg"
	slot = ACCESSORY_SLOT_VISOR
	see_invisible = SEE_INVISIBLE_NOLIGHTING
	toggleable = TRUE
	off_state = "nvgoff"
	electric = TRUE
	nvg = TRUE
	darkness_view = 4
	tint = TINT_MODERATE
	activation_sound = 'sound/items/metal_clicking_4.ogg'
	deactivation_sound = 'sound/items/metal_clicking_4.ogg'

/obj/item/clothing/accessory/glassesmod/hud/process_hud(mob/M)
	return

/obj/item/clothing/accessory/glassesmod/hud/security
	name = "security HUD attachment"
	desc = "An attachable security HUD for ballistic goggles."
	icon_state = "sechud"
	slot = ACCESSORY_SLOT_HUD
	hud_type = HUD_SECURITY
	toggleable = TRUE
	off_state = "hudoff"


/obj/item/clothing/accessory/glassesmod/hud/security/process_hud(mob/M)
	process_sec_hud(M, 1)


/obj/item/clothing/accessory/glassesmod/hud/medical
	name = "medical HUD attachment"
	desc = "An attachable security HUD for ballistic goggles."
	icon_state = "medhud"
	slot = ACCESSORY_SLOT_HUD
	hud_type = HUD_MEDICAL
	toggleable = TRUE
	off_state = "hudoff"

/obj/item/clothing/accessory/glassesmod/hud/medical/process_hud(mob/M)
	process_med_hud(M, 1)

/obj/item/clothing/accessory/glassesmod/vision/polarized
	name = "polarized lenses"
	desc = "A set of flash-resistant lenses that can be clipped onto a pair of ballistic goggles."
	slot = ACCESSORY_SLOT_VISION
	icon_state = "polarized"
	flash_protection = FLASH_PROTECTION_MODERATE
	darkness_view = -1

/obj/item/clothing/accessory/glassesmod/vision/welding
	name = "welding lenses"
	desc = "A set of welding lenses that can be attached to ballistic goggles to protect against arc-eye"
	slot = ACCESSORY_SLOT_VISION
	icon_state = "welding_lenses"
	off_state = "welding_lenses_up"
	flash_protection = FLASH_PROTECTION_MAJOR
	flags_inv = HIDEEYES
	tint = TINT_HEAVY
	toggleable = TRUE
	activation_sound = 'sound/items/metal_clicking_13.ogg'
	deactivation_sound = 'sound/items/metal_clicking_13.ogg'
	toggle_on_message = "You flip the lenses down to protect your eyes."
	toggle_off_message = "You push the lenses up out of your face."

/obj/item/clothing/accessory/glassesmod/vision/welding/activate(mob/usr)
	. = ..()
	flags_inv |= HIDEEYES
	body_parts_covered |= EYES

/obj/item/clothing/accessory/glassesmod/vision/welding/deactivate(mob/usr)
	. = ..()
	flags_inv &= ~HIDEEYES
	body_parts_covered &= ~EYES
