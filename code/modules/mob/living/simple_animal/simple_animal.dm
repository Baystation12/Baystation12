#define SIMPLE_ANIMAL_SCREAM_COOLDOWN 1 SECOND
/mob/living/simple_animal
	name = "animal"
	icon = 'icons/mob/animal.dmi'
	health = 20
	maxHealth = 20

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = MONKEY|SLIME|SIMPLE_ANIMAL

	var/show_stat_health = 1	//does the percentage health show in the stat panel for the mob

	var/icon_living = ""
	var/icon_dead = ""
	var/icon_gib = null	//We only try to show a gibbing animation if this exists.

	var/list/speak = list("...")
	var/speak_chance = 0
	var/list/emote_hear = list()	//Hearable emotes
	var/list/emote_see = list()		//Unlike speak_emote, the list of things in this variable only show by themselves with no spoken text. IE: Ian barks, Ian yaps

	var/turns_per_move = 1
	var/turns_since_move = 0
	universal_speak = 0		//No, just no.
	var/meat_amount = 0
	var/meat_type
	var/list/harvest_products = list()
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
	var/fire_alert = 0

	//Atmos effect - Yes, you can make creatures that require phoron or co2 to survive. N2O is a trace gas and handled separately, hence why it isn't here. It'd be hard to add it. Hard and me don't mix (Yes, yes make all the dick jokes you want with that.) - Errorage
	var/min_gas = list("oxygen" = 5)
	var/max_gas = list("phoron" = 1, "carbon_dioxide" = 5)
	var/unsuitable_atmos_damage = 2	//This damage is taken when atmos doesn't fit all the requirements above
	var/speed = 0 //LETS SEE IF I CAN SET SPEEDS FOR SIMPLE MOBS WITHOUT DESTROYING EVERYTHING. Higher speed is slower, negative speed is faster

	//LETTING SIMPLE ANIMALS ATTACK? WHAT COULD GO WRONG. Defaults to zero so Ian can still be cuddly
	var/melee_damage_lower = 0
	var/melee_damage_upper = 0
	var/attacktext = "attacked"
	var/attack_sound = null
	var/friendly = "nuzzles"
	var/environment_smash = 0
	var/resistance		  = 0	// Damage reduction
	var/can_ignite = 0
	var/ignite_overlay = "Generic_mob_burning"
	var/image/fire_overlay_image
	var/move_to_delay = 3 //delay for the automated movement.

	//Null rod stuff
	var/supernatural = 0
	var/purge = 0

	var/list/pain_scream_sounds = list()
	var/list/death_sounds = list()

	var/respawning = 0
	var/limited_respawn  = 0
	var/respawn_timer = 3 MINUTES
	var/turf/spawn_turf

	//Simple Command Stuff//
	var/mob/leader_follow
	var/hold_fire = FALSE

/mob/living/simple_animal/New()
	. = ..()
	spawn_turf = get_turf(src)

/mob/living/simple_animal/verb/verb_set_leader()
	set name = "Follow Me"
	set category = "AI Command"
	set src in range(7)

	var/mob/living/user = usr
	if(!istype(user))
		return
	if(user.faction != faction)
		to_chat(user,"<span class = 'notice'>[name] is not in your faction!</span>")
		return
	if(leader_follow && leader_follow.stat == CONSCIOUS)
		if(user == leader_follow)
			set_leader(null)
		else
			to_chat(user,"<span class = 'notice'>[name] is already following [leader_follow.name].</span>")
			return
	else
		set_leader(user)

/mob/living/simple_animal/verb/verb_hold_fire()
	set name = "Hold Fire"
	set category = "AI Command"
	set src in range(7)

	var/mob/living/user = usr
	if(!istype(user))
		return
	if(user.faction != faction)
		to_chat(user,"<span class = 'notice'>[name] is not in your faction!</span>")
		return
	toggle_hold_fire()

/mob/living/simple_animal/proc/set_leader(var/mob/leader)
	var/msg = null
	if(!leader)
		if(leader_follow)
			msg = "[name] stops following [leader_follow.name]"
		else
			msg = "[name] stops following."
	if(isnull(msg))
		msg ="[name] starts following [leader.name]"
	visible_message("<span class = 'notice'>[msg]</span>")
	leader_follow = leader

/mob/living/simple_animal/proc/toggle_hold_fire()
	hold_fire = !hold_fire
	if(hold_fire == FALSE)
		visible_message("<span class = 'danger'>[src.name] seems to become more aggressive.</span>")
	else
		visible_message("<span class = 'notice'>[src.name] seems to become more docile.</span>")

/mob/living/simple_animal/proc/handle_leader_pathing()
	if(leader_follow)
		if(get_dist(loc,leader_follow.loc) < 14 && loc != leader_follow.loc)//A bit higher than a single screen
			if(istype(loc,/obj/vehicles))
				var/obj/vehicles/v = loc
				v.exit_vehicle(src,1)
			walk_to(src,pick(orange(2,leader_follow.loc)),0,move_to_delay)
			if(istype(leader_follow.loc,/obj/vehicles))
				var/obj/vehicles/v = leader_follow.loc
				if(v.Adjacent(src))
					if(!v.enter_as_position(src,"gunner"))
						v.visible_message("<span class = 'notice'>[name] fails to enter [v.name]'s gunner seat.</span>")
						if(!v.enter_as_position(src,"passenger"))
							v.visible_message("<span class = 'notice'>[name] fails to enter [v.name]'s passenger seat.</span>")
							set_leader(null)
						else
							v.visible_message("<span class = 'notice'>[name] enters [v.name]'s passenger seat.</span>")
							return 1
					else
						v.visible_message("<span class = 'notice'>[name] enters [v.name]'s gunner seat.</span>")
						return 1
		else
			if(leader_follow && loc != leader_follow.loc)
				set_leader(null)
			walk(src,0)
		return 0

/mob/living/simple_animal/Life()
	..()

	//Health
	if(stat == DEAD)
		if(health > 0)
			icon_state = icon_living
			switch_from_dead_to_living_mob_list()
			set_stat(CONSCIOUS)
			set_density(1)
		else if(respawning || limited_respawn)
			if(world.time > timeofdeath + respawn_timer)
				if(limited_respawn > 0)
					limited_respawn--
				health = maxHealth
				src.forceMove(spawn_turf)
		return 0


	if(health <= 0)
		death()
		return

	if(health > maxHealth)
		health = maxHealth

	handle_stunned()
	handle_weakened()
	handle_paralysed()
	handle_supernatural()

	//Movement
	if(!client && !stop_automated_movement && wander && !anchored)
		if(isturf(src.loc) && !resting && !buckled && canmove)		//This is so it only moves if it's not inside a closet, gentics machine, etc.
			turns_since_move++
			if(turns_since_move >= turns_per_move)
				if(!(stop_automated_movement_when_pulled && pulledby)) //Soma animals don't move when pulled
					if(handle_leader_pathing())
					else
						var/moving_to = 0 // otherwise it always picks 4, fuck if I know.   Did I mention fuck BYOND
						var/list/dirs_pickfrom = GLOB.cardinal.Copy()
						var/allow_move = 0
						while(!allow_move)
							if(dirs_pickfrom.len == 0)
								allow_move = 1
								break
							moving_to = pick(dirs_pickfrom)
							if(!istype(get_step(src,moving_to),/turf/simulated/open) && isnull(locate(/obj/structure/bardbedwire) in moving_to))
								allow_move = 1
							dirs_pickfrom -= moving_to
						set_dir(moving_to)			//How about we turn them the direction they are moving, yay.
						Move(get_step(src,moving_to))
						turns_since_move = 0

	//Speaking
	if(!client && speak_chance)
		if(rand(0,200) < speak_chance)
			var/action = pick(
				speak.len;      "speak",
				emote_hear.len; "emote_hear",
				emote_see.len;  "emote_see"
				)

			switch(action)
				if("speak")
					say(pick(speak))
				if("emote_hear")
					audible_emote("[pick(emote_hear)].")
				if("emote_see")
					visible_emote("[pick(emote_see)].")

	//Atmos
	var/atmos_suitable = 1

	var/atom/A = loc
	if(!loc)
		return 1
	var/datum/gas_mixture/environment = A.return_air()

	if(environment)
		if( abs(environment.temperature - bodytemperature) > 40 )
			bodytemperature += (environment.temperature - bodytemperature) / 5
		if(min_gas)
			for(var/gas in min_gas)
				if(environment.gas[gas] < min_gas[gas])
					atmos_suitable = 0
		if(max_gas)
			for(var/gas in max_gas)
				if(environment.gas[gas] > max_gas[gas])
					atmos_suitable = 0

	//Atmos effect
	if(bodytemperature < minbodytemp)
		fire_alert = 2
		adjustBruteLoss(cold_damage_per_tick)
	else if(bodytemperature > maxbodytemp)
		fire_alert = 1
		adjustBruteLoss(heat_damage_per_tick)
	else
		fire_alert = 0

	if(!atmos_suitable)
		adjustBruteLoss(unsuitable_atmos_damage)
	return 1

/mob/living/simple_animal/proc/handle_supernatural()
	if(purge)
		purge -= 1

/mob/living/simple_animal/gib()
	..(icon_gib,1)

/mob/living/simple_animal/proc/visible_emote(var/act_desc)
	custom_emote(1, act_desc)

/mob/living/simple_animal/proc/audible_emote(var/act_desc)
	custom_emote(2, act_desc)

/mob/living/simple_animal/proc/do_pain_scream()
	if(health <= 0)
		return
	if(world.time < next_scream_at)
		return
	if(isnull(pain_scream_sounds) || pain_scream_sounds.len == 0)
		return

	var/scream_sound = pick(pain_scream_sounds)

	playsound(loc, scream_sound,50,0,7)
	next_scream_at = world.time + SIMPLE_ANIMAL_SCREAM_COOLDOWN

/mob/living/simple_animal/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj || Proj.nodamage)
		return 0
	var/oldhealth = health
	if(Proj.damtype == BURN)
		adjustFireLoss(max(0,Proj.damage-max(0,resistance-Proj.armor_penetration)))
	else
		adjustBruteLoss(max(0,Proj.damage-max(0,resistance-Proj.armor_penetration)))
	if(oldhealth == health)
		visible_message("<span class = 'notice'>[src] shrugs off \the [Proj]'s impact.</span>")
	do_pain_scream()
	return 1

/mob/living/simple_animal/attack_hand(mob/living/carbon/human/M as mob)
	..()

	switch(M.a_intent)

		if(I_HELP)
			if (health > 0)
				M.visible_message("<span class='notice'>[M] [response_help] \the [src]</span>")

		if(I_DISARM)
			M.visible_message("<span class='notice'>[M] [response_disarm] \the [src]</span>")
			M.do_attack_animation(src)
			//TODO: Push the mob away or something

		if(I_HURT)
			adjustBruteLoss(harm_intent_damage)
			M.visible_message("<span class='warning'>[M] [response_harm] \the [src]</span>")
			M.do_attack_animation(src)
			do_pain_scream()

	return

/mob/living/simple_animal/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/stack/medical))
		if(stat != DEAD)
			var/obj/item/stack/medical/MED = O
			if(!MED.animal_heal)
				to_chat(user, "<span class='notice'>That [MED] won't help \the [src] at all!</span>")
				return
			if(health < maxHealth)
				if(MED.amount >= 1)
					adjustBruteLoss(-MED.animal_heal)
					MED.amount -= 1
					if(MED.amount <= 0)
						qdel(MED)
					for(var/mob/M in viewers(src, null))
						if ((M.client && !( M.blinded )))
							M.show_message("<span class='notice'>[user] applies the [MED] on [src].</span>")
		else
			to_chat(user, "<span class='notice'>\The [src] is dead, medical items won't bring \him back to life.</span>")
		return 0
	if((meat_type || harvest_products.len) && (stat == DEAD))	//if the animal has a meat, and if it is dead.
		if(istype(O, /obj/item/weapon/material/knife) || istype(O, /obj/item/weapon/material/knife/butch))
			harvest(user)
	else
		if(!O.force)
			visible_message("<span class='notice'>[user] gently taps [src] with \the [O].</span>")
		else
			O.attack(src, user, user.zone_sel.selecting)
			return 1
/mob/living/simple_animal/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)

	visible_message("<span class='danger'>\The [src] has been attacked with \the [O] by [user].</span>")

	if(O.force <= resistance-O.armor_penetration)
		to_chat(user, "<span class='danger'>This weapon is ineffective, it does no damage.</span>")
		return 2

	var/damage = O.force
	if (O.damtype == PAIN)
		damage = 0
	if(supernatural && istype(O,/obj/item/weapon/nullrod))
		damage *= 2
		purge = 3
	adjustBruteLoss(damage)
	do_pain_scream()

/mob/living/simple_animal/movement_delay()
	var/tally = ..() //Incase I need to add stuff other than "speed" later

	tally += speed
	if(purge)//Purged creatures will move more slowly. The more time before their purge stops, the slower they'll move.
		if(tally <= 0)
			tally = 1
		tally *= purge

	return tally+config.animal_delay

/mob/living/simple_animal/Stat()
	. = ..()

	if(statpanel("Status") && show_stat_health)
		stat(null, "Health: [round((health / maxHealth) * 100)]%")

/mob/living/simple_animal/death(gibbed, deathmessage = "dies!", show_dead_message = 1)
	if(istype(loc,/obj/vehicles))
		var/obj/vehicles/v = loc
		v.exit_vehicle(src,1)
	timeofdeath = world.time
	icon_state = icon_dead
	density = 0
	//adjustBruteLoss(maxHealth) //Make sure dey dead.
	walk_to(src,0)
	if(death_sounds.len > 0)
		playsound(loc, pick(death_sounds),75,0,7)
	return ..(gibbed,deathmessage,show_dead_message)

/mob/living/simple_animal/ex_act(severity)
	if(!blinded)
		flash_eyes()

	var/damage
	switch (severity)
		if (1.0)
			damage = 500
			if(!prob(getarmor(null, "bomb")))
				gib()

		if (2.0)
			damage = 120

		if(3.0)
			damage = 30

	adjustBruteLoss(damage * blocked_mult(getarmor(null, "bomb")))

/mob/living/simple_animal/adjustBruteLoss(damage)
	..()
	updatehealth()

/mob/living/simple_animal/adjustFireLoss(damage)
	..()
	updatehealth()

/mob/living/simple_animal/adjustToxLoss(damage)
	..()
	updatehealth()

/mob/living/simple_animal/adjustOxyLoss(damage)
	..()
	updatehealth()

/mob/living/simple_animal/proc/SA_attackable(target_mob)
	if (isliving(target_mob))
		var/mob/living/L = target_mob
		if(!L.stat && L.health >= 0)
			return (0)
	if (istype(target_mob,/obj/mecha))
		var/obj/mecha/M = target_mob
		if (M.occupant)
			return (0)
	if(istype(target_mob,/obj/vehicles))
		return (0)
	return 1

/mob/living/simple_animal/say(var/message)
	var/verb = "says"
	if(speak_emote.len)
		verb = pick(speak_emote)

	message = sanitize(message)

	..(message, species_language, verb)

/mob/living/simple_animal/get_speech_ending(verb, var/ending)
	return verb

/mob/living/simple_animal/put_in_hands(var/obj/item/W) // No hands.
	W.loc = get_turf(src)
	return 1

// Harvest an animal's delicious byproducts
/mob/living/simple_animal/proc/harvest(var/mob/user)

	for(var/harvest_type in harvest_products)
		new harvest_type(get_turf(src))

	var/actual_meat_amount = max(1,(meat_amount/2))
	if(meat_type && actual_meat_amount>0 && (stat == DEAD))
		for(var/i=0;i<actual_meat_amount;i++)
			var/obj/item/meat = new meat_type(get_turf(src))
			meat.name = "[src.name] [meat.name]"
		if(issmall(src))
			user.visible_message("<span class='danger'>[user] chops up \the [src]!</span>")
			new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			qdel(src)
		else
			user.visible_message("<span class='danger'>[user] butchers \the [src] messily!</span>")
			gib()

/mob/living/simple_animal/handle_fire()
	if(can_ignite)
		. = ..()

/mob/living/simple_animal/update_fire()
	overlays -= fire_overlay_image
	fire_overlay_image = null
	if(on_fire)
		var/image/standing = overlay_image('icons/mob/OnFire.dmi', ignite_overlay, RESET_COLOR)
		fire_overlay_image = standing
		overlays += fire_overlay_image

/mob/living/simple_animal/IgniteMob()
	if(can_ignite)
		. = ..()

/mob/living/simple_animal/ExtinguishMob()
	if(can_ignite)
		. = ..()

/mob/living/simple_animal/updatehealth()
	. = ..()
	if(health <= 0 && stat != DEAD)
		death()
		return
