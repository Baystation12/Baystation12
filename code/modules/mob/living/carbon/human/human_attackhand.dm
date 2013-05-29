/mob/living/carbon/human/attack_hand(mob/living/carbon/human/M as mob)
	if(..())	//to allow surgery to return properly.
		return

	var/datum/organ/external/temp = M:organs_by_name["r_hand"]
	if (M.hand)
		temp = M:organs_by_name["l_hand"]
	if(temp && !temp.is_usable())
		M << "\red You can't use your [temp.display_name]."
		return

	..()

	if((M != src) && check_shields(0, M.name))
		visible_message("<span class='warning'>[M] attempted to touch [src]!</span>")
		return 0


	if(M.gloves && istype(M.gloves,/obj/item/clothing/gloves))
		var/obj/item/clothing/gloves/G = M.gloves
		if(G.cell)
			if(M.a_intent == "hurt")//Stungloves. Any contact will stun the alien.
				if(G.cell.charge >= 2500)
					G.cell.charge -= 2500
					visible_message("<span class='danger'>[src] has been touched with the stun gloves by [M]!</span>")
					M.attack_log += text("\[[time_stamp()]\] <font color='red'>Stungloved [src.name] ([src.ckey])</font>")
					src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been stungloved by [M.name] ([M.ckey])</font>")

					log_attack("<font color='red'>[M.name] ([M.ckey]) stungloved [src.name] ([src.ckey])</font>")

					var/armorblock = run_armor_check(M.zone_sel.selecting, "energy")
					apply_effects(5,5,0,0,5,0,0,armorblock)
					return 1
				else
					M << "<span class='notice'>Not enough charge!</span>"
					visible_message("<span class='danger'>[src] has been touched with the stun gloves by [M]!</span>")
				return

		if(istype(M.gloves , /obj/item/clothing/gloves/boxing/hologlove))	//HAHAHA FUCK THIS SHIT

			var/damage = rand(0, 9)
			if(!damage)
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message("<span class='warning'>[M] has attempted to punch [src]!</span>")
				return 0
			var/datum/organ/external/affecting = get_organ(ran_zone(M.zone_sel.selecting))
			var/armor_block = run_armor_check(affecting, "melee")

			if(HULK in M.mutations)			damage += 5

			playsound(loc, "punch", 25, 1, -1)

			visible_message("<span class='danger'>[M] has punched [src]!</span>")

			apply_damage(damage, HALLOSS, affecting, armor_block)
			if(damage >= 9)
				visible_message("<span class='danger'>[M] has weakened [src]!</span>")
				apply_effect(4, WEAKEN, armor_block)

			return


	switch(M.a_intent)
		if("help")
			if(health >= config.health_threshold_crit)
				help_shake_act(M)
				return 1
//			if(M.health < -75)	return 0

			if((M.head && (M.head.flags & HEADCOVERSMOUTH)) || (M.wear_mask && (M.wear_mask.flags & MASKCOVERSMOUTH)))
				M << "<span class='notice'>Remove your mask!</span>"
				return 0
			if((head && (head.flags & HEADCOVERSMOUTH)) || (wear_mask && (wear_mask.flags & MASKCOVERSMOUTH)))
				M << "<span class='notice'>Remove his mask!</span>"
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
			if(M == src)	return 0
			if(w_uniform)	w_uniform.add_fingerprint(M)
			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, M, src)

			M.put_in_active_hand(G)

			grabbed_by += G
			G.synch()
			LAssailant = M

			playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			visible_message("<span class='warning'>[M] has grabbed [src] passively!</span>")
			return 1

		if("hurt")

			var/attack_verb = "punch"
			if(src.lying)
				attack_verb = "kick"
			else if(M.dna)
				switch(M.dna.mutantrace)
					if("lizard")
						attack_verb = "scratch"
					if("tajaran")
						attack_verb = "scratch"
					if("plant")
						attack_verb = "slash"

			M.attack_log += text("\[[time_stamp()]\] <font color='red'>[attack_verb]ed [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been [attack_verb]ed by [M.name] ([M.ckey])</font>")

			log_attack("<font color='red'>[M.name] ([M.ckey]) [attack_verb]ed [src.name] ([src.ckey])</font>")

			var/damage = rand(0, 5)//BS12 EDIT
			if(!damage)
				switch(attack_verb)
					if("slash")
						playsound(loc, 'sound/weapons/slashmiss.ogg', 25, 1, -1)
					if("scratch")
						playsound(loc, 'sound/weapons/slashmiss.ogg', 25, 1, -1)
					else
						playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)

				visible_message("<span class='warning'>[M] has attempted to [attack_verb] [src]!</span>")
				return 0


			var/datum/organ/external/affecting = get_organ(ran_zone(M.zone_sel.selecting))
			var/armor_block = run_armor_check(affecting, "melee")

			if(HULK in M.mutations)			damage += 5


			switch(attack_verb)
				if("slash")
					playsound(loc, 'sound/weapons/slice.ogg', 25, 1, -1)
				if("scratch")
					playsound(loc, 'sound/weapons/slice.ogg', 25, 1, -1)
				else
					playsound(loc, "punch", 25, 1, -1)

			visible_message("<span class='danger'>[M] has [attack_verb]ed [src]!</span>")
			//Rearranged, so claws don't increase weaken chance.
			if(damage >= 5 && prob(50))
				visible_message("\red <B>[M] has weakened [src]!</B>")
				apply_effect(2, WEAKEN, armor_block)

			if(attack_verb == "scratch")	damage += 5
			apply_damage(damage, BRUTE, affecting, armor_block)
			if(damage >= 9)
				visible_message("<span class='danger'>[M] has weakened [src]!</span>")
				apply_effect(4, WEAKEN, armor_block)


		if("disarm")
			M.attack_log += text("\[[time_stamp()]\] <font color='red'>Disarmed [src.name] ([src.ckey])</font>")
			src.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been disarmed by [M.name] ([M.ckey])</font>")

			log_admin("ATTACK: [M.name] ([M.ckey]) disarmed [src.name] ([src.ckey])")
			log_attack("<font color='red'>[M.name] ([M.ckey]) disarmed [src.name] ([src.ckey])</font>")


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
			if(randn <= 25)
				apply_effect(4, WEAKEN, run_armor_check(affecting, "melee"))
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				visible_message("<span class='danger'>[M] has pushed [src]!</span>")
				return

			var/talked = 0	// BubbleWrap

			if(randn <= 60)
				//BubbleWrap: Disarming breaks a pull
				if(pulling)
					visible_message("<span class='warning'>[M] has broken [src]'s grip on [pulling]!</span>")
					talked = 1
					stop_pulling()

				//BubbleWrap: Disarming also breaks a grab - this will also stop someone being choked, won't it?
				if(istype(l_hand, /obj/item/weapon/grab))
					var/obj/item/weapon/grab/lgrab = l_hand
					if(lgrab.affecting)
						visible_message("<span class='warning'>[M] has broken [src]'s grip on [lgrab.affecting]!</span>")
						talked = 1
					spawn(1)
						del(lgrab)
				if(istype(r_hand, /obj/item/weapon/grab))
					var/obj/item/weapon/grab/rgrab = r_hand
					if(rgrab.affecting)
						visible_message("<span class='warning'>[M] has broken [src]'s grip on [rgrab.affecting]!</span>")
						talked = 1
					spawn(1)
						del(rgrab)
				//End BubbleWrap

				if(!talked)	//BubbleWrap
					drop_item()
					visible_message("<span class='danger'>[M] has disarmed [src]!</span>")
				playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
				return


			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			visible_message("<span class='warning'>[M] attempted to disarm [src]!</span>")
	return

/mob/living/carbon/human/proc/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, inrange, params)
	return