
/mob/living/carbon/standard_weapon_hit_effects(obj/item/I, mob/living/user, var/effective_force, var/blocked, var/hit_zone)
	if(!effective_force || blocked >= 100)
		return 0

	//Hulk modifier
	if(HULK in user.mutations)
		effective_force *= 2

	//Apply weapon damage
	var/damage_flags = I.damage_flags()
	if(prob(blocked)) //armour provides a chance to turn sharp/edge weapon attacks into blunt ones
		damage_flags &= ~(DAM_SHARP|DAM_EDGE)

	var/datum/wound/created_wound = apply_damage(effective_force, I.damtype, hit_zone, blocked, damage_flags, used_weapon=I)

	//Melee weapon embedded object code.
	if(istype(created_wound) && I && I.damtype == BRUTE && !I.anchored && !is_robot_module(I))
		var/weapon_sharp = (damage_flags & DAM_SHARP)
		var/damage = effective_force //just the effective damage used for sorting out embedding, no further damage is applied here
		if (blocked)
			damage *= blocked_mult(blocked)

		//blunt objects should really not be embedding in things unless a huge amount of force is involved
		var/embed_chance = weapon_sharp? damage/I.w_class : damage/(I.w_class*3)
		var/embed_threshold = weapon_sharp? 5*I.w_class : 15*I.w_class

		//Sharp objects will always embed if they do enough damage.
		if((weapon_sharp && damage > (10*I.w_class)) || (damage > embed_threshold && prob(embed_chance)))
			src.embed(I, hit_zone, supplied_wound = created_wound)

	return 1
