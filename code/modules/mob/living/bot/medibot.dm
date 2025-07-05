#define TREATMENT_BUILTIN 1
#define TREATMENT_BEAKER 2
#define TREATMENT_EMAG 3

/mob/living/bot/medbot
	name = "Medibot"
	desc = "A little medical robot. He looks somewhat underwhelmed."
	icon = 'icons/mob/bot/medibot.dmi'
	icon_state = "medibot0"
	req_access = list(list(access_medical, access_robotics))
	botcard_access = list(access_medical, access_morgue, access_surgery, access_chemistry, access_virology)
	/// Set to "tox", "ointment" or "o2" for the other two firstaid kits.
	var/skin = null

	//AI vars
	var/last_newpatient_speak = 0
	var/vocal = 1

	//Healing vars
	var/obj/item/reagent_containers/glass/reagent_glass = null //Can be set to draw from this for reagents.
	/// How much reagent do we inject at a time?
	var/injection_amount = 15
	/// Start healing when the patient's pulse is at least this much.
	var/pulse_threshold = PULSE_2FAST
	/// Use reagents in beaker instead of default treatment agents.
	var/use_beaker = 0
	/// Base reagent for treatment.
	var/treatment = /datum/reagent/inaprovaline
	/// Emagged reagent for treatment
	var/treatment_emag = /datum/reagent/toxin
	/// When attempting to treat a patient, should it notify everyone wearing medhuds?
	var/declare_treatment = 0
	/// map<weakref<mob/living/carbon/human>, world.time>
	var/list/treatment_map = list()

/mob/living/bot/medbot/handleIdle()
	if (vocal && prob(1))
		var/message = pick("Radar, put a mask on!", "There's always a catch, and it's the best there is.", "I knew it, I should've been a plastic surgeon.", "What kind of infirmary is this? Everyone's dropping like dead flies.", "Delicious!")
		say(message)

/mob/living/bot/medbot/handleAdjacentTarget()
	UnarmedAttack(target)

/mob/living/bot/medbot/lookForTargets()
	for (var/mob/living/carbon/human/H in view(7, src)) // Time to find a patient!
		var/target_found = FALSE
		for (var/weakref/human_ref as anything in treatment_map)
			var/mob/living/carbon/human/resolved = human_ref.resolve()
			if (!resolved)
				treatment_map -= human_ref
				continue
			if (resolved == H)
				target_found = TRUE
				var/treat_next = treatment_map[human_ref]
				if (treat_next <= world.time)
					treatment_map -= human_ref
					processTarget(H)
		if (!target_found)
			processTarget(H) // not already tracking them, so do so

/mob/living/bot/medbot/proc/processTarget(mob/living/carbon/human/human)
	if (!confirmTarget(human))
		return
	target = human
	if (last_newpatient_speak + 300 >= world.time)
		return
	var/message = pick("Hey, [human.name]! Hold on, I'm coming.", "Wait [human.name]! I want to help!", "[human.name], you appear to be injured!")
	say(message)
	custom_emote(1, "points at [human.name].")
	last_newpatient_speak = world.time

/mob/living/bot/medbot/UnarmedAttack(mob/living/carbon/human/human, proximity)
	if (!..())
		return

	if (!on)
		return

	if (!istype(human))
		return

	if (busy)
		return

	if (human.stat == DEAD || HAS_FLAGS(human.status_flags, FAKEDEATH))
		var/death_message = pick("No! NO!", "Live, damnit! LIVE!", "I... I've never lost a patient before. Not today, I mean.")
		say(death_message)
		target = null
		return

	var/treatment_tyoe = confirmTarget(human)
	if (!treatment_tyoe)
		var/message = pick("All patched up!", "An apple a day keeps me away.", "Feel better soon!")
		say(message)
		target = null
		return

	icon_state = "medibots"
	visible_message(SPAN_WARNING("[src] is trying to inject [human]!"))
	if (declare_treatment)
		var/area/location = get_area(src)
		broadcast_medical_hud_message("[src] is treating <b>[human]</b> in <b>[location]</b>", src)
	busy = 1
	update_icons()
	if (do_after(src, 3 SECONDS, human, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
		switch (treatment_tyoe)
			if (TREATMENT_BUILTIN)
				human.reagents.add_reagent(treatment, injection_amount)
			if (TREATMENT_EMAG)
				human.reagents.add_reagent(treatment_emag, injection_amount)
			if (TREATMENT_BEAKER)
				reagent_glass.reagents.trans_to_mob(human, injection_amount, CHEM_BLOOD)
		visible_message(SPAN_WARNING("[src] injects [human] with the syringe!"))
	busy = 0
	treatment_map[weakref(human)] = world.time + 3 MINUTES
	target = null
	update_icons()

/mob/living/bot/medbot/update_icons()
	ClearOverlays()
	if (skin)
		AddOverlays(image('icons/mob/bot/medibot_skins.dmi', "[skin]"))
	if (busy)
		icon_state = "medibots"
	else
		icon_state = "medibot[on]"


/mob/living/bot/medbot/get_construction_info()
	return list(
		"Add a robotic <b>Left Arm</b> or <b>Right Arm</b> to a <b>First-Aid Kit</b>.",
		"Add a <b>Health Analyzer</b>.",
		"Add a <b>Proximity Sensor</b> to complete the medbot."
	)


/mob/living/bot/medbot/get_interactions_info()
	. = ..()
	.["Beaker"] = "<p>Installs the beaker into \the [initial(name)]. If installed, it will use the contents of the beaker for injections instead of inaprovaline. Only one beaker can be installed at a time. The access panel must be unlocked.</p>"


/mob/living/bot/medbot/get_antag_interactions_info()
	. = ..()
	.[CODEX_INTERACTION_EMAG] += "<p>Causes \the [initial(name)] to synthesize and inject toxins instead of inaprovaline. It will also try to inject any mob in sight except the one who emagged it, regardless of injury state.</p>"


/mob/living/bot/medbot/use_tool(obj/item/tool, mob/user, list/click_params)
	// Beaker - Inserts a beaker
	if (istype(tool, /obj/item/reagent_containers/glass))
		if (locked)
			USE_FEEDBACK_FAILURE("\The [src]'s access panel must be open before you can insert a beaker.")
			return TRUE
		if (reagent_glass)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [reagent_glass] installed.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		reagent_glass = tool
		user.visible_message(
			SPAN_NOTICE("\The [user] installs \a [tool] into \the [src]."),
			SPAN_NOTICE("You install \the [tool] into \the [src].")
		)
		return TRUE

	return ..()


/mob/living/bot/medbot/GetInteractTitle()
	. = "<head><title>Medibot v1.0 controls</title></head>"
	. += "<b>Automatic Medical Unit v1.0</b>"

/mob/living/bot/medbot/GetInteractStatus()
	. = ..()
	. += "<br>Beaker: "
	if (reagent_glass)
		. += "<A href='byond://?src=\ref[src];command=eject'>Loaded \[[reagent_glass.reagents.total_volume]/[reagent_glass.reagents.maximum_volume]\]</a>"
	else
		. += "None loaded"

/mob/living/bot/medbot/GetInteractPanel()
	var/pulse_text
	switch (pulse_threshold)
		if (PULSE_FAST) pulse_text = "Fast"
		if (PULSE_2FAST) pulse_text = "Very Fast"
		if (PULSE_THREADY) pulse_text = "Thready"
		if (PULSE_NONE) pulse_text = "None"

	. = "Pulse threshold: "
	. += "<a href='byond://?src=\ref[src];command=adj_threshold;amount=[PULSE_FAST]'>Fast</a> "
	. += "<a href='byond://?src=\ref[src];command=adj_threshold;amount=[PULSE_2FAST]'>Very Fast</a> "
	. += "<a href='byond://?src=\ref[src];command=adj_threshold;amount=[PULSE_THREADY]'>Thready</a> "
	. += "<a href='byond://?src=\ref[src];command=adj_threshold;amount=[PULSE_NONE]'>None</a> "
	. += "[pulse_text] "

	. += "<br>Injection level: "
	. += "<a href='byond://?src=\ref[src];command=adj_inject;amount=-5'>-</a> "
	. += "[injection_amount] "
	. += "<a href='byond://?src=\ref[src];command=adj_inject;amount=5'>+</a> "

	. += "<br>Reagent source: <a href='byond://?src=\ref[src];command=use_beaker'>[use_beaker ? "Loaded Beaker (When available)" : "Inaprovaline"]</a>"
	. += "<br>Treatment report is [declare_treatment ? "on" : "off"]. <a href='byond://?src=\ref[src];command=declaretreatment'>Toggle</a>"
	. += "<br>The speaker switch is [vocal ? "on" : "off"]. <a href='byond://?src=\ref[src];command=togglevoice'>Toggle</a>"
	. += "<br>Waiting three minutes before repeated treatments."

/mob/living/bot/medbot/GetInteractMaintenance()
	. = "Injection mode: "
	switch(emagged)
		if (0)
			. += "<a href='byond://?src=\ref[src];command=emag'>Treatment</a>"
		if (1)
			. += "<a href='byond://?src=\ref[src];command=emag'>Random (DANGER)</a>"
		if (2)
			. += "ERROROROROROR-----"

/mob/living/bot/medbot/ProcessCommand(mob/user, command, href_list)
	..()
	if (CanAccessPanel(user))
		switch(command)
			if ("adj_threshold")
				if (!locked || issilicon(user))
					pulse_threshold = text2num(href_list["amount"])
			if ("adj_inject")
				if (!locked || issilicon(user))
					var/adjust_num = text2num(href_list["amount"])
					injection_amount = clamp(injection_amount + adjust_num, 5, 15)
			if ("use_beaker")
				if (!locked || issilicon(user))
					use_beaker = !use_beaker
			if ("eject")
				if (reagent_glass)
					if (!locked)
						reagent_glass.dropInto(src.loc)
						reagent_glass = null
					else
						to_chat(user, SPAN_NOTICE("You cannot eject the beaker because the panel is locked."))
			if ("togglevoice")
				if (!locked || issilicon(user))
					vocal = !vocal
			if ("declaretreatment")
				if (!locked || issilicon(user))
					declare_treatment = !declare_treatment

	if (CanAccessMaintenance(user))
		switch(command)
			if ("emag")
				if (emagged < 2)
					emagged = !emagged

/mob/living/bot/medbot/emag_act(remaining_uses, mob/user)
	. = ..()
	if (!emagged)
		if (user)
			to_chat(user, SPAN_WARNING("You short out [src]'s reagent synthesis circuits."))
			ignore_list |= user
		visible_message(SPAN_WARNING("[src] buzzes oddly!"))
		flick("medibot_spark", src)
		target = null
		busy = 0
		emagged = TRUE
		on = 1
		update_icons()
		. = 1

/mob/living/bot/medbot/explode()
	on = 0
	visible_message(SPAN_DANGER("[src] blows apart!"))
	var/turf/Tsec = get_turf(src)

	new /obj/item/storage/firstaid/empty(Tsec)
	new /obj/item/device/assembly/prox_sensor(Tsec)
	new /obj/item/device/scanner/health(Tsec)
	if (prob(50))
		new /obj/item/robot_parts/l_arm(Tsec)

	if (reagent_glass)
		reagent_glass.forceMove(Tsec)
		reagent_glass = null

	var/datum/effect/spark_spread/s = new /datum/effect/spark_spread
	s.set_up(3, 1, src)
	s.start()
	qdel(src)
	return

/**
 * Returns a falsy value if the target doesn't need to be treatment
 * Else, returns TREATMENT_BEAKER if a beaker treatment is perscribed (configurable on the medibot)
 * Otherwise, returns a TREATMENT_BUILTIN or TREATMENT_EMAG for a custom injection (usually toxin/inaprovaline)
 */
/mob/living/bot/medbot/confirmTarget(mob/living/carbon/human/target)
	if (!..())
		return FALSE
	if (target.stat == DEAD || HAS_FLAGS(target.status_flags, FAKEDEATH)) // He's dead, Jim
		return FALSE

	if (emagged)
		return TREATMENT_EMAG

	var/obj/item/organ/internal/heart/L = target.internal_organs_by_name[BP_HEART]
	if (istype(L) && BP_IS_ROBOTIC(L))
		return FALSE // Don't treat robotic hearts - we can't accurately read their pulse

	var/requires_treatment = FALSE
	var/pulse = target.pulse()
	if (pulse == PULSE_NONE)
		requires_treatment = TRUE
	else if (pulse_threshold != PULSE_NONE && pulse >= pulse_threshold)
		requires_treatment = TRUE

	if (reagent_glass && use_beaker && requires_treatment)
		return TREATMENT_BEAKER
	return requires_treatment ? TREATMENT_BUILTIN : FALSE

/mob/living/bot/medbot/turn_off()
	. = ..()
	treatment_map.Cut()

#undef TREATMENT_BUILTIN
#undef TREATMENT_BEAKER
#undef TREATMENT_EMAG
