/mob/living/exosuit/apply_effect(var/effect = 0,var/effecttype = STUN, var/blocked = 0)
	if(!effect || (blocked >= 2))
		return 0
	if(LAZYLEN(pilots) && !prob(body.pilot_coverage))
		if(effect > 0 && effecttype == IRRADIATE)
			effect = max((1-(getarmor(null, "rad")/100))*effect/(blocked+1),0)
		var/mob/living/pilot = pick(pilots)
		return pilot.apply_effect(effect, effecttype, blocked)
	if(!(effecttype in list(PAIN, STUTTER, EYE_BLUR, DROWSY)))
		. = ..()

/mob/living/exosuit/resolve_item_attack(var/obj/item/I, var/mob/living/user, var/def_zone)
	if(!I.force)
		user.visible_message(SPAN_NOTICE("\The [user] bonks \the [src] harmlessly with \the [I]."))
		return

	if(LAZYLEN(pilots) && !prob(body.pilot_coverage))
		var/mob/living/pilot = pick(pilots)
		return pilot.resolve_item_attack(I, user, def_zone)

	user.visible_message(SPAN_DANGER("\The [src] has been [I.attack_verb.len ? pick(I.attack_verb) : "attacked"] with \the [I] by [user]!"))
	if(I.hitsound) playsound(user.loc, I.hitsound, 50, 1, -1)

	var/armor = run_armor_check(attack_flag = "melee", armour_pen = I.armor_penetration)
	var/weapon_sharp = is_sharp(I)
	var/weapon_edge = has_edge(I)
	if((weapon_sharp || weapon_edge) && prob(getarmor(def_zone, "melee")))
		weapon_sharp = 0
		weapon_edge = 0
	if(armor >= 2)
		return 0
	apply_damage(I.force, I.damtype, null, armor, sharp=weapon_sharp, edge=weapon_edge, used_weapon=I)

	return // Return null so that we don't apply item effects like stun.

/mob/living/exosuit/getarmor(var/def_zone, var/type)
	if(body.armour)
		return isnull(body.armour.armor[type]) ? 0 : body.armour.armor[type]
	return 0

/mob/living/exosuit/updatehealth()
	maxHealth = body.mech_health
	health = maxHealth-(getFireLoss()+getBruteLoss())

/mob/living/exosuit/adjustFireLoss(var/amount)
	var/obj/item/mech_component/MC = pick(list(arms, legs, body, head))
	if(MC)
		MC.take_burn_damage(amount)
		MC.update_health()

/mob/living/exosuit/adjustBruteLoss(var/amount)
	var/obj/item/mech_component/MC = pick(list(arms, legs, body, head))
	if(MC)
		MC.take_brute_damage(amount)
		MC.update_health()

/mob/living/exosuit/apply_damage(var/damage = 0,var/damagetype = BRUTE, var/def_zone = null, var/blocked = 0, var/used_weapon = null, var/sharp = 0, var/edge = 0)
	..()
	if((damagetype == BRUTE || damagetype == BURN) && prob(25+(damage*2)))
		sparks.set_up(3,0,src)
		sparks.start()
	updatehealth()

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
	var/armourval = run_armor_check(attack_flag="energy",absorb_text="Your Faraday shielding negates the pulse!",soften_text="Your Faraday shielding lessens the pulse.")
	if(armourval >= 2) return
	emp_damage += round((12 - (severity*3))/(armourval ? armourval : 1))
	severity += armourval
	if(severity <= 3)
		for(var/obj/item/thing in list(arms,legs,head,body))
			thing.emp_act(severity)
		if(!hatch_closed || !prob(body.pilot_coverage))
			for(var/thing in pilots)
				var/mob/pilot = thing
				pilot.emp_act(severity)
