/mob/living/simple_animal
	name = "animal"
	icon = 'icons/mob/simple_animal/animal.dmi'
	health = 20
	maxHealth = 20
	universal_speak = FALSE

	mob_bump_flag = SIMPLE_ANIMAL
	mob_swap_flags = MONKEY|SLIME|SIMPLE_ANIMAL
	mob_push_flags = MONKEY|SLIME|SIMPLE_ANIMAL

	meat_type = /obj/item/weapon/reagent_containers/food/snacks/meat
	meat_amount = 3
	bone_material = MATERIAL_BONE_GENERIC
	bone_amount = 5
	skin_material = MATERIAL_SKIN_GENERIC 
	skin_amount = 5

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
	var/stop_automated_movement = 0 //Use this to temporarely stop random movement or to if you write special movement code for animals.
	var/wander = 1	// Does the mob wander around when idle?
	var/stop_automated_movement_when_pulled = 1 //When set to 1 this stops the animal from moving when someone is pulling it.

	//Interaction
	var/response_help   = "tries to help"
	var/response_disarm = "tries to disarm"
	var/response_harm   = "tries to hurt"
	var/harm_intent_damage = 3
	var/can_escape = FALSE // 'smart' simple animals such as human enemies, or things small, big, sharp or strong enough to power out of a net

	//Temperature effect
	var/minbodytemp = 250
	var/maxbodytemp = 350
	var/heat_damage_per_tick = 3	//amount of damage applied if animal's body temperature is higher than maxbodytemp
	var/cold_damage_per_tick = 2	//same as heat_damage_per_tick, only if the bodytemperature it's lower than minbodytemp
	var/fire_alert = 0

	//Atmos effect - Yes, you can make creatures that require phoron or co2 to survive. N2O is a trace gas and handled separately, hence why it isn't here. It'd be hard to add it. Hard and me don't mix (Yes, yes make all the dick jokes you want with that.) - Errorage
	var/list/min_gas = list(GAS_OXYGEN = 5)
	var/list/max_gas = list(GAS_PHORON = 1, GAS_CO2 = 5)

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
	var/damtype = BRUTE
	var/defense = "melee" //what armor protects against its attacks
	var/armor_type = /datum/extension/armor
	var/list/natural_armor //what armor animal has
	var/flash_vulnerability = 1 // whether or not the mob can be flashed; 0 = no, 1 = yes, 2 = very yes

	//Null rod stuff
	var/supernatural = 0
	var/purge = 0
	
	var/bleed_ticks = 0
	var/bleed_colour = COLOR_BLOOD_HUMAN
	var/can_bleed = TRUE

	// contained in a cage
	var/in_stasis = 0

	//for simple animals with abilities, mostly megafauna
	var/ability_cooldown
	var/time_last_used_ability

	//for simple animals that reflect damage when attacked in melee
	var/return_damage_min
	var/return_damage_max

/mob/living/simple_animal/Initialize()
	. = ..()
	if(LAZYLEN(natural_armor))
		set_extension(src, armor_type, natural_armor)

/mob/living/simple_animal/Life()
	. = ..()
	if(!.)
		return FALSE
	if(!living_observers_present(GetConnectedZlevels(z)))
		return
	//Health
	if(stat == DEAD)
		if(health > 0)
			icon_state = icon_living
			switch_from_dead_to_living_mob_list()
			set_stat(CONSCIOUS)
			set_density(1)
		return 0

	handle_atmos()

	if(health <= 0)
		death()
		return

	if(health > maxHealth)
		health = maxHealth

	handle_stunned()
	handle_weakened()
	handle_paralysed()
	handle_confused()
	handle_supernatural()
	handle_impaired_vision()
	
	if(can_bleed && bleed_ticks > 0)
		handle_bleeding()

	if(buckled && can_escape)
		if(istype(buckled, /obj/effect/energy_net))
			var/obj/effect/energy_net/Net = buckled
			Net.escape_net(src)
		else if(prob(50))
			escape(src, buckled)
		else if(prob(50))
			visible_message("<span class='warning'>\The [src] struggles against \the [buckled]!</span>")

	//Movement
	if(!client && !stop_automated_movement && wander && !anchored)
		if(isturf(src.loc) && !resting)		//This is so it only moves if it's not inside a closet, gentics machine, etc.
			turns_since_move++
			if(turns_since_move >= turns_per_move)
				if(!(stop_automated_movement_when_pulled && pulledby)) //Some animals don't move when pulled
					SelfMove(pick(GLOB.cardinal))
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
	return 1

/mob/living/simple_animal/proc/handle_atmos(var/atmos_suitable = 1)
	//Atmos

	if(!loc)
		return

	var/datum/gas_mixture/environment = loc.return_air()
	if(!(MUTATION_SPACERES in mutations) && environment)

		if(abs(environment.temperature - bodytemperature) > 40 )
			bodytemperature += ((environment.temperature - bodytemperature) / 5)

		 // don't bother checking it twice if we got a supplied 0 val.
		if(atmos_suitable)
			if(LAZYLEN(min_gas))
				for(var/gas in min_gas)
					if(environment.gas[gas] < min_gas[gas])
						atmos_suitable = FALSE
						break
			if(atmos_suitable && LAZYLEN(max_gas))
				for(var/gas in max_gas)
					if(environment.gas[gas] > max_gas[gas])
						atmos_suitable = FALSE
						break

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

/mob/living/simple_animal/proc/escape(mob/living/M, obj/O)
	O.unbuckle_mob(M)
	visible_message("<span class='danger'>\The [M] escapes from \the [O]!</span>")

/mob/living/simple_animal/proc/handle_supernatural()
	if(purge)
		purge -= 1

/mob/living/simple_animal/gib()
	..(icon_gib,1)

/mob/living/simple_animal/proc/visible_emote(var/act_desc)
	custom_emote(1, act_desc)

/mob/living/simple_animal/proc/audible_emote(var/act_desc)
	custom_emote(2, act_desc)

/mob/living/simple_animal/bullet_act(var/obj/item/projectile/Proj)
	if(!Proj || Proj.nodamage)
		return

	var/damage = Proj.damage
	if(Proj.damtype == STUN)
		damage = Proj.damage / 6
	if(Proj.damtype == BRUTE)
		damage = Proj.damage / 2
	if(Proj.damtype == BURN)
		damage = Proj.damage / 1.5
	if(Proj.agony)
		damage += Proj.agony / 6
		if(health < Proj.agony * 3)
			Paralyse(Proj.agony / 20)
			visible_message("<span class='warning'>[src] is stunned momentarily!</span>")

	bullet_impact_visuals(Proj)
	adjustBruteLoss(damage)
	Proj.on_hit(src)
	return 0

/mob/living/simple_animal/attack_hand(mob/living/carbon/human/M as mob)
	..()

	switch(M.a_intent)

		if(I_HELP)
			if (health > 0)
				M.visible_message("<span class='notice'>[M] [response_help] \the [src].</span>")
				M.update_personal_goal(/datum/goal/achievement/specific_object/pet, type)

		if(I_DISARM)
			M.visible_message("<span class='notice'>[M] [response_disarm] \the [src].</span>")
			M.do_attack_animation(src)
			//TODO: Push the mob away or something

		if(I_HURT)
			var/dealt_damage = harm_intent_damage
			var/harm_verb = response_harm
			if(ishuman(M) && M.species)
				var/datum/unarmed_attack/attack = M.get_unarmed_attack(src)
				dealt_damage = attack.damage <= dealt_damage ? dealt_damage : attack.damage
				harm_verb = pick(attack.attack_verb)
				if(attack.sharp || attack.edge)
					adjustBleedTicks(dealt_damage)

			adjustBruteLoss(dealt_damage)
			M.visible_message("<span class='warning'>[M] [harm_verb] \the [src]!</span>")
			M.do_attack_animation(src)

	return

/mob/living/simple_animal/attackby(var/obj/item/O, var/mob/user)
	if(istype(O, /obj/item/stack/medical))
		if(stat != DEAD)
			var/obj/item/stack/medical/MED = O
			if(!MED.animal_heal)
				to_chat(user, "<span class='notice'>That [MED] won't help \the [src] at all!</span>")
				return
			if(health < maxHealth)
				if(MED.can_use(1))
					adjustBruteLoss(-MED.animal_heal)
					visible_message("<span class='notice'>[user] applies the [MED] on [src].</span>")
					MED.use(1)
		else
			to_chat(user, "<span class='notice'>\The [src] is dead, medical items won't bring \him back to life.</span>")
		return

	if(istype(O, /obj/item/device/flash))
		if(stat != DEAD)
			O.attack(src, user, user.zone_sel.selecting)
			return

	if(meat_type && (stat == DEAD) && meat_amount)
		if(istype(O, /obj/item/weapon/material/knife/kitchen/cleaver))
			var/victim_turf = get_turf(src)
			if(!locate(/obj/structure/table, victim_turf))
				to_chat(user, SPAN_NOTICE("You need to place \the [src] on a table to butcher it."))
				return
			var/time_to_butcher = (mob_size)
			to_chat(user, SPAN_NOTICE("You begin harvesting \the [src]."))
			if(do_after(user, time_to_butcher, src, same_direction = TRUE))
				if(prob(user.skill_fail_chance(SKILL_COOKING, 60, SKILL_ADEPT)))
					to_chat(user, SPAN_NOTICE("You botch harvesting \the [src], and ruin some of the meat in the process."))
					subtract_meat(user)
					return
				else	
					harvest(user, user.get_skill_value(SKILL_COOKING))
					return
			else
				to_chat(user, SPAN_NOTICE("Your hand slips with your movement, and some of the meat is ruined."))
				subtract_meat(user)
				return
				
	else
		if(!O.force)
			visible_message("<span class='notice'>[user] gently taps [src] with \the [O].</span>")
		else
			O.attack(src, user, user.zone_sel.selecting)

/mob/living/simple_animal/hit_with_weapon(obj/item/O, mob/living/user, var/effective_force, var/hit_zone)

	visible_message("<span class='danger'>\The [src] has been attacked with \the [O] by [user]!</span>")

	if(O.force <= resistance)
		to_chat(user, "<span class='danger'>This weapon is ineffective; it does no damage.</span>")
		return 0

	var/damage = O.force
	if (O.damtype == PAIN)
		damage = 0
	if (O.damtype == STUN)
		damage = (O.force / 8)
	if(supernatural && istype(O,/obj/item/weapon/nullrod))
		damage *= 2
		purge = 3
	adjustBruteLoss(damage)
	if(O.edge || O.sharp)
		adjustBleedTicks(damage)

	return 1

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

/mob/living/simple_animal/death(gibbed, deathmessage = "dies!", show_dead_message)
	icon_state = icon_dead
	update_icon()
	density = 0
	adjustBruteLoss(maxHealth) //Make sure dey dead.
	walk_to(src,0)
	return ..(gibbed,deathmessage,show_dead_message)

/mob/living/simple_animal/ex_act(severity)
	if(!blinded)
		flash_eyes()

	var/damage
	switch (severity)
		if (1)
			damage = 500

		if (2)
			damage = 120

		if(3)
			damage = 30

	apply_damage(damage, BRUTE, damage_flags = DAM_EXPLODE)

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
	return 1

/mob/living/simple_animal/say(var/message)
	var/verb = "says"
	if(speak_emote.len)
		verb = pick(speak_emote)

	message = sanitize(message)

	..(message, null, verb)

/mob/living/simple_animal/get_speech_ending(verb, var/ending)
	return verb

/mob/living/simple_animal/put_in_hands(var/obj/item/W) // No hands.
	W.forceMove(get_turf(src))
	return 1

// Harvest an animal's delicious byproducts
/mob/living/simple_animal/proc/harvest(var/mob/user, var/skill_level)
	var/actual_meat_amount = round(max(1,(meat_amount / 2) + skill_level / 2))
	user.visible_message("<span class='danger'>\The [user] chops up \the [src]!</span>")
	if(meat_type && actual_meat_amount > 0 && (stat == DEAD))
		for(var/i=0;i<actual_meat_amount;i++)
			var/obj/item/meat = new meat_type(get_turf(src))
			meat.SetName("[src.name] [meat.name]")
			if(can_bleed)
				var/obj/effect/decal/cleanable/blood/splatter/splat = new(get_turf(src))
				splat.basecolor = bleed_colour
				splat.update_icon()
			qdel(src)

/mob/living/simple_animal/proc/subtract_meat(var/mob/user)
	meat_amount--
	if(meat_amount <= 0)
		to_chat(user, SPAN_NOTICE("\The [src] carcass is ruined beyond use."))

/mob/living/simple_animal/bullet_impact_visuals(var/obj/item/projectile/P, var/def_zone)
	..()
	switch(get_bullet_impact_effect_type(def_zone))
		if(BULLET_IMPACT_MEAT)
			if(P.damtype == BRUTE)
				var/hit_dir = get_dir(P.starting, src)
				var/obj/effect/decal/cleanable/blood/B = blood_splatter(get_step(src, hit_dir), src, 1, hit_dir)
				B.icon_state = pick("dir_splatter_1","dir_splatter_2")
				B.basecolor = bleed_colour
				var/scale = min(1, round(mob_size / MOB_MEDIUM, 0.1))
				var/matrix/M = new()
				B.transform = M.Scale(scale)
				B.update_icon()

/mob/living/simple_animal/handle_fire()
	return

/mob/living/simple_animal/update_fire()
	return
/mob/living/simple_animal/IgniteMob()
	return
/mob/living/simple_animal/ExtinguishMob()
	return

/mob/living/simple_animal/is_burnable()
	return heat_damage_per_tick

/mob/living/simple_animal/proc/adjustBleedTicks(var/amount)
	if(!can_bleed)
		return

	if(amount > 0)
		bleed_ticks = max(bleed_ticks, amount)
	else
		bleed_ticks = max(bleed_ticks + amount, 0)
		
	bleed_ticks = round(bleed_ticks)
	
/mob/living/simple_animal/proc/handle_bleeding()
	bleed_ticks--
	adjustBruteLoss(1)
	
	var/obj/effect/decal/cleanable/blood/drip/drip = new(get_turf(src))
	drip.basecolor = bleed_colour
	drip.update_icon()

/mob/living/simple_animal/get_digestion_product()
	return /datum/reagent/nutriment

/mob/living/simple_animal/eyecheck()
	switch(flash_vulnerability)
		if(2 to INFINITY)
			return FLASH_PROTECTION_REDUCED
		if(1)
			return FLASH_PROTECTION_NONE
		if(0)
			return FLASH_PROTECTION_MAJOR
		else 
			return FLASH_PROTECTION_MAJOR

/mob/living/simple_animal/proc/reflect_unarmed_damage(var/mob/living/carbon/human/attacker, var/damage_type, var/description)
	if(attacker.a_intent == I_HURT)
		var/hand_hurtie
		if(attacker.hand)
			hand_hurtie = BP_L_HAND
		else
			hand_hurtie = BP_R_HAND
		attacker.apply_damage(rand(return_damage_min, return_damage_max), damage_type, hand_hurtie, used_weapon = description)
		if(rand(25))
			to_chat(attacker, SPAN_WARNING("Your attack has no obvious effect on \the [src]'s [description]!"))