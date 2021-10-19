/obj/item/clothing/glasses/hud
	name = "HUD"
	desc = "A heads-up display that provides important info in (almost) real time."
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 2)
	var/list/icon/current = list() //the current hud icons
	electric = TRUE
	gender = NEUTER
	toggleable = TRUE
	action_button_name = "Toggle HUD"
	activation_sound = sound('sound/machines/boop1.ogg', volume = 10)
	deactivation_sound = sound('sound/effects/compbeep1.ogg', volume = 30)

	species_restricted = null

/obj/item/clothing/glasses/hud/Initialize()
	. = ..()
	toggle_on_message = "\The [src] boots up to life, flashing with information."
	toggle_off_message = "\The [src] powers down with a beep."

/obj/item/clothing/glasses/proc/process_hud(var/mob/M)
	if(hud)
		hud.process_hud(M)

/obj/item/clothing/glasses/hud/process_hud(var/mob/M)
	return

/obj/item/clothing/glasses/hud/health
	name = "health scanner HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	icon_state = "healthhud"
	off_state = "healthhud_off"
	hud_type = HUD_MEDICAL
	body_parts_covered = 0
	req_access = list(access_medical)

/obj/item/clothing/glasses/hud/health/process_hud(var/mob/M)
	process_med_hud(M, 1)

/obj/item/clothing/glasses/hud/health/prescription
	name = "prescription health scanner HUD"
	desc = "A medical HUD integrated with a set of prescription glasses."
	prescription = 5
	icon_state = "healthhudpresc"
	off_state = "healthhudpresc_off"
	item_state = "healthhudpresc"

/obj/item/clothing/glasses/hud/health/goggle
	name = "medical HUD visor"
	desc = "A medical HUD integrated with a wide visor."
	icon_state = "material"
	off_state = "degoggles"
	item_state = "material"
	body_parts_covered = EYES

/obj/item/clothing/glasses/hud/health/goggle/prescription
	prescription = 5
	desc = "A medical HUD integrated with a wide visor. This one has a corrective lense."

/obj/item/clothing/glasses/hud/security
	name = "security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status and security records."
	icon_state = "securityhud"
	off_state = "securityhud_off"
	hud_type = HUD_SECURITY
	body_parts_covered = 0
	var/global/list/jobs[0]
	req_access = list(access_security)

/obj/item/clothing/glasses/hud/security/prescription
	name = "prescription security HUD"
	desc = "A security HUD integrated with a set of prescription glasses."
	prescription = 5
	icon_state = "sechudpresc"
	off_state = "sechudpresc_off"
	item_state = "sechudpresc"

/obj/item/clothing/glasses/hud/security/jensenshades
	name = "augmented shades"
	desc = "Polarized bioneural eyewear, designed to augment your vision."
	gender = PLURAL
	icon_state = "jensenshades"
	item_state = "jensenshades"
	toggleable = FALSE
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING


/obj/item/clothing/glasses/hud/security/process_hud(var/mob/M)
	process_sec_hud(M, 1)

/obj/item/clothing/glasses/hud/janitor
	name = "janiHUD"
	desc = "A heads-up display that scans for messes and alerts the user. Good for finding puddles hiding under catwalks."
	icon_state = "janihud"
	off_state = "janihud_off"
	body_parts_covered = 0
	hud_type = HUD_JANITOR

/obj/item/clothing/glasses/hud/janitor/prescription
	name = "prescription janiHUD"
	icon_state = "janihudpresc"
	off_state = "janihudpresc_off"
	item_state = "janihudpresc"
	desc = "A janitor HUD integrated with a set of prescription glasses."
	prescription = 5

/obj/item/clothing/glasses/hud/janitor/process_hud(var/mob/M)
	process_jani_hud(M)

/obj/item/clothing/glasses/hud/science
	name = "science HUD"
	desc = "A heads-up display that analyzes objects for research potential."
	icon_state = "scihud"
	off_state = "scihud_off"
	hud_type = HUD_SCIENCE
	body_parts_covered = 0

/obj/item/clothing/glasses/hud/science/prescription
	name = "prescription scienceHUD"
	icon_state = "scihudpresc"
	off_state = "scihudpresc_off"
	item_state = "scihudpresc"
	desc = "A science HUD integrated with a set of prescription glasses."
	prescription = 5
