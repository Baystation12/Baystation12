/obj/item/grab/normal
	type_name = GRAB_NORMAL
	start_grab_name = NORM_PASSIVE

/obj/item/grab/normal/init()
	if(!(. = ..()))
		return
	var/obj/O = get_targeted_organ()
	if(affecting != assailant)
		visible_message(SPAN_WARNING("\The [assailant] has grabbed \the [affecting]'s [O.name]!"))
	else
		var/datum/pronouns/P = assailant.choose_from_pronouns()
		visible_message(SPAN_NOTICE("\The [assailant] has grabbed [P.his] [O.name]!"))

	if(!(affecting.a_intent == I_HELP))
		upgrade(TRUE)

/datum/grab/normal
	type_name = GRAB_NORMAL

	var/drop_headbutt = 1

	icon = 'icons/mob/screen1.dmi'

	help_action = "inspect"
	disarm_action = "pin"
	grab_action = "jointlock"
	harm_action = "dislocate"

/datum/grab/normal/on_hit_help(obj/item/grab/normal/G)
	var/obj/item/organ/external/O = G.get_targeted_organ()
	if(O)
		O.inspect(G.assailant)
		return TRUE
	else return FALSE

/datum/grab/normal/on_hit_disarm(obj/item/grab/G)
	var/mob/living/carbon/human/affecting = G.affecting
	var/mob/living/carbon/human/assailant = G.assailant

	if (!G.attacking && !affecting.lying)
		affecting.visible_message(SPAN_NOTICE("\The [assailant] is trying to pin \the [affecting] to the ground!"))
		G.attacking = 1

		if (do_after(assailant, action_cooldown - 1, affecting, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS) && assailant.use_sanity_check(affecting, G))
			G.attacking = 0
			G.action_used()
			affecting.Weaken(2)
			affecting.visible_message(SPAN_NOTICE("\The [assailant] pins \the [affecting] to the ground!"))

			return TRUE
		else
			affecting.visible_message(SPAN_NOTICE("\The [assailant] fails to pin \the [affecting] to the ground."))
			G.attacking = 0
			return TRUE
	else
		return FALSE


/datum/grab/normal/on_hit_grab(obj/item/grab/G)
	var/obj/item/organ/external/O = G.get_targeted_organ()
	var/mob/living/carbon/human/assailant = G.assailant
	var/mob/living/carbon/human/affecting = G.affecting

	if (!assailant.skill_check(SKILL_COMBAT, SKILL_TRAINED))
		to_chat(assailant, SPAN_NOTICE("You don't know how to do a jointlock!"))
		return FALSE

	if(!O)
		to_chat(assailant, SPAN_WARNING("\The [affecting] is missing that body part!"))
		return FALSE

	assailant.visible_message(SPAN_CLASS("danger", "\The [assailant] begins to [pick("bend", "twist")] \the [affecting]'s [O.name] into a jointlock!"))
	G.attacking = 1

	if (do_after(assailant, action_cooldown - 1, affecting, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS) && assailant.use_sanity_check(affecting, G))
		if (!G.has_hold_on_organ(O))
			to_chat(assailant, SPAN_WARNING("You must keep a hold on your target to jointlock!"))
			return TRUE


		G.attacking = 0
		G.action_used()
		O.jointlock(assailant)
		assailant.visible_message(SPAN_DANGER("\The [affecting]'s [O.name] is twisted!"))
		playsound(assailant.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
		return TRUE

	else

		affecting.visible_message(SPAN_NOTICE("\The [assailant] fails to jointlock \the [affecting]'s [O.name]."))
		G.attacking = 0
		return TRUE


/datum/grab/normal/on_hit_harm(obj/item/grab/G)
	var/obj/item/organ/external/O = G.get_targeted_organ()
	var/mob/living/carbon/human/assailant = G.assailant
	var/mob/living/carbon/human/affecting = G.affecting

	if (!assailant.skill_check(SKILL_COMBAT, SKILL_TRAINED))
		to_chat(assailant, SPAN_NOTICE("You don't know how to dislocate a joint!"))
		return FALSE

	if (!O)
		to_chat(assailant, SPAN_WARNING("\The [affecting] is missing that body part!"))
		return FALSE

	if (!O.dislocated)

		assailant.visible_message(SPAN_WARNING("\The [assailant] begins to dislocate \the [affecting]'s [O.joint]!"))
		G.attacking = 1

		if (do_after(assailant, action_cooldown - 1, affecting, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS) && assailant.use_sanity_check(affecting, G))

			if (!G.has_hold_on_organ(O))
				to_chat(assailant, SPAN_WARNING("You must keep a hold on your target to dislocate!"))
				return TRUE

			G.attacking = 0
			G.action_used()
			O.dislocate(1)
			assailant.visible_message(SPAN_CLASS("danger", "[affecting]'s [O.joint] [pick("gives way","caves in","crumbles","collapses")]!"))
			playsound(assailant.loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
			return TRUE

		else

			affecting.visible_message(SPAN_NOTICE("\The [assailant] fails to dislocate \the [affecting]'s [O.joint]."))
			G.attacking = 0
			return TRUE

	else if (O.dislocated > 0)
		to_chat(assailant, SPAN_WARNING("\The [affecting]'s [O.joint] is already dislocated!"))
		return FALSE
	else
		to_chat(assailant, SPAN_WARNING("You can't dislocate \the [affecting]'s [O.joint]!"))
		return FALSE

/datum/grab/normal/resolve_openhand_attack(obj/item/grab/G)
	if(G.assailant.a_intent != I_HELP)
		if(G.assailant.zone_sel.selecting == BP_HEAD)
			if(headbutt(G))
				if(drop_headbutt)
					let_go()
				return TRUE
		else if(G.assailant.zone_sel.selecting == BP_EYES)
			if(attack_eye(G))
				return TRUE
	return 0

/datum/grab/normal/proc/attack_eye(obj/item/grab/G)
	var/mob/living/carbon/human/attacker = G.assailant
	var/mob/living/carbon/human/target = G.affecting

	var/datum/unarmed_attack/attack = attacker.get_unarmed_attack(target, BP_EYES)

	if(!attack)
		return
	for(var/obj/item/protection in list(target.head, target.wear_mask, target.glasses))
		if(protection && (protection.body_parts_covered & EYES))
			to_chat(attacker, SPAN_DANGER("You're going to need to remove the eye covering first."))
			return
	if(!target.has_eyes())
		to_chat(attacker, SPAN_DANGER("You cannot locate any eyes on \the [target]!"))
		return

	admin_attack_log(attacker, target, "Grab attacked the victim's eyes.", "Had their eyes grab attacked.", "attacked the eyes, using a grab action, of")

	attack.handle_eye_attack(attacker, target)
	return TRUE

/datum/grab/normal/proc/headbutt(obj/item/grab/G)
	var/mob/living/carbon/human/attacker = G.assailant
	var/mob/living/carbon/human/target = G.affecting
	var/datum/pronouns/pronouns = attacker.choose_from_pronouns()

	if(!attacker.skill_check(SKILL_COMBAT, SKILL_BASIC))
		return

	if(target.lying)
		return

	var/damage = 20
	var/obj/item/clothing/hat = attacker.head
	var/damage_flags = 0
	if(istype(hat))
		damage += hat.force * 3
		damage_flags = hat.damage_flags()

	if(damage_flags & DAMAGE_FLAG_SHARP)
		attacker.visible_message(SPAN_CLASS("danger", "\The [attacker] gores \the [target][istype(hat)? " with \the [hat]" : ""]!"))
	else
		attacker.visible_message(SPAN_DANGER("\The [attacker] thrusts [pronouns.his] head into \the [target]'s skull!"))

	var/armor = target.get_blocked_ratio(BP_HEAD, DAMAGE_BRUTE, damage = 10)
	target.apply_damage(damage, DAMAGE_BRUTE, BP_HEAD, damage_flags)
	attacker.apply_damage(10, DAMAGE_BRUTE, BP_HEAD)

	if(armor < 0.5 && target.headcheck(BP_HEAD) && prob(damage))
		target.apply_effect(20, EFFECT_PARALYZE)
		target.visible_message(SPAN_DANGER("[target] [target.species.get_knockout_message(target)]"))

	playsound(attacker.loc, "swing_hit", 25, 1, -1)

	admin_attack_log(attacker, target, "Headbutted their victim.", "Was headbutted.", "headbutted")
	return TRUE

// Handles special targeting like eyes and mouth being covered.
/datum/grab/normal/special_target_effect(obj/item/grab/G)
	if(G.special_target_functional)
		switch(G.target_zone)
			if(BP_MOUTH)
				if(G.affecting.silent < 2)
					G.affecting.silent = 2
			if(BP_EYES)
				if(G.affecting.eye_blind < 2)
					G.affecting.eye_blind = 2

// Handles when they change targeted areas and something is supposed to happen.
/datum/grab/normal/special_target_change(obj/item/grab/G, old_zone, new_zone)
	if(old_zone != BP_HEAD && old_zone != BP_CHEST)
		return
	switch(new_zone)
		if(BP_MOUTH)
			G.assailant.visible_message(SPAN_WARNING("\The [G.assailant] covers \the [G.affecting]'s mouth!"))
		if(BP_EYES)
			G.assailant.visible_message(SPAN_WARNING("\The [G.assailant] covers \the [G.affecting]'s eyes!"))


/datum/grab/normal/check_special_target(obj/item/grab/G)
	switch(G.target_zone)
		if(BP_MOUTH)
			if(!G.affecting.check_has_mouth())
				to_chat(G.assailant, SPAN_DANGER("You cannot locate a mouth on \the [G.affecting]!"))
				return 0
		if(BP_EYES)
			if(!G.affecting.has_eyes())
				to_chat(G.assailant, SPAN_DANGER("You cannot locate any eyes on \the [G.affecting]!"))
				return 0
	return TRUE

/datum/grab/normal/resolve_item_attack(obj/item/grab/G, mob/living/carbon/human/user, obj/item/I)
	switch(G.assailant.zone_sel.selecting)
		if(BP_HEAD, BP_MOUTH)
			return attack_throat(G, I, user)
		else
			return attack_tendons(G, I, user, G.assailant.zone_sel.selecting)

/datum/grab/normal/proc/attack_throat(obj/item/grab/G, obj/item/W, mob/living/carbon/human/user)
	var/mob/living/carbon/human/affecting = G.affecting

	if(user.a_intent != I_HURT)
		return 0 // Not trying to hurt them.

	if (!W.edge || !W.force || W.damtype != DAMAGE_BRUTE)
		return 0 //unsuitable weapon
	user.visible_message(SPAN_DANGER("\The [user] begins to slit \the [affecting]'s throat with \the [W]!"))

	user.next_move = world.time + 20 //also should prevent user from triggering this repeatedly
	if(!do_after(user, 2 SECONDS * user.skill_delay_mult(SKILL_COMBAT), affecting, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
		return 0
	if(!(G && G.affecting == affecting)) //check that we still have a grab
		return 0

	var/damage_mod = 1
	var/damage_flags = W.damage_flags()
	//presumably, if they are wearing a helmet that stops pressure effects, then it probably covers the throat as well
	var/obj/item/clothing/head/helmet = affecting.get_equipped_item(slot_head)
	if(istype(helmet) && (helmet.body_parts_covered & HEAD) && (helmet.item_flags & ITEM_FLAG_AIRTIGHT) && !isnull(helmet.max_pressure_protection))
		var/datum/extension/armor/armor_datum = get_extension(helmet, /datum/extension/armor)
		if(armor_datum)
			damage_mod -= armor_datum.get_blocked(DAMAGE_BRUTE, damage_flags, W.armor_penetration, W.force*1.5)

	var/total_damage = 0
	for(var/i in 1 to 3)
		var/damage = min(W.force*2.5, 30)*damage_mod
		affecting.apply_damage(damage, W.damtype, BP_HEAD, damage_flags, armor_pen = 100, used_weapon=W)
		total_damage += damage


	if(total_damage)
		user.visible_message(SPAN_DANGER("\The [user] slit \the [affecting]'s throat open with \the [W]!"))

		if(W.hitsound)
			playsound(affecting.loc, W.hitsound, 50, 1, -1)

	G.last_action = world.time

	admin_attack_log(user, affecting, "Knifed their victim", "Was knifed", "knifed")
	return TRUE

/datum/grab/normal/proc/attack_tendons(obj/item/grab/G, obj/item/W, mob/living/carbon/human/user, target_zone)
	var/mob/living/carbon/human/affecting = G.affecting

	if(!user.skill_check(SKILL_COMBAT, SKILL_TRAINED))
		return

	if(user.a_intent != I_HURT)
		return 0 // Not trying to hurt them.

	if (!W.edge || !W.force || W.damtype != DAMAGE_BRUTE)
		return 0 //unsuitable weapon

	var/obj/item/organ/external/O = affecting.get_organ(target_zone)
	if(!O || O.is_stump() || !(O.limb_flags & ORGAN_FLAG_HAS_TENDON) || (O.status & ORGAN_TENDON_CUT))
		return FALSE

	user.visible_message(SPAN_DANGER("\The [user] begins to cut \the [affecting]'s [O.tendon_name] with \the [W]!"))
	user.next_move = world.time + 20

	if(!do_after(user, 2 SECONDS, affecting, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
		return 0
	if(!(G && G.affecting == affecting)) //check that we still have a grab
		return 0
	if(!O || O.is_stump() || !O.sever_tendon())
		return 0

	user.visible_message(SPAN_DANGER("\The [user] cut \the [affecting]'s [O.tendon_name] with \the [W]!"))
	if(W.hitsound) playsound(affecting.loc, W.hitsound, 50, 1, -1)
	G.last_action = world.time
	admin_attack_log(user, affecting, "hamstrung their victim", "was hamstrung", "hamstrung")
	return TRUE
