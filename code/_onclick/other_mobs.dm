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
	if(!gloves && !mutations.len) return
	var/obj/item/clothing/gloves/G = gloves
	if((LASER in mutations) && a_intent == "hurt")
		LaserEyes(A) // moved into a proc below

	else if(istype(G) && G.Touch(A,0)) // for magic gloves
		return

	else if(TK in mutations)
		switch(get_dist(src,A))
			if(1 to 5) // not adjacent may mean blocked by window
				next_move += 2
			if(5 to 7)
				next_move += 5
			if(8 to 15)
				next_move += 10
			if(16 to 128)
				return
		A.attack_tk(src)

/mob/living/RestrainedClickOn(var/atom/A)
	return

/*
	Monkeys
*/


/mob/living/carbon/monkey/UnarmedAttack(var/atom/A, var/proximity)

	if(!..())
		return

	A.attack_hand(src)

/*
	Monkey RestrainedClickOn() was apparently the
	one and only use of all of the restrained click code
	(except to stop you from doing things while handcuffed);
	moving it here instead of various hand_p's has simplified
	things considerably
*/
/mob/living/carbon/monkey/RestrainedClickOn(var/atom/A)
	if(a_intent != "harm" || !ismob(A)) return
	if(istype(wear_mask, /obj/item/clothing/mask/muzzle))
		return
	var/mob/living/carbon/ML = A
	var/dam_zone = ran_zone(pick("chest", "l_hand", "r_hand", "l_leg", "r_leg"))
	var/armor = ML.run_armor_check(dam_zone, "melee")
	if(prob(75))
		ML.apply_damage(rand(1,3), BRUTE, dam_zone, armor)
		for(var/mob/O in viewers(ML, null))
			O.show_message("\red <B>[name] has bit [ML]!</B>", 1)
		if(armor >= 2) return
		if(ismonkey(ML))
			for(var/datum/disease/D in viruses)
				if(istype(D, /datum/disease/jungle_fever))
					ML.contract_disease(D,1,0)
	else
		for(var/mob/O in viewers(ML, null))
			O.show_message("\red <B>[src] has attempted to bite [ML]!</B>", 1)

/*
	Aliens
*/

/mob/living/carbon/alien/RestrainedClickOn(var/atom/A)
	return

/mob/living/carbon/alien/UnarmedAttack(var/atom/A, var/proximity)

	if(!..())
		return 0

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

	var/mob/living/M = A
	if (istype(M))

		switch(src.a_intent)
			if ("help") // We just poke the other
				M.visible_message("<span class='notice'>[src] gently pokes [M]!</span>", "<span class='notice'>[src] gently pokes you!</span>")
			if ("disarm") // We stun the target, with the intention to feed
				var/stunprob = 1
				var/power = max(0, min(10, (powerlevel + rand(0, 3))))
				if (powerlevel > 0 && !istype(A, /mob/living/carbon/slime))
					if(ishuman(M))
						var/mob/living/carbon/human/H = M
						if(H.species.flags & IS_SYNTHETIC)
							return
						stunprob *= H.species.siemens_coefficient


					switch(power * 10)
						if(0) stunprob *= 10
						if(1 to 2) stunprob *= 20
						if(3 to 4) stunprob *= 30
						if(5 to 6) stunprob *= 40
						if(7 to 8) stunprob *= 60
						if(9) 	   stunprob *= 70
						if(10) 	   stunprob *= 95

				if(prob(stunprob))
					powerlevel = max(0, powerlevel-3)
					M.visible_message("<span class='danger'>[src] has shocked [M]!</span>", "<span class='danger'>[src] has shocked you!</span>")
					M.Weaken(power)
					M.Stun(power)
					M.stuttering = max(M.stuttering, power)

					var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
					s.set_up(5, 1, M)
					s.start()

					if(prob(stunprob) && powerlevel >= 8)
						M.adjustFireLoss(powerlevel * rand(6,10))
				else if(prob(40))
					M.visible_message("<span class='danger'>[src] has pounced at [M]!</span>", "<span class='danger'>[src] has pounced at you!</span>")
					M.Weaken(power)
				else
					M.visible_message("<span class='danger'>[src] has tried to pounce at [M]!</span>", "<span class='danger'>[src] has tried to pounce at you!</span>")
				M.updatehealth()
			if ("grab") // We feed
				Wrap(M)
			if ("hurt") // Attacking
				A.attack_generic(src, (is_adult ? rand(20,40) : rand(5,25)), "glomped")
	else
		A.attack_generic(src, (is_adult ? rand(20,40) : rand(5,25)), "glomped") // Basic attack.
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

	if(melee_damage_upper == 0 && istype(A,/mob/living))
		custom_emote(1,"[friendly] [A]!")
		return

	var/damage = rand(melee_damage_lower, melee_damage_upper)
	if(A.attack_generic(src,damage,attacktext,wall_smash) && loc && attack_sound)
		playsound(loc, attack_sound, 50, 1, 1)