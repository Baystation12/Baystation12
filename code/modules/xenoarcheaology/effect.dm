/datum/artifact_effect
	var/name = "unknown"
	var/effect = EFFECT_TOUCH
	var/effectrange = 4
	var/atom/holder
	var/activated = FALSE
	var/chargelevel = 0
	var/chargelevelmax = 10
	var/artifact_id = ""
	var/effect_type = 0
	var/toggled = FALSE
	var/on_time //time artifact should stay on for when toggled

	var/datum/artifact_trigger/trigger

/datum/artifact_effect/New(var/atom/location)
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
	addtimer(CALLBACK(src, .proc/DoActivation, reveal_toggle), 0)

/datum/artifact_effect/proc/DoActivation(reveal_toggle = 1)
	if (toggled && activated)
		return

	if(activated)
		activated = FALSE
	else
		addtimer(CALLBACK(src, /datum/artifact_effect/proc/toggle_off), on_time)
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
		toplevelholder.visible_message("<span class='warning'>[icon2html(toplevelholder, viewers(get_turf(toplevelholder)))] [toplevelholder] [display_msg]</span>")


/datum/artifact_effect/proc/DoEffectTouch(var/mob/user)
/datum/artifact_effect/proc/DoEffectAura(var/atom/holder)
/datum/artifact_effect/proc/DoEffectPulse(var/atom/holder)
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

//returns 0..1, with 1 being no protection and 0 being fully protected
/proc/GetAnomalySusceptibility(var/mob/living/carbon/human/H)
	if(!istype(H))
		return 1

	var/protected = 0

	//anomaly suits give best protection, but excavation suits are almost as good
	if(istype(H.back,/obj/item/rig/hazmat) || istype(H.back, /obj/item/rig/hazard))
		var/obj/item/rig/rig = H.back
		if(rig.suit_is_deployed() && !rig.offline)
			protected += 1

	if(istype(H.wear_suit,/obj/item/clothing/suit/bio_suit/anomaly))
		protected += 0.7
	else if(istype(H.wear_suit,/obj/item/clothing/suit/space/void/excavation))
		protected += 0.6

	if(istype(H.head,/obj/item/clothing/head/bio_hood/anomaly))
		protected += 0.3
	else if(istype(H.head,/obj/item/clothing/head/helmet/space/void/excavation))
		protected += 0.2

	//latex gloves and science goggles also give a bit of bonus protection
	if(istype(H.gloves,/obj/item/clothing/gloves/latex))
		protected += 0.1

	if(istype(H.glasses,/obj/item/clothing/glasses/science))
		protected += 0.1

	return 1 - protected

//Destruction/Damaged procs

/**
 * When an artifact is destroyed, this will be run before it is
 */
/datum/artifact_effect/proc/destroyed_effect()
	return

/**
 * Called by the artifact the effect is attached too whenever it takes damage
 */
/datum/artifact_effect/proc/holder_damaged()
	return