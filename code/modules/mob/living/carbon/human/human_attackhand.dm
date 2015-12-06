/mob/living/carbon/human/proc/get_unarmed_attack(var/mob/living/carbon/human/target, var/hit_zone)
	for(var/datum/unarmed_attack/u_attack in species.unarmed_attacks)
		if(u_attack.is_usable(src, target, hit_zone))
			return u_attack
	return null

/mob/living/carbon/human/attack_hand(mob/living/carbon/M as mob)

	var/mob/living/carbon/human/H = M
	if(istype(H))
		var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
		if(H.hand)
			temp = H.organs_by_name["l_hand"]
		if(!temp || !temp.is_usable())
			H << "\red You can't use your hand."
			return

	..()

	// Should this all be in Touch()?
	if(istype(H))
		if((H != src) && check_shields(0, H.name))
			visible_message("\red <B>[H] attempted to touch [src]!</B>")
			H.do_attack_animation(src)
			return 0

		if(istype(H.gloves, /obj/item/clothing/gloves/boxing/hologlove))
			H.do_attack_animation(src)
			var/damage = rand(0, 9)
			if(!damage)
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message("\red <B>[H] has attempted to punch [src]!</B>")
				return 0
			var/obj/item/organ/external/affecting = get_organ(ran_zone(H.zone_sel.selecting))
			var/armor_block = run_armor_check(affecting, "melee")

			if(HULK in H.mutations)
				damage += 5

			playsound(loc, "punch", 25, 1, -1)

			visible_message("\red <B>[H] has punched [src]!</B>")

			apply_damage(damage, HALLOSS, affecting, armor_block)
			if(damage >= 9)
				visible_message("\red <B>[H] has weakened [src]!</B>")
				apply_effect(4, WEAKEN, armor_block)

			return

	if(istype(M,/mob/living/carbon))
		M.spread_disease_to(src, "Contact")

	switch(M.a_intent)
		if(I_HELP)
			if(istype(H) && health < config.health_threshold_crit && health > config.health_threshold_dead)
				if((H.head && (H.head.flags & HEADCOVERSMOUTH)) || (H.wear_mask && (H.wear_mask.flags & MASKCOVERSMOUTH)))
					H << "<span class='notice'>Remove your mask!</span>"
					return 0
				if((head && (head.flags & HEADCOVERSMOUTH)) || (wear_mask && (wear_mask.flags & MASKCOVERSMOUTH)))
					H << "<span class='notice'>Remove [src]'s mask!</span>"
					return 0

				if (!cpr_time)
					return 0

				cpr_time = 0
				spawn(30)
					cpr_time = 1

				H.visible_message("<span class='danger'>\The [H] is trying perform CPR on \the [src]!</span>")

				if(!do_after(H, 30))
					return

				adjustOxyLoss(-(min(getOxyLoss(), 5)))
				updatehealth()
				H.visible_message("<span class='danger'>\The [H] performs CPR on \the [src]!</span>")
				src << "<span class='notice'>You feel a breath of fresh air enter your lungs. It feels good.</span>"
				H << "<span class='warning'>Repeat at least every 7 seconds.</span>"

			else
				help_shake_act(M)
			return 1

		if(I_GRAB)
			if(M == src || anchored)
				return 0
			for(var/obj/item/weapon/grab/G in src.grabbed_by)
				if(G.assailant == M)
					M << "<span class='notice'>You already grabbed [src].</span>"
					return
			if(w_uniform)
				w_uniform.add_fingerprint(M)

			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, src)
			if(buckled)
				M << "<span class='notice'>You cannot grab [src], \he is buckled in!</span>"
			if(!G)	//the grab will delete itself in New if affecting is anchored
				return
			M.put_in_active_hand(G)
			G.synch()
			LAssailant = M

			H.do_attack_animation(src)
			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			visible_message("<span class='warning'>[M] has grabbed [src] passively!</span>")
			return 1

		if(I_HURT)

			if(!istype(H))
				attack_generic(H,rand(1,3),"punched")
				return

			var/rand_damage = rand(1, 5)
			var/block = 0
			var/accurate = 0
			var/hit_zone = H.zone_sel.selecting
			var/obj/item/organ/external/affecting = get_organ(hit_zone)

			if(!affecting || affecting.is_stump())
				M << "<span class='danger'>They are missing that limb!</span>"
				return 1

			switch(src.a_intent)
				if(I_HELP)
					// We didn't see this coming, so we get the full blow
					rand_damage = 5
					accurate = 1
				if(I_HURT, I_GRAB)
					// We're in a fighting stance, there's a chance we block
					if(src.canmove && src!=H && prob(20))
						block = 1

			if (M.grabbed_by.len)
				// Someone got a good grip on them, they won't be able to do much damage
				rand_damage = max(1, rand_damage - 2)

			if(src.grabbed_by.len || src.buckled || !src.canmove || src==H)
				accurate = 1 // certain circumstances make it impossible for us to evade punches
				rand_damage = 5

			// Process evasion and blocking
			var/miss_type = 0
			var/attack_message
			if(!accurate)
				/* ~Hubblenaut
					This place is kind of convoluted and will need some explaining.
					ran_zone() will pick out of 11 zones, thus the chance for hitting
					our target where we want to hit them is circa 9.1%.

					Now since we want to statistically hit our target organ a bit more
					often than other organs, we add a base chance of 20% for hitting it.

					This leaves us with the following chances:

					If aiming for chest:
						27.3% chance you hit your target organ
						70.5% chance you hit a random other organ
						 2.2% chance you miss

					If aiming for something else:
						23.2% chance you hit your target organ
						56.8% chance you hit a random other organ
						15.0% chance you miss

					Note: We don't use get_zone_with_miss_chance() here since the chances
						  were made for projectiles.
					TODO: proc for melee combat miss chances depending on organ?
				*/
				if(prob(80))
					hit_zone = ran_zone(hit_zone)
				if(prob(15) && hit_zone != "chest") // Missed!
					if(!src.lying)
						attack_message = "[H] attempted to strike [src], but missed!"
					else
						attack_message = "[H] attempted to strike [src], but \he rolled out of the way!"
						src.set_dir(pick(cardinal))
					miss_type = 1

			if(!miss_type && block)
				attack_message = "[H] went for [src]'s [affecting.name] but was blocked!"
				miss_type = 2

			// See what attack they use
			var/datum/unarmed_attack/attack = H.get_unarmed_attack(src, hit_zone)
			if(!attack)
				return 0

			H.do_attack_animation(src)
			if(!attack_message)
				attack.show_attack(H, src, hit_zone, rand_damage)
			else
				H.visible_message("<span class='danger'>[attack_message]</span>")

			playsound(loc, ((miss_type) ? (miss_type == 1 ? attack.miss_sound : 'sound/weapons/thudswoosh.ogg') : attack.attack_sound), 25, 1, -1)
			H.attack_log += text("\[[time_stamp()]\] <font color='red'>[miss_type ? (miss_type == 1 ? "Missed" : "Blocked") : "[pick(attack.attack_verb)]"] [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>[miss_type ? (miss_type == 1 ? "Was missed by" : "Has blocked") : "Has Been [pick(attack.attack_verb)]"] by [H.name] ([H.ckey])</font>")
			msg_admin_attack("[key_name(H)] [miss_type ? (miss_type == 1 ? "has missed" : "was blocked by") : "has [pick(attack.attack_verb)]"] [key_name(src)]")

			if(miss_type)
				return 0

			var/real_damage = rand_damage
			real_damage += attack.get_unarmed_damage(H)
			real_damage *= damage_multiplier
			rand_damage *= damage_multiplier
			if(HULK in H.mutations)
				real_damage *= 2 // Hulks do twice the damage
				rand_damage *= 2
			real_damage = max(1, real_damage)

			var/armour = run_armor_check(affecting, "melee")
			// Apply additional unarmed effects.
			attack.apply_effects(H, src, armour, rand_damage, hit_zone)

			// Finally, apply damage to target
			apply_damage(real_damage, BRUTE, affecting, armour, sharp=attack.sharp, edge=attack.edge)

		if(I_DISARM)
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>Disarmed [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been disarmed by [M.name] ([M.ckey])</font>")

			msg_admin_attack("[key_name(M)] disarmed [src.name] ([src.ckey])")
			M.do_attack_animation(src)

			if(w_uniform)
				w_uniform.add_fingerprint(M)
			var/obj/item/organ/external/affecting = get_organ(ran_zone(M.zone_sel.selecting))

			var/list/holding = list(get_active_hand() = 40, get_inactive_hand = 20)

			//See if they have any guns that might go off
			for(var/obj/item/weapon/gun/W in holding)
				if(W && prob(holding[W]))
					var/list/turfs = list()
					for(var/turf/T in view())
						turfs += T
					if(turfs.len)
						var/turf/target = pick(turfs)
						visible_message("<span class='danger'>[src]'s [W] goes off during the struggle!</span>")
						return W.afterattack(target,src)

			var/randn = rand(1, 100)
			if(!(species.flags & NO_SLIP) && randn <= 25)
				var/armor_check = run_armor_check(affecting, "melee")
				apply_effect(3, WEAKEN, armor_check)
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				if(armor_check < 2)
					visible_message("<span class='danger'>[M] has pushed [src]!</span>")
				else
					visible_message("<span class='warning'>[M] attempted to push [src]!</span>")
				return

			if(randn <= 60)
				//See about breaking grips or pulls
				if(break_all_grabs(M))
					playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
					return

				//Actually disarm them
				for(var/obj/item/I in holding)
					if(I)
						drop_from_inventory(I)
						visible_message("<span class='danger'>[M] has disarmed [src]!</span>")
						playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
						return

			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			visible_message("\red <B>[M] attempted to disarm [src]!</B>")
	return

/mob/living/carbon/human/proc/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, inrange, params)
	return

/mob/living/carbon/human/attack_generic(var/mob/user, var/damage, var/attack_message)

	if(!damage)
		return

	user.attack_log += text("\[[time_stamp()]\] <font color='red'>attacked [src.name] ([src.ckey])</font>")
	src.attack_log += text("\[[time_stamp()]\] <font color='orange'>was attacked by [user.name] ([user.ckey])</font>")
	src.visible_message("<span class='danger'>[user] has [attack_message] [src]!</span>")
	user.do_attack_animation(src)

	var/dam_zone = pick("head", "chest", "l_arm", "r_arm", "l_leg", "r_leg", "groin")
	var/obj/item/organ/external/affecting = get_organ(ran_zone(dam_zone))
	var/armor_block = run_armor_check(affecting, "melee")
	apply_damage(damage, BRUTE, affecting, armor_block)
	updatehealth()
	return 1

/mob/living/carbon/human/proc/attack_joint(var/obj/item/W, var/mob/living/user, var/def_zone)
	if(!def_zone) def_zone = user.zone_sel.selecting
	var/target_zone = get_zone_with_miss_chance(check_zone(def_zone), src)

	if(user == src) // Attacking yourself can't miss
		target_zone = user.zone_sel.selecting
	if(!target_zone)
		return null
	var/obj/item/organ/external/organ = get_organ(check_zone(target_zone))
	if(!organ || (organ.dislocated == 2) || (organ.dislocated == -1))
		return null
	var/dislocation_str
	if(prob(W.force))
		dislocation_str = "[src]'s [organ.joint] [pick("gives way","caves in","crumbles","collapses")]!"
		organ.dislocate(1)
	return dislocation_str

//Used to attack a joint through grabbing
/mob/living/carbon/human/proc/grab_joint(var/mob/living/user, var/def_zone)
	var/has_grab = 0
	for(var/obj/item/weapon/grab/G in list(user.l_hand, user.r_hand))
		if(G.affecting == src && G.state == GRAB_NECK)
			has_grab = 1
			break

	if(!has_grab)
		return 0

	if(!def_zone) def_zone = user.zone_sel.selecting
	var/target_zone = check_zone(def_zone)
	if(!target_zone)
		return 0
	var/obj/item/organ/external/organ = get_organ(check_zone(target_zone))
	if(!organ || organ.is_dislocated() || organ.dislocated == -1)
		return 0

	user.visible_message("<span class='warning'>[user] begins to dislocate [src]'s [organ.joint]!</span>")
	if(do_after(user, 100))
		organ.dislocate(1)
		src.visible_message("<span class='danger'>[src]'s [organ.joint] [pick("gives way","caves in","crumbles","collapses")]!</span>")
		return 1
	return 0

//Breaks all grips and pulls that the mob currently has.
/mob/living/carbon/human/proc/break_all_grabs(mob/living/carbon/user)
	var/success = 0
	if(pulling)
		visible_message("<span class='danger'>[user] has broken [src]'s grip on [pulling]!</span>")
		success = 1
		stop_pulling()

	if(istype(l_hand, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/lgrab = l_hand
		if(lgrab.affecting)
			visible_message("<span class='danger'>[user] has broken [src]'s grip on [lgrab.affecting]!</span>")
			success = 1
		spawn(1)
			qdel(lgrab)
	if(istype(r_hand, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/rgrab = r_hand
		if(rgrab.affecting)
			visible_message("<span class='danger'>[user] has broken [src]'s grip on [rgrab.affecting]!</span>")
			success = 1
		spawn(1)
			qdel(rgrab)
	return success
