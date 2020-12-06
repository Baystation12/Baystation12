/mob/living/carbon/human/movement_delay()
	var/tally = ..()

	if(species.slowdown)
		tally += species.slowdown

	tally += species.handle_movement_delay_special(src)

	if (istype(loc, /turf/space)) // It's hard to be slowed down in space by... anything
		if(skill_check(SKILL_EVA, SKILL_PROF))
			return -2
		return -1

	if(embedded_flag || (stomach_contents && stomach_contents.len))
		handle_embedded_and_stomach_objects() //Moving with objects stuck in you can cause bad times.

	if(CE_SPEEDBOOST in chem_effects)
		tally -= chem_effects[CE_SPEEDBOOST]

	if(CE_SLOWDOWN in chem_effects)
		tally += chem_effects[CE_SLOWDOWN]

	var/health_deficiency = (maxHealth - health)
	if(health_deficiency >= 40) tally += (health_deficiency / 25)

	if(can_feel_pain())
		if(get_shock() >= 10) tally += (get_shock() / 10) //pain shouldn't slow you down if you can't even feel it

	if(istype(buckled, /obj/structure/bed/chair/wheelchair))
		for(var/organ_name in list(BP_L_HAND, BP_R_HAND, BP_L_ARM, BP_R_ARM))
			var/obj/item/organ/external/E = get_organ(organ_name)
			tally += E ? E.movement_delay(4) : 4
	else
		var/total_item_slowdown = -1
		for(var/slot = slot_first to slot_last)
			var/obj/item/I = get_equipped_item(slot)
			if(I)
				var/item_slowdown = 0
				item_slowdown += I.slowdown_general
				item_slowdown += I.slowdown_per_slot[slot]
				item_slowdown += I.slowdown_accessory

				if(item_slowdown >= 0)
					var/size_mod = size_strength_mod()
					if(size_mod + 1 > 0)
						item_slowdown = item_slowdown / (species.strength + size_mod + 1)
					else
						item_slowdown = item_slowdown - species.strength - size_mod
				total_item_slowdown += max(item_slowdown, 0)
		tally += round(total_item_slowdown)

		for(var/organ_name in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
			var/obj/item/organ/external/E = get_organ(organ_name)
			tally += E ? E.movement_delay(4) : 4

	if(shock_stage >= 10) tally += 3

	if(is_asystole()) tally += 10  //heart attacks are kinda distracting

	if(aiming && aiming.aiming_at) tally += 5 // Iron sights make you slower, it's a well-known fact.

	if(MUTATION_FAT in src.mutations)
		tally += 1.5
	if (bodytemperature < 283.222)
		tally += (283.222 - bodytemperature) / 10 * 1.75

	tally += max(2 * stance_damage, 0) //damaged/missing feet or legs is slow

	if(mRun in mutations)
		tally = 0

	return (tally+config.human_delay)

/mob/living/carbon/human/size_strength_mod()
	. = ..()
	. += species.strength

/mob/living/carbon/human/Allow_Spacemove(var/check_drift = 0)
	. = ..()
	if(.)
		return

	// This is horrible but short of spawning a jetpack inside the organ than locating
	// it, I don't really see another viable approach short of a total jetpack refactor.
	for(var/obj/item/organ/internal/powered/jets/jet in internal_organs)
		if(!jet.is_broken() && jet.active)
			inertia_dir = 0
			return 1
	// End 'eugh'

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

	if(thrust && thrust.on)
		if(prob(skill_fail_chance(SKILL_EVA, 10, SKILL_ADEPT)))
			to_chat(src, "<span class='warning'>You fumble with [thrust] controls!</span>")
			inertia_dir = pick(GLOB.cardinal)
			return 0

		if(((!check_drift) || (check_drift && thrust.stabilization_on)) && (!lying) && (thrust.allow_thrust(0.01, src)))
			inertia_dir = 0
			return 1

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
	if(species.species_flags & SPECIES_FLAG_NO_SLIP)
		return 1
	if(shoes && (shoes.item_flags & ITEM_FLAG_NOSLIP) && istype(shoes, /obj/item/clothing/shoes/magboots))  //magboots + dense_object = no floating
		return 1
	return 0

/mob/living/carbon/human/Move()
	. = ..()
	if(.) //We moved
		handle_exertion()
		handle_leg_damage()

/mob/living/carbon/human/proc/handle_exertion()
	if(isSynthetic())
		return
	var/lac_chance =  10 * encumbrance()
	if(lac_chance && prob(skill_fail_chance(SKILL_HAULING, lac_chance)))
		make_reagent(1, /datum/reagent/lactate)
		switch(rand(1,20))
			if(1)
				visible_message("<span class='notice'>\The [src] is sweating heavily!</span>", "<span class='notice'>You are sweating heavily!</span>")
			if(2)
				visible_message("<span class='notice'>\The [src] looks out of breath!</span>", "<span class='notice'>You are out of breath!</span>")

/mob/living/carbon/human/proc/handle_leg_damage()
	if(!can_feel_pain())
		return
	var/crutches = 0
	for(var/obj/item/weapon/cane/C in list(l_hand, r_hand))
		if(istype(C))
			crutches++
	for(var/organ_name in list(BP_L_LEG, BP_R_LEG, BP_L_FOOT, BP_R_FOOT))
		var/obj/item/organ/external/E = get_organ(organ_name)
		if(E && (E.is_dislocated() || E.is_broken()))
			if(crutches)
				crutches--
			else
				E.add_pain(10)