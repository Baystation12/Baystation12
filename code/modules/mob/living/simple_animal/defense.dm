/mob/living/simple_animal/bullet_act(obj/item/projectile/Proj)
	if(!Proj || Proj.nodamage)
		return
	if (status_flags & GODMODE)
		return PROJECTILE_FORCE_MISS

	var/damage = Proj.damage
	if (Proj.damtype == DAMAGE_STUN)
		damage = Proj.damage / 6
	if (Proj.damtype == DAMAGE_BRUTE)
		damage = Proj.damage / 2
	if (Proj.damtype == DAMAGE_BURN)
		damage = Proj.damage / 1.5
	if(Proj.agony)
		damage += Proj.agony / 6
		if(health < Proj.agony * 3)
			Paralyse(Proj.agony / 20)
			visible_message(SPAN_WARNING("[src] is stunned momentarily!"))

	bullet_impact_visuals(Proj)
	adjustBruteLoss(damage)
	Proj.on_hit(src)

	if (ai_holder && Proj.firer)
		ai_holder.react_to_attack(Proj.firer)

	return FALSE

/mob/living/simple_animal/attack_hand(mob/living/carbon/human/M as mob)
	..()
	switch (M.a_intent)
		if (I_HELP)
			if (health > 0)
				M.visible_message(SPAN_NOTICE("\The [M] [response_help] \the [src]."))
				M.update_personal_goal(/datum/goal/achievement/specific_object/pet, type)

		if (I_DISARM)
			M.visible_message(SPAN_NOTICE("\The [M] [response_disarm] \the [src]."))
			M.do_attack_animation(src)

		if (I_HURT)
			var/dealt_damage = harm_intent_damage
			var/harm_verb = response_harm
			if (ishuman(M) && M.species)
				var/datum/unarmed_attack/attack = M.get_unarmed_attack(src)
				dealt_damage = attack.damage <= dealt_damage ? dealt_damage : attack.damage
				harm_verb = pick(attack.attack_verb)
				playsound(loc, attack.attack_sound, 25, 1, -1)
				if(attack.sharp || attack.edge)
					adjustBleedTicks(dealt_damage)

			adjustBruteLoss(dealt_damage)
			M.visible_message(SPAN_WARNING("\The [M] [harm_verb] \the [src]!"))
			M.do_attack_animation(src)

			if (ai_holder)
				ai_holder.react_to_attack(M)

	return

/mob/living/simple_animal/use_tool(obj/item/tool, mob/user, list/click_params)
	// Butcher's Cleaver - Butcher dead mob
	if (istype(tool, /obj/item/material/knife/kitchen/cleaver))
		if (stat != DEAD)
			USE_FEEDBACK_FAILURE("\The [src] must be dead before you can butcher \him.")
			return TRUE
		if (!meat_type || !meat_amount)
			USE_FEEDBACK_FAILURE("\The [src] can't be butchered.")
			return TRUE
		var/turf/turf = get_turf(src)
		if (!locate(/obj/structure/table, turf))
			USE_FEEDBACK_FAILURE("You need to place \the [src] on a table to butcher \him.")
			return TRUE
		var/time_to_butcher = mob_size
		user.visible_message(
			SPAN_WARNING("\The [user] begins butchering \the [src]'s corpse with \a [tool]."),
			SPAN_WARNING("You begin \the [src]'s corpse with \the [tool].")
		)
		if (!user.do_skilled(time_to_butcher, SKILL_COOKING, src) || !user.use_sanity_check(src, tool))
			USE_FEEDBACK_FAILURE("Some of \the [src]'s meat is ruined.")
			subtract_meat(user)
			return TRUE
		if (prob(user.skill_fail_chance(SKILL_COOKING, 60, SKILL_TRAINED)))
			subtract_meat(user)
			user.visible_message(
				SPAN_WARNING("\The [user] botches harvesting \the [src], and ruins some of the meat in the process."),
				SPAN_WARNING("You botch harvesting \the [src], and ruins some of the meat in the process.")
			)
			return TRUE
		harvest(user, user.get_skill_value(SKILL_COOKING))
		user.visible_message(
			SPAN_WARNING("\The [user] harvests some meat from \the [src] with \a [tool]."),
			SPAN_WARNING("You harvest some meat from \the [src] with \the [tool].")
		)
		return TRUE

	// Medical - Attempt healing
	if (istype(tool, /obj/item/stack/medical))
		if (stat == DEAD)
			USE_FEEDBACK_FAILURE("\The [src] is dead, medical items won't bring \him back to life.")
			return TRUE
		if (health >= maxHealth)
			USE_FEEDBACK_FAILURE("\The [src] doesn't need any healing.")
			return TRUE
		var/obj/item/stack/medical/medical = tool
		if (!medical.animal_heal)
			USE_FEEDBACK_FAILURE("\The [medical] won't help \the [src].")
			return TRUE
		if (!medical.use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(medical, 1, "to heal \the [src].")
			return TRUE
		adjustBruteLoss(-medical.animal_heal)
		user.visible_message(
			SPAN_NOTICE("\The [user] applies [medical.get_vague_name(FALSE)] to \the [src]'s injuries."),
			SPAN_NOTICE("You apply [medical.get_exact_name(1)] to \the [src]'s injuries."),
			exclude_mobs = list(src)
		)
		to_chat(src, SPAN_NOTICE("\The [user] applies [medical.get_vague_name(FALSE)] to your injuries."),)
		return TRUE

	return ..()

/mob/living/simple_animal/hit_with_weapon(obj/item/O, mob/living/user, effective_force, hit_zone)
	if(O.force <= resistance)
		to_chat(user, SPAN_DANGER("This weapon is ineffective; it does no damage."))
		return FALSE

	var/damage = O.force
	if (O.damtype == DAMAGE_PAIN)
		damage = 0
	if (O.damtype == DAMAGE_STUN)
		damage = (O.force / 8)
	if (supernatural && istype(O,/obj/item/nullrod))
		damage *= 2
		purge = 3
	adjustBruteLoss(damage)
	if (O.edge || O.sharp)
		adjustBleedTicks(damage)
	return TRUE

/mob/living/simple_animal/proc/reflect_unarmed_damage(mob/living/carbon/human/attacker, damage_type, description)
	if(attacker.a_intent == I_HURT)
		var/hand_hurtie
		if(attacker.hand)
			hand_hurtie = BP_L_HAND
		else
			hand_hurtie = BP_R_HAND
		attacker.apply_damage(rand(return_damage_min, return_damage_max), damage_type, hand_hurtie, used_weapon = description)
		if(rand(25))
			to_chat(attacker, SPAN_WARNING("Your attack has no obvious effect on \the [src]'s [description]!"))
