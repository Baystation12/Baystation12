
//Called when the mob is hit with an item in combat.
/mob/living/carbon/resolve_item_attack(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	if(check_attack_throat(I, user))
		return null
	return ..()

/mob/living/carbon/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/blocked, var/hit_zone)
	if(!effective_force || blocked >= 100)
		return 0

	//Hulk modifier
	if(HULK in user.mutations)
		effective_force *= 2

	//Apply weapon damage
	var/weapon_sharp = is_sharp(I)
	var/weapon_edge = has_edge(I)
	if(prob(blocked)) //armour provides a chance to turn sharp/edge weapon attacks into blunt ones
		weapon_sharp = 0
		weapon_edge = 0

	apply_damage(effective_force, I.damtype, hit_zone, blocked, sharp=weapon_sharp, edge=weapon_edge, used_weapon=I)

	//Melee weapon embedded object code.
	if (I && I.damtype == BRUTE && !I.anchored && !is_robot_module(I))
		var/damage = effective_force //just the effective damage used for sorting out embedding, no further damage is applied here
		if (blocked)
			damage *= blocked_mult(blocked)

		//blunt objects should really not be embedding in things unless a huge amount of force is involved
		var/embed_chance = weapon_sharp? damage/I.w_class : damage/(I.w_class*3)
		var/embed_threshold = weapon_sharp? 5*I.w_class : 15*I.w_class

		//Sharp objects will always embed if they do enough damage.
		if((weapon_sharp && damage > (10*I.w_class)) || (damage > embed_threshold && prob(embed_chance)))
			src.embed(I, hit_zone)

	return 1

// Attacking someone with a weapon while they are neck-grabbed
/mob/living/carbon/proc/check_attack_throat(obj/item/W, mob/user)
	if(user.a_intent == I_HURT)
		for(var/obj/item/weapon/grab/G in src.grabbed_by)
			if(G.assailant == user && G.state >= GRAB_NECK)
				if(attack_throat(W, G, user))
					return 1
	return 0

// Knifing
/mob/living/carbon/proc/attack_throat(obj/item/W, obj/item/weapon/grab/G, mob/user)

	if(!W.edge || !W.force || W.damtype != BRUTE)
		return 0 //unsuitable weapon

	user.visible_message("<span class='danger'>\The [user] begins to slit [src]'s throat with \the [W]!</span>")

	user.next_move = world.time + 20 //also should prevent user from triggering this repeatedly
	if(!do_after(user, 20, progress=0))
		return 0
	if(!(G && G.assailant == user && G.affecting == src)) //check that we still have a grab
		return 0

	var/damage_mod = 1
	//presumably, if they are wearing a helmet that stops pressure effects, then it probably covers the throat as well
	var/obj/item/clothing/head/helmet = get_equipped_item(slot_head)
	if(istype(helmet) && (helmet.body_parts_covered & HEAD) && (helmet.flags & STOPPRESSUREDAMAGE))
		//we don't do an armor_check here because this is not an impact effect like a weapon swung with momentum, that either penetrates or glances off.
		damage_mod = 1.0 - (helmet.armor["melee"]/100)

	var/total_damage = 0
	for(var/i in 1 to 3)
		var/damage = min(W.force*1.5, 20)*damage_mod
		apply_damage(damage, W.damtype, BP_HEAD, 0, sharp=W.sharp, edge=W.edge)
		total_damage += damage

	var/oxyloss = total_damage
	if(total_damage >= 40) //threshold to make someone pass out
		oxyloss = 60 // Brain lacks oxygen immediately, pass out

	adjustOxyLoss(min(oxyloss, 100 - getOxyLoss())) //don't put them over 100 oxyloss

	if(total_damage)
		if(oxyloss >= 40)
			user.visible_message("<span class='danger'>\The [user] slit [src]'s throat open with \the [W]!</span>")
		else
			user.visible_message("<span class='danger'>\The [user] cut [src]'s neck with \the [W]!</span>")

		if(W.hitsound)
			playsound(loc, W.hitsound, 50, 1, -1)

	G.last_action = world.time
	flick(G.hud.icon_state, G.hud)

	admin_attack_log(user, src, "Knifed their victim", "Was knifed", "knifed")
	return 1