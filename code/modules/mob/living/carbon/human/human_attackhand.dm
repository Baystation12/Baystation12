/mob/living/carbon/human/proc/get_unarmed_attack(var/mob/target, var/hit_zone = null)
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
	if(istype(H))
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		if(H.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(!temp || !temp.is_usable())
			to_chat(H, "<span class='warning'>You can't use your hand.</span>")
			return

	..()
	remove_cloaking_source(species)
	// Should this all be in Touch()?
	if(istype(H))
		if(H != src && check_shields(0, null, H, H.zone_sel.selecting, H.name))
			H.do_attack_animation(src)
			return 0

		if(istype(H.gloves, /obj/item/clothing/gloves/boxing/hologlove))
			H.do_attack_animation(src)
			var/damage = rand(0, 9)
			if(!damage)
				playsound(loc, 'sound/weapons/punchmiss.ogg', 25, 1, -1)
				visible_message("<span class='danger'>\The [H] has attempted to punch \the [src]!</span>")
				return 0
			var/obj/item/organ/external/affecting = get_organ(ran_zone(H.zone_sel.selecting))

			if(MUTATION_HULK in H.mutations)
				damage += 5

			playsound(loc, "punch", 25, 1, -1)

			update_personal_goal(/datum/goal/achievement/fistfight, TRUE)
			H.update_personal_goal(/datum/goal/achievement/fistfight, TRUE)

			visible_message("<span class='danger'>[H] has punched \the [src]!</span>")

			apply_damage(damage, DAMAGE_PAIN, affecting)
			if(damage >= 9)
				visible_message("<span class='danger'>[H] has weakened \the [src]!</span>")
				var/armor_block = 100 * get_blocked_ratio(affecting, DAMAGE_BRUTE, damage = damage)
				apply_effect(4, EFFECT_WEAKEN, armor_block)

			return

	if(istype(H))
		for (var/obj/item/grab/G in H)
			if (G.assailant == H && G.affecting == src)
				if(G.resolve_openhand_attack())
					return 1

	switch(M.a_intent)
		if(I_HELP)
			if(MUTATION_FERAL in M.mutations)
				return 0
			if(H != src && istype(H) && (is_asystole() || (status_flags & FAKEDEATH) || failed_last_breath) && !(H.zone_sel.selecting == BP_R_ARM || H.zone_sel.selecting == BP_L_ARM))
				if (!cpr_time)
					return 0

				var/pumping_skill = max(M.get_skill_value(SKILL_MEDICAL),M.get_skill_value(SKILL_ANATOMY))
				var/cpr_delay = 15 * M.skill_delay_mult(SKILL_ANATOMY, 0.2)
				cpr_time = 0

				H.visible_message("<span class='notice'>\The [H] is trying to perform CPR on \the [src].</span>")

				if(!do_after(H, cpr_delay, src, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
					cpr_time = 1
					return
				cpr_time = 1

				H.visible_message("<span class='notice'>\The [H] performs CPR on \the [src]!</span>")

				if(is_asystole())
					if(prob(5 + 5 * (SKILL_EXPERT - pumping_skill)))
						var/obj/item/organ/external/chest = get_organ(BP_CHEST)
						if(chest)
							chest.fracture()

					var/obj/item/organ/internal/heart/heart = internal_organs_by_name[BP_HEART]
					if(heart)
						heart.external_pump = list(world.time, 0.4 + 0.1*pumping_skill + rand(-0.1,0.1))

					if(stat != DEAD && prob(2 * pumping_skill))
						resuscitate()

				if(!H.check_has_mouth())
					to_chat(H, "<span class='warning'>You don't have a mouth, you cannot do mouth-to-mouth resuscitation!</span>")
					return
				if(!check_has_mouth())
					to_chat(H, "<span class='warning'>They don't have a mouth, you cannot do mouth-to-mouth resuscitation!</span>")
					return
				if((H.head && (H.head.body_parts_covered & FACE)) || (H.wear_mask && (H.wear_mask.body_parts_covered & FACE)))
					to_chat(H, "<span class='warning'>You need to remove your mouth covering for mouth-to-mouth resuscitation!</span>")
					return 0
				if((head && (head.body_parts_covered & FACE)) || (wear_mask && (wear_mask.body_parts_covered & FACE)))
					to_chat(H, "<span class='warning'>You need to remove \the [src]'s mouth covering for mouth-to-mouth resuscitation!</span>")
					return 0
				if (!H.internal_organs_by_name[H.species.breathing_organ])
					to_chat(H, "<span class='danger'>You need lungs for mouth-to-mouth resuscitation!</span>")
					return
				if(!need_breathe())
					return
				var/obj/item/organ/internal/lungs/L = internal_organs_by_name[species.breathing_organ]
				if(L)
					var/datum/gas_mixture/breath = H.get_breath_from_environment()
					var/fail = L.handle_breath(breath, 1)
					if(!fail)
						if (!L.is_bruised())
							losebreath = 0
						to_chat(src, "<span class='notice'>You feel a breath of fresh air enter your lungs. It feels good.</span>")

			else if(!(M == src && apply_pressure(M, M.zone_sel.selecting)))
				help_shake_act(M)
			return 1

		if(I_GRAB)
			return H.species.attempt_grab(H, src)

		if(I_HURT)
			if(H.incapacitated())
				to_chat(H, "<span class='notice'>You can't attack while incapacitated.</span>")
				return

			if(!istype(H))
				attack_generic(H,rand(1,3),"punched")
				return

			var/rand_damage = rand(1, 5)
			var/block = 0
			var/accurate = 0
			var/hit_zone = H.zone_sel.selecting
			var/obj/item/organ/external/affecting = get_organ(hit_zone)

			// See what attack they use
			var/datum/unarmed_attack/attack = H.get_unarmed_attack(src, hit_zone)
			if(!attack)
				return 0
			if(world.time < H.last_attack + attack.delay)
				to_chat(H, "<span class='notice'>You can't attack again so soon.</span>")
				return 0
			else
				H.last_attack = world.time

			if(!affecting || affecting.is_stump())
				to_chat(M, "<span class='danger'>They are missing that limb!</span>")
				return 1

			switch(src.a_intent)
				if(I_HELP)
					// We didn't see this coming, so we get the full blow
					rand_damage = 5
					accurate = 1
				if(I_HURT, I_GRAB)
					// We're in a fighting stance, there's a chance we block
					if(MayMove() && src!=H && prob(20))
						block = 1

			if (M.grabbed_by.len)
				// Someone got a good grip on them, they won't be able to do much damage
				rand_damage = max(1, rand_damage - 2)

			if(src.grabbed_by.len || !src.MayMove() || src==H || H.species.species_flags & SPECIES_FLAG_NO_BLOCK)
				accurate = 1 // certain circumstances make it impossible for us to evade punches
				rand_damage = 5

			// Process evasion and blocking
			var/miss_type = 0
			var/attack_message
			if(!accurate)
				/* ~Hubblenaut
					This place is kind of convoluted and will need some explaining.
					ran_zone() will pick out of 11 zones, thus the chance for hitting
					our target where we want to hit them is circa 9.1%.

					Now since we want to statistically hit our target organ a bit more
					often than other organs, we add a base chance of 20% for hitting it.

					This leaves us with the following chances:

					If aiming for chest:
						27.3% chance you hit your target organ
						70.5% chance you hit a random other organ
						 2.2% chance you miss

					If aiming for something else:
						23.2% chance you hit your target organ
						56.8% chance you hit a random other organ
						15.0% chance you miss

					Note: We don't use get_zone_with_miss_chance() here since the chances
						  were made for projectiles.
					TODO: proc for melee combat miss chances depending on organ?
				*/
				if(prob(80))
					hit_zone = ran_zone(hit_zone)
				if(prob(15) && hit_zone != BP_CHEST) // Missed!
					if(!src.lying)
						attack_message = "[H] attempted to strike [src], but missed!"
					else
						attack_message = "[H] attempted to strike [src], but \he rolled out of the way!"
						src.set_dir(pick(GLOB.cardinal))
					miss_type = 1

			if(!miss_type && block)
				attack_message = "[H] went for [src]'s [affecting.name] but was blocked!"
				miss_type = 2

			H.do_attack_animation(src)
			if(!attack_message)
				attack.show_attack(H, src, hit_zone, rand_damage)
			else
				H.visible_message("<span class='danger'>[attack_message]</span>")

			playsound(loc, ((miss_type) ? (miss_type == 1 ? attack.miss_sound : 'sound/weapons/thudswoosh.ogg') : attack.attack_sound), 25, 1, -1)
			if (attack.should_attack_log)
				admin_attack_log(H, src, "[miss_type ? (miss_type == 1 ? "Has missed" : "Was blocked by") : "Has [pick(attack.attack_verb)]"] their victim.", "[miss_type ? (miss_type == 1 ? "Missed" : "Blocked") : "[pick(attack.attack_verb)]"] their attacker", "[miss_type ? (miss_type == 1 ? "has missed" : "was blocked by") : "has [pick(attack.attack_verb)]"]")

			if(miss_type)
				return 0

			var/real_damage = rand_damage
			real_damage += attack.get_unarmed_damage(H)
			if(MUTATION_HULK in H.mutations)
				real_damage *= 2 // Hulks do twice the damage
				rand_damage *= 2
			real_damage = max(1, real_damage)
			// Apply additional unarmed effects.
			attack.apply_effects(H, src, rand_damage, hit_zone)

			// Finally, apply damage to target
			apply_damage(real_damage, attack.get_damage_type(), hit_zone, damage_flags=attack.damage_flags())

		if(I_DISARM)
			if(H.species)
				admin_attack_log(M, src, "Disarmed their victim.", "Was disarmed.", "disarmed")
				H.species.disarm_attackhand(H, src)

	return

/mob/living/carbon/human/proc/afterattack(atom/target as mob|obj|turf|area, mob/living/user as mob|obj, inrange, params)
	return

/mob/living/carbon/human/attack_generic(mob/user, damage, attack_message, environment_smash, damtype = DAMAGE_BRUTE, armorcheck = "melee", dam_flags = EMPTY_BITFIELD)

	if(!damage || !istype(user))
		return
	admin_attack_log(user, src, "Attacked their victim", "Was attacked", "has [attack_message]")
	src.visible_message("<span class='danger'>[user] has [attack_message] [src]!</span>")
	user.do_attack_animation(src)

	var/dam_zone = pick(organs_by_name)
	var/obj/item/organ/external/affecting = get_organ(ran_zone(dam_zone))
	apply_damage(damage, damtype, affecting, dam_flags)
	updatehealth()
	return 1

//Breaks all grips and pulls that the mob currently has.
/mob/living/carbon/human/proc/break_all_grabs(mob/living/carbon/user)
	var/success = 0
	if(pulling)
		visible_message("<span class='danger'>[user] has broken [src]'s grip on [pulling]!</span>")
		success = 1
		stop_pulling()

	if(istype(l_hand, /obj/item/grab))
		var/obj/item/grab/lgrab = l_hand
		if(lgrab.affecting)
			visible_message("<span class='danger'>[user] has broken [src]'s grip on [lgrab.affecting]!</span>")
			success = 1
		spawn(1)
			qdel(lgrab)
	if(istype(r_hand, /obj/item/grab))
		var/obj/item/grab/rgrab = r_hand
		if(rgrab.affecting)
			visible_message("<span class='danger'>[user] has broken [src]'s grip on [rgrab.affecting]!</span>")
			success = 1
		spawn(1)
			qdel(rgrab)
	return success
/*
	We want to ensure that a mob may only apply pressure to one organ of one mob at any given time. Currently this is done mostly implicitly through
	the behaviour of do_after() and the fact that applying pressure to someone else requires a grab:

	If you are applying pressure to yourself and attempt to grab someone else, you'll change what you are holding in your active hand which will stop do_after()
	If you are applying pressure to another and attempt to apply pressure to yourself, you'll have to switch to an empty hand which will also stop do_after()
	Changing targeted zones should also stop do_after(), preventing you from applying pressure to more than one body part at once.
*/
/mob/living/carbon/human/proc/apply_pressure(mob/living/user, var/target_zone)
	var/obj/item/organ/external/organ = get_organ(target_zone)
	if(!organ || !(organ.status & ORGAN_BLEEDING) || BP_IS_ROBOTIC(organ))
		return 0

	if(organ.applied_pressure)
		var/message = "<span class='warning'>[ismob(organ.applied_pressure)? "Someone" : "\A [organ.applied_pressure]"] is already applying pressure to [user == src? "your [organ.name]" : "[src]'s [organ.name]"].</span>"
		to_chat(user, message)
		return 0

	if(user == src)
		user.visible_message("\The [user] starts applying pressure to \his [organ.name]!", "You start applying pressure to your [organ.name]!")
	else
		user.visible_message("\The [user] starts applying pressure to [src]'s [organ.name]!", "You start applying pressure to [src]'s [organ.name]!")
	spawn(0)
		organ.applied_pressure = user

		//apply pressure as long as they stay still and keep grabbing
		do_after(user, INFINITY, src, (DO_DEFAULT & ~DO_SHOW_PROGRESS) | DO_USER_SAME_ZONE)

		organ.applied_pressure = null

		if(user == src)
			user.visible_message("\The [user] stops applying pressure to \his [organ.name]!", "You stop applying pressure to your [organ.name]!")
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
