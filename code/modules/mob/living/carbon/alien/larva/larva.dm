//This is fine right now, if we're adding organ specific damage this needs to be updated
/mob/living/carbon/alien/larva/New()
	var/datum/reagents/R = new/datum/reagents(100)
	reagents = R
	R.my_atom = src
	if(name == "alien larva")
		name = text("alien larva ([rand(1, 1000)])")
	real_name = name
	spawn (1)
		update_clothing()
		src << "\blue Your icons have been generated!"
//	spawn(1200) grow()  Grow after 120 seconds -- TLE Commented out because life.dm has better version -- Urist
	..()

/mob/living/carbon/alien/larva/proc/mind_initialize(mob/G, alien_caste)
	mind = new
	mind.current = src
	mind.assigned_role = "Alien"
	mind.special_role = alien_caste
	mind.key = G.key

//This is fine, works the same as a human
/mob/living/carbon/alien/larva/Bump(atom/movable/AM as mob|obj, yes)

	spawn( 0 )
		if ((!( yes ) || now_pushing))
			return
		now_pushing = 1
		if(ismob(AM))
			var/mob/tmob = AM
			if(istype(tmob, /mob/living/carbon/human) && tmob.mutations & FAT)
				/*if(prob(70))
					for(var/mob/M in viewers(src, null))
						if(M.client)
							M << "\red <B>[src] fails to push [tmob]'s fat ass out of the way.</B>"
					now_pushing = 0
					return*/
				if(tmob.nopush)
					now_pushing = 0
					return
			tmob.LAssailant = src

		now_pushing = 0
		..()
		if (!( istype(AM, /atom/movable) ))
			return
		if (!( now_pushing ))
			now_pushing = 1
			if (!( AM.anchored ))
				var/t = get_dir(src, AM)
				step(AM, t)
			now_pushing = null
		return
	return

//This needs to be fixed
/mob/living/carbon/alien/larva/Stat()
	..()

	statpanel("Status")
	if (client && client.holder)
		stat(null, "([x], [y], [z])")

	stat(null, "Intent: [a_intent]")
	stat(null, "Move Mode: [m_intent]")

	if (client.statpanel == "Status")
		stat(null, "Progress: [amount_grown]/200")
		stat(null, "Plasma Stored: [getPlasma()]")


///mob/living/carbon/alien/larva/bullet_act(var/obj/item/projectile/Proj) taken care of in living


/mob/living/carbon/alien/larva/emp_act(severity)
	..()


/mob/living/carbon/alien/larva/ex_act(severity)
	flick("flash", flash)
/*
	if (stat == 2 && client)
		gib(1)
		return

	else if (stat == 2 && !client)
		gibs(loc, viruses)
		del(src)
		return
*/
	var/b_loss = null
	var/f_loss = null
	switch (severity)
		if (1.0)
			b_loss += 500
			gib(1)
			return

		if (2.0)

			b_loss += 60

			f_loss += 60

			ear_damage += 30
			ear_deaf += 120

		if(3.0)
			b_loss += 30
			if (prob(50))
				Paralyse(1)
			ear_damage += 15
			ear_deaf += 60

	adjustBruteLoss(b_loss)
	adjustFireLoss(f_loss)

	updatehealth()



/mob/living/carbon/alien/larva/blob_act()
	if (stat == 2)
		return
	var/shielded = 0

	var/damage = null
	if (stat != 2)
		damage = rand(10,30)

	if(shielded)
		damage /= 4

		//paralysis += 1

	show_message("\red The blob attacks you!")

	adjustFireLoss(damage)

	updatehealth()
	return

//can't unequip since it can't equip anything
/mob/living/carbon/alien/larva/u_equip(obj/item/W as obj)
	return

//can't equip anything
/mob/living/carbon/alien/larva/db_click(text, t1)
	return

/mob/living/carbon/alien/larva/meteorhit(O as obj)
	for(var/mob/M in viewers(src, null))
		if ((M.client && !( M.blinded )))
			M.show_message(text("\red [] has been hit by []", src, O), 1)
	if (health > 0)
		adjustBruteLoss((istype(O, /obj/effect/meteor/small) ? 10 : 25))
		adjustFireLoss(30)

		updatehealth()
	return

/mob/living/carbon/alien/larva/Move(a, b, flag)

	var/t7 = 1
	if (restrained())
		for(var/mob/M in range(src, 1))
			if ((M.pulling == src && M.stat == 0 && !( M.restrained() )))
				t7 = null

	if ((t7 && (pulling && ((get_dist(src, pulling) <= 1 || pulling.loc == loc) && (client && client.moving)))))
		var/turf/T = loc
		. = ..()

		if (pulling && pulling.loc)
			if(!( isturf(pulling.loc) ))
				pulling = null
				return
			else
				if(Debug)
					diary <<"pulling disappeared? at __LINE__ in mob.dm - pulling = [pulling]"
					diary <<"REPORT THIS"

		/////
		if(pulling && pulling.anchored)
			pulling = null
			return

		if (!restrained())
			var/diag = get_dir(src, pulling)
			if ((diag - 1) & diag)
			else
				diag = null
			if ((get_dist(src, pulling) > 1 || diag))
				if (ismob(pulling))
					var/mob/M = pulling
					var/ok = 1
					if (locate(/obj/item/weapon/grab, M.grabbed_by))
						if (prob(75))
							var/obj/item/weapon/grab/G = pick(M.grabbed_by)
							if (istype(G, /obj/item/weapon/grab))
								for(var/mob/O in viewers(M, null))
									O.show_message(text("\red [] has been pulled from []'s grip by []", G.affecting, G.assailant, src), 1)
								//G = null
								del(G)
						else
							ok = 0
						if (locate(/obj/item/weapon/grab, M.grabbed_by.len))
							ok = 0
					if (ok)
						var/t = M.pulling
						M.pulling = null
						step(pulling, get_dir(pulling.loc, T))
						M.pulling = t
				else
					if (pulling)
						step(pulling, get_dir(pulling.loc, T))
	else
		pulling = null
		. = ..()
	if ((s_active && !( s_active in contents ) ))
		s_active.close(src)

	for(var/mob/living/carbon/metroid/M in view(1,src))
		M.UpdateFeed(src)

	return

/mob/living/carbon/alien/larva/update_clothing()
	..()

	if (monkeyizing)
		return


	if (client)
		if (i_select)
			if (intent)
				client.screen += hud_used.intents

				var/list/L = dd_text2list(intent, ",")
				L[1] += ":-11"
				i_select.screen_loc = dd_list2text(L,",") //ICONS4, FUCKING SHIT
			else
				i_select.screen_loc = null
		if (m_select)
			if (m_int)
				client.screen += hud_used.mov_int

				var/list/L = dd_text2list(m_int, ",")
				L[1] += ":-11"
				m_select.screen_loc = dd_list2text(L,",") //ICONS4, FUCKING SHIT
			else
				m_select.screen_loc = null

	if (alien_invis)
		invisibility = 2
		if(istype(loc, /turf))//If they are standing on a turf.
			AddCamoOverlay(loc)//Overlay camo.
	else
		invisibility = 0

	for (var/mob/M in viewers(1, src))
		if ((M.client && M.machine == src))
			spawn (0)
				show_inv(M)
				return


/mob/living/carbon/alien/larva/hand_p(mob/M as mob)
	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if (M.a_intent == "hurt")
		if (istype(M.wear_mask, /obj/item/clothing/mask/muzzle))
			return
		if (health > 0)

			for(var/mob/O in viewers(src, null))
				if ((O.client && !( O.blinded )))
					O.show_message(text("\red <B>[M.name] has bit []!</B>", src), 1)
			var/damage = rand(1, 3)

			adjustBruteLoss(damage)

			updatehealth()

	return


/mob/living/carbon/alien/larva/attack_animal(mob/living/simple_animal/M as mob)
	if(M.melee_damage_upper == 0)
		M.emote("[M.friendly] [src]")
	else
		for(var/mob/O in viewers(src, null))
			O.show_message("\red <B>[M]</B> [M.attacktext] [src]!", 1)
		var/damage = rand(M.melee_damage_lower, M.melee_damage_upper)
		adjustBruteLoss(damage)
		updatehealth()



/mob/living/carbon/alien/larva/attack_paw(mob/living/carbon/monkey/M as mob)
	if(!(istype(M, /mob/living/carbon/monkey)))	return//Fix for aliens receiving double messages when attacking other aliens.

	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		M << "No attacking people at spawn, you jackass."
		return
	..()

	switch(M.a_intent)

		if ("help")
			help_shake_act(M)
		else
			if (istype(wear_mask, /obj/item/clothing/mask/muzzle))
				return
			if (health > 0)
				playsound(loc, 'bite.ogg', 50, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[M.name] has bit [src]!</B>"), 1)
				adjustBruteLoss(rand(1, 3))
				updatehealth()
	return


/mob/living/carbon/alien/larva/attack_metroid(mob/living/carbon/metroid/M as mob)
	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if(M.Victim) return // can't attack while eating!

	if (health > -100)

		for(var/mob/O in viewers(src, null))
			if ((O.client && !( O.blinded )))
				O.show_message(text("\red <B>The [M.name] has [pick("bit","slashed")] []!</B>", src), 1)

		var/damage = rand(1, 3)

		if(istype(src, /mob/living/carbon/metroid/adult))
			damage = rand(20, 40)
		else
			damage = rand(5, 35)

		adjustBruteLoss(damage)


		updatehealth()

	return

/mob/living/carbon/alien/larva/attack_hand(mob/living/carbon/human/M as mob)
	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		M << "No attacking people at spawn, you jackass."
		return

	..()

	if(M.gloves)
		if(M.gloves.cell)
			if(M.a_intent == "hurt")//Stungloves. Any contact will stun the alien.
				if(M.gloves.cell.charge >= 2500)
					M.gloves.cell.charge -= 2500

					Weaken(5)
					if (stuttering < 5)
						stuttering = 5
					Stun(5)

					for(var/mob/O in viewers(src, null))
						if ((O.client && !( O.blinded )))
							O.show_message("\red <B>[src] has been touched with the stun gloves by [M]!</B>", 1, "\red You hear someone fall.", 2)
					return
				else
					M << "\red Not enough charge! "
					return

	switch(M.a_intent)

		if ("help")
			if (health > 0)
				help_shake_act(M)
			else
				if (M.health >= -75.0)
					if ((M.head && M.head.flags & 4) || (M.wear_mask && !( M.wear_mask.flags & 32 )) )
						M << "\blue <B>Remove that mask!</B>"
						return
					var/obj/effect/equip_e/human/O = new /obj/effect/equip_e/human(  )
					O.source = M
					O.target = src
					O.s_loc = M.loc
					O.t_loc = loc
					O.place = "CPR"
					requests += O
					spawn( 0 )
						O.process()
						return

		if ("grab")
			if (M == src)
				return
			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab( M )
			G.assailant = M
			if (M.hand)
				M.l_hand = G
			else
				M.r_hand = G
			G.layer = 20
			G.affecting = src
			grabbed_by += G
			G.synch()

			LAssailant = M

			playsound(loc, 'thudswoosh.ogg', 50, 1, -1)
			for(var/mob/O in viewers(src, null))
				if ((O.client && !( O.blinded )))
					O.show_message(text("\red [] has grabbed [] passively!", M, src), 1)

		else
			var/damage = rand(1, 9)
			var/attack_verb
			switch(M.mutantrace)
				if("lizard")
					attack_verb = "scratch"
				if("plant")
					attack_verb = "slash"
				else
					attack_verb = "punch"

			if(M.type == /mob/living/carbon/human/tajaran)
				attack_verb = "slash"

			if (prob(90))
				if (M.mutations & HULK)
					damage += 5
					spawn(0)
						Paralyse(1)
						step_away(src,M,15)
						sleep(3)
						step_away(src,M,15)
				if(M.type != /mob/living/carbon/human/tajaran)
					playsound(loc, "punch", 25, 1, -1)
				else if (M.type == /mob/living/carbon/human/tajaran)
					damage += 10
					playsound(loc, 'slice.ogg', 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] has [attack_verb]ed []!</B>", M, src), 1)
				if (damage > 4.9)
					Weaken(rand(10,15))
					for(var/mob/O in viewers(M, null))
						if ((O.client && !( O.blinded )))
							O.show_message(text("\red <B>[] has weakened []!</B>", M, src), 1, "\red You hear someone fall.", 2)
				adjustBruteLoss(damage)
				updatehealth()
			else
				if(M.type != /mob/living/carbon/human/tajaran)
					playsound(loc, 'punchmiss.ogg', 25, 1, -1)
				else if (M.type == /mob/living/carbon/human/tajaran)
					playsound(loc, 'slashmiss.ogg', 25, 1, -1)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[] has attempted to [attack_verb] []!</B>", M, src), 1)
	return

/mob/living/carbon/alien/larva/attack_alien(mob/living/carbon/alien/humanoid/M as mob)
	if (!ticker)
		M << "You cannot attack people before the game has started."
		return

	if (istype(loc, /turf) && istype(loc.loc, /area/start))
		M << "No attacking people at spawn, you jackass."
		return

	..()

	switch(M.a_intent)

		if ("help")
			if(!sleeping_willingly)
				sleeping = 0
			resting = 0
			AdjustParalysis(-3)
			AdjustStunned(-3)
			AdjustWeakened(-3)
			for(var/mob/O in viewers(src, null))
				if ((O.client && !( O.blinded )))
					O.show_message(text("\blue [M.name] nuzzles [] trying to wake it up!", src), 1)

		else
			if (health > 0)
				playsound(loc, 'bite.ogg', 50, 1, -1)
				var/damage = rand(1, 3)
				for(var/mob/O in viewers(src, null))
					if ((O.client && !( O.blinded )))
						O.show_message(text("\red <B>[M.name] has bit []!</B>", src), 1)
				adjustBruteLoss(damage)
				updatehealth()
			else
				M << "\green <B>[name] is too injured for that.</B>"
	return

/mob/living/carbon/alien/larva/restrained()
	return 0

/mob/living/carbon/alien/larva/var/co2overloadtime = null
/mob/living/carbon/alien/larva/var/temperature_resistance = T0C+75

// new damage icon system
// now constructs damage icon for each organ from mask * damage field


/mob/living/carbon/alien/larva/show_inv(mob/user as mob)

	user.machine = src
	var/dat = {"
	<B><HR><FONT size=3>[name]</FONT></B>
	<BR><HR><BR>
	<BR><A href='?src=\ref[user];mach_close=mob[name]'>Close</A>
	<BR>"}
	user << browse(dat, text("window=mob[name];size=340x480"))
	onclose(user, "mob[name]")
	return

/mob/living/carbon/alien/larva/updatehealth()
	if (nodamage == 0)
	//oxyloss is only used for suicide
	//toxloss isn't used for aliens, its actually used as alien powers!!
		health = 25 - getOxyLoss() - getFireLoss() - getBruteLoss()
	else
		health = 25
		stat = 0


/* Commented out because it's duplicated in life.dm
/mob/living/carbon/alien/larva/proc/grow() // Larvae can grow into full fledged Xenos if they survive long enough -- TLE
	if(icon_state == "larva_l" && !canmove) // This is a shit death check. It is made of shit and death. Fix later.
		return
	else
		var/mob/living/carbon/alien/humanoid/A = new(loc)
		A.key = key
		del(src) */