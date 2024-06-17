/mob/living/carbon/human/proc/get_unarmed_attack(mob/target, hit_zone = null)
	if(!hit_zone)
		hit_zone = zone_sel.selecting

	if(default_attack && default_attack.is_usable(src, target, hit_zone))
		if(pulling_punches)
			var/datum/unarmed_attack/soft_type = default_attack.get_sparring_variant()
			if(soft_type)
				return soft_type
		return default_attack

	for(var/datum/unarmed_attack/u_attack in species.unarmed_attacks)
		if(u_attack.is_usable(src, target, hit_zone))
			if(pulling_punches)
				var/datum/unarmed_attack/soft_variant = u_attack.get_sparring_variant()
				if(soft_variant)
					return soft_variant
			return u_attack
	return null

/mob/living/carbon/human/attack_hand(mob/living/carbon/M as mob)

	var/mob/living/carbon/human/H = M
	if (!istype(H))
		if (M.a_intent == I_HURT)
			attack_generic(H,rand(1,3),"punched")
		return

	var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
	if (H.hand)
		temp = H.organs_by_name[BP_L_HAND]
	if (H.a_intent != I_HURT && (!temp || !temp.is_usable())) //Usability for harm is handled at the level of the attack datum's proc on get_attack_hand.
		to_chat(H, SPAN_WARNING("You can't use your hand."))
		return

	..()
	remove_cloaking_source(species)

	if (istype(H.gloves, /obj/item/clothing/gloves/boxing/hologlove))
		H.do_attack_animation(src)
		var/damage = rand(0, 9)
		var/hit_zone = resolve_hand_attack(damage, H, H.zone_sel.selecting)
		if (!hit_zone || !damage)
			playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
			visible_message(SPAN_DANGER("\The [H] has attempted to punch \the [src]!"))
			return

		var/obj/item/organ/external/affecting = get_organ(hit_zone)

		playsound(loc, "punch", 25, 1, -1)

		update_personal_goal(/datum/goal/achievement/fistfight, TRUE)
		H.update_personal_goal(/datum/goal/achievement/fistfight, TRUE)

		visible_message(SPAN_DANGER("[H] has punched \the [src] in the [affecting.name]!"))

		apply_damage(damage, DAMAGE_PAIN, affecting)
		if (damage >= 9)
			visible_message(SPAN_DANGER("[H] has weakened \the [src]!"))
			var/armor_block = 100 * get_blocked_ratio(affecting, DAMAGE_BRUTE, damage = damage)
			apply_effect(4, EFFECT_WEAKEN, armor_block)
		return

	for (var/obj/item/grab/G in H)
		if (G.assailant == H && G.affecting == src)
			if(G.resolve_openhand_attack())
				return

	switch(M.a_intent)
		if(I_HELP)
			if(MUTATION_FERAL in M.mutations)
				return
			if (H != src && istype(H) && (is_asystole() || (status_flags & FAKEDEATH) || failed_last_breath) && !(H.zone_sel.selecting == BP_R_ARM || H.zone_sel.selecting == BP_L_ARM))
				if (!cpr_time)
					return

				var/pumping_skill = max(M.get_skill_value(SKILL_MEDICAL),M.get_skill_value(SKILL_ANATOMY))
				var/cpr_delay = 15 * M.skill_delay_mult(SKILL_ANATOMY, 0.2)
				cpr_time = 0

				H.visible_message(SPAN_NOTICE("\The [H] is trying to perform CPR on \the [src]."))

				if (!do_after(H, cpr_delay, src, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
					cpr_time = 1
					return
				cpr_time = 1

				H.visible_message(SPAN_NOTICE("\The [H] performs CPR on \the [src]!"))

				if (is_asystole())
					if (prob(5 + 5 * (SKILL_EXPERIENCED - pumping_skill)))
						var/obj/item/organ/external/chest = get_organ(BP_CHEST)
						if (chest)
							chest.fracture()

					var/obj/item/organ/internal/heart/heart = internal_organs_by_name[BP_HEART]
					if (heart)
						heart.external_pump = list(world.time, 0.4 + 0.05*pumping_skill + Frand(-0.1,0.1))

					if (stat != DEAD && prob(2 * pumping_skill))
						resuscitate()

				if (!H.check_has_mouth())
					to_chat(H, SPAN_WARNING("You don't have a mouth, you cannot do mouth-to-mouth resuscitation!"))
					return
				if (!check_has_mouth())
					to_chat(H, SPAN_WARNING("They don't have a mouth, you cannot do mouth-to-mouth resuscitation!"))
					return
				if ((H.head && (H.head.body_parts_covered & FACE)) || (H.wear_mask && (H.wear_mask.body_parts_covered & FACE)))
					to_chat(H, SPAN_WARNING("You need to remove your mouth covering for mouth-to-mouth resuscitation!"))
					return
				if ((head && (head.body_parts_covered & FACE)) || (wear_mask && (wear_mask.body_parts_covered & FACE)))
					to_chat(H, SPAN_WARNING("You need to remove \the [src]'s mouth covering for mouth-to-mouth resuscitation!"))
					return
				if (!H.internal_organs_by_name[H.species.breathing_organ])
					to_chat(H, SPAN_DANGER("You need lungs for mouth-to-mouth resuscitation!"))
					return
				if (!need_breathe())
					return
				var/obj/item/organ/internal/lungs/L = internal_organs_by_name[species.breathing_organ]
				if (L)
					var/datum/gas_mixture/breath = H.get_breath_from_environment()
					var/fail = L.handle_breath(breath, 1)
					if (!fail)
						if (!L.is_bruised())
							losebreath = 0
						to_chat(src, SPAN_NOTICE("You feel a breath of fresh air enter your lungs. It feels good."))

			else if (!(M == src && apply_pressure(M, M.zone_sel.selecting)))
				help_shake_act(M)
			return

		if (I_GRAB)
			if (H != src && check_shields(0, null, H, H.zone_sel.selecting, H.name))
				H.do_attack_animation(src)
				return
			return H.species.attempt_grab(H, src)

		if (I_HURT)
			var/datum/unarmed_attack/attack = H.get_unarmed_attack(src, H.zone_sel.selecting)
			var/rand_damage = rand(1, 5)
			if (!attack)
				return
			if(H.incapacitated())
				to_chat(H, SPAN_NOTICE("You can't attack while incapacitated."))
				return

			if (world.time < H.last_attack + attack.delay)
				to_chat(H, SPAN_NOTICE("You can't attack again so soon."))
				return
			else
				H.last_attack = world.time

			H.do_attack_animation(src)
			var/hit_zone = resolve_hand_attack(rand_damage, H, H.zone_sel.selecting)
			if (!hit_zone)
				H.visible_message(SPAN_DANGER("[H] attempted to strike [src], but missed!"))
				playsound(loc, attack.miss_sound, 25, 1, -1)
				return

			var/obj/item/organ/external/affecting = get_organ(hit_zone)
			if (!affecting)
				return

			if (hit_zone != H.zone_sel.selecting) //If resolve_hand_attack returned a different zone, that means you're not as accurate.
				if (prob(15) && hit_zone != BP_CHEST && lying)
					var/datum/pronouns/pronouns = choose_from_pronouns()
					H.visible_message(SPAN_DANGER("\The [H] attempted to strike \the [src], but [pronouns.he] rolled out of the way!"))
					set_dir(pick(GLOB.cardinal))
					playsound(loc, attack.miss_sound, 25, 1, -1)
					return

			if (a_intent == I_HELP || buckled || lying)
				rand_damage = 5
			for (var/obj/item/grab/G in grabbed_by)
				if (G.stop_move())
					rand_damage = 5

			var/real_damage = rand_damage
			real_damage += attack.get_unarmed_damage(H)
			real_damage = max(1, real_damage)

			attack.show_attack(H, src, hit_zone, real_damage)
			playsound(loc, attack.attack_sound, 25, 1, -1)
			attack.apply_effects(H, src, real_damage, hit_zone)
			apply_damage(real_damage, attack.get_damage_type(), hit_zone, damage_flags=attack.damage_flags())
			if (attack.should_attack_log)
				admin_attack_log(H, src, "Has [pick(attack.attack_verb)] their victim.", "was [pick(attack.attack_verb)] by their attacker", "has [pick(attack.attack_verb)]")

			if (ai_holder)
				ai_holder.react_to_attack(H)

		if (I_DISARM)
			if (H.species)
				if (H != src && check_shields(0, null, H, H.zone_sel.selecting, H.name))
					H.do_attack_animation(src)
					return
				admin_attack_log(M, src, "Disarmed their victim.", "Was disarmed.", "disarmed")
				H.species.disarm_attackhand(H, src)
	return

/mob/living/carbon/human/attack_generic(mob/user, damage, attack_message, environment_smash, damtype = DAMAGE_BRUTE, armorcheck = "melee", dam_flags = EMPTY_BITFIELD)

	if(!damage || !istype(user))
		return
	admin_attack_log(user, src, "Attacked their victim", "Was attacked", "has [attack_message]")
	src.visible_message(SPAN_DANGER("[user] has [attack_message] [src]!"))
	user.do_attack_animation(src)

	var/dam_zone = pick(organs_by_name)
	var/obj/item/organ/external/affecting = get_organ(ran_zone(dam_zone))
	apply_damage(damage, damtype, affecting, dam_flags)
	updatehealth()

//Breaks all grips and pulls that the mob currently has.
/mob/living/carbon/human/proc/break_all_grabs(mob/living/carbon/user)
	var/success = 0
	if(pulling)
		visible_message(SPAN_DANGER("[user] has broken [src]'s grip on [pulling]!"))
		success = 1
		stop_pulling()

	for (var/obj/item/grab/grab as anything in GetAllHeld(/obj/item/grab))
		if(grab.affecting)
			visible_message(SPAN_DANGER("\The [user] has broken \the [src]'s grip on \the [grab.affecting]!"))
			success = TRUE
		spawn(1)
			grab.current_grab.let_go(grab)

	return success
/*
	We want to ensure that a mob may only apply pressure to one organ of one mob at any given time. Currently this is done mostly implicitly through
	the behaviour of do_after() and the fact that applying pressure to someone else requires a grab:

	If you are applying pressure to yourself and attempt to grab someone else, you'll change what you are holding in your active hand which will stop do_after()
	If you are applying pressure to another and attempt to apply pressure to yourself, you'll have to switch to an empty hand which will also stop do_after()
	Changing targeted zones should also stop do_after(), preventing you from applying pressure to more than one body part at once.
*/
/mob/living/carbon/human/proc/apply_pressure(mob/living/user, target_zone)
	var/obj/item/organ/external/organ = get_organ(target_zone)
	var/datum/pronouns/pronouns = user.choose_from_pronouns()
	if(!organ || !(organ.status & ORGAN_BLEEDING) || BP_IS_ROBOTIC(organ))
		return 0

	if(organ.applied_pressure)
		var/message = SPAN_WARNING("[ismob(organ.applied_pressure)? "Someone" : "\A [organ.applied_pressure]"] is already applying pressure to [user == src? "your [organ.name]" : "[src]'s [organ.name]"].")
		to_chat(user, message)
		return 0

	if(user == src)
		user.visible_message("\The [user] starts applying pressure to [pronouns.his] [organ.name]!", "You start applying pressure to your [organ.name]!")
	else
		user.visible_message("\The [user] starts applying pressure to [src]'s [organ.name]!", "You start applying pressure to [src]'s [organ.name]!")
	spawn(0)
		organ.applied_pressure = user

		//apply pressure as long as they stay still and keep grabbing
		do_after(user, INFINITY, src, (DO_DEFAULT & ~DO_SHOW_PROGRESS) | DO_USER_SAME_ZONE)

		organ.applied_pressure = null

		if(user == src)
			user.visible_message("\The [user] stops applying pressure to [pronouns.his] [organ.name]!", "You stop applying pressure to your [organ.name]!")
		else
			user.visible_message("\The [user] stops applying pressure to [src]'s [organ.name]!", "You stop applying pressure to [src]'s [organ.name]!")

	return 1

/mob/living/carbon/human/verb/set_default_unarmed_attack()
	set name = "Set Default Unarmed Attack"
	set category = "IC"
	set src = usr

	var/list/choices = list()
	for(var/thing in species.unarmed_attacks)
		var/datum/unarmed_attack/u_attack = thing
		choices[u_attack.attack_name] = u_attack

	var/selection = input("Select a default attack (currently selected: [default_attack ? default_attack.attack_name : "none"]).", "Default Unarmed Attack") as null|anything in choices
	if(selection && !(choices[selection] in species.unarmed_attacks))
		return

	default_attack = selection ? choices[selection] : null
	to_chat(src, SPAN_NOTICE("Your default unarmed attack is now <b>[default_attack ? default_attack.attack_name : "cleared"]</b>."))
