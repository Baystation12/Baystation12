
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


/obj/item/proc/attack(mob/living/M as mob, mob/living/user as mob, def_zone)

	if(!istype(M) || (can_operate(M) && do_surgery(M,user,src))) return 0

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
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		var/hit = H.attacked_by(src, user, def_zone)
		if(hit && hitsound)
			playsound(loc, hitsound, 50, 1, -1)
		return hit
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
