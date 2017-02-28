/obj/item/clothing/glasses/hud
	name = "HUD"
	desc = "A heads-up display that provides important info in (almost) real time."
	flags = 0 //doesn't protect eyes because it's a monocle, duh
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 2)
	var/list/icon/current = list() //the current hud icons

/obj/item/clothing/glasses/proc/process_hud(var/mob/M)
	if(hud)
		hud.process_hud(M)

/obj/item/clothing/glasses/hud/process_hud(var/mob/M)
	return

/obj/item/clothing/glasses/hud/health
	name = "Health Scanner HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their health status."
	icon_state = "healthhud"
	body_parts_covered = 0


/obj/item/clothing/glasses/hud/health/process_hud(var/mob/M)
	process_med_hud(M, 1)

/obj/item/clothing/glasses/hud/health/advanced
	name = "Advanced Health Scanner HUD"
	desc = "A technological breakthrough, allowing doctors wearing these to scan patients as if they were using a normal health analyzer. Kinda bulky though."
	icon_state = "adv_med_hud"
	item_state = "adv_med_hud"
	origin_tech = "magnets=6;biotech=5"
	w_class = 3
	var/mode = 1

/obj/item/clothing/glasses/hud/health/advanced/verb/toggle_mode()
	set name = "Switch Verbosity"
	set category = "Object"
	mode = !mode
	switch (mode)
		if(1)
			to_chat(usr, "The scanner now shows specific limb damage.")
		if(0)
			to_chat(usr, "The scanner no longer shows limb damage.")

/obj/item/clothing/glasses/hud/health/prescription
	name = "Prescription Health Scanner HUD"
	desc = "A medical HUD integrated with a set of prescription glasses"
	prescription = 7
	icon_state = "healthhudpresc"
	item_state = "glasses"

/obj/item/clothing/glasses/hud/security
	name = "Security HUD"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their ID status and security records."
	icon_state = "securityhud"
	body_parts_covered = 0
	var/global/list/jobs[0]

/obj/item/clothing/glasses/hud/security/prescription
	name = "Prescription Security HUD"
	desc = "A security HUD integrated with a set of prescription glasses"
	prescription = 7
	icon_state = "sechudpresc"
	item_state = "glasses"

/obj/item/clothing/glasses/hud/security/jensenshades
	name = "Augmented shades"
	desc = "Polarized bioneural eyewear, designed to augment your vision."
	icon_state = "jensenshades"
	item_state = "jensenshades"
	vision_flags = SEE_MOBS
	see_invisible = SEE_INVISIBLE_NOLIGHTING

/obj/item/clothing/glasses/hud/security/process_hud(var/mob/M)
	process_sec_hud(M, 1)

/obj/item/clothing/glasses/hud/security/health
	name = "Medical-Security HUD"
	icon_state = "medsechud"
	item_state = "medsechud"
	desc = "A heads-up display that scans the humans in view and provides accurate data about their security records, as well as their health status."

/obj/item/clothing/glasses/hud/security/health/process_hud(var/mob/M)
	..()
	process_med_hud(M,1)