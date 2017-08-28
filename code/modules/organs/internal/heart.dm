//Blood levels. These are percentages based on the species blood_volume far.
var/const/BLOOD_VOLUME_SAFE    = 85
var/const/BLOOD_VOLUME_OKAY    = 75
var/const/BLOOD_VOLUME_BAD     = 60
var/const/BLOOD_VOLUME_SURVIVE = 40

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
	relative_size = 15
	max_damage = 45
	var/open

/obj/item/organ/internal/heart/die()
	if(dead_icon)
		icon_state = dead_icon
	..()

/obj/item/organ/internal/heart/robotize()
	. = ..()
	icon_state = "heart-prosthetic"

/obj/item/organ/internal/heart/process()
	if(owner)
		handle_pulse()
		if(pulse)
			handle_heartbeat()
		handle_blood()
	..()

/obj/item/organ/internal/heart/proc/handle_pulse()
	if(owner.stat == DEAD || robotic >= ORGAN_ROBOT)
		pulse = PULSE_NONE	//that's it, you're dead (or your metal heart is), nothing can influence your pulse
		return
	if(owner.shock_stage >= 120 || owner.getOxyLoss() >= 100 || owner.get_effective_blood_volume() < BLOOD_VOLUME_SURVIVE || prob(max(0, owner.getBrainLoss() - owner.maxHealth * 0.75))) // The heart has stopped due to going into traumatic or cardiovascular shock.
		if(pulse != PULSE_NONE)
			to_chat(owner, "<span class='danger'>Your heart has stopped!</span>")
			pulse = PULSE_NONE
	else
		pulse = PULSE_NORM
		var/pulse_mod = owner.chem_effects[CE_PULSE]
		if(owner.shock_stage > 30)
			pulse_mod++
		if(owner.get_effective_blood_volume() <= BLOOD_VOLUME_BAD)	//how much blood do we have
			pulse  = PULSE_THREADY	//not enough :(

		else if(owner.status_flags & FAKEDEATH || owner.chem_effects[CE_NOPULSE])
			pulse = PULSE_NONE		//pretend that we're dead. unlike actual death, can be inflienced by meds
			pulse = Clamp(pulse + pulse_mod, PULSE_NONE, PULSE_2FAST)
		else
			pulse = Clamp(pulse + pulse_mod, PULSE_SLOW, PULSE_2FAST)

/obj/item/organ/internal/heart/proc/handle_heartbeat()
	if(pulse >= PULSE_2FAST || owner.shock_stage >= 10 || is_below_sound_pressure(get_turf(owner)))
		//PULSE_THREADY - maximum value for pulse, currently it 5.
		//High pulse value corresponds to a fast rate of heartbeat.
		//Divided by 2, otherwise it is too slow.
		var/rate = (PULSE_THREADY - pulse)/2

		if(heartbeat >= rate)
			heartbeat = 0
			sound_to(owner, sound(beat_sound,0,0,0,50))
		else
			heartbeat++

/obj/item/organ/internal/heart/proc/handle_blood()

	if(!owner)
		return

	//Dead or cryosleep people do not pump the blood.
	if(!owner || owner.in_stasis || owner.stat == DEAD || owner.bodytemperature < 170)
		return

	if(pulse != PULSE_NONE || robotic >= ORGAN_ROBOT)
		//Bleeding out
		var/blood_max = 0
		var/list/do_spray = list()
		for(var/obj/item/organ/external/temp in owner.organs)

			if(temp.robotic >= ORGAN_ROBOT)
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
				var/bleed_amount = Floor((owner.vessel.total_volume / (temp.applied_pressure ? 400 : 250))*temp.arterial_bleed_severity)
				if(bleed_amount)
					if(open_wound)
						blood_max += bleed_amount
						do_spray += "the [temp.artery_name] in \the [owner]'s [temp.name]"
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
			owner.visible_message("<span class='danger'>Blood squirts from [pick(do_spray)]!</span>")
			// It becomes very spammy otherwise. Arterial bleeding will still happen outside of this block, just not the squirt effect.
			next_blood_squirt = world.time + 100
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

	return pulse > PULSE_NONE || robotic == ORGAN_ROBOT || (owner.status_flags & FAKEDEATH)
