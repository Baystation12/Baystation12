/obj/item/clothing/glasses/hud
	name = "HUD"
	desc = "A heads-up display that provides important info in (almost) real time."
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 2)
	var/list/icon/current = list() //the current hud icons
	electric = 1
	gender = NEUTER

	species_restricted = null

/obj/item/clothing/glasses/proc/process_hud(var/mob/M)
	if(hud)
		hud.process_hud(M)

/obj/item/clothing/glasses/hud/process_hud(var/mob/M)
	return

/obj/item/clothing/glasses/hud/health
	name = "health scanner HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	icon_state = "healthhud"
	hud_type = HUD_MEDICAL
	body_parts_covered = 0

/obj/item/clothing/glasses/hud/health/process_hud(var/mob/M)
	process_med_hud(M, 1)

/obj/item/clothing/glasses/hud/health/prescription
	name = "prescription health scanner HUD"
	desc = "A medical HUD integrated with a set of prescription glasses."
	prescription = 7
	icon_state = "healthhudpresc"
	item_state = "glasses"

/obj/item/clothing/glasses/hud/health/visor
	name = "medical HUD visor"
	desc = "A medical HUD integrated with a wide visor."
	icon_state = "medhud_visor"
	item_state = "medhud_visor"
	body_parts_covered = EYES

/obj/item/clothing/glasses/hud/security
	name = "security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status and security records."
	icon_state = "securityhud"
	hud_type = HUD_SECURITY
	body_parts_covered = 0
	var/global/list/jobs[0]

/obj/item/clothing/glasses/hud/security/prescription
	name = "prescription security HUD"
	desc = "A security HUD integrated with a set of prescription glasses."
	prescription = 7
	icon_state = "sechudpresc"
	item_state = "glasses"

/obj/item/clothing/glasses/hud/security/jensenshades
	name = "augmented shades"
	desc = "Polarized bioneural eyewear, designed to augment your vision."
	gender = PLURAL
	icon_state = "jensenshades"
	item_state = "jensenshades"
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING


/obj/item/clothing/glasses/hud/security/process_hud(var/mob/M)
	process_sec_hud(M, 1)

/obj/item/clothing/glasses/hud/janitor
	name = "janiHUD"
	desc = "A heads-up display that scans for messes and alerts the user. Good for finding puddles hiding under catwalks."
	icon_state = "janihud"
	body_parts_covered = 0
	hud_type = HUD_JANITOR

/obj/item/clothing/glasses/hud/janitor/prescription
	name = "prescription janiHUD"
	icon_state = "janihudpresc"
	item_state = "glasses"
	desc = "A janitor HUD integrated with a set of prescription glasses."
	prescription = 7

/obj/item/clothing/glasses/hud/janitor/process_hud(var/mob/M)
	process_jani_hud(M)