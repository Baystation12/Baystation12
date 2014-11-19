/mob/living/carbon/human/attack_hand(mob/living/carbon/M as mob)

	var/mob/living/carbon/human/H = M
	if(istype(H))
		var/datum/organ/external/temp = H.organs_by_name["r_hand"]
		if(H.hand)
			temp = H.organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			H << "\red You can't use your [temp.display_name]."
			return

	..()

	// Should this all be in Touch()?
	if(istype(H))
		if((H != src) && check_shields(0, H.name))
			visible_message("\red <B>[H] attempted to touch [src]!</B>")
			return 0

		if(istype(H.gloves, /obj/item/clothing/gloves/boxing/hologlove))

			var/damage = rand(0, 9)
			if(!damage)
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message("\red <B>[H] has attempted to punch [src]!</B>")
				return 0
			var/datum/organ/external/affecting = get_organ(ran_zone(H.zone_sel.selecting))
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
		if("help")

			if(istype(H) && health < config.health_threshold_crit)

				if((H.head && (H.head.flags & HEADCOVERSMOUTH)) || (H.wear_mask && (H.wear_mask.flags & MASKCOVERSMOUTH)))
					H << "\blue <B>Remove your mask!</B>"
					return 0
				if((head && (head.flags & HEADCOVERSMOUTH)) || (wear_mask && (wear_mask.flags & MASKCOVERSMOUTH)))
					H << "\blue <B>Remove [src]'s mask!</B>"
					return 0

				var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human()
				O.source = M
				O.target = src
				O.s_loc = M.loc
				O.t_loc = loc
				O.place = "CPR"
				requests += O
				spawn(0)
					O.process()
			else
				help_shake_act(M)
			return 1

		if("grab")
			if(M == src || anchored)
				return 0
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

			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			visible_message("<span class='warning'>[M] has grabbed [src] passively!</span>")
			return 1

		if("hurt")

			if(!istype(H))
				attack_generic(H,rand(1,3),"punched")
				return

			// See if they can attack, and which attacks to use.
			var/datum/unarmed_attack/attack = H.species.unarmed
			if(!attack.is_usable(H))
				attack = H.species.secondary_unarmed
			if(!attack.is_usable(H))
				return 0 // COMMENT: This means that there's no way the secondary attack gets used, ever. Needs work ~Hubble

			if(attack_move)	return 0

			var/damage = rand(1, 5)
			var/block = 0
			var/accurate = 0
			var/target_zone = check_zone(H.zone_sel.selecting) // The zone that was targeted
			var/hit_zone = target_zone // The zone that is actually hit
			var/datum/organ/external/affecting = get_organ(hit_zone)

			// Snowflakey magboot stomp
			if(src.lying && H.canmove && !H.lying && H.shoes && istype(H.shoes, /obj/item/clothing/shoes/magboots))
				var/obj/item/clothing/shoes/magboots/mboots = H.shoes
				if(mboots.magpulse)
					visible_message("\red [H] raises one of \his magboots over [src]'s [affecting.display_name]...")
					attack_move = 1
					spawn(20)
						if(H.canmove && !H.lying && H.Adjacent(src) && src.lying)
							visible_message("\red <B>[H] stomps \his magboot down on [src]'s [affecting.display_name] with full force!</B>")
							apply_damage(rand(20,30), BRUTE, affecting, run_armor_check(affecting, "melee"))
							playsound(loc, 'sound/weapons/genhit3.ogg', 25, 1, -1)
							attack_move = 0

							H.attack_log += text("\[[time_stamp()]\] <font color='red'>Magboot-stomped [src.name] ([src.ckey])</font>")
							src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been magboot-stomped by [M.name] ([M.ckey])</font>")
							msg_admin_attack("[key_name(M)] magboot-stomped [key_name(src)]")
					return 0

			switch(src.a_intent)
				if("help")
					// We didn't see this coming, so we get the full blow
					damage = 5
					accurate = 1
				if("hurt", "grab")
					// We're in a fighting stance, there's a chance we block
					if(prob(20) && src.canmove && (!src==M))
						block = 1

			if (M.grabbed_by.len)
				// Someone got a good grip on them, they won't be able to do much damage
				damage = max(0, damage - 2)

			if(src.grabbed_by.len || src.buckled || !src.canmove || src==M)
				accurate = 1 // certain circumstances make it impossible for us to evade punches

			// Process evasion and blocking
			if(!accurate)
				hit_zone = ran_zone(target_zone)
				if(prob(15) && hit_zone != "chest") // Missed!
					playsound(loc, attack.miss_sound, 25, 1, -1)
					visible_message("\red <B>[H] attempted to punch [src]!</B>")
					visible_message("\red [pick("The punch barely misses their [affecting.display_name]!", "[src] manages to dodge narrowly!")]")

					H.attack_log += text("\[[time_stamp()]\] <font color='red'>attempted to [pick(attack.attack_verb)] [src.name] ([src.ckey]) (dodged)</font>")
					src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Dodged attack by [H.name] ([H.ckey])</font>")
					msg_admin_attack("[key_name(H)] attempted to [pick(attack.attack_verb)] [key_name(src)] (dodged)")
					return 0
			if(block)
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				visible_message("\red <B>[H] went for [src]'s [affecting.display_name] but was blocked!</B>")

				H.attack_log += text("\[[time_stamp()]\] <font color='red'>attempted to [pick(attack.attack_verb)] [src.name] ([src.ckey]) (blocked)</font>")
				src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Blocked attack by [H.name] ([H.ckey])</font>")
				msg_admin_attack("[key_name(H)] attempted to [pick(attack.attack_verb)] [key_name(src)] (blocked)")
				return 0

			// Handle the attack logs
			attack.combat_log(H, src, hit_zone, damage)

			H.attack_log += text("\[[time_stamp()]\] <font color='red'>[pick(attack.attack_verb)]ed [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been [pick(attack.attack_verb)]ed by [H.name] ([H.ckey])</font>")
			msg_admin_attack("[key_name(H)] [pick(attack.attack_verb)]ed [key_name(src)]")

			// This here is where buffs go
			if(H.mind && (H.mind.special_role == "Ninja" || H.mind.special_role == "Changeling"))
				damage += 2 // We assume Ninjas and Changelings are slightly better in combat than the usual human
			if(HULK in H.mutations)
				damage *= 2 // Hulks do twice the damage

			var/armor_block = run_armor_check(affecting, "melee") // IMPORTANT: To run armor check after attack log as it produces a log itself
			var/numb = rand(0, 100)
			if(damage >= 5 && armor_block < 2 && !lying && numb <= damage*5)
				switch(hit_zone) // strong punches can have effects depending on where they hit
					if("head")
						// Induce blurriness
						visible_message("\red [src] stares blankly for a few moments.", "\red You see stars.")
						apply_effect(damage*2, EYE_BLUR, armor_block)
					if("l_arm", "l_hand")
						if (l_hand)
							// Disarm left hand
							visible_message("\red [src] [pick("dropped", "let go off")] \the [l_hand][pick("", " with a scream")]!")
							drop_l_hand()
					if("r_arm", "r_hand")
						if (r_hand)
							// Disarm right hand
							visible_message("\red [src] [pick("dropped", "let go off")] \the [r_hand][pick("", " with a scream")]!")
							drop_r_hand()
					if("chest")
						visible_message("\red [pick("[src] was sent flying backward a few metres!", "[src] staggers back from the impact!")]")
						step(src, get_dir(get_turf(M), get_turf(src)))
						apply_effect(0.4*damage, WEAKEN, armor_block)
					if("groin")
						visible_message("\red [src] looks like \he is in pain!", (gender=="female")?"\red <i>Oh god that hurt!</i>":"\red <i>Oh no, not your[pick("testicles", "crown jewels", "clockweights", "family jewels", "marbles", "bean bags", "teabags", "sweetmeats", "goolies")]!</i>")
						apply_effects(stutter=damage*2, agony=damage*3, blocked=armor_block)
					if("l_leg", "l_foot", "r_leg", "r_foot")
						visible_message("\red [src] gives way slightly.")
						apply_effect(damage*3, AGONY, armor_block)
			else if(damage >= 5 && numb >= damage*10) // Chance to get the usual throwdown as well
				visible_message("\red [src] [pick("slumps", "falls", "drops")] down to the ground!")
				apply_effect(3, WEAKEN, armor_block)

			// Sum up species damage bonus at the very end so xenos don't get buffed stun chances
			damage += attack.damage // 3 for human/skrell, 5 for tajaran/unathi

			playsound(H.loc, attack.attack_sound, 25, 1, -1)

			// Finally, apply damage to target
			apply_damage(damage, BRUTE, affecting, armor_block, sharp=attack.sharp, edge=attack.edge)

		if("disarm")
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>Disarmed [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been disarmed by [M.name] ([M.ckey])</font>")

			msg_admin_attack("[key_name(M)] disarmed [src.name] ([src.ckey])")

			if(w_uniform)
				w_uniform.add_fingerprint(M)
			var/datum/organ/external/affecting = get_organ(ran_zone(M.zone_sel.selecting))

			if (istype(r_hand,/obj/item/weapon/gun) || istype(l_hand,/obj/item/weapon/gun))
				var/obj/item/weapon/gun/W = null
				var/chance = 0

				if (istype(l_hand,/obj/item/weapon/gun))
					W = l_hand
					chance = hand ? 40 : 20

				if (istype(r_hand,/obj/item/weapon/gun))
					W = r_hand
					chance = !hand ? 40 : 20

				if (prob(chance))
					visible_message("<spawn class=danger>[src]'s [W] goes off during struggle!")
					var/list/turfs = list()
					for(var/turf/T in view())
						turfs += T
					var/turf/target = pick(turfs)
					return W.afterattack(target,src)

			var/randn = rand(1, 100)
			if (randn <= 25)
				apply_effect(3, WEAKEN, run_armor_check(affecting, "melee"))
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				visible_message("\red <B>[M] has pushed [src]!</B>")
				return

			var/talked = 0	// BubbleWrap

			if(randn <= 60)
				//BubbleWrap: Disarming breaks a pull
				if(pulling)
					visible_message("\red <b>[M] has broken [src]'s grip on [pulling]!</B>")
					talked = 1
					stop_pulling()

				//BubbleWrap: Disarming also breaks a grab - this will also stop someone being choked, won't it?
				if(istype(l_hand, /obj/item/weapon/grab))
					var/obj/item/weapon/grab/lgrab = l_hand
					if(lgrab.affecting)
						visible_message("\red <b>[M] has broken [src]'s grip on [lgrab.affecting]!</B>")
						talked = 1
					spawn(1)
						del(lgrab)
				if(istype(r_hand, /obj/item/weapon/grab))
					var/obj/item/weapon/grab/rgrab = r_hand
					if(rgrab.affecting)
						visible_message("\red <b>[M] has broken [src]'s grip on [rgrab.affecting]!</B>")
						talked = 1
					spawn(1)
						del(rgrab)
				//End BubbleWrap

				if(!talked)	//BubbleWrap
					drop_item()
					visible_message("\red <B>[M] has disarmed [src]!</B>")
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

	var/dam_zone = pick("head", "chest", "l_arm", "r_arm", "l_leg", "r_leg", "groin")
	var/datum/organ/external/affecting = get_organ(ran_zone(dam_zone))
	var/armor_block = run_armor_check(affecting, "melee")
	apply_damage(damage, BRUTE, affecting, armor_block)
	updatehealth()
	return 1
