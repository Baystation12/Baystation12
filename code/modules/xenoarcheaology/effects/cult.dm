//Makes you into a cultist under the very right conditions
/datum/artifact_effect/cult
	name = "cultic resonance"
	effect_type = EFFECT_PSIONIC

	on_time = 1 SECONDS //It stays on for one second because it doesn't make sense to pulse

	var/reality_weakness = 0 //How strong will it be when converting


/datum/artifact_effect/cult/New()
	..()
	if(effect_type == EFFECT_PULSE)
		effect = rand() //Pulse breaks this
	reality_weakness = rand(10, 50) //Decent amount of power

//Checks the area for how cursed or weakened the fabric of reality is, returns void
/datum/artifact_effect/cult/proc/reality_weakness()
	//First, it checks to weaken reality
	if(reality_weakness <= 100) //It cannot surpass 100 because reality_weakness is used for prob()
		//multiplier increases the weakness at the end
		var/multiplier = 1

		//Check for cultic turfs
		var/list/nearby_turfs = trange(effectrange, get_turf(holder))
		for(var/turf/simulated/T in nearby_turfs)
			if(istype(T, /turf/simulated/wall/cult))
				reality_weakness += 2
			if(istype(T, /turf/simulated/floor))
				var/turf/simulated/floor/F = T
				if(F.flooring == /decl/flooring/reinforced/cult)
					reality_weakness += 2

		//Check for people
		for(var/mob/living/carbon/human/H in range(effectrange, get_turf(holder)))
			//Dead people weaken reality
			if(H.stat == DEAD)
				multiplier += 0.0625

			else if(iscultist(H))
				to_chat(H, SPAN_OCCULT("You feel temporarily weakened as the Geometer draws your strength to thin the fabric of reality."))
				H.remove_blood_simple(10) //Borrow some blood
				reality_weakness += 2 //Cultists weaken reality

		reality_weakness = reality_weakness * multiplier //This is used for probability, so maximum is 100
	//It always removes 0.1 of its value just so it discharges over time.
	reality_weakness -= reality_weakness * 0.1


/datum/artifact_effect/cult/proc/attempt_convert(mob/living/carbon/human/victim)
	//Everybody get's the Nar-Sie jumpscare	for kicks
	victim.playsound_local(victim.loc, 'sound/hallucinations/wail.ogg', 70)

	if(!iscultist(victim) && GLOB.cult.can_become_antag(victim.mind, TRUE) && prob(reality_weakness)) //Check if they aren't already a cultist, can becomea  cultist, and see how weak reality is
		to_chat(victim, SPAN_OCCULT("Reality feels like standing on bad suede. \The [holder] [pick("murmurs", "whispers", "silently screams")] to you in a language beyond your understanding..."))

		var/initiation = input(victim, "You've seen the unspeakable truth of Nar-Sie. Do you choose to embrace it?", "Cultic Resonance", "No!") in list("No!", "Of course!")

		if(initiation == "Of course!")
			GLOB.cult.add_antagonist(victim.mind, ignore_role = TRUE, do_not_equip = TRUE)

		else
			if(prob(reality_weakness) && GLOB.thralls.can_become_antag(victim.mind, TRUE)) //They may be thralled if reality weakness wins
				to_chat(victim, SPAN_OCCULT("Fool! If you won't serve humbly and enlightened, then you will serve weak and depraved!"))
				GLOB.thralls.add_antagonist(victim.mind, ignore_role = TRUE, do_not_equip = TRUE, fake_controller = "Nar-Sie")
			else
				to_chat(victim, SPAN_OCCULT("Your brain resonates like a bad hangover, the truth still ringing inside it..."))


/datum/artifact_effect/cult/DoEffectTouch(mob/toucher)
	reality_weakness()
	if(istype(toucher, /mob/living/carbon/human)) //gas mixtures with minds are not real
		attempt_convert(toucher)

/datum/artifact_effect/cult/DoEffectPulse()
	reality_weakness()
	for(var/mob/living/carbon/human/H in range(effectrange, get_turf(holder)))
		attempt_convert(H)

/datum/artifact_effect/cult/DoEffectAura()
	reality_weakness()
	for(var/mob/living/carbon/human/H in range(effectrange, get_turf(holder)))
		attempt_convert(H)