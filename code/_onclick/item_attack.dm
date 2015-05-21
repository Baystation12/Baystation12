
// Called when the item is in the active hand, and clicked; alternately, there is an 'activate held object' verb or you can hit pagedown.
/obj/item/proc/attack_self(mob/user)
	return

// No comment
/atom/proc/attackby(obj/item/W, mob/user)
	return
/atom/movable/attackby(obj/item/W, mob/user)
	if(!(W.flags&NOBLUDGEON))
		visible_message("<span class='danger'>[src] has been hit by [user] with [W].</span>")

/mob/living/attackby(obj/item/I, mob/user)
	if(istype(I) && ismob(user))
		I.attack(src, user)


// Proximity_flag is 1 if this afterattack was called on something adjacent, in your square, or on your person.
// Click parameters is the params string from byond Click() code, see that documentation.
/obj/item/proc/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	return

//TODO: refactor mob attack code.
/*
Busy writing something else that I don't want to get mixed up in a general attack code, and I don't want to forget this so leaving a note here.
leave attackby() as handling the general case of "using an item on a mob"
attackby() will decide to call attacked_by() or not.
attacked_by() will be made a living level proc and handle the specific case of "attacking with an item to cause harm"
attacked_by() will then call attack() so that stunbatons and other weapons that have special attack effects can do their thing.
attacked_by() will handle hitting/missing/logging as it does now, and will call attack() to apply the attack effects (damage) instead of the other way around (as it is now).
*/

/obj/item/proc/attack(mob/living/M as mob, mob/living/user as mob, def_zone)

	if(!istype(M) || (can_operate(M) && do_surgery(M,user,src))) return 0

	// Knifing
	if(edge)
		for(var/obj/item/weapon/grab/G in M.grabbed_by)
			if(G.assailant == user && G.state >= GRAB_NECK && world.time >= (G.last_action + 20))
				//TODO: better alternative for applying damage multiple times? Nice knifing sound?
				M.apply_damage(20, BRUTE, "head", 0, sharp=sharp, edge=edge)
				M.apply_damage(20, BRUTE, "head", 0, sharp=sharp, edge=edge)
				M.apply_damage(20, BRUTE, "head", 0, sharp=sharp, edge=edge)
				M.adjustOxyLoss(60) // Brain lacks oxygen immediately, pass out
				flick(G.hud.icon_state, G.hud)
				G.last_action = world.time
				user.visible_message("<span class='danger'>[user] slit [M]'s throat open with \the [name]!</span>")
				user.attack_log += "\[[time_stamp()]\]<font color='red'> Knifed [M.name] ([M.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>"
				M.attack_log += "\[[time_stamp()]\]<font color='orange'> Got knifed by [user.name] ([user.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>"
				msg_admin_attack("[key_name(user)] knifed [key_name(M)] with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])" )
				return

	/////////////////////////
	user.lastattacked = M
	M.lastattacker = user

	if(!no_attack_log)
		user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [M.name] ([M.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>"
		M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])</font>"
		msg_admin_attack("[key_name(user)] attacked [key_name(M)] with [name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(damtype)])" )
	/////////////////////////

	var/power = force
	if(HULK in user.mutations)
		power *= 2

	// TODO: needs to be refactored into a mob/living level attacked_by() proc. ~Z
	user.do_attack_animation(M)
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M

		// Handle striking to cripple.
		var/dislocation_str
		if(user.a_intent == "disarm")
			dislocation_str = H.attack_joint(src, user, def_zone)
		if(H.attacked_by(src, user, def_zone) && hitsound)
			playsound(loc, hitsound, 50, 1, -1)
			spawn(1) //ugh I hate this but I don't want to root through human attack procs to print it after this call resolves.
				if(dislocation_str) user.visible_message("<span class='danger'>[dislocation_str]</span>")
			return 1
		return 0
	else
		if(attack_verb.len)
			user.visible_message("<span class='danger'>[M] has been [pick(attack_verb)] with [src] by [user]!</span>")
		else
			user.visible_message("<span class='danger'>[M] has been attacked with [src] by [user]!</span>")

		if (hitsound)
			playsound(loc, hitsound, 50, 1, -1)
		switch(damtype)
			if("brute")
				M.take_organ_damage(power)
				if(prob(33)) // Added blood for whacking non-humans too
					var/turf/simulated/location = get_turf(M)
					if(istype(location)) location.add_blood_floor(M)
			if("fire")
				if (!(COLD_RESISTANCE in M.mutations))
					M.take_organ_damage(0, power)
					M << "Aargh it burns!"
		M.updatehealth()
	add_fingerprint(user)
	return 1
