/obj/item/organ/internal/heart
	name = "heart"
	icon_state = "heart-on"
	organ_tag = "heart"
	parent_organ = BP_CHEST
	dead_icon = "heart-off"
	var/pulse = PULSE_NORM
	var/heartbeat = 0
	var/beat_sound = 'sound/effects/singlebeat.ogg'
	var/tmp/next_blood_squirt = 0
	damage_reduction = 0.7
	relative_size = 5
	max_damage = 45
	var/open
	var/list/external_pump

/obj/item/organ/internal/heart/open
	open = 1

/obj/item/organ/internal/heart/die()
	if(dead_icon)
		icon_state = dead_icon
	..()

/obj/item/organ/internal/heart/robotize()
	. = ..()
	icon_state = "heart-prosthetic"

/obj/item/organ/internal/heart/Process()
	if(owner)
		handle_pulse()
		if(pulse)
			handle_heartbeat()
			if(pulse == PULSE_2FAST && prob(1))
				take_internal_damage(0.5)
			if(pulse == PULSE_THREADY && prob(5))
				take_internal_damage(0.5)
		handle_blood()
	..()

/obj/item/organ/internal/heart/proc/handle_pulse()
	if(BP_IS_ROBOTIC(src))
		pulse = PULSE_NONE	//that's it, you're dead (or your metal heart is), nothing can influence your pulse
		return

	// pulse mod starts out as just the chemical effect amount
	var/pulse_mod = owner.chem_effects[CE_PULSE]
	var/is_stable = owner.chem_effects[CE_STABLE]

	// If you have enough heart chemicals to be over 2, you're likely to take extra damage.
	if(pulse_mod > 2 && !is_stable)
		var/damage_chance = (pulse_mod - 2) ** 2
		if(prob(damage_chance))
			take_internal_damage(0.5)

	// Now pulse mod is impacted by shock stage and other things too
	if(owner.shock_stage > 30)
		pulse_mod++
	if(owner.shock_stage > 80)
		pulse_mod++

	var/oxy = owner.get_blood_oxygenation()
	if(oxy < BLOOD_VOLUME_OKAY) //brain wants us to get MOAR OXY
		pulse_mod++
	if(oxy < BLOOD_VOLUME_BAD) //MOAR
		pulse_mod++

	if(owner.status_flags & FAKEDEATH || owner.chem_effects[CE_NOPULSE])
		pulse = PULSE_NONE
		return

	//If heart is stopped, it isn't going to restart itself randomly.
	if(pulse == PULSE_NONE)
		return
	else //and if it's beating, let's see if it should
		var/should_stop = prob(80) && owner.get_blood_circulation() < BLOOD_VOLUME_SURVIVE //cardiovascular shock, not enough liquid to pump
		should_stop = should_stop || prob(max(0, owner.getBrainLoss() - owner.maxHealth * 0.75)) //brain failing to work heart properly
		should_stop = should_stop || (prob(5) && pulse == PULSE_THREADY) //erratic heart patterns, usually caused by oxyloss
		if(should_stop) // The heart has stopped due to going into traumatic or cardiovascular shock.
			to_chat(owner, "<span class='danger'>Your heart has stopped!</span>")
			pulse = PULSE_NONE
			return

	// Pulse normally shouldn't go above PULSE_2FAST, unless extreme amounts of bad stuff in blood
	if (pulse_mod < 6)
		pulse = Clamp(PULSE_NORM + pulse_mod, PULSE_SLOW, PULSE_2FAST)
	else
		pulse = Clamp(PULSE_NORM + pulse_mod, PULSE_SLOW, PULSE_THREADY)

	// If fibrillation, then it can be PULSE_THREADY
	var/fibrillation = oxy <= BLOOD_VOLUME_SURVIVE || (prob(30) && owner.shock_stage > 120)
	if(pulse && fibrillation)	//I SAID MOAR OXYGEN
		pulse = PULSE_THREADY

	// Stablising chemicals pull the heartbeat towards the center
	if(pulse != PULSE_NORM && is_stable)
		if(pulse > PULSE_NORM)
			pulse--
		else
			pulse++

/obj/item/organ/internal/heart/proc/handle_heartbeat()
	if(pulse >= PULSE_2FAST || owner.shock_stage >= 10 || is_below_sound_pressure(get_turf(owner)))
		//PULSE_THREADY - maximum value for pulse, currently it 5.
		//High pulse value corresponds to a fast rate of heartbeat.
		//Divided by 2, otherwise it is too slow.
		var/rate = (PULSE_THREADY - pulse)/2
		if(owner.chem_effects[CE_PULSE] > 2)
			heartbeat++

		if(heartbeat >= rate)
			heartbeat = 0
			sound_to(owner, sound(beat_sound,0,0,0,50))
		else
			heartbeat++

/obj/item/organ/internal/heart/proc/handle_blood()

	if(!owner)
		return

	//Dead or cryosleep people do not pump the blood.
	if(!owner || owner.InStasis() || owner.stat == DEAD || owner.bodytemperature < 170)
		return

	if(pulse != PULSE_NONE || BP_IS_ROBOTIC(src))
		//Bleeding out
		var/blood_max = 0
		var/list/do_spray = list()
		for(var/obj/item/organ/external/temp in owner.organs)

			if(BP_IS_ROBOTIC(temp))
				continue

			var/open_wound
			if(temp.status & ORGAN_BLEEDING)

				for(var/datum/wound/W in temp.wounds)

					if(!open_wound && (W.damage_type == CUT || W.damage_type == PIERCE) && W.damage && !W.is_treated())
						open_wound = TRUE

					if(W.bleeding())
						if(temp.applied_pressure)
							if(ishuman(temp.applied_pressure))
								var/mob/living/carbon/human/H = temp.applied_pressure
								H.bloody_hands(src, 0)
							//somehow you can apply pressure to every wound on the organ at the same time
							//you're basically forced to do nothing at all, so let's make it pretty effective
							var/min_eff_damage = max(0, W.damage - 10) / 6 //still want a little bit to drip out, for effect
							blood_max += max(min_eff_damage, W.damage - 30) / 40
						else
							blood_max += W.damage / 40

			if(temp.status & ORGAN_ARTERY_CUT)
				var/bleed_amount = Floor((owner.vessel.total_volume / (temp.applied_pressure || !open_wound ? 400 : 250))*temp.arterial_bleed_severity)
				if(bleed_amount)
					if(open_wound)
						blood_max += bleed_amount
						do_spray += "[temp.name]"
					else
						owner.vessel.remove_reagent(/datum/reagent/blood, bleed_amount)

		switch(pulse)
			if(PULSE_SLOW)
				blood_max *= 0.8
			if(PULSE_FAST)
				blood_max *= 1.25
			if(PULSE_2FAST, PULSE_THREADY)
				blood_max *= 1.5

		if(CE_STABLE in owner.chem_effects) // inaprovaline
			blood_max *= 0.8

		if(world.time >= next_blood_squirt && istype(owner.loc, /turf) && do_spray.len)
			var/spray_organ = pick(do_spray)
			owner.visible_message(
				SPAN_DANGER("Blood sprays out from \the [owner]'s [spray_organ]!"),
				FONT_HUGE(SPAN_DANGER("Blood sprays out from your [spray_organ]!"))
			)
			owner.Stun(1)
			owner.eye_blurry = 2

			playsound(owner, 'sound/effects/gore/blood_splat.ogg', 100, 0, -2) // from infinity

			//AB occurs every heartbeat, this only throttles the visible effect
			next_blood_squirt = world.time + 80
			var/turf/sprayloc = get_turf(owner)
			blood_max -= owner.drip(ceil(blood_max/3), sprayloc)
			if(blood_max > 0)
				blood_max -= owner.blood_squirt(blood_max, sprayloc)
				if(blood_max > 0)
					owner.drip(blood_max, get_turf(owner))
		else
			owner.drip(blood_max)

/obj/item/organ/internal/heart/proc/is_working()
	if(!is_usable())
		return FALSE

	return pulse > PULSE_NONE || BP_IS_ROBOTIC(src) || (owner.status_flags & FAKEDEATH)

/obj/item/organ/internal/heart/listen()
	if(BP_IS_ROBOTIC(src) && is_working())
		if(is_bruised())
			return "sputtering pump"
		else
			return "steady whirr of the pump"

	if(!pulse || (owner.status_flags & FAKEDEATH))
		return "no pulse"

	var/pulsesound = "normal"
	if(is_bruised())
		pulsesound = "irregular"

	switch(pulse)
		if(PULSE_SLOW)
			pulsesound = "slow"
		if(PULSE_FAST)
			pulsesound = "fast"
		if(PULSE_2FAST)
			pulsesound = "very fast"
		if(PULSE_THREADY)
			pulsesound = "extremely fast and faint"

	. = "[pulsesound] pulse"

/obj/item/organ/internal/heart/get_mechanical_assisted_descriptor()
	return "pacemaker-assisted [name]"
