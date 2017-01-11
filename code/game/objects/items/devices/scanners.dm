/*
CONTAINS:
T-RAY
DETECTIVE SCANNER
HEALTH ANALYZER
GAS ANALYZER
MASS SPECTROMETER
REAGENT SCANNER
*/


/obj/item/device/healthanalyzer
	name = "health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	icon_state = "health"
	item_state = "analyzer"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEM_SIZE_SMALL
	throw_speed = 5
	throw_range = 10
	matter = list(DEFAULT_WALL_MATERIAL = 200)
	origin_tech = list(TECH_MAGNET = 1, TECH_BIO = 1)
	var/mode = 1;

/obj/item/device/healthanalyzer/do_surgery(mob/living/M, mob/living/user)
	if(user.a_intent != I_HELP) //in case it is ever used as a surgery tool
		return ..()
	scan_mob(M, user) //default surgery behaviour is just to scan as usual
	return 1

/obj/item/device/healthanalyzer/attack(mob/living/M, mob/living/user)
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	scan_mob(M, user)

/obj/item/device/healthanalyzer/proc/scan_mob(mob/living/M, mob/living/user)
	if ((CLUMSY in user.mutations) && prob(50))
		to_chat(user, text("<span class='warning'>You try to analyze the floor's vitals!</span>"))
		for(var/mob/O in viewers(M, null))
			O.show_message("<span class='warning'>\The [user] has analyzed the floor's vitals!</span>", 1)
		user.show_message("<span class='notice'>Analyzing Results for The floor:</span>", 1)
		user.show_message("Overall Status: Healthy</span>", 1)
		user.show_message("<span class='notice'>    Damage Specifics: 0-0-0-0</span>", 1)
		user.show_message("<span class='notice'>Key: Suffocation/Toxin/Burns/Brute</span>", 1)
		user.show_message("<span class='notice'>Body Temperature: ???</span>", 1)
		return
	if (!user.IsAdvancedToolUser())
		return
	user.visible_message("<span class='notice'>[user] has analyzed [M]'s vitals.</span>","<span class='notice'>You have analyzed [M]'s vitals.</span>")

	if (!istype(M,/mob/living/carbon/human) || M.isSynthetic())
		//these sensors are designed for organic life
		user.show_message("<span class='notice'>Analyzing Results for ERROR:\n\t Overall Status: ERROR</span>")
		user.show_message("<span class='notice'>    Key: <font color='blue'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font></span>", 1)
		user.show_message("<span class='notice'>    Damage Specifics: <font color='blue'>?</font> - <font color='green'>?</font> - <font color='#FFA500'>?</font> - <font color='red'>?</font></span>")
		user.show_message("<span class='notice'>Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)</span>", 1)
		user.show_message("<span class='warning'>Warning: Blood Level ERROR: --% --cl.</span> <span class='notice'>Type: ERROR</span>")
		user.show_message("<span class='notice'>Subject's pulse: <font color='red'>-- bpm.</font></span>")
		return

	var/fake_oxy = max(rand(1,40), M.getOxyLoss(), (300 - (M.getToxLoss() + M.getFireLoss() + M.getBruteLoss())))
	var/OX = M.getOxyLoss() > 50 	? 	"<b>[M.getOxyLoss()]</b>" 		: M.getOxyLoss()
	var/TX = M.getToxLoss() > 50 	? 	"<b>[M.getToxLoss()]</b>" 		: M.getToxLoss()
	var/BU = M.getFireLoss() > 50 	? 	"<b>[M.getFireLoss()]</b>" 		: M.getFireLoss()
	var/BR = M.getBruteLoss() > 50 	? 	"<b>[M.getBruteLoss()]</b>" 	: M.getBruteLoss()
	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 			? 	"<b>[fake_oxy]</b>" 			: fake_oxy
		user.show_message("<span class='notice'>Analyzing Results for [M]:</span>")
		user.show_message("<span class='notice'>Overall Status: dead</span>")
	else
		user.show_message("<span class='notice'>Analyzing Results for [M]:\n\t Overall Status: [M.stat > 1 ? "dead" : "[round(M.health*100/M.maxHealth)]% healthy"]</span>")
	user.show_message("<span class='notice'>    Key: <font color='blue'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font></span>", 1)
	user.show_message("<span class='notice'>    Damage Specifics: <font color='blue'>[OX]</font> - <font color='green'>[TX]</font> - <font color='#FFA500'>[BU]</font> - <font color='red'>[BR]</font></span>")
	user.show_message("<span class='notice'>Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)</span>", 1)
	if(M.stat == DEAD || (M.status_flags & FAKEDEATH))
		user.show_message("<span class='notice'>Time of Death: [time2text(worldtime2stationtime(M.timeofdeath))]</span>")
	if(istype(M, /mob/living/carbon/human) && mode == 1)
		var/mob/living/carbon/human/H = M
		var/list/damaged = H.get_damaged_organs(1,1)
		user.show_message("<span class='notice'>Localized Damage, Brute/Burn:</span>",1)
		if(length(damaged)>0)
			for(var/obj/item/organ/external/org in damaged)
				user.show_message(text("<span class='notice'>     [][]: [][] - []</span>",
				capitalize(org.name),
				(org.robotic >= ORGAN_ROBOT) ? "(Cybernetic)" : "",
				(org.brute_dam > 0) ? "<span class='warning'>[org.brute_dam]</span>" : 0,
				(org.status & ORGAN_BLEEDING)?"<span class='danger'>\[Bleeding\]</span>":"",
				(org.burn_dam > 0) ? "<font color='#FFA500'>[org.burn_dam]</font>" : 0),1)
		else
			user.show_message("<span class='notice'>    Limbs are OK.</span>",1)

	OX = M.getOxyLoss() > 50 ? 	"<font color='blue'><b>Severe oxygen deprivation detected</b></font>" 		: 	"Subject bloodstream oxygen level normal"
	TX = M.getToxLoss() > 50 ? 	"<font color='green'><b>Dangerous amount of toxins detected</b></font>" 	: 	"Subject bloodstream toxin level minimal"
	BU = M.getFireLoss() > 50 ? 	"<font color='#FFA500'><b>Severe burn damage detected</b></font>" 			:	"Subject burn injury status O.K"
	BR = M.getBruteLoss() > 50 ? "<font color='red'><b>Severe anatomical damage detected</b></font>" 		: 	"Subject brute-force injury status O.K"
	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 ? 		"<span class='warning'>Severe oxygen deprivation detected</span>" 	: 	"Subject bloodstream oxygen level normal"
	user.show_message("[OX] | [TX] | [BU] | [BR]")
	if(M.radiation)
		user.show_message("<span class='notice'>Radiation Level: [M.radiation]</span>")
	else
		user.show_message("<span class='notice'>No radiation detected.</span>")
	if(istype(M, /mob/living/carbon))
		var/mob/living/carbon/C = M
		if(C.reagents.total_volume)
			var/unknown = 0
			var/reagentdata[0]
			for(var/A in C.reagents.reagent_list)
				var/datum/reagent/R = A
				if(R.scannable)
					reagentdata["[R.id]"] = "<span class='notice'>    [round(C.reagents.get_reagent_amount(R.id), 1)]u [R.name]</span>"
				else
					unknown++
			if(reagentdata.len)
				user.show_message("<span class='notice'>Beneficial reagents detected in subject's blood:</span>")
				for(var/d in reagentdata)
					user.show_message(reagentdata[d])
			if(unknown)
				user.show_message("<span class='warning'>Warning: Unknown substance[(unknown>1)?"s":""] detected in subject's blood.</span>")
		if(C.ingested && C.ingested.total_volume)
			var/unknown = 0
			for(var/datum/reagent/R in C.ingested.reagent_list)
				if(R.scannable)
					to_chat(user, "<span class='notice'>[R.name] found in subject's stomach.</span>")
				else
					++unknown
			if(unknown)
				to_chat(user, "<span class='warning'>Non-medical reagent[(unknown > 1)?"s":""] found in subject's stomach.</span>")
		if(C.virus2.len)
			for (var/ID in C.virus2)
				if (ID in virusDB)
					var/datum/data/record/V = virusDB[ID]
					user.show_message("<span class='warning'>Warning: Pathogen [V.fields["name"]] detected in subject's blood. Known antigen : [V.fields["antigen"]]</span>")
//			user.show_message(text("<span class='warning'>Warning: Unknown pathogen detected in subject's blood.</span>"))
	if (M.getCloneLoss())
		user.show_message("<span class='warning'>Subject appears to have been imperfectly cloned.</span>")
//	if (M.reagents && M.reagents.get_reagent_amount("inaprovaline"))
//		user.show_message("<span class='notice'>Bloodstream Analysis located [M.reagents:get_reagent_amount("inaprovaline")] units of rejuvenation chemicals.</span>")
	if (M.has_brain_worms())
		user.show_message("<span class='warning'>Subject suffering from aberrant brain activity. Recommend further scanning.</span>")

	else if (M.getBrainLoss() >= 60 || !M.has_brain())
		user.show_message("<span class='warning'>Subject is brain dead.</span>")
	else if (M.getBrainLoss() >= 25)
		user.show_message("<span class='warning'>Severe brain damage detected. Subject likely to have a traumatic brain injury.</span>")
	else if (M.getBrainLoss() >= 10)
		user.show_message("<span class='warning'>Significant brain damage detected. Subject may have had a concussion.</span>")
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/name in H.organs_by_name)
			var/obj/item/organ/external/e = H.organs_by_name[name]
			if(!e)
				continue
			var/limb = e.name
			if(e.status & ORGAN_BROKEN)
				if(((e.name == BP_L_ARM) || (e.name == BP_R_ARM) || (e.name == BP_L_LEG) || (e.name == BP_R_LEG)) && (!e.splinted))
					to_chat(user, "<span class='warning'>Unsecured fracture in subject [limb]. Splinting recommended for transport.</span>")
			if(e.has_infected_wound())
				to_chat(user, "<span class='warning'>Infected wound detected in subject [limb]. Disinfection recommended.</span>")

		if (H.internal_organs_by_name[BP_STACK])
			user.show_message("<span class='notice'>Subject has a neural lace implant.</span>")

		for(var/name in H.organs_by_name)
			var/obj/item/organ/external/e = H.organs_by_name[name]
			if(e && e.status & ORGAN_BROKEN)
				user.show_message(text("<span class='warning'>Bone fractures detected. Advanced scanner required for location.</span>"), 1)
				break
		for(var/obj/item/organ/external/e in H.organs)
			if(!e)
				continue
			for(var/datum/wound/W in e.wounds) if(W.internal)
				user.show_message(text("<span class='warning'>Internal bleeding detected. Advanced scanner required for location.</span>"), 1)
				break
		if(M:vessel)
			var/blood_volume = H.vessel.get_reagent_amount("blood")
			var/blood_percent =  round((blood_volume / H.species.blood_volume)*100)
			var/blood_type = H.dna.b_type
			if((blood_percent <= BLOOD_VOLUME_SAFE) && (blood_percent > BLOOD_VOLUME_BAD))
				user.show_message("<span class='danger'>Warning: Blood Level LOW: [blood_percent]% [blood_volume]cl.</span> <span class='notice'>Type: [blood_type]</span>")
			else if(blood_percent <= BLOOD_VOLUME_BAD)
				user.show_message("<span class='danger'><i>Warning: Blood Level CRITICAL: [blood_percent]% [blood_volume]cl.</i></span> <span class='notice'>Type: [blood_type]</span>")
			else
				user.show_message("<span class='notice'>Blood Level Normal: [blood_percent]% [blood_volume]cl. Type: [blood_type]</span>")
		user.show_message("<span class='notice'>Subject's pulse: <font color='[H.pulse() == PULSE_THREADY || H.pulse() == PULSE_NONE ? "red" : "blue"]'>[H.get_pulse(GETPULSE_TOOL)] bpm.</font></span>")

/obj/item/device/healthanalyzer/verb/toggle_mode()
	set name = "Switch Verbosity"
	set category = "Object"

	mode = !mode
	switch (mode)
		if(1)
			to_chat(usr, "The scanner now shows specific limb damage.")
		if(0)
			to_chat(usr, "The scanner no longer shows limb damage.")


/obj/item/device/analyzer
	name = "analyzer"
	desc = "A hand-held environmental scanner which reports current gas levels."
	icon_state = "atmos"
	item_state = "analyzer"
	w_class = ITEM_SIZE_SMALL
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20

	matter = list(DEFAULT_WALL_MATERIAL = 30,"glass" = 20)

	origin_tech = list(TECH_MAGNET = 1, TECH_ENGINEERING = 1)

/obj/item/device/analyzer/attack_self(mob/user as mob)

	if (user.incapacitated())
		return
	if (!user.IsAdvancedToolUser())
		return

	analyze_gases(user.loc, user)
	return

/obj/item/device/mass_spectrometer
	name = "mass spectrometer"
	desc = "A hand-held mass spectrometer which identifies trace chemicals in a blood sample."
	icon_state = "spectrometer"
	item_state = "analyzer"
	w_class = ITEM_SIZE_SMALL
	flags = CONDUCT | OPENCONTAINER
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20

	matter = list(DEFAULT_WALL_MATERIAL = 30,"glass" = 20)

	origin_tech = list(TECH_MAGNET = 2, TECH_BIO = 2)
	var/details = 0
	var/recent_fail = 0

/obj/item/device/mass_spectrometer/New()
	..()
	var/datum/reagents/R = new/datum/reagents(5)
	reagents = R
	R.my_atom = src

/obj/item/device/mass_spectrometer/on_reagent_change()
	if(reagents.total_volume)
		icon_state = initial(icon_state) + "_s"
	else
		icon_state = initial(icon_state)

/obj/item/device/mass_spectrometer/attack_self(mob/user as mob)
	if (user.incapacitated())
		return
	if (!user.IsAdvancedToolUser())
		return
	if(reagents.total_volume)
		var/list/blood_traces = list()
		for(var/datum/reagent/R in reagents.reagent_list)
			if(R.id != "blood")
				reagents.clear_reagents()
				to_chat(user, "<span class='warning'>The sample was contaminated! Please insert another sample</span>")
				return
			else
				blood_traces = params2list(R.data["trace_chem"])
				break
		var/dat = "Trace Chemicals Found: "
		for(var/R in blood_traces)
			if(details)
				dat += "[R] ([blood_traces[R]] units) "
			else
				dat += "[R] "
		to_chat(user, "[dat]")
		reagents.clear_reagents()
	return

/obj/item/device/mass_spectrometer/adv
	name = "advanced mass spectrometer"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)

/obj/item/device/reagent_scanner
	name = "reagent scanner"
	desc = "A hand-held reagent scanner which identifies chemical agents."
	icon_state = "spectrometer"
	item_state = "analyzer"
	w_class = ITEM_SIZE_SMALL
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 5
	throw_speed = 4
	throw_range = 20
	matter = list(DEFAULT_WALL_MATERIAL = 30,"glass" = 20)

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

	if(!isnull(O.reagents))
		var/dat = ""
		if(O.reagents.reagent_list.len > 0)
			var/one_percent = O.reagents.total_volume / 100
			for (var/datum/reagent/R in O.reagents.reagent_list)
				dat += "\n \t <span class='notice'>[R][details ? ": [R.volume / one_percent]%" : ""]"
		if(dat)
			to_chat(user, "<span class='notice'>Chemicals found: [dat]</span>")
		else
			to_chat(user, "<span class='notice'>No active chemical agents found in [O].</span>")
	else
		to_chat(user, "<span class='notice'>No significant chemical agents found in [O].</span>")

	return

/obj/item/device/reagent_scanner/adv
	name = "advanced reagent scanner"
	icon_state = "adv_spectrometer"
	details = 1
	origin_tech = list(TECH_MAGNET = 4, TECH_BIO = 2)

/obj/item/device/slime_scanner
	name = "slime scanner"
	icon_state = "adv_spectrometer"
	item_state = "analyzer"
	origin_tech = list(TECH_BIO = 1)
	w_class = ITEM_SIZE_SMALL
	flags = CONDUCT
	throwforce = 0
	throw_speed = 3
	throw_range = 7
	matter = list(DEFAULT_WALL_MATERIAL = 30,"glass" = 20)

/obj/item/device/slime_scanner/attack(mob/living/M as mob, mob/living/user as mob)
	if(!isslime(M))
		to_chat(user, "This device can only scan slimes.")
		return
	var/mob/living/carbon/slime/T = M
	user.show_message("<span class='notice'>Slime scan result for \the [M]:</span>")
	user.show_message("[T.colour] [T.is_adult ? "adult" : "baby"] slime")
	user.show_message("Nutrition: [T.nutrition]/[T.get_max_nutrition()]")
	if(T.nutrition < T.get_starve_nutrition())
		user.show_message("<span class='alert'>Warning: the slime is starving!</span>")
	else if (T.nutrition < T.get_hunger_nutrition())
		user.show_message("<span class='warning'>Warning: the slime is hungry.</span>")
	user.show_message("Electric charge strength: [T.powerlevel]")
	user.show_message("Health: [round(T.health / T.maxHealth)]%")

	var/list/mutations = T.GetMutations()

	if(!mutations.len)
		user.show_message("This slime will never mutate.")
	else
		var/list/mutationChances = list()
		for(var/i in mutations)
			if(i == T.colour)
				continue
			if(mutationChances[i])
				mutationChances[i] += T.mutation_chance / mutations.len
			else
				mutationChances[i] = T.mutation_chance / mutations.len

		var/list/mutationTexts = list("[T.colour] ([100 - T.mutation_chance]%)")
		for(var/i in mutationChances)
			mutationTexts += "[i] ([mutationChances[i]]%)"

		user.show_message("Possible colours on splitting: [english_list(mutationTexts)]")

	if (T.cores > 1)
		user.show_message("Anomalious slime core amount detected.")
	user.show_message("Growth progress: [T.amount_grown]/10.")

/obj/item/device/price_scanner
	name = "price scanner"
	desc = "Using an up-to-date database of various costs and prices, this device estimates the market price of an item up to 0.001% accuracy."
	icon_state = "price_scanner"
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	throwforce = 0
	throw_speed = 3
	throw_range = 3
	matter = list(DEFAULT_WALL_MATERIAL = 25, "glass" = 25)

/obj/item/device/price_scanner/afterattack(atom/movable/target, mob/user as mob, proximity)
	if(!proximity)
		return

	var/value = get_value(target)
	user.visible_message("\The [user] scans \the [target] with \the [src]")
	user.show_message("Price estimation of \the [target]: [value ? value : "N/A"] Thalers")