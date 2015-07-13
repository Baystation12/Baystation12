/mob/living/simple_animal
	name = "animal"
	icon = 'icons/mob/animal.dmi'
	health = 20
	maxHealth = 20

	var/icon_living = ""
	var/icon_dead = ""
	var/icon_gib = null	//We only try to show a gibbing animation if this exists.

	var/list/speak = list()
	var/speak_chance = 0
	var/list/emote_hear = list()	//Hearable emotes
	var/list/emote_see = list()		//Unlike speak_emote, the list of things in this variable only show by themselves with no spoken text. IE: Ian barks, Ian yaps

	var/turns_per_move = 1
	var/turns_since_move = 0
	universal_speak = 0		//No, just no.
	var/meat_amount = 0
	var/meat_type
	var/stop_automated_movement = 0 //Use this to temporarely stop random movement or to if you write special movement code for animals.
	var/wander = 1	// Does the mob wander around when idle?
	var/stop_automated_movement_when_pulled = 1 //When set to 1 this stops the animal from moving when someone is pulling it.

	//Interaction
	var/response_help   = "tries to help"
	var/response_disarm = "tries to disarm"
	var/response_harm   = "tries to hurt"
	var/harm_intent_damage = 3

	//Temperature effect
	var/minbodytemp = 250
	var/maxbodytemp = 350
	var/heat_damage_per_tick = 3	//amount of damage applied if animal's body temperature is higher than maxbodytemp
	var/cold_damage_per_tick = 2	//same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp

	//Atmos effect - Yes, you can make creatures that require phoron or co2 to survive. N2O is a trace gas and handled separately, hence why it isn't here. It'd be hard to add it. Hard and me don't mix (Yes, yes make all the dick jokes you want with that.) - Errorage
	var/min_oxy = 5
	var/max_oxy = 0					//Leaving something at 0 means it's off - has no maximum
	var/min_tox = 0
	var/max_tox = 1
	var/min_co2 = 0
	var/max_co2 = 5
	var/min_n2 = 0
	var/max_n2 = 0
	var/unsuitable_atoms_damage = 2	//This damage is taken when atmos doesn't fit all the requirements above
	var/speed = 0 //LETS SEE IF I CAN SET SPEEDS FOR SIMPLE MOBS WITHOUT DESTROYING EVERYTHING. Higher speed is slower, negative speed is faster

	//LETTING SIMPLE ANIMALS ATTACK? WHAT COULD GO WRONG. Defaults to zero so Ian can still be cuddly
	var/melee_damage_lower = 0
	var/melee_damage_upper = 0
	var/attacktext = "attacked"
	var/attack_sound = null
	var/friendly = "nuzzles"
	var/wall_smash = 0

/mob/living/simple_animal/New()
	..()
	verbs -= /mob/verb/observe

/mob/living/simple_animal/Login()
	if(src && src.client)
		src.client.screen = null
	..()

/mob/living/simple_animal/updatehealth()
	return

/mob/living/simple_animal/Life()

	//Health
	if(stat == DEAD)
		if(health > 0)
			icon_state = icon_living
			dead_mob_list -= src
			living_mob_list += src
			stat = CONSCIOUS
			density = 1
		return 0


	if(health < 1)
		death()
		return

	if(health > maxHealth)
		health = maxHealth

	handle_stunned()
	handle_weakened()
	handle_paralysed()
	update_canmove()

	//Movement
	if(!client && !stop_automated_movement && wander && !anchored)
		if(isturf(src.loc) && !resting && !buckled && canmove)		//This is so it only moves if it's not inside a closet, gentics machine, etc.
			turns_since_move++
			if(turns_since_move >= turns_per_move)
				if(!(stop_automated_movement_when_pulled && pulledby)) //Soma animals don't move when pulled
					/var/moving_to = 0 // otherwise it always picks 4, fuck if I know.   Did I mention fuck BYOND
					moving_to = pick(cardinal)
					dir = moving_to			//How about we turn them the direction they are moving, yay.
					Move(get_step(src,moving_to))
					turns_since_move = 0

	//Speaking
	if(!client && speak_chance)
		if(rand(0,200) < speak_chance)
			if(speak && speak.len)
				if((emote_hear && emote_hear.len) || (emote_see && emote_see.len))
					var/length = speak.len
					if(emote_hear && emote_hear.len)
						length += emote_hear.len
					if(emote_see && emote_see.len)
						length += emote_see.len
					var/randomValue = rand(1,length)
					if(randomValue <= speak.len)
						say(pick(speak))
					else
						randomValue -= speak.len
						if(emote_see && randomValue <= emote_see.len)
							visible_emote("[pick(emote_see)].")
						else
							audible_emote("[pick(emote_hear)].")
				else
					say(pick(speak))
			else
				if(!(emote_hear && emote_hear.len) && (emote_see && emote_see.len))
					visible_emote("[pick(emote_see)].")
				if((emote_hear && emote_hear.len) && !(emote_see && emote_see.len))
					audible_emote("[pick(emote_hear)].")
				if((emote_hear && emote_hear.len) && (emote_see && emote_see.len))
					var/length = emote_hear.len + emote_see.len
					var/pick = rand(1,length)
					if(pick <= emote_see.len)
						visible_emote("[pick(emote_see)].")
					else
						audible_emote("[pick(emote_hear)].")


	//Atmos
	var/atmos_suitable = 1

	var/atom/A = src.loc

	if(istype(A,/turf))
		var/turf/T = A

		var/datum/gas_mixture/Environment = T.return_air()

		if(Environment)

			if( abs(Environment.temperature - bodytemperature) > 40 )
				bodytemperature += ((Environment.temperature - bodytemperature) / 5)

			if(min_oxy)
				if(Environment.gas["oxygen"] < min_oxy)
					atmos_suitable = 0
			if(max_oxy)
				if(Environment.gas["oxygen"] > max_oxy)
					atmos_suitable = 0
			if(min_tox)
				if(Environment.gas["phoron"] < min_tox)
					atmos_suitable = 0
			if(max_tox)
				if(Environment.gas["phoron"] > max_tox)
					atmos_suitable = 0
			if(min_n2)
				if(Environment.gas["nitrogen"] < min_n2)
					atmos_suitable = 0
			if(max_n2)
				if(Environment.gas["nitrogen"] > max_n2)
					atmos_suitable = 0
			if(min_co2)
				if(Environment.gas["carbon_dioxide"] < min_co2)
					atmos_suitable = 0
			if(max_co2)
				if(Environment.gas["carbon_dioxide"] > max_co2)
					atmos_suitable = 0

	//Atmos effect
	if(bodytemperature < minbodytemp)
		adjustBruteLoss(cold_damage_per_tick)
	else if(bodytemperature > maxbodytemp)
		adjustBruteLoss(heat_damage_per_tick)

	if(!atmos_suitable)
		adjustBruteLoss(unsuitable_atoms_damage)
	return 1

/mob/living/simple_animal/Bumped(AM as mob|obj)
	if(!AM) return

	if(resting || buckled)
		return

	if(isturf(src.loc))
		if(ismob(AM))
			var/newamloc = src.loc
			src.loc = AM:loc
			AM:loc = newamloc
		else
			..()

/mob/living/simple_animal/gib()
	..(icon_gib,1)

/mob/living/simple_animal/emote(var/act, var/type, var/desc)
	if(act)
		..(act, type, desc)

/mob/living/simple_animal/proc/visible_emote(var/act_desc)
	custom_emote(1, act_desc)

/mob/living/simple_animal/proc/audible_emote(var/act_desc)
	custom_emote(2, act_desc)

/mob/living/simple_animal/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj || Proj.nodamage)
		return

	adjustBruteLoss(Proj.damage)
	return 0

/mob/living/simple_animal/attack_hand(mob/living/carbon/human/M as mob)
	..()

	switch(M.a_intent)

		if("help")
			if (health > 0)
				M.visible_message("\blue [M] [response_help] \the [src]")

		if("disarm")
			M.visible_message("\blue [M] [response_disarm] \the [src]")
			//TODO: Push the mob away or something

		if("grab")
			if (M == src)
				return
			if (!(status_flags & CANPUSH))
				return

			var/obj/item/weapon/grab/G = new /obj/item/weapon/grab(M, src)

			M.put_in_active_hand(G)

			G.synch()
			G.affecting = src
			LAssailant = M

			M.visible_message("\red [M] has grabbed [src] passively!")

		if("hurt")
			adjustBruteLoss(harm_intent_damage)
			M.visible_message("\red [M] [response_harm] \the [src]")

	return

/mob/living/simple_animal/attackby(var/obj/item/O, var/mob/user)  //Marker -Agouri

	if(istype(O, /obj/item/stack/medical))

		if(stat != DEAD && health < maxHealth)
			var/obj/item/stack/medical/medical_pack = O
			if(medical_pack.use(1))
				adjustBruteLoss(-medical_pack.heal_brute)
				visible_message("<span class='warning'>\The [user] applies the [medical_pack] to \the [src].</span>")
		else
			user << "<span class='warning'>\The [src] cannot benefit from medical items in \his current state.</span>"
		return

	else if(istype(O, /obj/item/weapon/kitchenknife) || istype(O, /obj/item/weapon/butch))
		var/actual_meat_amount = max(1,(meat_amount/2))
		if(meat_type && actual_meat_amount>0 && (stat == DEAD))
			for(var/i=0;i<actual_meat_amount;i++)
				var/obj/item/meat = new meat_type(get_turf(src))
				meat.name = "[src.name] [meat.name]"
			if(small)
				user.visible_message("<span class='danger'>[user] chops up \the [src]!</span>")
				new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
				del(src)
			else
				user.visible_message("<span class='danger'>[user] butchers \the [src] messily!</span>")
				gib()
			return

	if(O.force)
		var/damage = O.force
		if (O.damtype == HALLOSS)
			damage = 0
		adjustBruteLoss(damage)
		visible_message("<span class='danger'>\The [src] has been attacked with \the [O] by [user].</span>")
	else
		user << "<span class='danger'>This weapon is ineffective; it does no damage.</span>"
		visible_message("<span class='danger'>\The [user] gently taps [src] with the [O].</span>")

/mob/living/simple_animal/movement_delay()
	var/tally = 0 //Incase I need to add stuff other than "speed" later

	tally = speed

	return tally+config.animal_delay

/mob/living/simple_animal/Stat()
	..()

	statpanel("Status")
	stat(null, "Health: [round((health / maxHealth) * 100)]%")

/mob/living/simple_animal/death()
	icon_state = icon_dead
	density = 0
	return ..(deathmessage = "no message")

/mob/living/simple_animal/ex_act(severity)
	if(!blinded)
		flick("flash", flash)
	switch (severity)
		if (1.0)
			adjustBruteLoss(500)
			gib()
			return

		if (2.0)
			adjustBruteLoss(60)


		if(3.0)
			adjustBruteLoss(30)

/mob/living/simple_animal/adjustBruteLoss(damage)
	health = Clamp(health - damage, 0, maxHealth)

/mob/living/simple_animal/proc/SA_attackable(target_mob)
	if (isliving(target_mob))
		var/mob/living/L = target_mob
		if(!L.stat && L.health >= 0)
			return (0)
	if (istype(target_mob,/obj/mecha))
		var/obj/mecha/M = target_mob
		if (M.occupant)
			return (0)
	if (istype(target_mob,/obj/machinery/bot))
		var/obj/machinery/bot/B = target_mob
		if(B.health > 0)
			return (0)
	return (1)

//Call when target overlay should be added/removed
/mob/living/simple_animal/update_targeted()
	if(!targeted_by && target_locked)
		del(target_locked)
	overlays = null
	if (targeted_by && target_locked)
		overlays += target_locked

/mob/living/simple_animal/say(var/message)
	if(stat)
		return

	if(copytext(message,1,2) == "*")
		return emote(copytext(message,2))

	if(stat)
		return

	var/verb = "says"

	if(speak_emote.len)
		verb = pick(speak_emote)

	message = capitalize(trim_left(message))

	..(message, null, verb)

/mob/living/simple_animal/put_in_hands(var/obj/item/W) // No hands.
	W.loc = get_turf(src)
	return 1
