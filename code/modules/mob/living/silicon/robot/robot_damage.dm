/mob/living/silicon/robot/updatehealth()
	if(status_flags & GODMODE)
		health = maxHealth
		stat = CONSCIOUS
		return
	health = maxHealth - (getBruteLoss() + getFireLoss())
	return

/mob/living/silicon/robot/getBruteLoss()
	var/amount = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed != 0) amount += C.brute_damage
	return amount

/mob/living/silicon/robot/getFireLoss()
	var/amount = 0
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed != 0) amount += C.electronics_damage
	return amount

/mob/living/silicon/robot/adjustBruteLoss(var/amount)
	if(amount > 0)
		take_overall_damage(amount, 0)
	else
		heal_overall_damage(-amount, 0)

/mob/living/silicon/robot/adjustFireLoss(var/amount)
	if(amount > 0)
		take_overall_damage(0, amount)
	else
		heal_overall_damage(0, -amount)

/mob/living/silicon/robot/proc/get_damaged_components(var/brute, var/burn, var/destroyed = 0)
	var/list/datum/robot_component/parts = list()
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed == 1 || (C.installed == -1 && destroyed))
			if((brute && C.brute_damage) || (burn && C.electronics_damage) || (!C.toggled) || (!C.powered && C.toggled))
				parts += C
	return parts

/mob/living/silicon/robot/proc/get_damageable_components()
	var/list/rval = new
	for(var/V in components)
		var/datum/robot_component/C = components[V]
		if(C.installed == 1) rval += C
	return rval

/mob/living/silicon/robot/proc/get_armour()

	if(!components.len) return 0
	var/datum/robot_component/C = components["armour"]
	if(C && C.installed == 1)
		return C
	return 0

/mob/living/silicon/robot/heal_organ_damage(var/brute, var/burn)
	var/list/datum/robot_component/parts = get_damaged_components(brute,burn)
	if(!parts.len)	return
	var/datum/robot_component/picked = pick(parts)
	picked.heal_damage(brute,burn)


/mob/living/silicon/robot/take_organ_damage(brute = 0, burn = 0, flags = 0)
	if (flags & ORGAN_DAMAGE_FLESH_ONLY || !brute && !burn)
		return

	var/list/components = get_damageable_components()
	if (!components.len)
		return

	if (module_active && istype(module_active, /obj/item/borg/combat/shield))
		var/obj/item/borg/combat/shield/shield = module_active
		var/absorb_brute = brute * shield.shield_level
		var/absorb_burn = burn * shield.shield_level
		if (cell.checked_use(absorb_brute * 100 + absorb_burn * 100))
			brute = max(brute - absorb_brute, 0)
			burn = max(brute - absorb_burn, 0)
			if (!brute && !burn)
				to_chat(src, SPAN_WARNING("Your shield absorbs all of the damage!"))
				return
			else
				to_chat(src, SPAN_WARNING("Your shield absorbs some of the damage!"))
		else
			to_chat(src, SPAN_DANGER("Your charge is too low to power your shield!"))

	var/datum/robot_component/component
	if (~flags & ORGAN_DAMAGE_SILICON_EMP)
		component = get_armour()
	if (!component)
		component = pick(components)
	if (component)
		component.take_damage(brute, burn, !!(flags & ORGAN_DAMAGE_SHARP), !!(flags & ORGAN_DAMAGE_EDGE))


/mob/living/silicon/robot/heal_overall_damage(var/brute, var/burn)
	var/list/datum/robot_component/parts = get_damaged_components(brute,burn)

	while(parts.len && (brute>0 || burn>0) )
		var/datum/robot_component/picked = pick(parts)

		var/brute_was = picked.brute_damage
		var/burn_was = picked.electronics_damage

		picked.heal_damage(brute,burn)

		brute -= (brute_was-picked.brute_damage)
		burn -= (burn_was-picked.electronics_damage)

		parts -= picked

/mob/living/silicon/robot/take_overall_damage(var/brute = 0, var/burn = 0, var/sharp = FALSE, var/used_weapon = null)
	if(status_flags & GODMODE)	return	//godmode
	var/list/datum/robot_component/parts = get_damageable_components()

	 //Combat shielding absorbs a percentage of damage directly into the cell.
	if(module_active && istype(module_active,/obj/item/borg/combat/shield))
		var/obj/item/borg/combat/shield/shield = module_active
		//Shields absorb a certain percentage of damage based on their power setting.
		var/absorb_brute = brute*shield.shield_level
		var/absorb_burn = burn*shield.shield_level
		var/cost = (absorb_brute+absorb_burn)*100

		cell.charge -= cost
		if(cell.charge <= 0)
			cell.charge = 0
			to_chat(src, "<span class='warning'>Your shield has overloaded!</span>")
		else
			brute -= absorb_brute
			burn -= absorb_burn
			to_chat(src, "<span class='warning'>Your shield absorbs some of the impact!</span>")

	var/datum/robot_component/armour/A = get_armour()
	if(A)
		A.take_damage(brute,burn,sharp)
		return

	while(parts.len && (brute>0 || burn>0) )
		var/datum/robot_component/picked = pick(parts)

		var/brute_was = picked.brute_damage
		var/burn_was = picked.electronics_damage

		picked.take_damage(brute,burn)

		brute	-= (picked.brute_damage - brute_was)
		burn	-= (picked.electronics_damage - burn_was)

		parts -= picked

/mob/living/silicon/robot/emp_act(severity)
	uneq_all()
	..() //Damage is handled at /silicon/ level.
