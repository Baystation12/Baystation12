/mob/living/carbon/human/movement_delay()
	var/tally = ..()

	if(species.slowdown)
		tally += species.slowdown

	tally += species.handle_movement_delay_special(src)

	if (istype(loc, /turf/space)) return -1 // It's hard to be slowed down in space by... anything

	if(embedded_flag || (stomach_contents && stomach_contents.len))
		handle_embedded_and_stomach_objects() //Moving with objects stuck in you can cause bad times.

	if(CE_SPEEDBOOST in chem_effects)
		return -1

	if(CE_SLOWDOWN in chem_effects)
		tally += chem_effects[CE_SLOWDOWN]

	var/health_deficiency = (maxHealth - health)
	if(health_deficiency >= 40) tally += (health_deficiency / 25)

	if(can_feel_pain())
		if(get_shock() >= 10) tally += (get_shock() / 10) //pain shouldn't slow you down if you can't even feel it

	if(istype(buckled, /obj/structure/bed/chair/wheelchair))
		for(var/organ_name in list(BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM))
			var/obj/item/organ/external/E = get_organ(organ_name)
			if(!E || E.is_stump())
				tally += 4
			else if(E.splinted)
				tally += 0.5
			else if(E.status & ORGAN_BROKEN)
				tally += 1.5
	else
		var/total_item_slowdown = -1
		for(var/slot = slot_first to slot_last)
			var/obj/item/I = get_equipped_item(slot)
			if(I)
				var/item_slowdown = 0
				item_slowdown += I.slowdown_general
				item_slowdown += I.slowdown_per_slot[slot]

				if(item_slowdown >= 0)
					var/size_mod = 0
					if(!(mob_size == MOB_MEDIUM))
						size_mod = log(2, mob_size / MOB_MEDIUM)
					if(species.strength + size_mod + 1 > 0)
						item_slowdown = item_slowdown / (species.strength + size_mod + 1)
					else
						item_slowdown = item_slowdown - species.strength - size_mod
				total_item_slowdown += max(item_slowdown, 0)
		tally += round(total_item_slowdown)

		for(var/organ_name in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
			var/obj/item/organ/external/E = get_organ(organ_name)
			if(!E || E.is_stump())
				tally += 4
			else if(E.splinted)
				tally += 0.5
			else if(E.status & ORGAN_BROKEN)
				tally += 1.5

	if(shock_stage >= 10) tally += 3

	if(aiming && aiming.aiming_at) tally += 5 // Iron sights make you slower, it's a well-known fact.

	if(FAT in src.mutations)
		tally += 1.5
	if (bodytemperature < 283.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75

	tally += max(2 * stance_damage, 0) //damaged/missing feet or legs is slow

	if(mRun in mutations)
		tally = 0

	return (tally+config.human_delay)

/mob/living/carbon/human/Allow_Spacemove(var/check_drift = 0)
	//Can we act?
	if(restrained())	return 0

	//Do we have a working jetpack?
	var/obj/item/weapon/tank/jetpack/thrust
	if(back)
		if(istype(back,/obj/item/weapon/tank/jetpack))
			thrust = back
		else if(istype(back,/obj/item/weapon/rig))
			var/obj/item/weapon/rig/rig = back
			for(var/obj/item/rig_module/maneuvering_jets/module in rig.installed_modules)
				thrust = module.jets
				break

	if(thrust)
		if(((!check_drift) || (check_drift && thrust.stabilization_on)) && (!lying) && (thrust.allow_thrust(0.01, src)))
			inertia_dir = 0
			return 1

	//If no working jetpack then use the other checks
	. = ..()


/mob/living/carbon/human/slip_chance(var/prob_slip = 5)
	if(!..())
		return 0

	//Check hands and mod slip
	if(!l_hand)	prob_slip -= 2
	else if(l_hand.w_class <= ITEM_SIZE_SMALL)	prob_slip -= 1
	if (!r_hand)	prob_slip -= 2
	else if(r_hand.w_class <= ITEM_SIZE_SMALL)	prob_slip -= 1

	return prob_slip

/mob/living/carbon/human/Check_Shoegrip()
	if(species.flags & NO_SLIP)
		return 1
	if(shoes && (shoes.item_flags & NOSLIP) && istype(shoes, /obj/item/clothing/shoes/magboots))  //magboots + dense_object = no floating
		return 1
	return 0