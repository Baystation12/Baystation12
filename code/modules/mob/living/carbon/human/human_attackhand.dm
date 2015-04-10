/mob/living/carbon/human/attack_hand(mob/living/carbon/human/M as mob)
	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		M << "No attacking people at spawn, you jackass."
		return

	var/datum/organ/external/temp = M:organs_by_name["r_hand"]
	if (M.hand)
		temp = M:organs_by_name["l_hand"]
	if(temp && !temp.is_usable())
		M << "\red You can't use your [temp.display_name]."
		return

	..()

	if((M != src) && check_shields(0, M.name))
		visible_message("\red <B>[M] attempted to touch [src]!</B>")
		return 0


	if(M.gloves && istype(M.gloves,/obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.cell)
			if(M.a_intent == "hurt")//Stungloves. Any contact will stun the alien.
				if(G.cell.charge >= 2500)
					G.cell.use(2500)
					visible_message("\red <B>[src] has been touched with the stun gloves by [M]!</B>")
					M.attack_log += text("\[[time_stamp()]\] <font color='red'>Stungloved [src.name] ([src.ckey])</font>")
					src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been stungloved by [M.name] ([M.ckey])</font>")

					msg_admin_attack("[M.name] ([M.ckey]) stungloved [src.name] ([src.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[M.x];Y=[M.y];Z=[M.z]'>JMP</a>)")

					var/armorblock = run_armor_check(M.zone_sel.selecting, "energy")
					apply_effects(5,5,0,0,5,0,0,armorblock)
					return 1
				else
					M << "\red Not enough charge! "
					visible_message("\red <B>[src] has been touched with the stun gloves by [M]!</B>")
				return

		if(istype(M.gloves , /obj/item/clothing/gloves/boxing/hologlove))

			var/damage = rand(0, 9)
			if(!damage)
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message("\red <B>[M] has attempted to punch [src]!</B>")
				return 0
			var/datum/organ/external/affecting = get_organ(ran_zone(M.zone_sel.selecting))
			var/armor_block = run_armor_check(affecting, "melee")

			if(HULK in M.mutations)			damage += 5

			playsound(loc, "punch", 25, 1, -1)

			visible_message("\red <B>[M] has punched [src]!</B>")

			apply_damage(damage, HALLOSS, affecting, armor_block)
			if(damage >= 9)
				visible_message("\red <B>[M] has weakened [src]!</B>")
				apply_effect(4, WEAKEN, armor_block)

			return
	else
		if(istype(M,/mob/living/carbon))
//			log_debug("No gloves, [M] is truing to infect [src]")
			M.spread_disease_to(src, "Contact")


	switch(M.a_intent)
		if("help")
			if(health >= config.health_threshold_crit)
				help_shake_act(M)
				return 1
//			if(M.health < -75)	return 0

			if((M.head && (M.head.flags & HEADCOVERSMOUTH)) || (M.wear_mask && (M.wear_mask.flags & MASKCOVERSMOUTH)))
				M << "\blue <B>Remove your mask!</B>"
				return 0
			if((head && (head.flags & HEADCOVERSMOUTH)) || (wear_mask && (wear_mask.flags & MASKCOVERSMOUTH)))
				M << "\blue <B>Remove their mask!</B>"
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
					if((M.head && (M.head.flags & HEADCOVERSMOUTH)) || (M.wear_mask && (M.wear_mask.flags & MASKCOVERSMOUTH)))
						M << "\red Remove your mask!"
						return 0
					if(mind && mind.vampire && (mind in ticker.mode.vampires))
						M << "\red Your fangs fail to pierce [src.name]'s cold flesh"
						return 0
					//we're good to suck the blood, blaah
					M.handle_bloodsucking(src)
					return
			//end vampire codes
			// See if they can attack, and which attacks to use.
			var/datum/unarmed_attack/attack = M.species.unarmed
			if(!attack.is_usable(M))
				attack = M.species.secondary_unarmed
			if(!attack.is_usable(M))
				return 0

			M.attack_log += text("\[[time_stamp()]\] <font color='red'>[pick(attack.attack_verb)]ed [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been [pick(attack.attack_verb)]ed by [M.name] ([M.ckey])</font>")
			msg_admin_attack("[key_name(M)] [pick(attack.attack_verb)]ed [key_name(src)] (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")

			var/damage = rand(0, 5)//BS12 EDIT
			if(!damage)
				playsound(loc, attack.miss_sound, 25, 1, -1)
				visible_message("\red <B>[M] tried to [pick(attack.attack_verb)] [src]!</B>")
				return 0


			var/datum/organ/external/affecting = get_organ(ran_zone(M.zone_sel.selecting))
			var/armor_block = run_armor_check(affecting, "melee")

			if(HULK in M.mutations)			damage += 5


			playsound(loc, attack.attack_sound, 25, 1, -1)

			visible_message("\red <B>[M] [pick(attack.attack_verb)]ed [src]!</B>")
			//Rearranged, so claws don't increase weaken chance.
			if(damage >= 5 && prob(50))
				visible_message("\red <B>[M] has weakened [src]!</B>")
				apply_effect(3, WEAKEN, armor_block)

			damage += attack.damage
			apply_damage(damage, BRUTE, affecting, armor_block, sharp=attack.sharp, edge=attack.edge)


		if("disarm")
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>Disarmed [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been disarmed by [M.name] ([M.ckey])</font>")

			msg_admin_attack("[key_name(M)] disarmed [src.name] ([src.ckey]) (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[src.x];Y=[src.y];Z=[src.z]'>JMP</a>)")

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