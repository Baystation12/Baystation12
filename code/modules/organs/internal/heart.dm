/obj/item/organ/heart
	name = "heart"
	icon_state = "heart-on"
	organ_tag = "heart"
	parent_organ = "chest"
	dead_icon = "heart-off"
	var/pulse = PULSE_NORM
	var/heartbeat = 0
	var/beat_sound = 'sound/effects/singlebeat.ogg'
	var/efficiency = 1

/obj/item/organ/heart/process()
	if(owner)
		handle_pulse()
		if(pulse)	handle_heartbeat()
		handle_blood()
	..()

/obj/item/organ/heart/proc/handle_pulse()
	if(owner.stat == DEAD || status & ORGAN_ROBOT)
		pulse = PULSE_NONE	//that's it, you're dead (or your metal heart is), nothing can influence your pulse
		return
	if(owner.life_tick % 5 == 0)//update pulse every 5 life ticks (~1 tick/sec, depending on server load)
		pulse = PULSE_NORM

		if(round(owner.vessel.get_reagent_amount("blood")) <= BLOOD_VOLUME_BAD)	//how much blood do we have
			pulse  = PULSE_THREADY	//not enough :(

		if(owner.status_flags & FAKEDEATH || owner.chem_effects[CE_NOPULSE])
			pulse = PULSE_NONE		//pretend that we're dead. unlike actual death, can be inflienced by meds

		pulse = Clamp(pulse + owner.chem_effects[CE_PULSE], PULSE_SLOW, PULSE_2FAST)

/obj/item/organ/heart/proc/handle_heartbeat()
	if(pulse >= PULSE_2FAST || owner.shock_stage >= 10 || istype(get_turf(owner), /turf/space))
		//PULSE_THREADY - maximum value for pulse, currently it 5.
		//High pulse value corresponds to a fast rate of heartbeat.
		//Divided by 2, otherwise it is too slow.
		var/rate = (PULSE_THREADY - pulse)/2

		if(heartbeat >= rate)
			heartbeat = 0
			owner << sound(beat_sound,0,0,0,50)
		else
			heartbeat++

/obj/item/organ/heart/proc/handle_blood()
	if(!owner)
		return
	if(owner.stat == DEAD && owner.bodytemperature >= 170)	//Dead or cryosleep people do not pump the blood.
		return

	var/blood_volume_raw = owner.vessel.get_reagent_amount("blood")
	var/blood_volume = round((blood_volume_raw/species.blood_volume)*100) // Percentage.

	blood_volume *= efficiency
	// Damaged heart virtually reduces the blood volume, as the blood isn't
	// being pumped properly anymore.
	if(is_broken())
		blood_volume *= 0.3
	else if(is_bruised())
		blood_volume *= 0.6
	else if(damage > 1)
		blood_volume *= 0.8

	//Effects of bloodloss
	switch(blood_volume)
		if(BLOOD_VOLUME_OKAY to BLOOD_VOLUME_SAFE)
			if(prob(1))
				owner << "<span class='warning'>You feel [pick("dizzy","woosey","faint")]</span>"
			if(owner.getOxyLoss() < 20)
				owner.adjustOxyLoss(3)
		if(BLOOD_VOLUME_BAD to BLOOD_VOLUME_OKAY)
			owner.eye_blurry = max(owner.eye_blurry,6)
			if(owner.getOxyLoss() < 50)
				owner.adjustOxyLoss(10)
			owner.adjustOxyLoss(1)
			if(prob(15))
				owner.Paralyse(rand(1,3))
				owner << "<span class='warning'>You feel extremely [pick("dizzy","woosey","faint")]</span>"
		if(BLOOD_VOLUME_SURVIVE to BLOOD_VOLUME_BAD)
			owner.adjustOxyLoss(5)
			owner.adjustToxLoss(3)
			if(prob(15))
				owner << "<span class='warning'>You feel extremely [pick("dizzy","woosey","faint")]</span>"
		else if(blood_volume < BLOOD_VOLUME_SURVIVE)
			owner.death()

	//Blood regeneration if there is some space
	if(blood_volume_raw < species.blood_volume)
		var/datum/reagent/blood/B = owner.get_blood(owner.vessel)
		B.volume += 0.1 // regenerate blood VERY slowly
		if(CE_BLOODRESTORE in owner.chem_effects)
			B.volume += owner.chem_effects[CE_BLOODRESTORE]

	// Blood loss or liver damage make you lose nutriments
	if(blood_volume < BLOOD_VOLUME_SAFE || is_bruised())
		if(owner.nutrition >= 300)
			owner.nutrition -= 10
		else if(owner.nutrition >= 200)
			owner.nutrition -= 3

/obj/item/organ/lungs
	name = "lungs"
	icon_state = "lungs"
	gender = PLURAL
	organ_tag = "lungs"
	parent_organ = "chest"

/obj/item/organ/lungs/process()
	..()

	if(!owner)
		return

	if (germ_level > INFECTION_LEVEL_ONE)
		if(prob(5))
			owner.emote("cough")		//respitory tract infection

	if(is_bruised())
		if(prob(2))
			spawn owner.emote("me", 1, "coughs up blood!")
			owner.drip(10)
		if(prob(4))
			spawn owner.emote("me", 1, "gasps for air!")
			owner.losebreath += 15