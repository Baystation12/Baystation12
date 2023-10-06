/obj/item/clothing/accessory/glassesmod
	abstract_type = /obj/item/clothing/accessory/glassesmod
	name = "base glasses mod"
	desc = "A basic modification for ballistic goggles."
	icon_override = 'icons/mob/onmob/onmob_goggle_mod.dmi'
	var/obj/screen/overlay = null
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
		SPECIES_VOX = 'icons/mob/species/vox/onmob_goggle_mod_vox.dmi'
		)
	activation_sound = 'sound/items/goggles_charge.ogg'

/obj/item/clothing/accessory/glassesmod/proc/process_hud(mob/M)
	return


/obj/item/clothing/accessory/glassesmod/Initialize()
	. = ..()
	if (toggleable)
		set_extension(src, /datum/extension/base_icon_state, icon_state)


/obj/item/clothing/accessory/glassesmod/on_update_icon()
	..()
	parent.overlays -= inv_overlay
	inv_overlay.icon_state = "[icon_state]_tie"
	parent.overlays += inv_overlay

/obj/item/clothing/accessory/glassesmod/polarization
	name = "polarized lenses"
	desc = "A set of clip-on self-polarizing lenses that can attach to ballistic goggles."
	icon_state = "polarized_lenses"
	slot = ACCESSORY_SLOT_VISION
	flash_protection = FLASH_PROTECTION_MODERATE

/obj/item/clothing/accessory/glassesmod/welding
	name = "welding lenses"
	desc = "A set of clip-on, flip-up, strongly polarized lenses that attach to ballistic goggles"
	icon_state = "welding_lenses"
	slot = ACCESSORY_SLOT_VISION
	flash_protection = FLASH_PROTECTION_MAJOR
	tint = TINT_HEAVY
	off_state = "welding_lenses_up"
	toggleable = TRUE
	activation_sound = null

/obj/item/clothing/accessory/glassesmod/welding/Initialize()
	. = ..()
	toggle_on_message = "You flip down \the [src]."
	toggle_off_message = "You flip up \the [src]."

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
