/datum/artifact_effect
	var/name = "unknown"
	var/effect = EFFECT_TOUCH
	var/effectrange = 4
	var/atom/holder
	var/activated = FALSE
	var/chargelevel = 0
	var/chargelevelmax = 10
	var/artifact_id = ""
	var/effect_type = EFFECT_UNKNOWN
	var/toggled = FALSE
	var/on_time //time artifact should stay on for when toggled

	var/datum/artifact_trigger/trigger

/datum/artifact_effect/New(atom/location)
	..()
	holder = location
	effect = rand(0, MAX_EFFECT)
	var/triggertype = pick(subtypesof(/datum/artifact_trigger))
	if (effect == EFFECT_TOUCH && !istype(triggertype, /datum/artifact_trigger/touch)) // touch effect and touch trigger only work when paired
		triggertype = pick(typesof(/datum/artifact_trigger/touch))
	trigger = new triggertype

	on_time = rand(5, 20) SECONDS

	//this will be replaced by the excavation code later, but it's here just in case
	artifact_id = "[pick("kappa","sigma","antaeres","beta","omicron","iota","epsilon","omega","gamma","delta","tau","alpha")]-[rand(100,999)]"

	//random charge time and distance
	switch(pick(100;1, 50;2, 25;3))
		if(1)
			//short range, short charge time
			chargelevelmax = rand(3, 20)
			effectrange = rand(1, 3)
		if(2)
			//medium range, medium charge time
			chargelevelmax = rand(15, 40)
			effectrange = rand(5, 15)
		if(3)
			//large range, long charge time
			chargelevelmax = rand(20, 120)
			effectrange = rand(20, 200)

/datum/artifact_effect/Destroy()
	QDEL_NULL(trigger)
	. = ..()

/datum/artifact_effect/proc/ToggleActivate(reveal_toggle = 1)
	addtimer(new Callback(src, .proc/DoActivation, reveal_toggle), 0)

/datum/artifact_effect/proc/DoActivation(reveal_toggle = 1)
	if (toggled && activated)
		return

	if(activated)
		activated = FALSE
	else
		addtimer(new Callback(src, /datum/artifact_effect/proc/toggle_off), on_time)
		activated = TRUE
		toggled = TRUE
	if(reveal_toggle && holder)
		if(istype(holder, /obj/machinery/artifact))
			var/obj/machinery/artifact/A = holder
			A.icon_state = "ano[A.icon_num][activated]"

		var/display_msg
		if(activated)
			display_msg = pick("momentarily glows brightly!","distorts slightly for a moment!","flickers slightly!","vibrates!","shimmers slightly for a moment!")
		else
			display_msg = pick("grows dull!","fades in intensity!","suddenly becomes very still!","suddenly becomes very quiet!")

		var/atom/toplevelholder = holder
		while(!isnull(toplevelholder.loc) && !istype(toplevelholder.loc, /turf))
			toplevelholder = toplevelholder.loc
		toplevelholder.visible_message(SPAN_WARNING("[icon2html(toplevelholder, viewers(get_turf(toplevelholder)))] [toplevelholder] [display_msg]"))


/datum/artifact_effect/proc/DoEffectTouch(mob/user)
/datum/artifact_effect/proc/DoEffectAura(atom/holder)
/datum/artifact_effect/proc/DoEffectPulse(atom/holder)
/datum/artifact_effect/proc/UpdateMove()

/datum/artifact_effect/proc/process()
	if(chargelevel < chargelevelmax)
		chargelevel++

	if(activated)
		if(effect == EFFECT_AURA)
			DoEffectAura()
		else if(effect == EFFECT_PULSE && chargelevel >= chargelevelmax)
			chargelevel = 0
			DoEffectPulse()


/datum/artifact_effect/proc/getDescription()
	. = "<b>"
	switch(effect_type)
		if(EFFECT_ENERGY)
			. += "Concentrated energy emissions"
		if(EFFECT_PSIONIC)
			. += "Intermittent psionic wavefront"
		if(EFFECT_ELECTRO)
			. += "Electromagnetic energy"
		if(EFFECT_PARTICLE)
			. += "High frequency particles"
		if(EFFECT_ORGANIC)
			. += "Organically reactive exotic particles"
		if(EFFECT_BLUESPACE)
			. += "Interdimensional/bluespace? phasing"
		if(EFFECT_SYNTH)
			. += "Atomic synthesis"
		else
			. += "Low level energy emissions"

	. += "</b> have been detected <b>"

	switch(effect)
		if(EFFECT_TOUCH)
			. += "interspersed throughout substructure and shell."
		if(EFFECT_AURA)
			. += "emitting in an ambient energy field."
		if(EFFECT_PULSE)
			. += "emitting in periodic bursts."
		else
			. += "emitting in an unknown way."

	. += "</b>"

	. += " Activation index involves [trigger]."

/datum/artifact_effect/proc/toggle_off()
	toggled = FALSE
	ToggleActivate(TRUE)


/// A value denoting how much this item should protect against the effects of anomalies when worn.
/obj/item/var/anomaly_protection = 0

/obj/item/rig/hazmat/anomaly_protection = 1

/obj/item/clothing/suit/bio_suit/anomaly/anomaly_protection = 0.7

/obj/item/clothing/suit/space/void/excavation/anomaly_protection = 0.6

/obj/item/clothing/head/bio_hood/anomaly/anomaly_protection = 0.3

/obj/item/clothing/head/helmet/space/void/excavation/anomaly_protection = 0.2

/obj/item/clothing/gloves/latex/anomaly_protection = 0.1

/obj/item/clothing/glasses/science/anomaly_protection = 0.1


/// returns 0..1, with 1 being no protection and 0 being fully protected
/proc/GetAnomalySusceptibility(mob/living/carbon/human/human)
	if (!istype(human))
		return 1
	var/susceptibility = 1
	var/list/items = list(human.w_uniform, human.wear_suit, human.head, human.gloves, human.shoes, human.glasses)
	if (istype(human.back, /obj/item/rig))
		var/obj/item/rig/rig = human.back
		if (!rig.offline && rig.suit_is_deployed())
			items += rig
	for (var/obj/item/item in items)
		susceptibility -= item.anomaly_protection
	return clamp(susceptibility, 0, 1)


/// When an artifact is destroyed, this will be run first.
/datum/artifact_effect/proc/destroyed_effect()
	return


/// Called by the artifact the effect is attached to whenever it takes damage
/datum/artifact_effect/proc/holder_damaged()
	return
