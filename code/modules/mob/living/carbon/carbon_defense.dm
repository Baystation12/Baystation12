
/mob/living/carbon/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/hit_zone)
	if(!effective_force)
		return 0

	//Apply weapon damage
	var/damage_flags = I.damage_flags()
	var/datum/wound/created_wound = apply_damage(effective_force, I.damtype, hit_zone, damage_flags, used_weapon=I, armor_pen=I.armor_penetration)

	//Melee weapon embedded object code.
	if (istype(created_wound) && I && I.can_embed() && I.damtype == DAMAGE_BRUTE && !I.anchored && !is_robot_module(I))
		var/weapon_sharp = (damage_flags & DAMAGE_FLAG_SHARP)
		var/damage = effective_force //just the effective damage used for sorting out embedding, no further damage is applied here
		damage *= 1 - get_blocked_ratio(hit_zone, I.damtype, I.damage_flags(), I.armor_penetration, I.force)

		//blunt objects should really not be embedding in things unless a huge amount of force is involved
		var/embed_chance = weapon_sharp? damage/I.w_class : damage/(I.w_class*3)
		var/embed_threshold = weapon_sharp? 5*I.w_class : 15*I.w_class

		//Sharp objects will always embed if they do enough damage.
		if((weapon_sharp && damage > (10*I.w_class)) || (damage > embed_threshold && prob(embed_chance)))
			src.embed(I, hit_zone, supplied_wound = created_wound)
			I.has_embedded()

	return 1
