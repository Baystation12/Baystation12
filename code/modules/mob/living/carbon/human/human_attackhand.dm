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
			if (M == src && !get_active_hand() && (species.flags & IS_SYNTHETIC)) // Arm ripping fun!
				var/datum/organ/external/affected = get_organ(M.zone_sel.selecting)
				if (!affected.destspawn)
					if (affected.body_part == UPPER_TORSO)
						return // Don't rip your own chest out, it's rude.
					if (affected.body_part == HEAD || affected.body_part == LOWER_TORSO) // Takes its time to rip. Also methods of suicide, so do that check.
						var/permitted = 0
						var/list/allowed = list("Syndicate","traitor","Wizard","Head Revolutionary","Cultist","Changeling")
						for(var/T in allowed)
							if(mind.special_role == T)
								permitted = 1
								break
						if(permitted || check_rights(R_MOD|R_ADMIN, 0)) // Admins can also rip off their limbs. They know best.
							visible_message("\red [src] is trying to rip off their [affected.display_name]!", "\red You start ripping off your [affected.display_name]")
							spawn(rand(100, 200)) // After 10 - 20 seconds, PLOP.
								if (get_organ(M.zone_sel.selecting)==affected && M.a_intent == "grab" && !M.lying && !affected.destspawn) // If they haven't stopped.
									visible_message("\red [src] rips their own [affected.display_name] off.", "\red You rip your own [affected.display_name] off. Why the hell did you think that was a good idea?")
									affected.droplimb(1, 0, 1, 0)
									handle_organs(1)
								else
									visible_message("\blue [src] decides ripping their [affected.display_name] off may not be the best idea.", "\blue You stop ripping off your [affected.display_name]. Thank god.")
						else
							src << "You cannot do that, as it will kill you. A-Help if you need to die, or dismember that."
							message_admins("[ckey] ([src]) has tried to rip off their [affected.display_name], but they were not permitted due to not being antagonist as human.", 1)
					else
						visible_message("\blue [src] detaches their own [affected.display_name].", "\blue You detach your [affected.display_name].")
						var/organ = affected.droplimb(1, 0, 0, 0) // If this isn't a robo limb, what the fuck.
						if (istype(organ, /obj/item/robot_parts))
							var/obj/item/robot_parts/robolimb = organ
							var/datum/organ/external/handy = hand ? organs_by_name["l_hand"] : organs_by_name["r_hand"]
							handle_organs(1)
							if (handy && !handy.destspawn) // Incase they are ripping off that arm.
								put_in_active_hand(robolimb) // Took me too long to find that proc. Also, Defining robolimb instead of just using organ is DEFINANTLY required. For raisons
				else if (affected.body_part != UPPER_TORSO)
					M << "\red You try to detach your [affected.display_name] but really, there's nothing there."
				return
			if(M == src || anchored)
				return 0
			if(w_uniform)
				w_uniform.add_fingerprint(M)

			if(istype(M.get_inactive_hand(), /obj/item/weapon/grab) && M.species) // Do they have a grab in their other hand?
				var/datum/organ/external/affected = get_organ(M.zone_sel.selecting)
				if (affected.body_part != UPPER_TORSO && !affected.destspawn) // Can't grab the chest. Pervert.
					if (!ripping)
						var/TugText = "tugging at"
						var/TuggedText = "tugged at"
						if(M.species.flags & IS_STRONG)
							TugText = "ripping off"
							TuggedText = "ripped off"
						if(HULK in M.mutations)
							TugText = "dismembering"
							TuggedText = "dismembered"
						if (TugText=="tugging at"&&affected.name=="groin")
							return
						visible_message("<span class='danger'>[M] starts [TugText] [src]'s [affected.display_name]</span>", "<span class='danger'>[M] starts [TugText] your [affected.display_name]!</span>") // Begin tugging.
						var/tugTime = 150
						if(affected.name == "head" || affected.name == "groin")
							tugTime = 600 // Important limbs'll take a WHILE.
						if(affected.name == "l_arm" || affected.name == "r_arm" || affected.name == "l_leg" || affected.name == "r_leg")
							tugTime = 300
						if(affected.status & ORGAN_ROBOT)
							tugTime = tugTime/2 // Easier to rip off. Still likely messy.
						if(HULK in M.mutations)
							tugTime = tugTime/10
						M.attack_log += text("\[[time_stamp()]\] <font color='red'>Began [TugText] [src.name] ([src.ckey])'s [affected.name]</font>")
						src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Had their [affected.name] tugged at by [M.name] ([M.ckey])</font>")
						if (M.species.flags & IS_STRONG || affected.status & ORGAN_ROBOT)
							msg_admin_attack("[key_name(M)] began [TugText] [key_name(src)]'s [affected.name] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)") // Tell all the admins that ARM RIPPING FUN.
						ripping = 1
						spawn(tugTime)
							var/CanRip = 0
							if (M.species.flags & IS_STRONG)
								CanRip = 1
							if (affected.status & ORGAN_ROBOT)
								CanRip = 1
							if (HULK in M.mutations)
								CanRip = 1
							if (ripping && (CanRip) && istype(M.get_inactive_hand(), /obj/item/weapon/grab) && M.a_intent == "grab" && M.Adjacent(src) && !M.lying && !affected.destspawn && get_organ(M.zone_sel.selecting)==affected) // Are we still ripping?
								affected.droplimb(1) // RIP.
								M.attack_log += text("\[[time_stamp()]\] <font color='red'>Ripped off [src.name] ([src.ckey])'s [affected.name]</font>")
								src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Had their [affected.name] ripped off by [M.name] ([M.ckey])</font>")
								msg_admin_attack("[key_name(M)] ripped off [key_name(src)]'s [affected.name] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")
								visible_message("<span class='danger'>[M] ripped off [src]'s [affected.display_name]!</span>", "<span class='danger'>[M] ripped off your [affected.display_name]!</span>")
							else
								M.attack_log += text("\[[time_stamp()]\] <font color='red'>Stopped [TugText] [src.name] ([src.ckey])'s [affected.name]</font>")
								src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Stopped having their [affected.name] [TuggedText] by [M.name] ([M.ckey])</font>")
								if (M.species.flags & IS_STRONG)
									msg_admin_attack("[key_name(M)] stopped [TugText] [key_name(src)]'s [affected.name]")
								//visible_message("\blue [M] stopped [TugText] [src]'s [affected.display_name].", "\blue [M] stopped [TugText] your [affected.display_name].") Gawd that's annoying.]
							ripping = 0
					else
						M << "\red You are all ready ripping off a limb! Wait!"
					return


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
			//Vampire code
			if(M.zone_sel && M.zone_sel.selecting == "head" && src != M)
				if(M.mind && M.mind.vampire && (M.mind in ticker.mode.vampires) && !M.mind.vampire.draining)
					if((head && (head.flags & HEADCOVERSMOUTH)) || (wear_mask && (wear_mask.flags & MASKCOVERSMOUTH)))
						M << "\red Remove their mask!"
						return 0
					if((H.head && (H.head.flags & HEADCOVERSMOUTH)) || (M.wear_mask && (M.wear_mask.flags & MASKCOVERSMOUTH)))
						M << "\red Remove your mask!"
						return 0
					if(mind && mind.vampire && (mind in ticker.mode.vampires))
						M << "\red Your fangs fail to pierce [src.name]'s cold flesh"
						return 0
					//we're good to suck the blood, blaah
					M.handle_bloodsucking(src)
					return
			//end vampire codes

			if(!istype(H))
				attack_generic(H,rand(1,3),"punched")
				return

			var/rand_damage = rand(1, 5)
			var/block = 0
			var/accurate = 0
			var/hit_zone = H.zone_sel.selecting
			var/datum/organ/external/affecting = get_organ(hit_zone)

			switch(src.a_intent)
				if("help")
					// We didn't see this coming, so we get the full blow
					rand_damage = 5
					accurate = 1
				if("hurt", "grab")
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

			/*M.attack_log += text("\[[time_stamp()]\] <font color='red'>[pick(attack.attack_verb)]ed [src.name] ([src.ckey])</font>")
			msg_admin_attack("[key_name(M)] [pick(attack.attack_verb)]ed [key_name(src)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")*/
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
				attack_message = "[H] went for [src]'s [affecting.display_name] but was blocked!"
				miss_type = 2

			// See what attack they use
			var/datum/unarmed_attack/attack = null
			for(var/datum/unarmed_attack/u_attack in H.species.unarmed_attacks)
				if(!u_attack.is_usable(H, src, hit_zone))
					continue
				else
					attack = u_attack
					break
			if(!attack)
				return 0

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

		if("disarm")
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>Disarmed [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been disarmed by [M.name] ([M.ckey])</font>")

			msg_admin_attack("[key_name(M)] disarmed [src.name] ([src.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")

			if(w_uniform)
				w_uniform.add_fingerprint(M)
			var/datum/organ/external/affecting = get_organ(ran_zone(M.zone_sel.selecting))

			if(istype(r_hand,/obj/item/weapon/gun) || istype(l_hand,/obj/item/weapon/gun))
				var/obj/item/weapon/gun/W = null
				var/chance = 0

				if (istype(l_hand,/obj/item/weapon/gun))
					W = l_hand
					chance += hand ? 40 : 20

				else if (istype(r_hand,/obj/item/weapon/gun))
					W = r_hand
					chance += !hand ? 40 : 20

				if (prob(chance))
					visible_message("<span class='danger'>[src]'s [W.name] goes off during struggle!")
					var/list/turfs = list()
					for(var/turf/T in view())
						turfs += T
					var/turf/target = pick(turfs)
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
