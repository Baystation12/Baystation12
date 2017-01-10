/****************************************************
			   DAMAGE PROCS
****************************************************/

/obj/item/organ/external/proc/is_damageable(var/additional_damage = 0)
	//Continued damage to vital organs can kill you, and robot organs don't count towards total damage so no need to cap them.
	return (vital || (robotic >= ORGAN_ROBOT) || brute_dam + burn_dam + additional_damage < max_damage)

/obj/item/organ/external/take_damage(brute, burn, sharp, edge, used_weapon = null, list/forbidden_limbs = list())
	brute = round(brute * brute_mod, 0.1)
	burn = round(burn * burn_mod, 0.1)
	if((brute <= 0) && (burn <= 0))
		return 0

	// High brute damage or sharp objects may damage internal organs
	if(internal_organs && (brute_dam + brute >= max_damage || (((sharp && brute >= 5) || brute >= 10) && prob(5))))
		// Damage an internal organ
		if(internal_organs && internal_organs.len)
			var/obj/item/organ/I = pick(internal_organs)
			I.take_damage(brute / 2)
			brute -= brute / 2

	if(status & ORGAN_BROKEN && prob(40) && brute)
		if(!can_feel_pain())
			owner.emote("scream") //getting hit on broken hand hurts
	if(used_weapon)
		add_autopsy_data("[used_weapon]", brute + burn)

	var/can_cut = (prob(brute*2) || sharp) && (robotic < ORGAN_ROBOT)
	var/spillover = 0
	var/pure_brute = brute
	if(!is_damageable(brute + burn))
		spillover =  brute_dam + burn_dam + brute - max_damage
		if(spillover > 0)
			brute -= spillover
		else
			spillover = brute_dam + burn_dam + brute + burn - max_damage
			if(spillover > 0)
				burn -= spillover
	// If the limbs can break, make sure we don't exceed the maximum damage a limb can take before breaking
	// Non-vital organs are limited to max_damage. You can't kill someone by bludeonging their arm all the way to 200 -- you can
	// push them faster into paincrit though, as the additional damage is converted into shock.
	if(is_damageable(brute + burn) || !config.limbs_can_break)
		if(brute)
			if(can_cut)
				//need to check sharp again here so that blunt damage that was strong enough to break skin doesn't give puncture wounds
				if(sharp && !edge)
					createwound( PIERCE, brute )
				else
					createwound( CUT, brute )
			else
				createwound( BRUISE, brute )
		if(burn)
			createwound( BURN, burn )
	else
		//If there are still hurties to dispense
		if (spillover)
			owner.shock_stage += spillover * config.organ_damage_spillover_multiplier

	// sync the organ's damage with its wounds
	src.update_damages()
	owner.updatehealth() //droplimb will call updatehealth() again if it does end up being called
	//If limb took enough damage, try to cut or tear it off
	if(owner && loc == owner && !is_stump())
		if(!cannot_amputate && config.limbs_can_break && (brute_dam + burn_dam + brute + burn + spillover) >= (max_damage * config.organ_health_multiplier))
			//organs can come off in three cases
			//1. If the damage source is edge_eligible and the brute damage dealt exceeds the edge threshold, then the organ is cut off.
			//2. If the damage amount dealt exceeds the disintegrate threshold, the organ is completely obliterated.
			//3. If the organ has already reached or would be put over it's max damage amount (currently redundant),
			//   and the brute damage dealt exceeds the tearoff threshold, the organ is torn off.
			//Check edge eligibility
			var/edge_eligible = 0
			if(edge)
				if(istype(used_weapon,/obj/item))
					var/obj/item/W = used_weapon
					if(W.w_class >= w_class)
						edge_eligible = 1
				else
					edge_eligible = 1
			brute = pure_brute
			if(edge_eligible && brute >= max_damage / DROPLIMB_THRESHOLD_EDGE && prob(brute))
				droplimb(0, DROPLIMB_EDGE)
			else if(burn >= max_damage / DROPLIMB_THRESHOLD_DESTROY && prob(burn/3))
				droplimb(0, DROPLIMB_BURN)
			else if(brute >= max_damage / DROPLIMB_THRESHOLD_DESTROY && prob(brute))
				droplimb(0, DROPLIMB_BLUNT)
			else if(brute >= max_damage / DROPLIMB_THRESHOLD_TEAROFF && prob(brute/3))
				droplimb(0, DROPLIMB_EDGE)

	return update_damstate()

/obj/item/organ/external/proc/heal_damage(brute, burn, internal = 0, robo_repair = 0)
	if(robotic >= ORGAN_ROBOT && !robo_repair)
		return

	//Heal damage on the individual wounds
	for(var/datum/wound/W in wounds)
		if(brute == 0 && burn == 0)
			break

		// heal brute damage
		if(W.damage_type == BURN)
			burn = W.heal_damage(burn)
		else
			brute = W.heal_damage(brute)

	if(internal)
		status &= ~ORGAN_BROKEN

	//Sync the organ's damage with its wounds
	src.update_damages()
	owner.updatehealth()

	return update_damstate()

// Brute/burn
/obj/item/organ/external/proc/get_brute_damage()
	return brute_dam

/obj/item/organ/external/proc/get_burn_damage()
	return burn_dam

// Geneloss/cloneloss.
/obj/item/organ/external/proc/get_genetic_damage()
	return ((species.flags & NO_SCAN) || robotic >= ORGAN_ROBOT) ? 0 : genetic_degradation

/obj/item/organ/external/proc/remove_genetic_damage(var/amount)
	if((species.flags & NO_SCAN) || robotic >= ORGAN_ROBOT)
		genetic_degradation = 0
		status &= ~ORGAN_MUTATED
		return
	var/last_gene_dam = genetic_degradation
	genetic_degradation = min(100,max(0,genetic_degradation - amount))
	if(genetic_degradation <= 30)
		if(status & ORGAN_MUTATED)
			unmutate()
			to_chat(src, "<span class = 'notice'>Your [name] is shaped normally again.</span>")
	return -(genetic_degradation - last_gene_dam)

/obj/item/organ/external/proc/add_genetic_damage(var/amount)
	if((species.flags & NO_SCAN) || robotic >= ORGAN_ROBOT)
		genetic_degradation = 0
		status &= ~ORGAN_MUTATED
		return
	var/last_gene_dam = genetic_degradation
	genetic_degradation = min(100,max(0,genetic_degradation + amount))
	if(genetic_degradation > 30)
		if(!(status & ORGAN_MUTATED) && prob(genetic_degradation))
			mutate()
			to_chat(owner, "<span class = 'notice'>Something is not right with your [name]...</span>")
	return (genetic_degradation - last_gene_dam)

/obj/item/organ/external/proc/mutate()
	if(src.robotic >= ORGAN_ROBOT)
		return
	src.status |= ORGAN_MUTATED
	if(owner) owner.update_body()

/obj/item/organ/external/proc/unmutate()
	src.status &= ~ORGAN_MUTATED
	if(owner) owner.update_body()

// Pain/halloss
/obj/item/organ/external/proc/get_pain(var/amount)
	if(!can_feel_pain() || robotic >= ORGAN_ROBOT)
		return 0
	return pain

/obj/item/organ/external/proc/remove_pain(var/amount)
	if(!can_feel_pain() || robotic >= ORGAN_ROBOT)
		pain = 0
		return
	var/last_pain = pain
	pain = max(0,min(max_damage,pain-amount))
	return -(pain-last_pain)

/obj/item/organ/external/proc/add_pain(var/amount)
	if(!can_feel_pain() || robotic >= ORGAN_ROBOT)
		pain = 0
		return
	var/last_pain = pain
	pain = max(0,min(max_damage,pain+amount))
	if(owner && ((amount > 15 && prob(20)) || (amount > 30 && prob(60))))
		owner.emote("scream")
	return pain-last_pain

/obj/item/organ/external/proc/stun_act(var/stun_amount, var/agony_amount)
	return

/obj/item/organ/external/proc/get_agony_multiplier()
	return 1
