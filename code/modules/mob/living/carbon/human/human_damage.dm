//Updates the mob's health from organs and mob damage variables
/mob/living/carbon/human/updatehealth()

	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
		return
	var/total_burn  = 0
	var/total_brute = 0
	for(var/obj/item/organ/external/O in organs)	//hardcoded to streamline things a bit
		if((O.robotic >= ORGAN_ROBOT) && !O.vital)
			continue //*non-vital* robot limbs don't count towards shock and crit
		total_brute += O.brute_dam
		total_burn  += O.burn_dam

	health = maxHealth - getOxyLoss() - getToxLoss() - getCloneLoss() - total_burn - total_brute

	//TODO: fix husking
	if(((maxHealth - total_burn) < config.health_threshold_dead) && stat == DEAD)
		ChangeToHusk()
	return

/mob/living/carbon/human/adjustBrainLoss(var/amount)

	if(status_flags & GODMODE)	return 0	//godmode

	if(should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/brain/sponge = internal_organs_by_name[BP_BRAIN]
		if(sponge)
			sponge.take_damage(amount)
			brainloss = sponge.damage
		else
			brainloss = 200
	else
		brainloss = 0

/mob/living/carbon/human/setBrainLoss(var/amount)

	if(status_flags & GODMODE)	return 0	//godmode

	if(should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/brain/sponge = internal_organs_by_name[BP_BRAIN]
		if(sponge)
			sponge.damage = min(max(amount, 0),(maxHealth*2))
			brainloss = sponge.damage
		else
			brainloss = 200
	else
		brainloss = 0

/mob/living/carbon/human/getBrainLoss()

	if(status_flags & GODMODE)	return 0	//godmode

	if(should_have_organ(BP_BRAIN))
		var/obj/item/organ/internal/brain/sponge = internal_organs_by_name[BP_BRAIN]
		if(sponge)
			brainloss = min(sponge.damage,maxHealth*2)
		else
			brainloss = 200
	else
		brainloss = 0
	return brainloss

//These procs fetch a cumulative total damage from all organs
/mob/living/carbon/human/getBruteLoss()
	var/amount = 0
	for(var/obj/item/organ/external/O in organs)
		if((O.robotic >= ORGAN_ROBOT) && !O.vital)
			continue //robot limbs don't count towards shock and crit
		amount += O.brute_dam
	return amount

/mob/living/carbon/human/getFireLoss()
	var/amount = 0
	for(var/obj/item/organ/external/O in organs)
		if((O.robotic >= ORGAN_ROBOT) && !O.vital)
			continue //robot limbs don't count towards shock and crit
		amount += O.burn_dam
	return amount

/mob/living/carbon/human/adjustBruteLoss(var/amount)
	amount = amount*species.brute_mod
	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)
	BITSET(hud_updateflag, HEALTH_HUD)

/mob/living/carbon/human/adjustFireLoss(var/amount)
	amount = amount*species.burn_mod
	if(amount > 0)
		take_overall_damage(0, amount)
	else
		heal_overall_damage(0, -amount)
	BITSET(hud_updateflag, HEALTH_HUD)

/mob/living/carbon/human/proc/adjustBruteLossByPart(var/amount, var/organ_name, var/obj/damage_source = null)
	amount = amount*species.brute_mod
	if (organ_name in organs_by_name)
		var/obj/item/organ/external/O = get_organ(organ_name)

		if(amount > 0)
			O.take_damage(amount, 0, sharp=is_sharp(damage_source), edge=has_edge(damage_source), used_weapon=damage_source)
		else
			//if you don't want to heal robot organs, they you will have to check that yourself before using this proc.
			O.heal_damage(-amount, 0, internal=0, robo_repair=(O.robotic >= ORGAN_ROBOT))

	BITSET(hud_updateflag, HEALTH_HUD)

/mob/living/carbon/human/proc/adjustFireLossByPart(var/amount, var/organ_name, var/obj/damage_source = null)
	amount = amount*species.burn_mod
	if (organ_name in organs_by_name)
		var/obj/item/organ/external/O = get_organ(organ_name)

		if(amount > 0)
			O.take_damage(0, amount, sharp=is_sharp(damage_source), edge=has_edge(damage_source), used_weapon=damage_source)
		else
			//if you don't want to heal robot organs, they you will have to check that yourself before using this proc.
			O.heal_damage(0, -amount, internal=0, robo_repair=(O.robotic >= ORGAN_ROBOT))

	BITSET(hud_updateflag, HEALTH_HUD)

/mob/living/carbon/human/Stun(amount)
	if(HULK in mutations)	return
	..()

/mob/living/carbon/human/Weaken(amount)
	if(HULK in mutations)	return
	..()

/mob/living/carbon/human/Paralyse(amount)
	if(HULK in mutations)	return
	// Notify our AI if they can now control the suit.
	if(wearing_rig && !stat && paralysis < amount) //We are passing out right this second.
		wearing_rig.notify_ai("<span class='danger'>Warning: user consciousness failure. Mobility control passed to integrated intelligence system.</span>")
	..()

/mob/living/carbon/human/getCloneLoss()
	if((species.flags & NO_SCAN) || isSynthetic())
		cloneloss = 0
	return ..()

/mob/living/carbon/human/setCloneLoss(var/amount)
	if((species.flags & NO_SCAN) || isSynthetic())
		cloneloss = 0
	else
		..()

/mob/living/carbon/human/adjustCloneLoss(var/amount)
	..()

	if((species.flags & NO_SCAN) || isSynthetic())
		cloneloss = 0
		return

	var/heal_prob = max(0, 80 - getCloneLoss())
	var/mut_prob = min(80, getCloneLoss()+10)
	if (amount > 0)
		if (prob(mut_prob))
			var/list/obj/item/organ/external/candidates = list()
			for (var/obj/item/organ/external/O in organs)
				if(!(O.status & ORGAN_MUTATED))
					candidates |= O
			if (candidates.len)
				var/obj/item/organ/external/O = pick(candidates)
				O.mutate()
				to_chat(src, "<span class = 'notice'>Something is not right with your [O.name]...</span>")
				return
	else
		if (prob(heal_prob))
			for (var/obj/item/organ/external/O in organs)
				if (O.status & ORGAN_MUTATED)
					O.unmutate()
					to_chat(src, "<span class = 'notice'>Your [O.name] is shaped normally again.</span>")
					return

	if (getCloneLoss() < 1)
		for (var/obj/item/organ/external/O in organs)
			if (O.status & ORGAN_MUTATED)
				O.unmutate()
				to_chat(src, "<span class = 'notice'>Your [O.name] is shaped normally again.</span>")
	BITSET(hud_updateflag, HEALTH_HUD)

// Defined here solely to take species flags into account without having to recast at mob/living level.
/mob/living/carbon/human/getOxyLoss()
	if(!should_have_organ(BP_LUNGS))
		oxyloss = 0
	return ..()

/mob/living/carbon/human/adjustOxyLoss(var/amount)
	if(!should_have_organ(BP_LUNGS))
		oxyloss = 0
	else
		amount = amount*species.oxy_mod
		..(amount)

/mob/living/carbon/human/setOxyLoss(var/amount)
	if(!should_have_organ(BP_LUNGS))
		oxyloss = 0
	else
		..()

/mob/living/carbon/human/getToxLoss()
	if((species.flags & NO_POISON) || isSynthetic())
		toxloss = 0
	return ..()

/mob/living/carbon/human/adjustToxLoss(var/amount)
	if((species.flags & NO_POISON) || isSynthetic())
		toxloss = 0
	else
		amount = amount*species.toxins_mod
		..(amount)

/mob/living/carbon/human/setToxLoss(var/amount)
	if((species.flags & NO_POISON) || isSynthetic())
		toxloss = 0
	else
		..()

////////////////////////////////////////////

//Returns a list of damaged organs
/mob/living/carbon/human/proc/get_damaged_organs(var/brute, var/burn)
	var/list/obj/item/organ/external/parts = list()
	for(var/obj/item/organ/external/O in organs)
		if((brute && O.brute_dam) || (burn && O.burn_dam))
			parts += O
	return parts

//Returns a list of damageable organs
/mob/living/carbon/human/proc/get_damageable_organs()
	var/list/obj/item/organ/external/parts = list()
	for(var/obj/item/organ/external/O in organs)
		if(O.is_damageable())
			parts += O
	return parts

//Heals ONE external organ, organ gets randomly selected from damaged ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/heal_organ_damage(var/brute, var/burn)
	var/list/obj/item/organ/external/parts = get_damaged_organs(brute,burn)
	if(!parts.len)	return
	var/obj/item/organ/external/picked = pick(parts)
	if(picked.heal_damage(brute,burn))
		UpdateDamageIcon()
		BITSET(hud_updateflag, HEALTH_HUD)
	updatehealth()


/*
In most cases it makes more sense to use apply_damage() instead! And make sure to check armour if applicable.
*/
//Damages ONE external organ, organ gets randomly selected from damagable ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/take_organ_damage(var/brute, var/burn, var/sharp = 0, var/edge = 0)
	var/list/obj/item/organ/external/parts = get_damageable_organs()
	if(!parts.len)	return
	var/obj/item/organ/external/picked = pick(parts)
	if(picked.take_damage(brute,burn,sharp,edge))
		UpdateDamageIcon()
		BITSET(hud_updateflag, HEALTH_HUD)
	updatehealth()


//Heal MANY external organs, in random order
/mob/living/carbon/human/heal_overall_damage(var/brute, var/burn)
	var/list/obj/item/organ/external/parts = get_damaged_organs(brute,burn)

	var/update = 0
	while(parts.len && (brute>0 || burn>0) )
		var/obj/item/organ/external/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam

		update |= picked.heal_damage(brute,burn)

		brute -= (brute_was-picked.brute_dam)
		burn -= (burn_was-picked.burn_dam)

		parts -= picked
	updatehealth()
	BITSET(hud_updateflag, HEALTH_HUD)
	if(update)	UpdateDamageIcon()

// damage MANY external organs, in random order
/mob/living/carbon/human/take_overall_damage(var/brute, var/burn, var/sharp = 0, var/edge = 0, var/used_weapon = null)
	if(status_flags & GODMODE)	return	//godmode
	var/list/obj/item/organ/external/parts = get_damageable_organs()
	var/update = 0
	while(parts.len && (brute>0 || burn>0) )
		var/obj/item/organ/external/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam

		update |= picked.take_damage(brute,burn,sharp,edge,used_weapon)
		brute	-= (picked.brute_dam - brute_was)
		burn	-= (picked.burn_dam - burn_was)

		parts -= picked
	updatehealth()
	BITSET(hud_updateflag, HEALTH_HUD)
	if(update)	UpdateDamageIcon()


////////////////////////////////////////////

/*
This function restores the subjects blood to max.
*/
/mob/living/carbon/human/proc/restore_blood()
	if(!should_have_organ(BP_HEART))
		return
	if(vessel.total_volume < species.blood_volume)
		vessel.add_reagent("blood", species.blood_volume - vessel.total_volume)

/*
This function restores all organs.
*/
/mob/living/carbon/human/restore_all_organs(var/ignore_prosthetic_prefs)
	for(var/bodypart in BP_BY_DEPTH)
		var/obj/item/organ/external/current_organ = organs_by_name[bodypart]
		if(istype(current_organ))
			current_organ.rejuvenate(ignore_prosthetic_prefs)

/mob/living/carbon/human/proc/HealDamage(zone, brute, burn)
	var/obj/item/organ/external/E = get_organ(zone)
	if(istype(E, /obj/item/organ/external))
		if (E.heal_damage(brute, burn))
			UpdateDamageIcon()
			BITSET(hud_updateflag, HEALTH_HUD)
	else
		return 0
	return


/mob/living/carbon/human/proc/get_organ(var/zone, var/check = 1)
	if(check)
		zone = check_zone(zone)

	if(zone in BP_TAUR_OVERRIDDEN)
		if(organs_by_name[BP_TAUR])
			return organs_by_name[BP_TAUR]

	return organs_by_name[zone]

/mob/living/carbon/human/apply_damage(var/damage = 0, var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0, var/damage_flags = 0, var/obj/used_weapon = null)

	var/obj/item/organ/external/organ = null
	if(isorgan(def_zone))
		organ = def_zone
	else
		if(!def_zone)	def_zone = ran_zone(def_zone)
		organ = get_organ(check_zone(def_zone))

	var/obj/item/organ/external/taur = get_organ(BP_TAUR)
	if(def_zone in BP_TAUR_OVERRIDDEN && taur)
		organ = taur

	//Handle other types of damage
	if(damagetype != BRUTE && damagetype != BURN)
		if(!stat && damagetype == HALLOSS && can_feel_pain())
			if ((damage > 25 && prob(20)) || (damage > 50 && prob(60)))
				emote("scream")

		..(damage, damagetype, def_zone, blocked)
		return 1

	//Handle BRUTE and BURN damage
	handle_suit_punctures(damagetype, damage, def_zone)

	if(blocked >= 100)	return 0


	if(!organ)	return 0

	if(blocked)
		damage *= blocked_mult(blocked)

	switch(damagetype)
		if(BRUTE)
			damageoverlaytemp = 20
			damage = damage*species.brute_mod
			if(organ.take_damage(damage, 0, damage_flags, used_weapon))
				UpdateDamageIcon()
		if(BURN)
			damageoverlaytemp = 20
			damage = damage*species.burn_mod
			if(organ.take_damage(0, damage, damage_flags, used_weapon))
				UpdateDamageIcon()

	// Will set our damageoverlay icon to the next level, which will then be set back to the normal level the next mob.Life().
	updatehealth()
	BITSET(hud_updateflag, HEALTH_HUD)
	return 1
