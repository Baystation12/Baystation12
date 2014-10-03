//Updates the mob's health from organs and mob damage variables
/mob/living/carbon/human/updatehealth()
	if(status_flags & GODMODE)
		health = 100
		stat = CONSCIOUS
		return
	var/total_burn	= 0
	var/total_brute	= 0
	for(var/datum/organ/external/O in organs)	//hardcoded to streamline things a bit
		total_brute	+= O.brute_dam
		total_burn	+= O.burn_dam
	health = 100 - getOxyLoss() - getToxLoss() - getCloneLoss() - total_burn - total_brute
	//TODO: fix husking
	if( ((100 - total_burn) < config.health_threshold_dead) && stat == DEAD) //100 only being used as the magic human max health number, feel free to change it if you add a var for it -- Urist
		ChangeToHusk()
	return

/mob/living/carbon/human/getBrainLoss()
	var/res = brainloss
	var/datum/organ/internal/brain/sponge = internal_organs_by_name["brain"]
	if (sponge.is_bruised())
		res += 20
	if (sponge.is_broken())
		res += 50
	res = min(res,maxHealth*2)
	return res

//These procs fetch a cumulative total damage from all organs
/mob/living/carbon/human/getBruteLoss()
	var/amount = 0
	for(var/datum/organ/external/O in organs)
		amount += O.brute_dam
	return amount

/mob/living/carbon/human/getFireLoss()
	var/amount = 0
	for(var/datum/organ/external/O in organs)
		amount += O.burn_dam
	return amount


/mob/living/carbon/human/adjustBruteLoss(var/amount)
	if(species && species.brute_mod)
		amount = amount*species.brute_mod

	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)
	hud_updateflag |= 1 << HEALTH_HUD

/mob/living/carbon/human/adjustFireLoss(var/amount)
	if(species && species.burn_mod)
		amount = amount*species.burn_mod

	if(amount > 0)
		take_overall_damage(0, amount)
	else
		heal_overall_damage(0, -amount)
	hud_updateflag |= 1 << HEALTH_HUD

/mob/living/carbon/human/proc/adjustBruteLossByPart(var/amount, var/organ_name, var/obj/damage_source = null)
	if(species && species.brute_mod)
		amount = amount*species.brute_mod

	if (organ_name in organs_by_name)
		var/datum/organ/external/O = get_organ(organ_name)

		if(amount > 0)
			O.take_damage(amount, 0, sharp=is_sharp(damage_source), edge=has_edge(damage_source), used_weapon=damage_source)
		else
			//if you don't want to heal robot organs, they you will have to check that yourself before using this proc.
			O.heal_damage(-amount, 0, internal=0, robo_repair=(O.status & ORGAN_ROBOT))

	hud_updateflag |= 1 << HEALTH_HUD

/mob/living/carbon/human/proc/adjustFireLossByPart(var/amount, var/organ_name, var/obj/damage_source = null)
	if(species && species.burn_mod)
		amount = amount*species.burn_mod

	if (organ_name in organs_by_name)
		var/datum/organ/external/O = get_organ(organ_name)

		if(amount > 0)
			O.take_damage(0, amount, sharp=is_sharp(damage_source), edge=has_edge(damage_source), used_weapon=damage_source)
		else
			//if you don't want to heal robot organs, they you will have to check that yourself before using this proc.
			O.heal_damage(0, -amount, internal=0, robo_repair=(O.status & ORGAN_ROBOT))

	hud_updateflag |= 1 << HEALTH_HUD

/mob/living/carbon/human/Stun(amount)
	if(HULK in mutations)	return
	..()

/mob/living/carbon/human/Weaken(amount)
	if(HULK in mutations)	return
	..()

/mob/living/carbon/human/Paralyse(amount)
	if(HULK in mutations)	return
	..()

/mob/living/carbon/human/adjustCloneLoss(var/amount)
	..()

	if(species.flags & IS_SYNTHETIC)
		return

	var/heal_prob = max(0, 80 - getCloneLoss())
	var/mut_prob = min(80, getCloneLoss()+10)
	if (amount > 0)
		if (prob(mut_prob))
			var/list/datum/organ/external/candidates = list()
			for (var/datum/organ/external/O in organs)
				if(!(O.status & ORGAN_MUTATED))
					candidates |= O
			if (candidates.len)
				var/datum/organ/external/O = pick(candidates)
				O.mutate()
				src << "<span class = 'notice'>Something is not right with your [O.display_name]...</span>"
				return
	else
		if (prob(heal_prob))
			for (var/datum/organ/external/O in organs)
				if (O.status & ORGAN_MUTATED)
					O.unmutate()
					src << "<span class = 'notice'>Your [O.display_name] is shaped normally again.</span>"
					return

	if (getCloneLoss() < 1)
		for (var/datum/organ/external/O in organs)
			if (O.status & ORGAN_MUTATED)
				O.unmutate()
				src << "<span class = 'notice'>Your [O.display_name] is shaped normally again.</span>"
	hud_updateflag |= 1 << HEALTH_HUD

////////////////////////////////////////////

//Returns a list of damaged organs
/mob/living/carbon/human/proc/get_damaged_organs(var/brute, var/burn)
	var/list/datum/organ/external/parts = list()
	for(var/datum/organ/external/O in organs)
		if((brute && O.brute_dam) || (burn && O.burn_dam))
			parts += O
	return parts

//Returns a list of damageable organs
/mob/living/carbon/human/proc/get_damageable_organs()
	var/list/datum/organ/external/parts = list()
	for(var/datum/organ/external/O in organs)
		if(O.brute_dam + O.burn_dam < O.max_damage)
			parts += O
	return parts

//Heals ONE external organ, organ gets randomly selected from damaged ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/heal_organ_damage(var/brute, var/burn)
	var/list/datum/organ/external/parts = get_damaged_organs(brute,burn)
	if(!parts.len)	return
	var/datum/organ/external/picked = pick(parts)
	if(picked.heal_damage(brute,burn))
		UpdateDamageIcon()
		hud_updateflag |= 1 << HEALTH_HUD
	updatehealth()


/*
In most cases it makes more sense to use apply_damage() instead! And make sure to check armour if applicable.
*/
//Damages ONE external organ, organ gets randomly selected from damagable ones.
//It automatically updates damage overlays if necesary
//It automatically updates health status
/mob/living/carbon/human/take_organ_damage(var/brute, var/burn, var/sharp = 0, var/edge = 0)
	var/list/datum/organ/external/parts = get_damageable_organs()
	if(!parts.len)	return
	var/datum/organ/external/picked = pick(parts)
	if(picked.take_damage(brute,burn,sharp,edge))
		UpdateDamageIcon()
		hud_updateflag |= 1 << HEALTH_HUD
	updatehealth()
	speech_problem_flag = 1


//Heal MANY external organs, in random order
/mob/living/carbon/human/heal_overall_damage(var/brute, var/burn)
	var/list/datum/organ/external/parts = get_damaged_organs(brute,burn)

	var/update = 0
	while(parts.len && (brute>0 || burn>0) )
		var/datum/organ/external/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam

		update |= picked.heal_damage(brute,burn)

		brute -= (brute_was-picked.brute_dam)
		burn -= (burn_was-picked.burn_dam)

		parts -= picked
	updatehealth()
	hud_updateflag |= 1 << HEALTH_HUD
	speech_problem_flag = 1
	if(update)	UpdateDamageIcon()

// damage MANY external organs, in random order
/mob/living/carbon/human/take_overall_damage(var/brute, var/burn, var/sharp = 0, var/edge = 0, var/used_weapon = null)
	if(status_flags & GODMODE)	return	//godmode
	var/list/datum/organ/external/parts = get_damageable_organs()
	var/update = 0
	while(parts.len && (brute>0 || burn>0) )
		var/datum/organ/external/picked = pick(parts)

		var/brute_was = picked.brute_dam
		var/burn_was = picked.burn_dam

		update |= picked.take_damage(brute,burn,sharp,edge,used_weapon)
		brute	-= (picked.brute_dam - brute_was)
		burn	-= (picked.burn_dam - burn_was)

		parts -= picked
	updatehealth()
	hud_updateflag |= 1 << HEALTH_HUD
	if(update)	UpdateDamageIcon()


////////////////////////////////////////////

/*
This function restores the subjects blood to max.
*/
/mob/living/carbon/human/proc/restore_blood()
	if(!species.flags & NO_BLOOD)
		var/blood_volume = vessel.get_reagent_amount("blood")
		vessel.add_reagent("blood",560.0-blood_volume)


/*
This function restores all organs.
*/
/mob/living/carbon/human/restore_all_organs()
	for(var/datum/organ/external/current_organ in organs)
		current_organ.rejuvenate()

/mob/living/carbon/human/proc/HealDamage(zone, brute, burn)
	var/datum/organ/external/E = get_organ(zone)
	if(istype(E, /datum/organ/external))
		if (E.heal_damage(brute, burn))
			UpdateDamageIcon()
			hud_updateflag |= 1 << HEALTH_HUD
	else
		return 0
	return


/mob/living/carbon/human/proc/get_organ(var/zone)
	if(!zone)	zone = "chest"
	if (zone in list( "eyes", "mouth" ))
		zone = "head"
	return organs_by_name[zone]

/mob/living/carbon/human/apply_damage(var/damage = 0, var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0, var/sharp = 0, var/edge = 0, var/obj/used_weapon = null)

	//visible_message("Hit debug. [damage] | [damagetype] | [def_zone] | [blocked] | [sharp] | [used_weapon]")
	
	//Handle other types of damage
	if((damagetype != BRUTE) && (damagetype != BURN))
		if(damagetype == HALLOSS)
			if ((damage > 25 && prob(20)) || (damage > 50 && prob(60)))
				emote("scream")
		
		
		..(damage, damagetype, def_zone, blocked)
		return 1

	//Handle BRUTE and BURN damage
	handle_suit_punctures(damagetype, damage)
	
	if(blocked >= 2)	return 0

	var/datum/organ/external/organ = null
	if(isorgan(def_zone))
		organ = def_zone
	else
		if(!def_zone)	def_zone = ran_zone(def_zone)
		organ = get_organ(check_zone(def_zone))
	if(!organ)	return 0

	if(blocked)
		damage = (damage/(blocked+1))

	switch(damagetype)
		if(BRUTE)
			damageoverlaytemp = 20
			if(species && species.brute_mod)
				damage = damage*species.brute_mod
			if(organ.take_damage(damage, 0, sharp, edge, used_weapon))
				UpdateDamageIcon()
		if(BURN)
			damageoverlaytemp = 20
			if(species && species.burn_mod)
				damage = damage*species.burn_mod
			if(organ.take_damage(0, damage, sharp, edge, used_weapon))
				UpdateDamageIcon()

	// Will set our damageoverlay icon to the next level, which will then be set back to the normal level the next mob.Life().
	updatehealth()
	hud_updateflag |= 1 << HEALTH_HUD
	return 1
