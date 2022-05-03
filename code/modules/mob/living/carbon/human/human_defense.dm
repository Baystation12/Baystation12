/*
Contains most of the procs that are called when a mob is attacked by something

bullet_act
ex_act
meteor_act

*/

/mob/living/carbon/human/bullet_act(var/obj/item/projectile/P, var/def_zone)
	if (status_flags & GODMODE)
		return PROJECTILE_FORCE_MISS

	def_zone = check_zone(def_zone)
	if(!has_organ(def_zone))
		return PROJECTILE_FORCE_MISS //if they don't have the organ in question then the projectile just passes by.

	//Shields
	var/shield_check = check_shields(P.damage, P, null, def_zone, "the [P.name]")
	if(shield_check)
		if(shield_check < 0)
			return shield_check
		else
			P.on_hit(src, 100, def_zone)
			return 100

	var/blocked = ..(P, def_zone)

	radio_interrupt_cooldown = world.time + (RADIO_INTERRUPT_DEFAULT * 0.8)

	return blocked

/mob/living/carbon/human/stun_effect_act(var/stun_amount, var/agony_amount, var/def_zone)
	var/obj/item/organ/external/affected = get_organ(check_zone(def_zone))
	if(!affected)
		return

	var/siemens_coeff = get_siemens_coefficient_organ(affected)
	stun_amount *= siemens_coeff
	agony_amount *= siemens_coeff
	agony_amount *= affected.get_agony_multiplier()
	affected.stun_act(stun_amount, agony_amount)

	radio_interrupt_cooldown = world.time + RADIO_INTERRUPT_DEFAULT

	if(!affected.can_feel_pain() || (chem_effects[CE_PAINKILLER]/3 > agony_amount))//stops blurry eyes and stutter if you can't feel pain
		agony_amount = 0

	..(stun_amount, agony_amount, def_zone)

/mob/living/carbon/human/get_blocked_ratio(def_zone, damage_type, damage_flags, armor_pen, damage)
	if(!def_zone && (damage_flags & DAMAGE_FLAG_DISPERSED))
		var/tally
		for(var/zone in organ_rel_size)
			tally += organ_rel_size[zone]
		for(var/zone in organ_rel_size)
			def_zone = zone
			. += .() * organ_rel_size/tally
		return
	return ..()

/mob/living/carbon/human/get_armors_by_zone(obj/item/organ/external/def_zone, damage_type, damage_flags)
	if(!def_zone)
		def_zone = ran_zone()
	if(!istype(def_zone))
		def_zone = get_organ(check_zone(def_zone))
	if(!def_zone)
		return ..()

	. = list()
	var/list/protective_gear = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes)
	for(var/obj/item/clothing/gear in protective_gear)
		if(gear.accessories.len)
			for(var/obj/item/clothing/accessory/bling in gear.accessories)
				if(bling.body_parts_covered & def_zone.body_part)
					var/armor = get_extension(bling, /datum/extension/armor)
					if(armor)
						. += armor
		if(gear.body_parts_covered & def_zone.body_part)
			var/armor = get_extension(gear, /datum/extension/armor)
			if(armor)
				. += armor

	// Add inherent armor to the end of list so that protective equipment is checked first
	. += ..()

//this proc returns the Siemens coefficient of electrical resistivity for a particular external organ.
/mob/living/carbon/human/proc/get_siemens_coefficient_organ(var/obj/item/organ/external/def_zone)
	if (!def_zone)
		return 1.0

	var/siemens_coefficient = max(species.siemens_coefficient,0)

	var/list/clothing_items = list(head, wear_mask, wear_suit, w_uniform, gloves, shoes) // What all are we checking?
	for(var/obj/item/clothing/C in clothing_items)
		for(var/obj/item/clothing/accessories in C.accessories)
			if (accessories.body_parts_covered & def_zone.body_part)
				siemens_coefficient *= accessories.siemens_coefficient
		if(istype(C) && (C.body_parts_covered & def_zone.body_part)) // Is that body part being targeted covered?
			siemens_coefficient *= C.siemens_coefficient

	return siemens_coefficient

/mob/living/carbon/human/proc/check_head_coverage()

	for(var/obj/item/clothing/bp in list(head, wear_mask, wear_suit, w_uniform))
		if(bp.body_parts_covered & HEAD)
			return 1
	return 0

//Used to check if they can be fed food/drinks/pills
/mob/living/carbon/human/check_mouth_coverage()
	var/list/protective_gear = list(head, wear_mask, wear_suit, w_uniform)
	for(var/obj/item/gear in protective_gear)
		if(istype(gear) && (gear.body_parts_covered & FACE) && !(gear.item_flags & ITEM_FLAG_FLEXIBLEMATERIAL))
			return gear

///Returns null or the first equipped item covering the bodypart
/mob/living/carbon/human/proc/get_clothing_coverage(bodypart)
	switch(bodypart)
		if (BP_HEAD)
			bodypart = HEAD
		if (BP_EYES)
			bodypart = EYES
		if (BP_MOUTH)
			bodypart = FACE
		if (BP_CHEST)
			bodypart = UPPER_TORSO
		if (BP_GROIN)
			bodypart = LOWER_TORSO
		if (BP_L_ARM, BP_R_ARM)
			bodypart =  ARMS
		if (BP_L_HAND,  BP_R_HAND)
			bodypart =  HANDS
		if (BP_L_LEG, BP_R_LEG)
			bodypart = LEGS
		if (BP_L_FOOT, BP_R_FOOT)
			bodypart = FEET

	for(var/obj/item/clothing/C in list(head, wear_mask, wear_suit, w_uniform, gloves, shoes, glasses))
		if (C.body_parts_covered & bodypart)
			return C
	return null

/mob/living/carbon/human/proc/check_shields(var/damage = 0, var/atom/damage_source = null, var/mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")

	var/obj/item/projectile/P = damage_source
	if(istype(P) && !P.disrupts_psionics() && psi && P.starting && prob(psi.get_armour(get_armor_key(P.damage_type, P.damage_flags())) * 0.5) && psi.spend_power(round(damage/10)))
		visible_message("<span class='danger'>\The [src] deflects [attack_text]!</span>")
		P.redirect(P.starting.x + rand(-2,2), P.starting.y + rand(-2,2), get_turf(src), src)
		return PROJECTILE_FORCE_MISS

	for(var/obj/item/shield in list(l_hand, r_hand, wear_suit))
		if(!shield) continue
		. = shield.handle_shield(src, damage, damage_source, attacker, def_zone, attack_text)
		if(.) return
	return 0

/mob/living/carbon/human/resolve_item_attack(obj/item/I, mob/living/user, var/target_zone)

	for (var/obj/item/grab/G in grabbed_by)
		if(G.resolve_item_attack(user, I, target_zone))
			return null

	if(user == src) // Attacking yourself can't miss
		return target_zone

	var/accuracy_penalty = user.melee_accuracy_mods()
	accuracy_penalty += 5*get_skill_difference(SKILL_COMBAT, user)
	accuracy_penalty += 10*(I.w_class - ITEM_SIZE_NORMAL)
	accuracy_penalty -= I.melee_accuracy_bonus

	var/hit_zone = get_zone_with_miss_chance(target_zone, src, accuracy_penalty)

	if(!hit_zone)
		visible_message("<span class='danger'>\The [user] misses [src] with \the [I]!</span>")
		return null

	if(check_shields(I.force, I, user, target_zone, "the [I.name]"))
		return null

	var/obj/item/organ/external/affecting = get_organ(hit_zone)
	if (!affecting || affecting.is_stump())
		to_chat(user, "<span class='danger'>They are missing that limb!</span>")
		return null

	return hit_zone

/mob/living/carbon/human/hit_with_weapon(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	var/obj/item/organ/external/affecting = get_organ(hit_zone)
	if(!affecting)
		return //should be prevented by attacked_with_item() but for sanity.

	var/weapon_mention
	if(I.attack_message_name())
		weapon_mention = " with [I.attack_message_name()]"
	visible_message(SPAN_DANGER("\The [src] has been [I.attack_verb.len? pick(I.attack_verb) : "attacked"] in the [affecting.name][weapon_mention] by \the [user]!"))
	return standard_weapon_hit_effects(I, user, effective_force, hit_zone)

/mob/living/carbon/human/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	var/obj/item/organ/external/affecting = get_organ(hit_zone)
	if(!affecting)
		return 0

	if(user.a_intent == I_DISARM)
		effective_force *= 0.66 //reduced effective force...

	var/blocked = get_blocked_ratio(hit_zone, I.damtype, I.damage_flags(), I.armor_penetration, effective_force)

	// Handle striking to cripple.
	if(user.a_intent == I_DISARM)
		if(!..(I, user, effective_force, hit_zone))
			return 0

		//set the dislocate mult less than the effective force mult so that
		//dislocating limbs on disarm is a bit easier than breaking limbs on harm
		attack_joint(affecting, I, effective_force, 0.5, blocked) //...but can dislocate joints
	else if(!..())
		return 0

	var/unimpeded_force = (1 - blocked) * effective_force
	if(effective_force > 10 || effective_force >= 5 && prob(33))
		forcesay(GLOB.hit_appends)	//forcesay checks stat already
		radio_interrupt_cooldown = world.time + (RADIO_INTERRUPT_DEFAULT * 0.8) //getting beat on can briefly prevent radio use
	if ((I.damtype == DAMAGE_BRUTE || I.damtype == DAMAGE_PAIN) && prob(25 + (unimpeded_force * 2)))
		if(!stat)
			if(!headcheck(hit_zone))
				if(prob(unimpeded_force + 5))
					apply_effect(3, EFFECT_WEAKEN, 100 * blocked)
					visible_message("<span class='danger'>[src] has been knocked down!</span>")
		//Apply blood
		attack_bloody(I, user, effective_force, hit_zone)

	return 1

/mob/living/carbon/human/proc/attack_bloody(obj/item/W, mob/living/attacker, var/effective_force, var/hit_zone)
	if (W.damtype != DAMAGE_BRUTE)
		return

	//make non-sharp low-force weapons less likely to be bloodied
	if(W.sharp || prob(effective_force*4))
		if(!(W.atom_flags & ATOM_FLAG_NO_BLOOD))
			W.add_blood(src)
	else
		return //if the weapon itself didn't get bloodied than it makes little sense for the target to be bloodied either

	//getting the weapon bloodied is easier than getting the target covered in blood, so run prob() again
	if(prob(33 + W.sharp ? 10 : 0))
		var/turf/location = loc
		if(istype(location, /turf/simulated))
			location.add_blood(src)
		if(ishuman(attacker))
			var/mob/living/carbon/human/H = attacker
			if(get_dist(H, src) <= 1) //people with TK won't get smeared with blood
				H.bloody_body(src)
				H.bloody_hands(src)

		switch(hit_zone)
			if(BP_HEAD)
				if(wear_mask)
					wear_mask.add_blood(src)
					update_inv_wear_mask(0)
				if(head)
					head.add_blood(src)
					update_inv_head(0)
				if(glasses && prob(33))
					glasses.add_blood(src)
					update_inv_glasses(0)
			if(BP_CHEST)
				bloody_body(src)

/mob/living/carbon/human/proc/projectile_hit_bloody(obj/item/projectile/P, var/effective_force, var/hit_zone, var/obj/item/organ/external/organ)
	if (P.damage_type != DAMAGE_BRUTE || P.nodamage)
		return
	if(!(P.sharp || prob(effective_force*4)))
		return
	if(prob(effective_force))
		var/turf/location = loc
		if(istype(location, /turf/simulated))
			location.add_blood(src)
		if(hit_zone)
			organ = get_organ(hit_zone)
		var/list/bloody = get_covering_equipped_items(organ.body_part)
		for(var/obj/item/clothing/C in bloody)
			C.add_blood(src)
			C.update_clothing_icon()

/mob/living/carbon/human/proc/attack_joint(var/obj/item/organ/external/organ, var/obj/item/W, var/effective_force, var/dislocate_mult, var/blocked)
	if(!organ || (organ.dislocated == 2) || (organ.dislocated == -1) || blocked >= 100)
		return 0
	if (W.damtype != DAMAGE_BRUTE)
		return 0

	//want the dislocation chance to be such that the limb is expected to dislocate after dealing a fraction of the damage needed to break the limb
	var/dislocate_chance = effective_force/(dislocate_mult * organ.min_broken_damage * config.organ_health_multiplier) * (organ.damage * 1.75)
	if(prob(dislocate_chance * blocked_mult(blocked)))
		visible_message("<span class='danger'>[src]'s [organ.joint] [pick("gives way","caves in","crumbles","collapses")]!</span>")
		organ.dislocate(1)
		return 1
	return 0

/mob/living/carbon/human/emag_act(var/remaining_charges, mob/user, var/emag_source)
	var/obj/item/organ/external/affecting = get_organ(user.zone_sel.selecting)
	if(!affecting || !BP_IS_ROBOTIC(affecting))
		to_chat(user, "<span class='warning'>That limb isn't robotic.</span>")
		return -1
	if(affecting.status & ORGAN_SABOTAGED)
		to_chat(user, "<span class='warning'>[src]'s [affecting.name] is already sabotaged!</span>")
		return -1
	to_chat(user, "<span class='notice'>You sneakily slide [emag_source] into the dataport on [src]'s [affecting.name] and short out the safeties.</span>")
	affecting.status |= ORGAN_SABOTAGED
	return 1

//this proc handles being hit by a thrown atom
/mob/living/carbon/human/hitby(atom/movable/AM as mob|obj, var/datum/thrownthing/TT)

	if(isobj(AM))
		var/obj/O = AM

		if(in_throw_mode && !get_active_hand() && TT.speed <= THROWFORCE_SPEED_DIVISOR)	//empty active hand and we're in throw mode
			if(!incapacitated())
				if(isturf(O.loc))
					put_in_active_hand(O)
					visible_message("<span class='warning'>[src] catches [O]!</span>")
					throw_mode_off()
					return

		var/dtype = O.damtype
		var/throw_damage = O.throwforce*(TT.speed/THROWFORCE_SPEED_DIVISOR)

		var/zone = BP_CHEST
		if (TT.target_zone)
			zone = check_zone(TT.target_zone)
		else
			zone = ran_zone()	//Hits a random part of the body, -was already geared towards the chest

		//check if we hit
		var/miss_chance = max(15*(TT.dist_travelled-2),0)
		zone = get_zone_with_miss_chance(zone, src, miss_chance, ranged_attack=1)

		if(zone && TT.thrower && TT.thrower != src)
			var/shield_check = check_shields(throw_damage, O, TT.thrower, zone, "[O]")
			if(shield_check == PROJECTILE_FORCE_MISS)
				zone = null
			else if(shield_check)
				return

		if(!zone)
			visible_message("<span class='notice'>\The [O] misses [src] narrowly!</span>")
			return

		var/obj/item/organ/external/affecting = get_organ(zone)
		if (!affecting)
			visible_message("<span class='notice'>\The [O] misses [src] narrowly!</span>")
			return

		var/hit_area = affecting.name
		var/datum/wound/created_wound

		src.visible_message("<span class='warning'>\The [src] has been hit in the [hit_area] by \the [O].</span>")
		created_wound = apply_damage(throw_damage, dtype, zone, O.damage_flags(), O, O.armor_penetration)

		if(TT.thrower)
			var/client/assailant = TT.thrower.client
			if(assailant)
				admin_attack_log(TT.thrower, src, "Threw \an [O] at their victim.", "Had \an [O] thrown at them", "threw \an [O] at")

		//thrown weapon embedded object code.
		if (dtype == DAMAGE_BRUTE && istype(O,/obj/item))
			var/obj/item/I = O
			if (!is_robot_module(I))
				var/sharp = I.can_embed()
				var/damage = throw_damage //the effective damage used for embedding purposes, no actual damage is dealt here
				damage *= (1 - get_blocked_ratio(zone, DAMAGE_BRUTE, O.damage_flags(), O.armor_penetration, throw_damage))

				//blunt objects should really not be embedding in things unless a huge amount of force is involved
				var/embed_chance = sharp? damage/I.w_class : damage/(I.w_class*3)
				var/embed_threshold = sharp? 5*I.w_class : 15*I.w_class

				//Sharp objects will always embed if they do enough damage.
				//Thrown sharp objects have some momentum already and have a small chance to embed even if the damage is below the threshold
				if((sharp && prob(damage/(10*I.w_class)*100)) || (damage > embed_threshold && prob(embed_chance)))
					affecting.embed(I, supplied_wound = created_wound)
					I.has_embedded()

		// Begin BS12 momentum-transfer code.
		var/mass = 1.5
		if(istype(O, /obj/item))
			var/obj/item/I = O
			mass = I.w_class/THROWNOBJ_KNOCKBACK_DIVISOR
		var/momentum = TT.speed*mass

		if(momentum >= THROWNOBJ_KNOCKBACK_SPEED)
			var/dir = TT.init_dir

			visible_message("<span class='warning'>\The [src] staggers under the impact!</span>","<span class='warning'>You stagger under the impact!</span>")

			if(!src.isinspace())
				src.throw_at(get_edge_target_turf(src,dir),1,momentum - THROWNOBJ_KNOCKBACK_SPEED)

			if(!O || !src) return

			if(O.loc == src && O.sharp && !(mob_flags & MOB_FLAG_UNPINNABLE)) //Projectile is embedded and suitable for pinning.
				var/turf/T = near_wall(dir,2)

				if(T)
					src.forceMove(T)
					visible_message("<span class='warning'>[src] is pinned to the wall by [O]!</span>","<span class='warning'>You are pinned to the wall by [O]!</span>")
					src.anchored = TRUE
					src.pinned += O
	else
		..()

/mob/living/carbon/human/embed(var/obj/O, var/def_zone=null, var/datum/wound/supplied_wound)
	if(!def_zone) ..()

	var/obj/item/organ/external/affecting = get_organ(def_zone)
	if(affecting)
		affecting.embed(O, supplied_wound = supplied_wound)

/mob/living/carbon/human/proc/bloody_hands(var/mob/living/source, var/amount = 2)
	var/obj/item/clothing/gloves/gloves = get_equipped_item(slot_gloves)
	if(istype(gloves))
		gloves.add_blood(source)
		gloves.transfer_blood = amount
		gloves.bloody_hands_mob = source
	else
		add_blood(source)
		bloody_hands = amount
		bloody_hands_mob = source
	update_inv_gloves()		//updates on-mob overlays for bloody hands and/or bloody gloves

/mob/living/carbon/human/proc/bloody_body(var/mob/living/source)
	if(wear_suit)
		wear_suit.add_blood(source)
		update_inv_wear_suit(0)
	if(w_uniform)
		w_uniform.add_blood(source)
		update_inv_w_uniform(0)

/mob/living/carbon/human/proc/handle_suit_punctures(var/damtype, var/damage, var/def_zone)

	// Tox and oxy don't matter to suits.
	if (damtype != DAMAGE_BURN && damtype != DAMAGE_BRUTE)
		return

	// The rig might soak this hit, if we're wearing one.
	if(back && istype(back,/obj/item/rig))
		var/obj/item/rig/rig = back
		rig.take_hit(damage)

	// We may also be taking a suit breach.
	if(!wear_suit) return
	if(!istype(wear_suit,/obj/item/clothing/suit/space)) return
	var/obj/item/clothing/suit/space/SS = wear_suit
	SS.create_breaches(damtype, damage)

/mob/living/carbon/human/reagent_permeability()
	var/perm = 0

	var/list/perm_by_part = list(
		"head" = THERMAL_PROTECTION_HEAD,
		"upper_torso" = THERMAL_PROTECTION_UPPER_TORSO,
		"lower_torso" = THERMAL_PROTECTION_LOWER_TORSO,
		"legs" = THERMAL_PROTECTION_LEG_LEFT + THERMAL_PROTECTION_LEG_RIGHT,
		"feet" = THERMAL_PROTECTION_FOOT_LEFT + THERMAL_PROTECTION_FOOT_RIGHT,
		"arms" = THERMAL_PROTECTION_ARM_LEFT + THERMAL_PROTECTION_ARM_RIGHT,
		"hands" = THERMAL_PROTECTION_HAND_LEFT + THERMAL_PROTECTION_HAND_RIGHT
		)

	for(var/obj/item/clothing/C in src.get_equipped_items())
		if(C.permeability_coefficient == 1 || !C.body_parts_covered)
			continue
		if(C.body_parts_covered & HEAD)
			perm_by_part["head"] *= C.permeability_coefficient
		if(C.body_parts_covered & UPPER_TORSO)
			perm_by_part["upper_torso"] *= C.permeability_coefficient
		if(C.body_parts_covered & LOWER_TORSO)
			perm_by_part["lower_torso"] *= C.permeability_coefficient
		if(C.body_parts_covered & LEGS)
			perm_by_part["legs"] *= C.permeability_coefficient
		if(C.body_parts_covered & FEET)
			perm_by_part["feet"] *= C.permeability_coefficient
		if(C.body_parts_covered & ARMS)
			perm_by_part["arms"] *= C.permeability_coefficient
		if(C.body_parts_covered & HANDS)
			perm_by_part["hands"] *= C.permeability_coefficient

	for(var/part in perm_by_part)
		perm += perm_by_part[part]

	return perm

/mob/living/carbon/human/lava_act(datum/gas_mixture/air, temperature, pressure)
	if (status_flags & GODMODE)
		return
	var/was_burned = FireBurn(0.4 * vsc.fire_firelevel_multiplier, temperature, pressure)
	if (was_burned)
		fire_act(air, temperature)
	return FALSE
