
/obj/item/proc/attack_self()
	return

/obj/item/proc/talk_into(mob/M as mob, text)
	return

/obj/item/proc/moved(mob/user as mob, old_loc as turf)
	return

/obj/item/proc/dropped(mob/user as mob)
	..()

// called just as an item is picked up (loc is not yet changed)
/obj/item/proc/pickup(mob/user)
	return

// called when this item is removed from a storage item, which is passed on as S. The loc variable is already set to the new destination before this is called.
/obj/item/proc/on_exit_storage(obj/item/weapon/storage/S as obj)
	return

// called when this item is added into a storage item, which is passed on as S. The loc variable is already set to the storage item.
/obj/item/proc/on_enter_storage(obj/item/weapon/storage/S as obj)
	return

// called after an item is placed in an equipment slot
// user is mob that equipped it
// slot uses the slot_X defines found in setup.dm
// for items that can be placed in multiple slots
// note this isn't called during the initial dressing of a player
/obj/item/proc/equipped(var/mob/user, var/slot)
	return

/obj/item/proc/afterattack()

	return

/obj/item/weapon/dummy/ex_act()
	return

/obj/item/weapon/dummy/blob_act()
	return

/obj/item/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			if (prob(50))
				del(src)
				return
		if(3.0)
			if (prob(5))
				del(src)
				return
		else
	return

/obj/item/blob_act()
	return

/obj/item/verb/move_to_top()
	set name = "Move To Top"
	set category = "Object"
	set src in oview(1)

	if(!istype(src.loc, /turf) || usr.stat || usr.restrained() )
		return

	var/turf/T = src.loc

	src.loc = null

	src.loc = T

/obj/item/examine()
	set src in view()

	var/t
	switch(src.w_class)
		if(1.0)
			t = "tiny"
		if(2.0)
			t = "small"
		if(3.0)
			t = "normal-sized"
		if(4.0)
			t = "bulky"
		if(5.0)
			t = "huge"
		else
	if ((CLUMSY in usr.mutations) && prob(50)) t = "funny-looking"
	usr << text("This is a []\icon[][]. It is a [] item.", !src.blood_DNA ? "" : "bloody ",src, src.name, t)
	if(src.desc)
		usr << src.desc
	return

/obj/item/attack_hand(mob/user as mob)
	if (!user) return
	if (istype(src.loc, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = src.loc
		S.remove_from_storage(src)

	src.throwing = 0
	if (src.loc == user)
		//canremove==0 means that object may not be removed. You can still wear it. This only applies to clothing. /N
		if(!src.canremove)
			return
		else
			user.u_equip(src)
	else
		if(isliving(src.loc))
			return
		src.pickup(user)
		user.lastDblClick = world.time + 2
		user.next_move = world.time + 2
	add_fingerprint(user)
	user.put_in_active_hand(src)
	return


/obj/item/attack_paw(mob/user as mob)

	if(isalien(user)) // -- TLE
		var/mob/living/carbon/alien/A = user

		if(!A.has_fine_manipulation || w_class >= 4)
			if(src in A.contents) // To stop Aliens having items stuck in their pockets
				A.drop_from_inventory(src)
			user << "Your claws aren't capable of such fine manipulation."
			return

	if (istype(src.loc, /obj/item/weapon/storage))
		for(var/mob/M in range(1, src.loc))
			if (M.s_active == src.loc)
				if (M.client)
					M.client.screen -= src
	src.throwing = 0
	if (src.loc == user)
		//canremove==0 means that object may not be removed. You can still wear it. This only applies to clothing. /N
		if(istype(src, /obj/item/clothing) && !src:canremove)
			return
		else
			user.u_equip(src)
	else
		if(istype(src.loc, /mob/living))
			return
		src.pickup(user)
		user.lastDblClick = world.time + 2
		user.next_move = world.time + 2

	user.put_in_active_hand(src)
	return

/obj/item/attackby(obj/item/weapon/W as obj, mob/user as mob)

	if(istype(W,/obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = W
		if(S.use_to_pickup)
			if(!S.can_be_inserted(src))
				return
			if(S.collection_mode) //Mode is set to collect all items on a tile and we clicked on a valid one.
				if(isturf(src.loc))
					for(var/obj/item/I in src.loc)
						if(I != src) //We'll do the one we clicked on last.
							if(!S.can_be_inserted(src))
								continue
							S.handle_item_insertion(I, 1)	//The 1 stops the "You put the [src] into [S]" insertion message from being displayed.
			S.handle_item_insertion(src)


	return

mob/proc/flash_weak_pain()
	flick("weak_pain",pain)

/obj/item/proc/attack(mob/living/M as mob, mob/living/user as mob, def_zone)

	if (!istype(M)) // not sure if this is the right thing...
		return
	var/messagesource = M

	if (istype(M,/mob/living/carbon/brain))
		messagesource = M:container
	if (src.hitsound)
		playsound(src.loc, hitsound, 50, 1, -1)
	M.flash_weak_pain()
	/////////////////////////
	user.lastattacked = M
	M.lastattacker = user

	var/power = src.force

	// EXPERIMENTAL: scale power and time to the weight class
	if(w_class >= 4.0 && !istype(src,/obj/item/weapon/melee/energy/blade)) // eswords are an exception, they only have a w_class of 4 to not fit into pockets
		power = power * 2.5

		user.visible_message("\red [user.name] swings at [M.name] with \the [src]!")
		user.next_move = max(user.next_move, world.time + 30)

		// if the mob didn't move, he has a 100% chance to hit(given the enemy also didn't move)
		// otherwise, the chance to hit is lower
		var/unmoved = 0
		spawn
			unmoved = do_after(user, 4)
		sleep(4)
		if( (!unmoved && !prob(70)) || (get_dist(user, M) != 1 && user != M))
			user.visible_message("\red [user.name] misses with \the [src]!")
			return


	user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(src.damtype)])</font>"
	M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(src.damtype)])</font>"

	log_admin("ATTACK: [user] ([user.ckey]) attacked [M] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(src.damtype)]")
	msg_admin_attack("ATTACK: [user] ([user.ckey]) attacked [M] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(src.damtype)]")

	log_attack("<font color='red'>[user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)]) (DAMTYE: [uppertext(src.damtype)])</font>" )

	//spawn(1800)            // this wont work right
	//	M.lastattacker = null
	/////////////////////////

	if((HULK in user.mutations) || (SUPRSTR in user.augmentations))
		power *= 2

	if(!istype(M, /mob/living/carbon/human))
		if(istype(M, /mob/living/carbon/metroid))
			var/mob/living/carbon/metroid/Metroid = M
			if(prob(25))
				user << "\red [src] passes right through [M]!"
				return

			if(power > 0)
				Metroid.attacked += 10

			if(Metroid.Discipline && prob(50))	// wow, buddy, why am I getting attacked??
				Metroid.Discipline = 0

			if(power >= 3)
				if(istype(Metroid, /mob/living/carbon/metroid/adult))
					if(prob(5 + round(power/2)))

						if(Metroid.Victim)
							if(prob(80) && !Metroid.client)
								Metroid.Discipline++
						Metroid.Victim = null
						Metroid.anchored = 0

						spawn()
							if(Metroid)
								Metroid.SStun = 1
								sleep(rand(5,20))
								if(Metroid)
									Metroid.SStun = 0

						spawn(0)
							if(Metroid)
								Metroid.canmove = 0
								step_away(Metroid, user)
								if(prob(25 + power))
									sleep(2)
									if(Metroid && user)
										step_away(Metroid, user)
								Metroid.canmove = 1

				else
					if(prob(10 + power*2))
						if(Metroid)
							if(Metroid.Victim)
								if(prob(80) && !Metroid.client)
									Metroid.Discipline++

									if(Metroid.Discipline == 1)
										Metroid.attacked = 0

								spawn()
									if(Metroid)
										Metroid.SStun = 1
										sleep(rand(5,20))
										if(Metroid)
											Metroid.SStun = 0

							Metroid.Victim = null
							Metroid.anchored = 0


						spawn(0)
							if(Metroid && user)
								step_away(Metroid, user)
								Metroid.canmove = 0
								if(prob(25 + power*4))
									sleep(2)
									if(Metroid && user)
										step_away(Metroid, user)
								Metroid.canmove = 1


		var/showname = "."
		if(user)
			showname = " by [user]."
		if(!(user in viewers(M, null)))
			showname = "."

		for(var/mob/O in viewers(messagesource, null))
			if(src.attack_verb.len)
				O.show_message("\red <B>[M] has been [pick(src.attack_verb)] with [src][showname] </B>", 1)
			else
				O.show_message("\red <B>[M] has been attacked with [src][showname] </B>", 1)

		if(!showname && user)
			if(user.client)
				user << "\red <B>You attack [M] with [src]. </B>"



	if(istype(M, /mob/living/carbon/human))
		M:attacked_by(src, user, def_zone)
	else
		switch(src.damtype)
			if("brute")
				if(istype(src, /mob/living/carbon/metroid))
					M.adjustBrainLoss(power)

				else

					M.take_organ_damage(power)
					if (prob(33)) // Added blood for whacking non-humans too
						var/turf/location = M.loc
						if (istype(location, /turf/simulated))
							location.add_blood_floor(M)
			if("fire")
				if (!(COLD_RESISTANCE in M.mutations))
					M.take_organ_damage(0, power)
					M << "Aargh it burns!"
		M.updatehealth()
	src.add_fingerprint(user)
	return 1


/obj/item/proc/IsShield()
	return 0

/obj/item/proc/eyestab(mob/living/carbon/M as mob, mob/living/carbon/user as mob)

	var/mob/living/carbon/human/H = M
	if(istype(H) && ( \
			(H.head && H.head.flags & HEADCOVERSEYES) || \
			(H.wear_mask && H.wear_mask.flags & MASKCOVERSEYES) || \
			(H.glasses && H.glasses.flags & GLASSESCOVERSEYES) \
		))
		// you can't stab someone in the eyes wearing a mask!
		user << "\red You're going to need to remove that mask/helmet/glasses first."
		return

	var/mob/living/carbon/monkey/Mo = M
	if(istype(Mo) && ( \
			(Mo.wear_mask && Mo.wear_mask.flags & MASKCOVERSEYES) \
		))
		// you can't stab someone in the eyes wearing a mask!
		user << "\red You're going to need to remove that mask/helmet/glasses first."
		return

	if(istype(M, /mob/living/carbon/alien) || istype(M, /mob/living/carbon/metroid))//Aliens don't have eyes./N     Metroids also don't have eyes!
		user << "\red You cannot locate any eyes on this creature!"
		return

	user.attack_log += "\[[time_stamp()]\]<font color='red'> Attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>"
	M.attack_log += "\[[time_stamp()]\]<font color='orange'> Attacked by [user.name] ([user.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>"

	log_attack("<font color='red'> [user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])</font>")

	log_admin("ATTACK: [user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])")
	msg_admin_attack("ATTACK: [user.name] ([user.ckey]) attacked [M.name] ([M.ckey]) with [src.name] (INTENT: [uppertext(user.a_intent)])") //BS12 EDIT ALG

	src.add_fingerprint(user)
	//if((CLUMSY in user.mutations) && prob(50))
	//	M = user
		/*
		M << "\red You stab yourself in the eye."
		M.sdisabilities |= BLIND
		M.weakened += 4
		M.adjustBruteLoss(10)
		*/
	if(M != user)
		for(var/mob/O in (viewers(M) - user - M))
			O.show_message("\red [M] has been stabbed in the eye with [src] by [user].", 1)
		M << "\red [user] stabs you in the eye with [src]!"
		user << "\red You stab [M] in the eye with [src]!"
	else
		user.visible_message( \
			"\red [user] has stabbed themself with [src]!", \
			"\red You stab yourself in the eyes with [src]!" \
		)
	if(istype(M, /mob/living/carbon/human))
		var/datum/organ/external/affecting = M:get_organ("head")
		if(affecting.take_damage(7))
			M:UpdateDamageIcon()
	else
		M.take_organ_damage(7)
	M.eye_blurry += rand(3,4)
	M.eye_stat += rand(2,4)
	if (M.eye_stat >= 10)
		M.eye_blurry += 15+(0.1*M.eye_blurry)
		M.disabilities |= NEARSIGHTED
		if(M.stat != 2)
			M << "\red Your eyes start to bleed profusely!"
		if(prob(50))
			if(M.stat != 2)
				M << "\red You drop what you're holding and clutch at your eyes!"
				M.drop_item()
			M.eye_blurry += 10
			M.Paralyse(1)
			M.Weaken(4)
		if (prob(M.eye_stat - 10 + 1))
			if(M.stat != 2)
				M << "\red You go blind!"
			M.sdisabilities |= BLIND
	return


