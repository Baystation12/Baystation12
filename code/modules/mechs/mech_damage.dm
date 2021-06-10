/mob/living/exosuit/ex_act(severity)
	var/b_loss = 0
	var/f_loss = 0
	switch (severity)
		if (1)
			b_loss = 200
			f_loss = 200
		if (2)
			b_loss = 90
			f_loss = 90
		if(3)
			b_loss = 45

	// spread damage overall
	apply_damage(b_loss, BRUTE, null, DAM_EXPLODE | DAM_DISPERSED, used_weapon = "Explosive blast")
	apply_damage(f_loss, BURN, null, DAM_EXPLODE | DAM_DISPERSED, used_weapon = "Explosive blast")

/mob/living/exosuit/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	if(!effect || (blocked >= 100))
		return 0
	if(LAZYLEN(pilots) && (!hatch_closed || !prob(body.pilot_coverage)))
		if(effect > 0 && effecttype == IRRADIATE)
			effect = max((1-(get_armors_by_zone(null, IRRADIATE)/100))*effect/(blocked+1),0)
		var/mob/living/pilot = pick(pilots)
		return pilot.apply_effect(effect, effecttype, blocked)
	if(!(effecttype in list(PAIN, STUTTER, EYE_BLUR, DROWSY, STUN, WEAKEN)))
		. = ..()

/mob/living/exosuit/resolve_item_attack(var/obj/item/I, var/mob/living/user, var/def_zone)
	if(!I.force)
		user.visible_message(SPAN_NOTICE("\The [user] bonks \the [src] harmlessly with \the [I]."))
		return

	switch(def_zone)
		if(BP_HEAD , BP_CHEST, BP_MOUTH, BP_EYES)
			if(LAZYLEN(pilots) && (!hatch_closed || !prob(body.pilot_coverage)))
				var/mob/living/pilot = pick(pilots)
				var/zone = pilot.resolve_item_attack(I, user, def_zone)
				if(zone)
					var/datum/attack_result/AR = new()
					AR.hit_zone = zone
					AR.attackee = pilot
					return AR

	return def_zone //Careful with effects, mechs shouldn't be stunned
	
/mob/living/exosuit/hitby(atom/movable/AM, var/datum/thrownthing/TT)
	if(LAZYLEN(pilots) && (!hatch_closed || !prob(body.pilot_coverage)))
		var/mob/living/pilot = pick(pilots)
		return pilot.hitby(AM, TT)
	. = ..()

/mob/living/exosuit/bullet_act(obj/item/projectile/P, def_zone, used_weapon)
	switch(def_zone)
		if(BP_HEAD , BP_CHEST, BP_MOUTH, BP_EYES)
			if(LAZYLEN(pilots) && (!hatch_closed || !prob(body.pilot_coverage)))
				var/mob/living/pilot = pick(pilots)
				return pilot.bullet_act(P, def_zone, used_weapon)
	..()

/mob/living/exosuit/get_armors_by_zone(def_zone, damage_type, damage_flags)
	. = ..()
	if(body && body.m_armour)
		var/body_armor = get_extension(body.m_armour, /datum/extension/armor)
		if(body_armor)
			. += body_armor

/mob/living/exosuit/updatehealth()
	maxHealth = body ? body.mech_health : 0
	health = maxHealth-(getFireLoss()+getBruteLoss())

/mob/living/exosuit/adjustFireLoss(var/amount, var/obj/item/mech_component/MC = pick(list(arms, legs, body, head)))
	if(MC)
		MC.take_burn_damage(amount)
		MC.update_health()

/mob/living/exosuit/adjustBruteLoss(var/amount, var/obj/item/mech_component/MC = pick(list(arms, legs, body, head)))
	if(MC)
		MC.take_brute_damage(amount)
		MC.update_health()

/mob/living/exosuit/proc/zoneToComponent(var/zone)
	switch(zone)
		if(BP_EYES , BP_HEAD)
			return head
		if(BP_L_ARM , BP_R_ARM)
			return arms
		if(BP_L_LEG , BP_R_LEG)
			return legs
		else
			return body

/mob/living/exosuit/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/damage_flags = 0, var/used_weapon = null, var/armor_pen, var/silent = FALSE)
	if(!damage)
		return 0

	if(!def_zone)
		if(damage_flags & DAM_DISPERSED)
			var/old_damage = damage
			var/tally
			silent = FALSE
			for(var/obj/item/part in list(arms, legs, body, head))
				tally += part.w_class
			for(var/obj/item/part in list(arms, legs, body, head))
				damage = old_damage * part.w_class/tally
				def_zone = BP_CHEST
				if(part == arms)
					def_zone = BP_L_ARM
				else if(part == legs)
					def_zone = BP_L_LEG
				else if(part == head)
					def_zone = BP_HEAD

				. = .() || .
			return

		def_zone = ran_zone(def_zone)

	var/list/after_armor = modify_damage_by_armor(def_zone, damage, damagetype, damage_flags, src, armor_pen, TRUE)
	damage = after_armor[1]
	damagetype = after_armor[2]

	if(!damage)
		return 0

	var/target = zoneToComponent(def_zone)
	//Only 3 types of damage concern mechs and vehicles
	switch(damagetype)
		if(BRUTE)
			adjustBruteLoss(damage, target)
		if(BURN)
			adjustFireLoss(damage, target)
		if(IRRADIATE)
			for(var/mob/living/pilot in pilots)
				pilot.apply_damage(damage, IRRADIATE, def_zone, damage_flags, used_weapon)

	if((damagetype == BRUTE || damagetype == BURN) && prob(25+(damage*2)))
		sparks.set_up(3,0,src)
		sparks.start()
	updatehealth()

	return 1

/mob/living/exosuit/rad_act(var/severity)
	return FALSE // Pilots already query rads, modify this for radiation alerts and such

/mob/living/exosuit/get_rads()
	. = ..()
	if(!hatch_closed || (body.pilot_coverage < 100)) //Open, environment is the source
		return .
	var/list/after_armor = modify_damage_by_armor(null, ., IRRADIATE, DAM_DISPERSED, src, 0, TRUE)
	return after_armor[1]	

/mob/living/exosuit/getFireLoss()
	var/total = 0
	for(var/obj/item/mech_component/MC in list(arms, legs, body, head))
		if(MC)
			total += MC.burn_damage
	return total

/mob/living/exosuit/getBruteLoss()
	var/total = 0
	for(var/obj/item/mech_component/MC in list(arms, legs, body, head))
		if(MC)
			total += MC.brute_damage
	return total

/mob/living/exosuit/emp_act(var/severity)

	var/ratio = get_blocked_ratio(null, BURN, null, (4-severity) * 20)

	if(ratio >= 0.5)
		for(var/mob/living/m in pilots)
			to_chat(m, SPAN_NOTICE("Your Faraday shielding absorbed the pulse!"))
		return
	else if(ratio > 0)
		for(var/mob/living/m in pilots)
			to_chat(m, SPAN_NOTICE("Your Faraday shielding mitigated the pulse!"))

	emp_damage += round((12 - (severity*3))*( 1 - ratio))
	if(severity <= 3)
		for(var/obj/item/thing in list(arms,legs,head,body))
			thing.emp_act(severity)
		if(!hatch_closed || !prob(body.pilot_coverage))
			for(var/thing in pilots)
				var/mob/pilot = thing
				pilot.emp_act(severity)
				
/mob/living/exosuit/get_bullet_impact_effect_type(def_zone)
	return BULLET_IMPACT_METAL
