/obj/item/device/scanner/health
	name = "health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	icon = 'icons/obj/health_analyzer.dmi'
	icon_state = "health"
	item_state = "analyzer"
	item_flags = ITEM_FLAG_NO_BLUDGEON
	matter = list(MATERIAL_ALUMINIUM = 200)
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 1)
	printout_color = "#deebff"
	var/mode = 1

/obj/item/device/scanner/health/is_valid_scan_target(atom/O)
	return istype(O, /mob/living/carbon/human) || istype(O, /obj/structure/closet/body_bag)

/obj/item/device/scanner/health/scan(atom/A, mob/user)
	scan_data = medical_scan_action(A, user, src, mode)
	playsound(src, 'sound/effects/fastbeep.ogg', 20)

/proc/medical_scan_action(atom/target, mob/living/user, obj/scanner, var/verbose)
	if (!user.IsAdvancedToolUser())
		to_chat(user, "<span class='warning'>You are not nimble enough to use this device.</span>")
		return

	if ((MUTATION_CLUMSY in user.mutations) && prob(50))
		user.visible_message("<span class='notice'>\The [user] runs \the [scanner] over the floor.")
		to_chat(user, "<span class='notice'><b>Scan results for the floor:</b></span>")
		to_chat(user, "Overall Status: Healthy</span>")
		return

	var/mob/living/carbon/human/scan_subject = null
	if (istype(target, /mob/living/carbon/human))
		scan_subject = target
	else if (istype(target, /obj/structure/closet/body_bag))
		var/obj/structure/closet/body_bag/B = target
		if(!B.opened)
			var/list/scan_content = list()
			for(var/mob/living/L in B.contents)
				scan_content.Add(L)

			if (scan_content.len == 1)
				for(var/mob/living/carbon/human/L in scan_content)
					scan_subject = L
			else if (scan_content.len > 1)
				to_chat(user, "<span class='warning'>\The [scanner] picks up multiple readings inside \the [target], too close together to scan properly.</span>")
				return
			else
				to_chat(user, "\The [scanner] does not detect anyone inside \the [target].")
				return

	if(!scan_subject)
		return

	if (scan_subject.isSynthetic())
		to_chat(user, "<span class='warning'>\The [scanner] is designed for organic humanoid patients only.</span>")
		return

	. = medical_scan_results(scan_subject, verbose, user.get_skill_value(SKILL_MEDICAL))
	to_chat(user, "<hr>")
	to_chat(user, .)
	to_chat(user, "<hr>")

/proc/medical_scan_results(var/mob/living/carbon/human/H, var/verbose, var/skill_level = SKILL_DEFAULT)
	. = list()
	var/header = list()
	var/b
	var/endb
	var/dat = list()

	if(skill_level >= SKILL_BASIC)
		header += "<style> .scan_notice{color: #5f94af;}</style>"
		header += "<style> .scan_warning{color: #ff0000; font-style: italic;}</style>"
		header += "<style> .scan_danger{color: #ff0000; font-weight: bold;}</style>"
		header += "<style> .scan_red{color:red}</style>"
		header += "<style> .scan_green{color:green}</style>"
		header += "<style> .scan_blue{color: #5f94af}</style>"
		header += "<style> .scan_orange{color:#ffa500}</style>"
		b		= "<b>"
		endb	= "</b>"

	. += "[b]Scan results for \the [H]:[endb]"

	// Brain activity.
	var/brain_result = "normal"
	if(H.should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/brain/brain = H.internal_organs_by_name[BP_BRAIN]
		if(!brain || H.stat == DEAD || (H.status_flags & FAKEDEATH))
			brain_result = "<span class='scan_danger'>none, patient is braindead</span>"
		else if(H.stat != DEAD)
			if(H.has_brain_worms())
				brain_result = "<span class='scan_danger'>ERROR - aberrant/unknown brainwave patterns, advanced scanner recommended</span>"
			else
				if(skill_level < SKILL_BASIC)
					brain_result = "there's movement on the graph"
				else if(istype(brain))
					switch(brain.get_current_damage_threshold())
						if(0)
							brain_result = "normal"
						if(1 to 2)
							brain_result = "<span class='scan_notice'>minor brain damage</span>"
						if(3 to 5)
							brain_result = "<span class='scan_warning'>weak</span>"
						if(6 to 8)
							brain_result = "<span class='scan_danger'>extremely weak</span>"
						if(9 to INFINITY)
							brain_result = "<span class='scan_danger'>fading</span>"
						else
							brain_result = "<span class='scan_danger'>ERROR - Hardware fault</span>"
				else
					brain_result = "<span class='scan_danger'>ERROR - Organ not recognized</span>"
	else
		brain_result = "<span class='scan_danger'>ERROR - Nonstandard biology</span>"
	dat += "Brain activity: [brain_result]."

	if(H.stat == DEAD || (H.status_flags & FAKEDEATH))
		dat += "<span class='scan_warning'>[b]Time of Death:[endb] [time2text(worldtime2stationtime(H.timeofdeath), "hh:mm")]</span>"

	// Pulse rate.
	var/pulse_result = "normal"
	if(H.should_have_organ(BP_HEART))
		if(H.status_flags & FAKEDEATH)
			pulse_result = 0
		else
			pulse_result = H.get_pulse(GETPULSE_TOOL)
		pulse_result = "[pulse_result]bpm"
		if(H.pulse() == PULSE_NONE)
			pulse_result = "<span class='scan_danger'>[pulse_result]</span>"
		else if(H.pulse() < PULSE_NORM)
			pulse_result = "<span class='scan_notice'>[pulse_result]</span>"
		else if(H.pulse() > PULSE_NORM)
			pulse_result = "<span class='scan_warning'>[pulse_result]</span>"
	else
		pulse_result = "<span class='scan_danger'>ERROR - Nonstandard biology</span>"
	dat += "Pulse rate: [pulse_result]."

	// Blood pressure. Based on the idea of a normal blood pressure being 120 over 80.
	if(H.should_have_organ(BP_HEART))
		if(H.get_blood_volume() <= 70)
			dat += "<span class='scan_danger'>Severe blood loss detected.</span>"
		var/oxygenation_string = "[H.get_blood_oxygenation()]% blood oxygenation"
		switch(H.get_blood_oxygenation())
			if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
				oxygenation_string = "<span class='scan_notice'>[oxygenation_string]</span>"
			if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_OKAY)
				oxygenation_string = "<span class='scan_warning'>[oxygenation_string]</span>"
			if(-(INFINITY) to BLOOD_VOLUME_SURVIVE)
				oxygenation_string = "<span class='scan_danger'>[oxygenation_string]</span>"
		dat += "[b]Blood pressure:[endb] [H.get_blood_pressure()] ([oxygenation_string])"
	else
		dat += "[b]Blood pressure:[endb] N/A"

	// Body temperature.
	dat += "Body temperature: [H.bodytemperature-T0C]&deg;C ([H.bodytemperature*1.8-459.67]&deg;F)"

	// Radiation.
	switch(H.radiation)
		if(-INFINITY to 0)
			dat += "No radiation detected."
		if(1 to 30)
			dat += "<span class='scan_notice'>Patient shows minor traces of radiation exposure.</span>"
		if(31 to 60)
			dat += "<span class='scan_notice'>Patient is suffering from mild radiation poisoning.</span>"
		if(61 to 90)
			dat += "<span class='scan_warning'>Patient is suffering from advanced radiation poisoning.</span>"
		if(91 to 120)
			dat += "<span class='scan_warning'>Patient is suffering from severe radiation poisoning.</span>"
		if(121 to 240)
			dat += "<span class='scan_danger'>Patient is suffering from extreme radiation poisoning. Immediate treatment recommended.</span>"
		if(241 to INFINITY)
			dat += "<span class='scan_danger'>Patient is suffering from acute radiation poisoning. Immediate treatment recommended.</span>"

	// Traumatic shock.
	if(H.is_asystole())
		dat += "<span class='scan_danger'>Patient is suffering from cardiovascular shock. Administer CPR immediately.</span>"
	else if(H.shock_stage > 80)
		dat += "<span class='scan_warning'>Patient is at serious risk of going into shock. Pain relief recommended.</span>"

	// Other general warnings.
	if(skill_level >= SKILL_BASIC)
		if(H.getOxyLoss() > 50)
			dat += "<span class='scan_blue'>[b]Severe oxygen deprivation detected.[endb]</span>"
		if(H.getToxLoss() > 50)
			dat += "<span class='scan_green'>[b]Major systemic organ failure detected.[endb]</span>"
	if(H.getFireLoss() > 50)
		dat += "<span class='scan_orange'>[b]Severe burn damage detected.[endb]</span>"
	if(H.getBruteLoss() > 50)
		dat += "<span class='scan_red'>[b]Severe anatomical damage detected.[endb]</span>"

	if(skill_level >= SKILL_BASIC)
		for(var/name in H.organs_by_name)
			var/obj/item/organ/external/e = H.organs_by_name[name]
			if(!e)
				continue
			var/limb = e.name
			if(e.status & ORGAN_BROKEN)
				if(((e.name == BP_L_ARM) || (e.name == BP_R_ARM) || (e.name == BP_L_LEG) || (e.name == BP_R_LEG)) && (!e.splinted))
					dat += "<span class='scan_warning'>Unsecured fracture in subject [limb]. Splinting recommended for transport.</span>"
			if(e.has_infected_wound())
				dat += "<span class='scan_warning'>Infected wound detected in subject [limb]. Disinfection recommended.</span>"

		for(var/name in H.organs_by_name)
			var/obj/item/organ/external/e = H.organs_by_name[name]
			if(e && e.status & ORGAN_BROKEN)
				dat += "<span class='scan_warning'>Bone fractures detected. Advanced scanner required for location.</span>"
				break

		var/found_bleed
		var/found_tendon
		var/found_disloc
		for(var/obj/item/organ/external/e in H.organs)
			if(e)
				if(!found_disloc && e.dislocated >= 1)
					dat += "<span class='scan_warning'>Dislocation detected. Advanced scanner required for location.</span>"
					found_disloc = TRUE
				if(!found_bleed && (e.status & ORGAN_ARTERY_CUT))
					dat += "<span class='scan_warning'>Arterial bleeding detected. Advanced scanner required for location.</span>"
					found_bleed = TRUE
				if(!found_tendon && (e.status & ORGAN_TENDON_CUT))
					dat += "<span class='scan_warning'>Tendon or ligament damage detected. Advanced scanner required for location.</span>"
					found_tendon = TRUE
			if(found_disloc && found_bleed && found_tendon)
				break

	. += (skill_level < SKILL_BASIC) ? shuffle(dat) : dat
	dat = list()

	if(verbose)
		// Limb status.
		. += "[b]Specific limb damage:[endb]"

		var/list/damaged = H.get_damaged_organs(1,1)
		if(damaged.len)
			for(var/obj/item/organ/external/org in damaged)
				var/limb_result = "[capitalize(org.name)][BP_IS_ROBOTIC(org) ? " (Cybernetic)" : ""]:"
				if(org.brute_dam > 0)
					limb_result = "[limb_result] \[<font color = 'red'><b>[get_wound_severity(org.brute_ratio, (org.limb_flags & ORGAN_FLAG_HEALS_OVERKILL))] physical trauma</b></font>\]"
				if(org.burn_dam > 0)
					limb_result = "[limb_result] \[<font color = '#ffa500'><b>[get_wound_severity(org.burn_ratio, (org.limb_flags & ORGAN_FLAG_HEALS_OVERKILL))] burns</b></font>\]"
				if(org.status & ORGAN_BLEEDING)
					limb_result = "[limb_result] \[<span class='scan_danger'>bleeding</span>\]"
				dat += limb_result
		else
			dat += "No detectable limb injuries."
	. += (skill_level < SKILL_BASIC) ? shuffle(dat) : dat

	// Reagent data.
	. += "[b]Reagent scan:[endb]"

	var/print_reagent_default_message = TRUE
	if(H.reagents.total_volume)
		var/unknown = 0
		var/reagentdata[0]
		for(var/A in H.reagents.reagent_list)
			var/datum/reagent/R = A
			if(R.scannable)
				print_reagent_default_message = FALSE
				reagentdata[R.type] = "<span class='scan_notice'>[round(H.reagents.get_reagent_amount(R.type), 1)]u [R.name]</span>"
			else
				unknown++
		if(reagentdata.len)
			print_reagent_default_message = FALSE
			. += "<span class='scan_notice'>Beneficial reagents detected in subject's blood:</span>"
			for(var/d in reagentdata)
				. += reagentdata[d]
		if(unknown)
			print_reagent_default_message = FALSE
			. += "<span class='scan_warning'>Warning: Unknown substance[(unknown>1)?"s":""] detected in subject's blood.</span>"

	var/datum/reagents/ingested = H.get_ingested_reagents()
	if(ingested && ingested.total_volume)
		var/unknown = 0
		for(var/datum/reagent/R in ingested.reagent_list)
			if(R.scannable)
				print_reagent_default_message = FALSE
				. += "<span class='scan_notice'>[R.name] found in subject's stomach.</span>"
			else
				++unknown
		if(unknown)
			print_reagent_default_message = FALSE
			. += "<span class='scan_warning'>Non-medical reagent[(unknown > 1)?"s":""] found in subject's stomach.</span>"

	if(H.chem_doses.len)
		var/list/chemtraces = list()
		for(var/T in H.chem_doses)
			var/datum/reagent/R = T
			if(initial(R.scannable))
				chemtraces += "[initial(R.name)] ([H.chem_doses[T]])"
		if(chemtraces.len)
			. += "<span class='scan_notice'>Metabolism products of [english_list(chemtraces)] found in subject's system.</span>"

	if(print_reagent_default_message)
		. += "No results."

	header = jointext(header, null)
	. = jointext(.,"<br>")
	. = jointext(list(header,.),null)

// Calculates severity based on the ratios defined external limbs.
proc/get_wound_severity(var/damage_ratio, var/can_heal_overkill = 0)
	var/degree

	switch(damage_ratio)
		if(0 to 0.1)
			degree = "minor"
		if(0.1 to 0.25)
			degree = "moderate"
		if(0.25 to 0.5)
			degree = "significant"
		if(0.5 to 0.75)
			degree = "severe"
		if(0.75 to 1)
			degree = "extreme"
		else
			if(can_heal_overkill)
				degree = "critical"
			else
				degree = "irreparable"

	return degree

/obj/item/device/scanner/health/verb/toggle_mode()
	set name = "Switch Verbosity"
	set category = "Object"

	mode = !mode
	if(mode)
		to_chat(usr, "The scanner now shows specific limb damage.")
	else
		to_chat(usr, "The scanner no longer shows limb damage.")
