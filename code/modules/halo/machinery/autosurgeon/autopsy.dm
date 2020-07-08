
/obj/machinery/autosurgeon
	var/list/species_autopsies = list(\
		/datum/species/human = /obj/item/weapon/paper/autopsy_report/human,\
		/datum/species/spartan = /obj/item/weapon/paper/autopsy_report/human,\
		/datum/species/brutes = /obj/item/weapon/paper/autopsy_report/jiralhanae,\
		/datum/species/kig_yar = /obj/item/weapon/paper/autopsy_report/ruuhtian,\
		/datum/species/sangheili = /obj/item/weapon/paper/autopsy_report/sangheili,\
		/datum/species/sanshyuum = /obj/item/weapon/paper/autopsy_report/sanshyuum,\
		/datum/species/kig_yar = /obj/item/weapon/paper/autopsy_report/ruuhtian,\
		/datum/species/kig_yar_skirmisher = /obj/item/weapon/paper/autopsy_report/tvoan,\
		/datum/species/yanmee = /obj/item/weapon/paper/autopsy_report/yanmee,\
		/datum/species/unggoy = /obj/item/weapon/paper/autopsy_report/unggoy)

/obj/machinery/autosurgeon/proc/last_autopsy()
	var/obj/item/organ/external/external = locate() in buckled_mob:organs
	if(external)
		src.visible_message("<span class='info'>[src] starts dissecting [buckled_mob]'s [external.amputation_point]...</span>")
	else
		src.visible_message("<span class='info'>[src] starts dissecting [buckled_mob]'s core...</span>")

/obj/machinery/autosurgeon/proc/finish_autopsy()
	do_autopsy = FALSE

	if(buckled_mob)

		//create the autopsy report
		var/autopsy_type = /obj/item/weapon/paper/autopsy_report
		if(ishuman(buckled_mob))
			autopsy_type = species_autopsies[buckled_mob:species.type]
			if(!autopsy_type)
				autopsy_type = /obj/item/weapon/paper/autopsy_report

		var/obj/item/weapon/paper/autopsy_report/A = new autopsy_type(src.loc)
		A.plane = ABOVE_OBJ_PLANE
		A.write_report(buckled_mob)

		//finish off the last of the mob
		buckled_mob.gib()
		playsound(get_turf(src), 'sound/effects/squelch2.ogg', 100, TRUE)

/obj/item/weapon/paper/autopsy_report
	var/my_species

/obj/item/weapon/paper/autopsy_report/proc/write_report(var/mob/living/carbon/human/H)
	var/text = "<h1>Autopsy report</h1>"
	var/title = "Autopsy report: [H.real_name]"
	if(istype(H))
		title += " ([H.species.name])"
		my_species = H.species

		text += "<em>Species:</em> [H.species.name]<br>"
		text += "[H.species.blurb]<br>"
		text += "<em>Autopsy subject:</em> [H.real_name]<br>"
		text += "<em>Main language:</em> [H.species.default_language]<br>"
		text += "<em>Other languages:</em> [english_list(H.species.additional_langs)]<br>"
		text += "<em>Inhale gas:</em> [H.species.breath_type]<br>"
		text += "<em>Exhale gas:</em> [H.species.exhale_type]<br>"
		text += "<em>Safe inhalation pressure:</em> [H.species.breath_pressure]kPa<br>"
		text += "<em>Toxins:</em> [english_list(H.species.poison_gases)]<br>"
		text += "<em>Adrenal break threshold:</em> [H.species.adrenal_break_threshold]u<br>"
		text += "<em>Core temperature:</em> [H.species.body_temperature]k<br>"
		text += "<em>Comfortable temperature:</em> [H.species.cold_discomfort_level]k to [H.species.heat_discomfort_level]k<br>"
		text += "<em>Comfortable pressure:</em> [H.species.warning_low_pressure]kPa to [H.species.warning_high_pressure]kPa<br>"
		text += "<em>Low light vision:</em> [H.species.darksight > 2 ? "good" : "poor"]<br>"
		text += "<em>Blood volume:</em> [H.species.blood_volume]u<br>"
		text += "<em>Feats of strength:</em> [H.species.can_force_door ? "true" : "false"]<br>"
		text += "<em>Physical mobility:</em> "
		if(H.species.slowdown > 0)
			text += "poor"
		else if(H.species.slowdown < 0)
			text += "good"
		else
			text += "average"
		text += "<br>"
		text += "<em>Melee damage:</em> "
		if(H.species.melee_force_multiplier > 1)
			text += "good"
		else if(H.species.melee_force_multiplier < 1)
			text += "poor"
		else
			text += "average"
		text += "<br>"
		text += "<em>Stat comparisons to baseline human:</em><br>"
		text += "	- [100 * H.species.brute_mod]% physical damage<br>"
		text += "	- [100 * H.species.burn_mod]% burn damage<br>"
		text += "	- [100 * H.species.oxy_mod]% asphyxiation damage<br>"
		text += "	- [100 * H.species.toxins_mod]% toxin damage<br>"
		text += "	- [100 * H.species.radiation_mod]% radiation damage<br>"
		text += "	- [100 * H.species.flash_mod]% strobe susceptability<br>"
		text += "	- [100 * H.species.metabolism_mod]% metabolism rate<br>"
		text += "	- [100 * H.species.pain_mod]% pain reception<br>"
		text += "	- [100 * H.species.explosion_effect_mod]% blast damage<br>"
		text += "	- [100 * H.species.siemens_coefficient]% electricity damage<br>"
		text += "	- [round(100 * H.species.total_health/200)]% body robustness ([H.species.total_health])<br>"
		text += "	- [100 * H.species.equipment_slowdown_multiplier]% equipment encumbrance<br>"
		text += "<em>Internal organs:</em> [english_list(H.species.has_organ)]<br>"
		text += "<em>External organs:</em> [english_list(H.species.has_limbs)]<br>"
	else
		text += "<em>Species:</em> Unknown/NA. Unable to determine from autopsy<br>"

	set_content(text, title)

//have to set these subtypes so it works with research code

/obj/item/weapon/paper/autopsy_report/human
/obj/item/weapon/paper/autopsy_report/jiralhanae
/obj/item/weapon/paper/autopsy_report/ruuhtian
/obj/item/weapon/paper/autopsy_report/sangheili
/obj/item/weapon/paper/autopsy_report/sanshyuum
/obj/item/weapon/paper/autopsy_report/ruuhtian
/obj/item/weapon/paper/autopsy_report/tvoan
/obj/item/weapon/paper/autopsy_report/yanmee
/obj/item/weapon/paper/autopsy_report/unggoy
