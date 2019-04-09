/obj/item/device/reagent_scanner
	name = "reagent scanner"
	desc = "A hand-held reagent scanner which identifies chemical agents."
	icon_state = "spectrometer"
	item_state = "analyzer"
	w_class = ITEM_SIZE_SMALL
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20
	matter = list(MATERIAL_ALUMINIUM = 30,MATERIAL_GLASS = 20)

	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	var/details = 0
	var/recent_fail = 0

/obj/item/device/reagent_scanner/afterattack(obj/O, mob/user as mob, proximity)
	if(!proximity)
		return
	if (user.incapacitated())
		return
	if (!user.IsAdvancedToolUser())
		return
	if(!istype(O))
		return
	var/dat = reagent_scan_results(O, details)
	to_chat(user, "<span class = 'notice'>[jointext(dat,"<br>")]</span>")

/proc/reagent_scan_results(obj/O, details = 0)
	if(isnull(O.reagents))
		return list("No significant chemical agents found in [O].")
	if(O.reagents.reagent_list.len == 0)
		return list("No active chemical agents found in [O].")
	. = list("Chemicals found:")
	var/one_percent = O.reagents.total_volume / 100
	for (var/datum/reagent/R in O.reagents.reagent_list)
		. += "[R][details ? ": [R.volume / one_percent]%" : ""]"

/obj/item/device/reagent_scanner/adv
	name = "advanced reagent scanner"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)