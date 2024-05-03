/obj/item/clothing/glasses/thermal
	name = "optical thermal scanner"
	desc = "Thermals in the shape of glasses."
	gender = NEUTER
	icon_state = "thermal"
	item_state = "glasses"
	action_button_name = "Toggle Goggles"
	origin_tech = list(TECH_MAGNET = 3)
	vision_flags = SEE_INFRA
	toggleable = TRUE
	electric = TRUE

/obj/item/clothing/glasses/thermal/Initialize()
	. = ..()
	overlay = GLOB.global_hud.thermal
	renderer = new /atom/movable/renderer/thermals

/obj/item/clothing/glasses/thermal/syndi	//These are now a traitor item, concealed as mesons.	-Pete
	name = "optical meson scanner"
	desc = "Used for seeing walls, floors, and stuff through anything."
	icon_state = "meson"
	origin_tech = list(TECH_MAGNET = 3, TECH_ESOTERIC = 4)

/obj/item/clothing/glasses/thermal/aviators
	name = "HUD aviators"
	desc = "A thermal HUD integrated into a pair of aviator sunglasses. See through walls and look cool at the same time."
	icon_state = "thermal_avi_on"
	off_state = "avi_off"
	item_state = "thermal_avi_on"

/obj/item/clothing/glasses/thermal/syndi/aviators
	name = "aviator sunglasses"
	desc = "An anachronistic style of glare protection popularized by military pilot mystique. These ones have black frames and lenses."
	icon_state = "syn_avi_on"
	off_state = "syn_avi_off"
	item_state = "syn_avi_on"

/obj/item/clothing/glasses/thermal/plain
	toggleable = FALSE
	activation_sound = null
	action_button_name = null

/obj/item/clothing/glasses/thermal/plain/monocle
	name = "thermonocle"
	desc = "A monocle thermal."
	icon_state = "thermoncle"
	body_parts_covered = 0 //doesn't protect eyes because it's a monocle, duh

/obj/item/clothing/glasses/thermal/plain/eyepatch
	name = "optical thermal eyepatch"
	desc = "An eyepatch with built-in thermal optics."
	icon_state = "eyepatch"
	item_state = "eyepatch"
	body_parts_covered = 0

/obj/item/clothing/glasses/thermal/plain/jensen
	name = "adhesive thermal lenses"
	gender = PLURAL
	desc = "A set of deployable thermal lenses that adhere to the eyebrows. Cool looking, probably."
	icon_state = "thermalimplants"
	item_state = "syringe_kit"
