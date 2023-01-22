/mob/living/carbon/human/proc/get_raw_medical_data(var/tag = FALSE)
	var/mob/living/carbon/human/H = src
	var/list/scan = list()

	scan["name"] = H.name
	if(H.fake_name)
		scan["name"] = H.real_name
	scan["age"] = H.age + H.changed_age
	scan["time"] = stationtime2text()
	var/brain_result
	if(H.should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/brain/brain = H.internal_organs_by_name[BP_BRAIN]
		if(!brain || H.stat == DEAD || (H.status_flags & FAKEDEATH))
			brain_result = 0
		else if(H.stat != DEAD)
			brain_result = round(max(0,(1 - brain.damage/brain.max_damage)*100))
	else
		brain_result = -1
	scan["brain_activity"] = brain_result

	var/pulse_result
	if(H.should_have_organ(BP_HEART))
		var/obj/item/organ/internal/heart/heart = H.internal_organs_by_name[BP_HEART]
		if(!heart)
			pulse_result = 0
		else if(BP_IS_ROBOTIC(heart))
			pulse_result = -2
		else if(H.status_flags & FAKEDEATH)
			pulse_result = 0
		else
			pulse_result = H.get_pulse(GETPULSE_TOOL)
	else
		pulse_result = -1

	if(pulse_result == ">250")
		pulse_result = -3
	scan["pulse"] = text2num(pulse_result)

	scan["blood_pressure"] = H.get_blood_pressure()
	scan["blood_o2"] = H.get_blood_oxygenation()
	scan["blood_volume"] = H.vessel.get_reagent_amount(/datum/reagent/blood)
	scan["blood_volume_max"] = H.species.blood_volume
	scan["temperature"] = H.bodytemperature
	scan["trauma"] = H.getBruteLoss()
	scan["burn"] = H.getFireLoss()
	scan["toxin"] = H.getToxLoss()
	scan["oxygen"] = H.getOxyLoss()
	scan["radiation"] = H.radiation
	scan["genetic"] = H.getCloneLoss()
	scan["paralysis"] = H.paralysis
	scan["immune_system"] = H.virus_immunity()
	scan["worms"] = H.has_brain_worms()

	scan["reagents"] = list()

	if(H.reagents.total_volume)
		for(var/datum/reagent/R in H.reagents.reagent_list)
			var/list/reagent  = list()
			reagent["name"]= R.name
			reagent["quantity"] = round(H.reagents.get_reagent_amount(R.type),1)
			reagent["scannable"] = R.scannable
			scan["reagents"] += list(reagent)

	scan["external_organs"] = list()

	for(var/obj/item/organ/external/E in H.organs)
		var/list/O = list()
		O["name"] = E.name
		O["is_stump"] = E.is_stump()
		O["brute_ratio"] = E.brute_ratio
		O["burn_ratio"] = E.burn_ratio
		O["limb_flags"] = E.limb_flags
		O["brute_dam"] = E.brute_dam
		O["burn_dam"] = E.burn_dam
		O["scan_results"] = E.get_scan_results(tag)

		scan["external_organs"] += list(O)

	scan["internal_organs"] = list()

	for(var/obj/item/organ/internal/I in H.internal_organs)
		if (istype(I, /obj/item/organ/internal/augment))
			var/obj/item/organ/internal/augment/A = I
			if (~A.augment_flags & AUGMENT_SCANNABLE)
				continue
		var/list/O = list()
		O["name"] = I.name
		O["is_broken"] = I.is_broken()
		O["is_bruised"] = I.is_bruised()
		O["is_damaged"] = I.is_damaged()
		O["scan_results"] = I.get_scan_results(tag)
		if (istype(I, /obj/item/organ/internal/appendix))
			var/obj/item/organ/internal/appendix/A = I
			O["inflamed"] = A.inflamed

		scan["internal_organs"] += list(O)

	scan["missing_organs"] = list()

	for(var/organ_name in H.species.has_organ)
		if(!locate(H.species.has_organ[organ_name]) in H.internal_organs)
			scan["missing_organs"] += organ_name
	if(H.sdisabilities & BLINDED)
		scan["blind"] = TRUE
	if(H.sdisabilities & NEARSIGHTED)
		scan["nearsight"] = TRUE
	return scan

/proc/display_medical_data_header(var/list/scan, skill_level = SKILL_DEFAULT)
	//In case of problems, abort.
	var/dat = list()

	if(!scan["name"])
		return "<center><span class='bad'><strong>SCAN READOUT ERROR.</strong></span></center>"

	//Table definition and starting data block.
	/*
	<!--Clean HTML Formatting-->
	<table class="block" width="95%">
		<tr><td><strong>Scan Results For:</strong></td><td>Name</td></tr>
		<tr><td><strong>Scan Performed At:</strong></td><td>00:00</td></tr>
	*/
	dat += "<table class='block' width='95%'>"
	dat += "<tr><td><strong>Scan Results For:</strong></td><td>[scan["name"]]</td></tr>"
	dat += "<tr><td><strong>Scan performed at:</strong></td><td>[scan["time"]]</td></tr>"

	dat = JOINTEXT(dat)
	return dat

/proc/display_medical_data_health(var/list/scan, skill_level = SKILL_DEFAULT)
	//In case of problems, abort.
	if(!scan["name"])
		return "<center><span class='bad'><strong>SCAN READOUT ERROR.</strong></span></center>"

	var/list/subdat = list()
	var/dat = list()

	dat += "<tr><td><strong>Apparent Age:</strong></td><td>[scan["age"]]</td></tr>"

	//Brain activity
	/*
		<tr><td><strong>Brain Activity:</strong></td><td>100%</td></tr>
	*/
	dat += "<tr><td><strong>Brain activity:</strong></td>"
	switch(scan["brain_activity"])
		if(0)
			dat += "<td><span class='bad'>none, patient is braindead</span></td></tr>"
		if(-1)
			dat += "<td><span class='average'>ERROR - Nonstandard biology</span></td></tr>"
		else
			if(skill_level >= SKILL_BASIC)
				if(scan["brain_activity"] <= 50)
					dat += "<td><span class='bad'>[scan["brain_activity"]]%</span></td></tr>"
				else if(scan["brain_activity"] <= 80)
					dat += "<td><span class='average'>[scan["brain_activity"]]%</span></td></tr>"
				else
					dat += "<td>[scan["brain_activity"]]%</td></tr>"
			else
				if(scan["brain_activity"] > 0)
					dat += "<td>there's a squiggly line here</td></tr>"
				else
					dat += "<td>there's a straight line here</td></tr>"

	//Circulatory System
	/*
		<tr><td><strong>Pulse Rate:</strong></td><td>75bpm</td></tr>
		<tr><td colspan='2'><span class='average'>Patient is tachycardic.</span></td></tr>
		<tr><td><strong>Blood Pressure:</strong></td><td>120/80 (100% oxygenation)</td></tr>
		<tr><td><strong>Blood Volume:</strong></td><td>560u/560u</td></tr>
		<tr><td colspan="2" align="center"><span class='bad'>Patient in Hypovolemic Shock. Transfusion highly recommended.</span></td></tr>
	*/
	dat += "<tr><td><strong>Pulse rate:</strong></td>"
	if(scan["pulse"] == -1)
		dat += "<td><span class='average'>ERROR - Nonstandard biology</span></td></tr>"
	else if(scan["pulse"] == -2)
		dat += "<td>N/A</td></tr>"
	else if(scan["pulse"] == -3)
		dat += "<td><span class='bad'>250+bpm</span></td></tr>"
	else if(scan["pulse"] == 0)
		dat += "<td><span class='bad'>[scan["pulse"]]bpm</span></td></tr>"
	else if(scan["pulse"] >= 140)
		dat += "<td><span class='bad'>[scan["pulse"]]bpm</span></td></tr>"
	else if(scan["pulse"] >= 120)
		dat += "<td><span class='average'>[scan["pulse"]]bpm</span></td></tr>"
	else
		dat += "<td>[scan["pulse"]]bpm</td></tr>"
	if(skill_level >= SKILL_ADEPT)
		if((scan["pulse"] >= 140) || (scan["pulse"] == -3))
			dat+= "<tr><td colspan='2'><span class='bad'>Patient is tachycardic.</span></td></tr>"
		else if(scan["pulse"] >= 120)
			dat += "<tr><td colspan='2'><span class='average'>Patient is tachycardic.</span></td></tr>"
		else if(scan["pulse"] == 0)
			dat+= "<tr><td colspan='2'><span class='bad'>Patient's heart is stopped.</span></td></tr>"
		else if((scan["pulse"] > 0) && (scan["pulse"] <= 40))
			dat+= "<tr><td colspan='2'><span class='average'>Patient is bradycardic.</span></td></tr>"


	var/ratio = scan["blood_volume"]/scan["blood_volume_max"]
	dat += "<tr><td><strong>Blood pressure:</strong></td><td>[scan["blood_pressure"]] "
	if(scan["blood_o2"] <= 70)
		dat += "(<span class='bad'>[scan["blood_o2"]]% blood oxygenation</span>)</td></tr>"
	else if(scan["blood_o2"] <= 85)
		dat += "(<span class='average'>[scan["blood_o2"]]% blood oxygenation</span>)</td></tr>"
	else if(scan["blood_o2"] <= 90)
		dat += "(<span class='oxyloss'>[scan["blood_o2"]]% blood oxygenation</span>)</td></tr>"
	else
		dat += "([scan["blood_o2"]]% blood oxygenation)</td></tr>"

	dat += "<tr><td><strong>Blood volume:</strong></td><td>[scan["blood_volume"]]u/[scan["blood_volume_max"]]u</td></tr>"

	if(skill_level >= SKILL_ADEPT)
		if(ratio <= 0.70)
			dat += "<tr><td colspan='2'><span class='bad'>Patient is in hypovolemic shock. Transfusion highly recommended.</span></td></tr>"

	// Body temperature.
	/*
		<tr><td><strong>Body Temperature:</strong></td><td>40&deg;C (98.6&deg;F)</td></tr>
	*/
	dat += "<tr><td><strong>Body temperature:</strong></td><td>[scan["temperature"]-T0C]&deg;C ([scan["temperature"]*1.8-459.67]&deg;F)</td></tr>"

	//Information Summary
	/*
		<tr><td><strong>Physical Trauma:</strong></td><td>severe</td></tr>
		<tr><td><strong>Burn Severity:</strong></td><td>severe</td></tr>
		<tr><td><strong>Systematic Organ Failure:</strong>severe</td></tr>
		<tr><td><strong>Oxygen Deprivation:</strong></td><td>severe</tr>
		<tr><td><strong>Radiation Level:</strong></td><td>acute</td></tr>
		<tr><td><strong>Genetic Tissue Damage:</strong></td><td>severe</td></tr>
		<tr><td><strong>Paralysis Summary:</strong></td><td>approx 0 seconds left</td></tr>
	*/
	if(skill_level >= SKILL_BASIC)
		subdat += "<tr><td><strong>Physical Trauma:</strong></td><td>\t[get_severity(scan["trauma"],TRUE)]</td></tr>"
		subdat += "<tr><td><strong>Burn Severity:</strong></td><td>\t[get_severity(scan["burn"],TRUE)]</td></tr>"
		subdat += "<tr><td><strong>Systematic Organ Failure:</strong></td><td>\t[get_severity(scan["toxin"],TRUE)]</td></tr>"
		subdat += "<tr><td><strong>Oxygen Deprivation:</strong></td><td>\t[get_severity(scan["oxygen"],TRUE)]</td></tr>"
		subdat += "<tr><td><strong>Radiation Level:</strong></td><td>\t[get_severity(scan["radiation"]/5,TRUE)]</td></tr>"
		subdat += "<tr><td><strong>Genetic Tissue Damage:</strong></td><td>\t[get_severity(scan["genetic"],TRUE)]</td></tr>"

		if(scan["paralysis"])
			subdat += "<tr><td><strong>Paralysis Summary:</strong></td><td>approx. [scan["paralysis"]/4] seconds left</td></tr>"

		dat += subdat

		subdat = null
		//Immune System
		/*
			<tr><td colspan='2'><center>Antibody levels and immune system performance are at 100% of baseline.</center></td></tr>
			<tr><td colspan='2'><span class='bad'><center>Viral Pathogen detected in blood stream.</center></span></td></tr>
			<tr><td colspan='2'><span class='bad'><center>Large growth detected in frontal lobe, possibly cancerous.</center></span></td></tr>
		*/
		dat += "<tr><td colspan = '2'>Antibody levels and immune system perfomance are at [scan["immune_system"]*100]% of baseline.</td></tr>"

		if(scan["worms"])
			dat += "<tr><td colspan='2'><span class='bad'><center>Large growth detected in frontal lobe, possibly cancerous.</center></span></td></tr>"

		//Reagent scan
		/*
			<tr><td colspan='2'>Beneficial reagents detected in subject's bloodstream:</td></tr>
			<tr><td colspan='2'>10u dexalin plus</td></tr>
		*/
		var/other_reagent = FALSE

		for(var/list/R in scan["reagents"])
			if(R["scannable"])
				subdat += "<tr><td colspan='2'>[R["quantity"]]u [R["name"]]</td></tr>"
			else
				other_reagent = TRUE
		if(subdat)
			dat += "<tr><td colspan='2'>Beneficial reagents detected in subject's bloodstream:</td></tr>"
			dat += subdat
		if(other_reagent)
			dat += "<tr><td colspan='2'><span class='average'>Warning: Unknown substance detected in subject's blood.</span></td></tr>"

	//summary for the medically disinclined.
	/*
			<tr><td colspan='2'>You see a lot of numbers and abbreviations here, but you have no clue what any of this means.</td></tr>
	*/
	else
		dat += "<tr><td colspan='2'>You see a lot of numbers and abbreviations here, but you have no clue what any of it means.</td></tr>"

	dat = JOINTEXT(dat)

	return dat

/proc/display_medical_data_body(var/list/scan, skill_level = SKILL_DEFAULT)
	//In case of problems, abort.
	if(!scan["name"])
		return "<center><span class='bad'><strong>SCAN READOUT ERROR.</strong></span></center>"

	var/list/subdat = list()
	var/dat = list()
	//External Organs
	/*
			<tr><td colspan='2'><center>
				<table class='block' border='1' width='95%'>
					<tr><th colspan='3'>Body Status</th></tr>
					<tr><th>Organ</th><th>Damage</th><th>Status</th></tr>
					<tr><td>head</td><td><span class='brute'>Severe physical trauma</span><br><span class='burn'>Severe burns</span></td><td><span class='bad'>Bleeding</span></td></td>
					<tr><td>upper body</td><td>None</td><td></td></tr>
					<tr><td>right arm</td><td>N/A</td><td><span class='bad'>Missing</span></td></tr>
	*/

	dat += "<tr><td colspan='2'><center><table class='block' border='1' width='95%'><tr><th colspan='3'>Body Status</th></tr>"
	dat += "<tr><th>Organ</th><th>Damage</th><th>Status</th></tr>"
	subdat = list()

	for(var/list/E in scan["external_organs"])
		if(!E)
			break
		var/row = list()
		row += "<tr><td>[E["name"]]</td>"
		if(E["is_stump"])
			row += "<td><span style='font-weight: bold; color: [COLOR_MEDICAL_MISSING]'>Missing</span></td>"
			if(skill_level >= SKILL_ADEPT)
				row += "<td><span>[english_list(E["scan_results"], nothing_text = "&nbsp;")]</span></td>"
			else
				row += "<td>&nbsp;</td>"
		else
			row += "<td>"
			if(E["brute_dam"] + E["burn_dam"] == 0)
				row += "None</td>"
			if(skill_level < SKILL_ADEPT)
				if(E["brute_dam"])
					row += "<span style='font-weight: bold; color: [COLOR_MEDICAL_BRUTE]'>Damaged</span><br>"
				if(E["burn_dam"])
					row += "<span style='font-weight: bold; color: [COLOR_MEDICAL_BURN]'>Burned</span></td>"
			else
				if(E["brute_dam"])
					row += "<span style='font-weight: bold; color: [COLOR_MEDICAL_BRUTE]'>[capitalize(get_wound_severity(E["brute_ratio"], (E["limb_flags"] & ORGAN_FLAG_HEALS_OVERKILL)))] physical trauma</span><br>"
				if(E["burn_dam"])
					row += "<span style='font-weight: bold; color: [COLOR_MEDICAL_BURN]'>[capitalize(get_wound_severity(E["burn_ratio"], (E["limb_flags"] & ORGAN_FLAG_HEALS_OVERKILL)))] burns</span></td>"
			if(skill_level >= SKILL_ADEPT)
				row += "<td>"
				row += "<span>[english_list(E["scan_results"], nothing_text="&nbsp;")]</span>"
				row += "</td>"
			else
				row += "<td>&nbsp;</td>"
		row += "</tr>"
		subdat += JOINTEXT(row)
	dat += subdat
	subdat = list()


	//Internal Organs
	/*
					<tr><th colspan='3'><center>Internal Organs</center></th></tr>
					<tr><td>heart</td<td>None</td><td></td>
					<tr><td>lungs</td><td><span class='bad'>Severe</td><td>Decaying</span></td>
					<tr><td colspan='3'><span class='bad'>No liver detected.</span></td></tr>
					<tr><td colspan='3'>No appendix detected.</td></tr>
					<tr><td colspan='3'><span class='bad'>Cateracts detected.</span></td></tr>
					<tr><td colspan='3'><span class='average'>Retinal misalignment detected.</span></td></tr>
				</table>
			</center></td></tr>
	*/
	if(skill_level >= SKILL_BASIC)
		dat += "<tr><th colspan='3'><center>Internal Organs</center></th></tr>"
		for(var/list/I in scan["internal_organs"])
			var/row = list()
			var/inflamed = I["inflamed"] || FALSE
			row += "<tr><td><span[inflamed ? " class='bad'" : ""]>[I["name"]]</span></td>"
			if(I["is_broken"])
				row += "<td><span class='bad'>Severe</span></td>"
			else if(I["is_bruised"])
				row += "<td><span class='average'>Moderate</span></td>"
			else if(I["is_damaged"])
				row += "<td><span class='mild'>Minor</span></td>"
			else
				row += "<td>None</td>"
			row += "<td>"
			row += "<span class='bad'>[english_list(I["scan_results"], nothing_text="&nbsp;")]</span>"
			row += "</td></tr>"
			subdat += jointext(row, null)

	if(skill_level <= SKILL_ADEPT)
		dat += shuffle(subdat)
	else
		dat += subdat
	for(var/organ_name in scan["missing_organs"])
		if(organ_name != "appendix")
			dat += "<tr><td colspan='3'><span class='bad'>No [organ_name] detected.</span></td></tr>"
		else
			dat += "<tr><td colspan='3'>No [organ_name] detected.</td></tr>"

	if(scan["blind"])
		dat += "<tr><td colspan='3'><span class='bad'>Cataracts detected.</span></td></tr>"
	else if(scan["nearsight"])
		dat += "<tr><td colspan='3'><span class='average'>Retinal misalignment detected.</span></td></tr>"
	dat += "</table></center></td></tr>"

	dat = JOINTEXT(dat)
	return dat

/proc/display_medical_data(var/list/scan, skill_level = SKILL_DEFAULT, var/TT = FALSE)
	//In case of problems, abort.
	if(!scan["name"])
		return "<center><span class='bad'><strong>SCAN READOUT ERROR.</strong></span></center>"

	var/dat = list()

	if(TT)
		dat += "<tt>"

	//necessary evil, due to the limitations of nanoUI's variable length output.
	//This allows for the display_medical_data proc to be used for non-ui things
	//while keeping the variable size lower for the scanner template.
	//decoupling the two would lead to inconsistent output between the template
	//and other sources if changes are ever made.
	dat += display_medical_data_header(scan, skill_level)
	dat += display_medical_data_health(scan, skill_level)
	dat += display_medical_data_body(scan, skill_level)

	if(TT)
		dat += "</tt>"

	dat = JOINTEXT(dat)
	return dat

/proc/get_severity(amount, var/tag = FALSE)
	if(!amount)
		return "none"

	if(amount > 50)
		if(tag)
			. = "<span class='bad'>severe</span>"
		else
			. = "severe"
	else if(amount > 25)
		if(tag)
			. = "<span class='bad'>significant</span>"
		else
			. = "significant"
	else if(amount > 10)
		if(tag)
			. = "<span class='average'>moderate</span>"
		else
			. = "moderate"
	else
		if (tag)
			. = "<span class='mild'>minor</span>"
		else
			. = "minor"
