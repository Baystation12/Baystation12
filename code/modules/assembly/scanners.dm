/obj/item/device/assembly/scanner/healthanalyzer
	name = "health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	icon_state = "health"
	item_state = "analyzer"
	flags = CONDUCT
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = 2.0
	throw_speed = 5
	throw_range = 10
	matter = list(DEFAULT_WALL_MATERIAL = 200)
	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_PROCESS_SEND | WIRE_DIRECT_SEND | WIRE_MISC_CONNECTION | WIRE_MISC_SPECIAL
	wire_num = 7
	var/list/health_data = list()
	var/mode = "Specific Limb Damage"
	var/range = 1
	var/scanning = 0
	var/list/sendable_data = list("Overall Health Status", "Toxin Damage", "Respiration Damage", "Brute Damage", "Burn Damage", "Blood Level")
	var/sent_data = "Overall Health Status"
	var/stage = 0 // Motorised

/obj/item/device/assembly/scanner/healthanalyzer/misc_special(var/mob/M)
	if(M)
		scan(M, null)
	return 1

/obj/item/device/assembly/scanner/healthanalyzer/implant_process(var/mob/living/carbon/C)
	if(prob(60))
		scan(C)
		if(prob(10))
			C.audible_message("<small><span class='warning'>*beep*</span></small>", null, 2)

/obj/item/device/assembly/scanner/healthanalyzer/attackby(var/obj/O as obj, mob/user as mob)
	if(istype(O, /obj/item/weapon/stock_parts/scanning_module))
		if(range >= 5)
			user << "<span class='warning'>\The [src] cannot hold anymore scanning modules!</span>"
			return
		user.visible_message("<span class='notice'>[user] begins attaching a scanning device to \the [src]</span>", "<span class='notice'>You begin attaching a scanning device to \the [src]!</span>")
		if(!do_after(user, 90)) return
		user.drop_item()
		O.forceMove(src)
		qdel(O)
		range++
		user << "<span class='notice'>You attach a scanning device to \the [src]!</span>"
	if(istype(O, /obj/item/weapon/reagent_containers/syringe) && !stage)
		user.visible_message("<span class='notice'>\The [user] begins inserting a syringe into \the [src]..</span>", "<span class='notice'>You begin connecting a syringe to \the [src]..</span>")
		if(!do_after(user, 60)) return
		user << "<span class='notice'>You successfully install \the [O] into \the [src]!</span>"
		user.drop_item()
		O.forceMove(src)
		qdel(O)
		stage = 1
	if(istype(O, /obj/item/weapon/reagent_containers/syringe) && stage == 1)
		user.visible_message("<span class='notice'>\The [user] begins inserting a second syringe into \the [src]..</span>", "<span class='notice'>You begin connecting the second syringe to \the [src]..</span>")
		if(!do_after(user, 60)) return
		user << "<span class='notice'>You successfully install the second syringe into \the [src]!</span>"
		user.drop_item()
		O.forceMove(src)
		qdel(O)
		stage = 3
		implantable = 1
		name = "modified [name]"
		desc = "A weird contraption with needles poking out of it. It doesn't look very friendly."
		if(holder)
			holder.update_holder()
	..()

/obj/item/device/assembly/scanner/healthanalyzer/get_data(var/mob/user, var/ui_key)
	var/list/data = list()
	data.Add("Verbosity", mode)
	if(holder)
		data.Add("Sent Data", sent_data)
		data.Add("Scanning", scanning)
	return data

/obj/item/device/assembly/scanner/healthanalyzer/activate()
	if(scanning)
		add_debug_log("Searching for candidates \[[src]\]")
		var/mob/living/carbon/human/target
		var/dist = 7
		for(var/mob/living/carbon/human/human in view(range))
			if(get_dist(human, src) < dist)
				target = human
				dist = get_dist(human, src)
				add_debug_log("Found! Target:[target] Distance:[dist] Source: \[[src]\]")
		if(target)
			scan(target, null)
		else
			return 0
	else
		send_data(health_data)
		return 1

/obj/item/device/assembly/scanner/healthanalyzer/attack(mob/living/M as mob, mob/living/user as mob)
	scan(M, user)

/obj/item/device/assembly/scanner/healthanalyzer/proc/scan(var/mob/living/M as mob, mob/living/user as mob)
	var/list/scanned_data = list()
	add_debug_log("Scanning [M.name] \[[src]\]")
	if(!M)
		return
	if(user)
		if (( (CLUMSY in user.mutations) || user.getBrainLoss() >= 60) && prob(50) && user)
			user << text("<span class='warning'>You try to analyze the floor's vitals!</span>")
			for(var/mob/O in viewers(M, null))
				O.show_message(text("<span class='warning'>[user] has analyzed the floor's vitals!</span>"))
			scanned_data.Add(text("<span class='notice'>Analyzing Results for The floor:\n\t Overall Status: Healthy</span>"))
			scanned_data.Add(text("<span class='notice'> \t Damage Specifics: [0]-[0]-[0]-[0]</span>"))
			scanned_data.Add("<span class='notice'> Key: Suffocation/Toxin/Burns/Brute</span>")
			scanned_data.Add("<span class='notice'> Body Temperature: ???</span>")
			return
		if (!(istype(usr, /mob/living/carbon/human) || ticker) && ticker.mode.name != "monkey" && user)
			usr << "<span class='warning'>You don't have the dexterity to do this!</span>"
			return
	if(user)
		user.visible_message("<span class='notice'> [user] has analyzed [M]'s vitals.</span>","<span class='notice'> You have analyzed [M]'s vitals.</span>")
	else
		var/turf/T = get_turf(src.loc)
		if(T) T.visible_message("<span class='notice'>\The [src] beeps as it scan's [M]'s vitals!</span>")

	if (!istype(M, /mob/living/carbon) || M.isSynthetic())
		//these sensors are designed for organic life
		scanned_data.Add("<span class='notice'>Analyzing Results for ERROR:\n\t Overall Status: ERROR</span>")
		scanned_data.Add("\t Key: <font color='blue'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font>")
		scanned_data.Add("\t Damage Specifics: <font color='blue'>?</font> - <font color='green'>?</font> - <font color='#FFA500'>?</font> - <font color='red'>?</font>")
		scanned_data.Add("<span class='notice'> Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)</span>")
		scanned_data.Add("<span class='warning'> <b>Warning: Blood Level ERROR: --% --cl.\blue Type: ERROR</b></span>")
		scanned_data.Add("<span class='notice'> Subject's pulse: <font color='red'>-- bpm.</font></span>")
		return

	var/fake_oxy = max(rand(1,40), M.getOxyLoss(), (300 - (M.getToxLoss() + M.getFireLoss() + M.getBruteLoss())))
	var/OX = M.getOxyLoss() > 50 	? 	"<b>[M.getOxyLoss()]</b>" 		: M.getOxyLoss()
	var/TX = M.getToxLoss() > 50 	? 	"<b>[M.getToxLoss()]</b>" 		: M.getToxLoss()
	var/BU = M.getFireLoss() > 50 	? 	"<b>[M.getFireLoss()]</b>" 		: M.getFireLoss()
	var/BR = M.getBruteLoss() > 50 	? 	"<b>[M.getBruteLoss()]</b>" 	: M.getBruteLoss()
	if(sent_data == "Toxin Damage")
		send_data(list(M.getToxLoss()))
	if(sent_data == "Respiration Damage")
		send_data(list(M.getOxyLoss()))
	if(sent_data == "Brute Damage")
		send_data(list(M.getBruteLoss()))
	if(sent_data == "Burn Damage")
		send_data(list(M.getFireLoss()))
	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 			? 	"<b>[fake_oxy]</b>" 			: fake_oxy
		scanned_data.Add("<span class='notice'>Analyzing Results for [M]:\n\t Overall Status: dead</span>")
	else
		scanned_data.Add("<span class='notice'>Analyzing Results for [M]:\n\t Overall Status: [M.stat > 1 ? "dead" : "[M.health - M.halloss]% healthy"]</span>")
		if(sent_data == "Overall Health Status")
			send_data(list("[M.health - M.halloss]"))
	scanned_data.Add("\t Key: <font color='blue'>Suffocation</font>/<font color='green'>Toxin</font>/<font color='#FFA500'>Burns</font>/<font color='red'>Brute</font>")
	scanned_data.Add("\t Damage Specifics: <font color='blue'>[OX]</font> - <font color='green'>[TX]</font> - <font color='#FFA500'>[BU]</font> - <font color='red'>[BR]</font>")
	scanned_data.Add("<span class='notice'>Body Temperature: [M.bodytemperature-T0C]&deg;C ([M.bodytemperature*1.8-459.67]&deg;F)</span>")
	if(M.tod && (M.stat == DEAD || (M.status_flags & FAKEDEATH)))
		scanned_data.Add("<span class='notice'>Time of Death: [M.tod]</span>")
	if(istype(M, /mob/living/carbon/human) && mode == 1)
		var/mob/living/carbon/human/H = M
		var/list/damaged = H.get_damaged_organs(1,1)
		scanned_data.Add("<span class='notice'>Localized Damage, Brute/Burn:</span>")
		if(length(damaged)>0)
			for(var/obj/item/organ/external/org in damaged)
				scanned_data.Add(text("<span class='notice'>\t []: [][]\blue - []</span>",	\
				"[capitalize(org.name)][org.status & ORGAN_ROBOT ? "(Cybernetic)" : ""]",	\
				(org.brute_dam > 0)	?	"<span class='warning'>[org.brute_dam]</span>"							:0,		\
				(org.status & ORGAN_BLEEDING)?"<span class='warning'><b>\[Bleeding\]</b></span>":"\t", 		\
				(org.burn_dam > 0)	?	"<font color='#FFA500'>[org.burn_dam]</font>"	:0),1)
		else
			scanned_data.Add("<span class='notice'>\t Limbs are OK.</span>")

	OX = M.getOxyLoss() > 50 ? 	"<font color='blue'><b>Severe oxygen deprivation detected</b></font>" 		: 	"Subject bloodstream oxygen level normal"
	TX = M.getToxLoss() > 50 ? 	"<font color='green'><b>Dangerous amount of toxins detected</b></font>" 	: 	"Subject bloodstream toxin level minimal"
	BU = M.getFireLoss() > 50 ? 	"<font color='#FFA500'><b>Severe burn damage detected</b></font>" 			:	"Subject burn injury status O.K"
	BR = M.getBruteLoss() > 50 ? "<font color='red'><b>Severe anatomical damage detected</b></font>" 		: 	"Subject brute-force injury status O.K"
	if(M.status_flags & FAKEDEATH)
		OX = fake_oxy > 50 ? 		"<span class='danger'>Severe oxygen deprivation detected</span>" 	: 	"Subject bloodstream oxygen level normal"
	scanned_data.Add("[OX] | [TX] | [BU] | [BR]")
	if(istype(M, /mob/living/carbon))
		var/mob/living/carbon/C = M
		if(C.reagents.total_volume)
			var/unknown = 0
			var/reagentdata[0]
			for(var/A in C.reagents.reagent_list)
				var/datum/reagent/R = A
				if(R.scannable)
					reagentdata["[R.id]"] = "\t <span class='notice'> [round(C.reagents.get_reagent_amount(R.id), 1)]u [R.name]</span>"
				else
					unknown++
			if(reagentdata.len)
				scanned_data.Add("<span class='notice'>Beneficial reagents detected in subject's blood:</span>")
				for(var/d in reagentdata)
					scanned_data.Add(reagentdata[d])
			if(unknown)
				scanned_data.Add(text("<span class='warning'>Warning: Unknown substance[(unknown>1)?"s":""] detected in subject's blood.</span>"))
		if(C.ingested && C.ingested.total_volume && user)
			var/unknown = 0
			for(var/datum/reagent/R in C.ingested.reagent_list)
				if(R.scannable)
					user << "<span class='notice'>[R.name] found in subject's stomach.</span>"
				else
					++unknown
			if(unknown)
				user << "<span class='warning'>Non-medical reagent[(unknown > 1)?"s":""] found in subject's stomach.</span>"
		if(C.virus2.len)
			for (var/ID in C.virus2)
				if (ID in virusDB)
					var/datum/data/record/V = virusDB[ID]
					scanned_data.Add(text("<span class='warning'>Warning: Pathogen [V.fields["name"]] detected in subject's blood. Known antigen : [V.fields["antigen"]]</span>"))
//			user.show_message(text("\red Warning: Unknown pathogen detected in subject's blood."))
	if (M.getCloneLoss())
		scanned_data.Add("<span class='warning'>Subject appears to have been imperfectly cloned.</span>")
	for(var/datum/disease/D in M.viruses)
		if(!D.hidden[SCANNER])
			scanned_data.Add(text("<span class='warning'><b>Warning: [D.form] Detected</b>\nName: [D.name].\nType: [D.spread].\nStage: [D.stage]/[D.max_stages].\nPossible Cure: [D.cure]</span>"))
//	if (M.reagents && M.reagents.get_reagent_amount("inaprovaline"))
//		user.show_message("\blue Bloodstream Analysis located [M.reagents:get_reagent_amount("inaprovaline")] units of rejuvenation chemicals.")
	if (M.has_brain_worms())
		scanned_data.Add("<span class='warning'>Subject suffering from aberrant brain activity. Recommend further scanning.</span>")
	else if (M.getBrainLoss() >= 100 || !M.has_brain())
		scanned_data.Add("<span class='warning'>Subject is brain dead.</span>")
	else if (M.getBrainLoss() >= 60)
		scanned_data.Add("<span class='warning'>Severe brain damage detected. Subject likely to have mental retardation.</span>")
	else if (M.getBrainLoss() >= 10)
		scanned_data.Add("<span class='warning'>Significant brain damage detected. Subject may have had a concussion</span>")
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		for(var/name in H.organs_by_name)
			var/obj/item/organ/external/e = H.organs_by_name[name]
			if(!e)
				continue
			var/limb = e.name
			if(e.status & ORGAN_BROKEN && user)
				if(((e.name == "l_arm") || (e.name == "r_arm") || (e.name == "l_leg") || (e.name == "r_leg")) && (!(e.status & ORGAN_SPLINTED)))
					user << "<span class='warning'>Unsecured fracture in subject [limb]. Splinting recommended for transport.</span>"
			if(e.has_infected_wound() && user)
				user << "<span class='warning'>Infected wound detected in subject [limb]. Disinfection recommended.</span>"

		for(var/name in H.organs_by_name)
			var/obj/item/organ/external/e = H.organs_by_name[name]
			if(e && e.status & ORGAN_BROKEN)
				scanned_data.Add(text("<span class='warning'>Bone fractures detected. Advanced scanner required for location.</span>"))
				break
		for(var/obj/item/organ/external/e in H.organs)
			if(!e)
				continue
			for(var/datum/wound/W in e.wounds) if(W.internal)
				scanned_data.Add(text("<span class='warning'>Internal bleeding detected. Advanced scanner required for location.</span>"))
				break
		if(M:vessel)
			var/blood_volume = round(M:vessel.get_reagent_amount("blood"))
			var/blood_percent =  blood_volume / 560
			var/blood_type = M.dna.b_type
			blood_percent *= 100
			if(sent_data == "Blood Level")
				send_data(list(blood_percent))
			if(blood_volume <= 500 && blood_volume > 336)
				scanned_data.Add("<span class='warning'><b>Warning: Blood Level LOW: [blood_percent]% [blood_volume]cl.</span></b><span class='notice'> Type: [blood_type]</span>")
			else if(blood_volume <= 336)
				scanned_data.Add("<span class='warning'><b>Warning: Blood Level CRITICAL: [blood_percent]% [blood_volume]cl.</b></span><span class='notice'> Type: [blood_type]</span><")
			else
				scanned_data.Add("<span class='notice'>Blood Level Normal: [blood_percent]% [blood_volume]cl. Type: [blood_type]</span>")
		scanned_data.Add("<span class='notice'>Subject's pulse: <font color='[H.pulse == PULSE_THREADY || H.pulse == PULSE_NONE ? "red" : "blue"]'>[H.get_pulse(GETPULSE_TOOL)] bpm.</font></span>")
	if(user)
		src.add_fingerprint(user)
	if(user)
		for(var/i=1,i<=scanned_data.len,i++)
			user.show_message(scanned_data[i])
	health_data.Cut()
	health_data.Add(scanned_data)
	return

/obj/item/device/assembly/scanner/healthanalyzer/verb/toggle_mode()
	set name = "Switch Verbosity"
	set category = "Object"

	mode = !mode
	switch (mode)
		if("Non-specific damage")
			usr << "The scanner now shows specific limb damage."
			mode = "Specific Limb Damage"
		if("Specific Limb Damage")
			usr << "The scanner no longer shows limb damage."
			mode = "Non-specific damage"

/obj/item/device/assembly/scanner/healthanalyzer/Topic(href, href_list)
	if(href_list["option"])
		switch(href_list["option"])
			if("Verbosity")
				toggle_mode()
			if("Scanning")
				scanning = !scanning
			if("Sent Data")
				var/index = sendable_data.Find(sent_data)
				if(index)
					var/new_scan = "Overall Health Status"
					if(index == sendable_data.len)
						new_scan = sendable_data[1]
					else
						new_scan = sendable_data[(index+1)]
					usr << "<span class='notice'>You set \the	[src]'s sent data type to \"[new_scan]\"!</span>"
					sent_data = new_scan
	..()