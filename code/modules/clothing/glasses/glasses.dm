/obj/item/clothing/glasses
	name = "glasses"
	icon = 'icons/obj/clothing/obj_eyes.dmi'
	sprite_sheets = list(
		SPECIES_VOX = 'icons/mob/species/vox/onmob_eyes_vox.dmi',
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_eyes_unathi.dmi'
		)
	var/prescription = FALSE
	off_state = "degoggles"
	activation_sound = 'sound/items/goggles_charge.ogg'
	deactivation_sound = null
	var/obj/screen/overlay = null
	var/obj/item/clothing/glasses/hud/hud = null	// Hud glasses, if any
	electric = FALSE //if the glasses should be disrupted by EMP


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


/obj/item/clothing/glasses/attack_self(mob/user)
	if(toggleable && !user.incapacitated())
		if(active)
			deactivate(user)
		else
			activate(user)

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

/obj/item/clothing/glasses/ballistic
	name = "ballistic goggles"
	desc = "A pair of goggles designed to protect the wearer's eyes from shrapnel."
	icon_state = "ballistic"
	origin_tech = list(TECH_COMBAT = 2)
	siemens_coefficient = 0.6
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		bullet = ARMOR_BALLISTIC_SMALL,
		bomb = ARMOR_BOMB_MINOR
	)
	action_button_name = "Toggle Attachments"
	valid_accessory_slots = list(ACCESSORY_SLOT_GLASSES_VISION, ACCESSORY_SLOT_GLASSES_HUD)
	restricted_accessory_slots = list(ACCESSORY_SLOT_GLASSES_VISION, ACCESSORY_SLOT_GLASSES_HUD)
	var/toggle_mods = list()

/obj/item/clothing/glasses/ballistic/Initialize()
	. = ..()
	count_toggle_mods()

/obj/item/clothing/glasses/ballistic/attach_accessory(mob/user, obj/item/clothing/accessory/A)
	. = ..()
	if(A.toggleable)
		toggle_mods += A

/obj/item/clothing/glasses/ballistic/remove_accessory(mob/user, obj/item/clothing/accessory/A)
	. = ..()
	if(A.toggleable)
		toggle_mods -= A

/obj/item/clothing/glasses/ballistic/proc/count_toggle_mods()
	toggle_mods = list()
	for (var/obj/item/clothing/accessory/glassesmod/mod in accessories)
		if(mod.toggleable)
			toggle_mods += mod


/obj/item/clothing/glasses/ballistic/attack_self(mob/user)
	if(!user.incapacitated())
		var/obj/item/clothing/accessory/glassesmod/choice = null
		if (length(toggle_mods) == 1)
			choice = toggle_mods[1]
		else if(length(toggle_mods) <= 0)
			return
		else
			input(user, "Toggle which accessory?", "Attachment selection") as null|anything in toggle_mods
		if (choice.active)
			choice.deactivate(user)
		else
			choice.activate(user)
		update_vision()


/obj/item/clothing/glasses/ballistic/prescription
	name = "prescription ballistic goggles"
	desc = "A pair of goggles designed to protect the wearer's eyes from shrapnel. This set has corrective lenses."
	prescription = 5


/obj/item/clothing/glasses/ballistic/fake
	name = "budget ballistic goggles"
	desc = "A pair of goggles that probably won't protect the wearer's eyes from shrapnel. At least they make you feel more tacticool."
	origin_tech = null
	armor = null

/obj/item/clothing/glasses/ballistic/fake/prescription
	name = "budget ballistic goggles"
	desc = "A pair of goggles that probably won't protect the wearer's eyes from shrapnel. At least they make you feel more tacticool. This set has corrective lenses."
	origin_tech = null
	armor = null
	prescription = 5


/obj/item/clothing/glasses/ballistic/security
	accessories = list(
		/obj/item/clothing/accessory/glassesmod/vision/polarized,
		/obj/item/clothing/accessory/glassesmod/hud/security
	)

/obj/item/clothing/glasses/ballistic/medic
	accessories = list(/obj/item/clothing/accessory/glassesmod/hud/medical)

/obj/item/clothing/glasses/ballistic/engi
	accessories = list(/obj/item/clothing/accessory/glassesmod/vision/welding)

/obj/item/clothing/glasses/meson/prescription
	desc = "Used for seeing walls, floors, and stuff through anything. This set has corrective lenses."
	prescription = 5

/obj/item/clothing/glasses/meson/aviators
	name = "HUD aviators"
	desc = "A meson HUD integrated into a pair of aviator sunglasses. It does little to protect against the sun, but it sure looks cool."
	icon_state = "meson_avi_on"
	off_state = "avi_off"
	item_state = "meson_avi_on"

/obj/item/clothing/glasses/meson/aviators/prescription
	prescription = 5
	desc = "A meson HUD integrated into a pair of aviator sunglasses. These ones have eyesight-correcting lenses."

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

/obj/item/clothing/glasses/night/aviators
	name = "HUD aviators"
	desc = "Night-vision glasses integrated into a pair of aviator sunglasses. It does little to protect against the sun, but it sure looks cool."
	icon_state = "nvg_avi_on"
	off_state = "avi_off"
	item_state = "nvg_avi_on"

/obj/item/clothing/glasses/tacgoggles
	name = "tactical goggles"
	desc = "Self-polarizing goggles with light amplification for dark environments. Made from durable synthetic."
	icon_state = "swatgoggles"
	origin_tech = list(TECH_MAGNET = 2, TECH_COMBAT = 4)
	darkness_view = 5
	action_button_name = "Toggle Goggles"
	toggleable = TRUE
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
	desc = "Very confusing goggles."
	gender = NEUTER
	icon_state = "material"
	item_state = "glasses"
	origin_tech = list(TECH_MAGNET = 3, TECH_ENGINEERING = 3)
	action_button_name = "Toggle Goggles"
	toggleable = TRUE
	vision_flags = SEE_OBJS
	electric = TRUE


/obj/item/clothing/glasses/material/prescription
	desc = "Very confusing goggles. This set has corrective lenses."
	prescription = 5


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
