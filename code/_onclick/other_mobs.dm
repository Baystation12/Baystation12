// Generic damage proc (slimes and monkeys).
/atom/proc/attack_generic(mob/user as mob)
	return 0

/*
	Humans:
	Adds an exception for gloves, to allow special glove types like the ninja ones.

	Otherwise pretty standard.
*/
/mob/living/carbon/human/UnarmedAttack(var/atom/A, var/proximity)

	if(!..())
		return

	// Special glove functions:
	// If the gloves do anything, have them return 1 to stop
	// normal attack_hand() here.
	var/obj/item/clothing/gloves/G = gloves // not typecast specifically enough in defines
	if(istype(G) && G.Touch(A,1))
		return

	A.attack_hand(src)

/atom/proc/attack_hand(mob/user as mob)
	return

/mob/living/carbon/human/RestrainedClickOn(var/atom/A)
	return

/mob/living/carbon/human/RangedAttack(var/atom/A)
	//Climbing up open spaces
	if((istype(A, /turf/simulated/floor) || istype(A, /obj/structure/catwalk)) && isturf(loc) && shadow && !is_physically_disabled()) //Climbing through openspace
		var/turf/T = get_turf(A)
		if(T.Adjacent(shadow) && !locate(/obj/structure) in shadow.loc)
			var/list/objects_to_stand_on = list(
				/obj/item/weapon/stool,
				/obj/structure/bed,
			)
			var/atom/helper = null
			var/area/location = get_area(loc)
			if(!location.has_gravity || can_overcome_gravity())
				helper = src
			else
				for(var/type in objects_to_stand_on)
					helper = locate(type) in src.loc
					if(helper)
						if(istype(helper, /obj/structure/bed/chair/office) && prob(60)) //If you are intent on removing yourself from the round
							visible_message("<span class='warning'>[src] slips and falls!", "<span class='warning'>\The [helper] moves beneath you and you fall on the ground!")
							shadow.visible_message("<span class='warning'>[src] slips and falls!")

							//Taken from climbing shaken proc
							Weaken(3)

							//With any luck you won't kill yourself
							if(prob(40))
								var/damage = rand(10,30)
								var/obj/item/organ/external/target

								target = get_organ(pick(BP_ALL_LIMBS))

								if(target)
									visible_message("<span class='warning'>[src] lands heavily on their [target.name]!", "<span class='warning'>You land heavily on your [target.name]!")
									shadow.visible_message("<span class='warning'>[shadow] lands heavily on their [target.name]!")
									target.take_damage(damage, 0)
								if(target.parent)
									target.parent.add_autopsy_data("Fall", damage)
								else
									visible_message("<span class='warning'>[src] lands heavily!", "<span class='warning'>You land heavily!")
									shadow.visible_message("<span class='warning'>[shadow] lands heavily.")
									adjustBruteLoss(damage)

								UpdateDamageIcon()
								updatehealth()

						break
				//Right, second time around we check climbable if we didn't find from list of items
				if(!helper)
					for(var/atom/a in src.loc)
						if(a.flags & OBJ_CLIMBABLE)
							helper = a
							break
				if(!helper)
					return

			visible_message("<span class='notice'>[src] starts climbing onto \the [A]!</span>", "<span class='notice'>You start climbing onto \the [A]!</span>")
			shadow.visible_message("<span class='notice'>[shadow] starts climbing onto \the [A]!</span>")
			if(do_after(src, 50, helper))
				visible_message("<span class='notice'>[src] climbs onto \the [A]!</span>", "<span class='notice'>You climb onto \the [A]!</span>")
				shadow.visible_message("<span class='notice'>[shadow] climbs onto \the [A]!</span>")
				src.Move(T)
			else
				visible_message("<span class='warning'>[src] gives up on trying to climb onto \the [A]!", "<span class='warning'>You give up on trying to climb onto \the [A]!")
				shadow.visible_message("<span class='warning'>[shadow] gives up on trying to climb onto \the [A]!")
			return

	if(!gloves && !mutations.len) return
	var/obj/item/clothing/gloves/G = gloves
	if((LASER in mutations) && a_intent == I_HURT)
		LaserEyes(A) // moved into a proc below

	else if(istype(G) && G.Touch(A,0)) // for magic gloves
		return

	else if(TK in mutations)
		A.attack_tk(src)

/mob/living/RestrainedClickOn(var/atom/A)
	return

/*
	Aliens
*/

/mob/living/carbon/alien/RestrainedClickOn(var/atom/A)
	return

/mob/living/carbon/alien/UnarmedAttack(var/atom/A, var/proximity)

	if(!..())
		return 0

	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	A.attack_generic(src,rand(5,6),"bitten")

/*
	Slimes
	Nothing happening here
*/

/mob/living/carbon/slime/RestrainedClickOn(var/atom/A)
	return

/mob/living/carbon/slime/UnarmedAttack(var/atom/A, var/proximity)

	if(!..())
		return

	// Eating
	if(Victim)
		if (Victim == A)
			Feedstop()
		return

	//should have already been set if we are attacking a mob, but it doesn't hurt and will cover attacking non-mobs too
	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/mob/living/M = A
	if(!istype(M))
		A.attack_generic(src, (is_adult ? rand(20,40) : rand(5,25)), "glomped") // Basic attack.
	else
		var/power = max(0, min(10, (powerlevel + rand(0, 3))))

		switch(src.a_intent)
			if (I_HELP) // We just poke the other
				M.visible_message("<span class='notice'>[src] gently pokes [M]!</span>", "<span class='notice'>[src] gently pokes you!</span>")
			if (I_DISARM) // We stun the target, with the intention to feed
				var/stunprob = 1

				if (powerlevel > 0 && !istype(A, /mob/living/carbon/slime))
					switch(power * 10)
						if(0) stunprob *= 10
						if(1 to 2) stunprob *= 20
						if(3 to 4) stunprob *= 30
						if(5 to 6) stunprob *= 40
						if(7 to 8) stunprob *= 60
						if(9) 	   stunprob *= 70
						if(10) 	   stunprob *= 95

				if(prob(stunprob))
					var/shock_damage = max(0, powerlevel-3) * rand(6,10)
					M.electrocute_act(shock_damage, src, 1.0, ran_zone())
				else if(prob(40))
					M.visible_message("<span class='danger'>[src] has pounced at [M]!</span>", "<span class='danger'>[src] has pounced at you!</span>")
					M.Weaken(power)
				else
					M.visible_message("<span class='danger'>[src] has tried to pounce at [M]!</span>", "<span class='danger'>[src] has tried to pounce at you!</span>")
				M.updatehealth()
			if (I_GRAB) // We feed
				Wrap(M)
			if (I_HURT) // Attacking
				if(iscarbon(M) && prob(15))
					M.visible_message("<span class='danger'>[src] has pounced at [M]!</span>", "<span class='danger'>[src] has pounced at you!</span>")
					M.Weaken(power)
				else
					A.attack_generic(src, (is_adult ? rand(20,40) : rand(5,25)), "glomped")

/*
	New Players:
	Have no reason to click on anything at all.
*/
/mob/new_player/ClickOn()
	return

/*
	Animals
*/
/mob/living/simple_animal/UnarmedAttack(var/atom/A, var/proximity)

	if(!..())
		return
	if(istype(A,/mob/living))
		if(melee_damage_upper == 0)
			custom_emote(1,"[friendly] [A]!")
			return
		if(ckey)
			admin_attack_log(src, A, "Has [attacktext] its victim.", "Has been [attacktext] by its attacker.", attacktext)
	setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	var/damage = rand(melee_damage_lower, melee_damage_upper)
	if(A.attack_generic(src,damage,attacktext,environment_smash) && loc && attack_sound)
		playsound(loc, attack_sound, 50, 1, 1)