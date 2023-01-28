/datum/modifier/changeling
	name = "changeling"
	desc = "Changeling modifier."

	var/required_chems = 1	// Default is to require at least 1 chem unit. This does not consume it.

	var/chem_maintenance = 1	// How many chems are expended per cycle, if we are consuming chems.

	var/max_genetic_damage = 100

	var/max_stat = 0

	var/use_chems = FALSE	// Do we have an upkeep cost on chems?

	var/exterior_modifier = FALSE	// Should we be checking the origin mob for chems?

/datum/modifier/changeling/check_if_valid()
	var/mob/living/L = null
	if(exterior_modifier)
		if(origin)
			L = origin.resolve()
		else
			expire()
			return

	if((!exterior_modifier && !holder.changeling_power(required_chems, 0, max_genetic_damage, max_stat)) || (exterior_modifier && L && !L.changeling_power(required_chems, 0, max_genetic_damage, max_stat)))
		expire()
	else
		..()

/datum/modifier/changeling/tick()
	..()

	if(use_chems)
		var/mob/living/L = null

		if(exterior_modifier)
			L = origin.resolve()

		else
			L = holder

		L.mind.changeling.chem_charges = between(0, L.mind.changeling.chem_charges - chem_maintenance, L.mind.changeling.chem_storage)

/datum/modifier/changeling/thermal_sight
	name = "Thermal Adaptation"
	desc = "Our eyes are capable of seeing into the infrared spectrum to accurately identify prey through walls."
	vision_flags = SEE_MOBS

	on_expired_text = "<span class='alien'>Your sight returns to what it once was.</span>"
	stacks = MODIFIER_STACK_EXTEND

/datum/modifier/changeling/thermal_sight/check_if_valid()
	var/mob/living/L = null

	if(exterior_modifier)
		L = origin.resolve()

	else
		L = holder

	if(!L)
		expire()
		return

	var/datum/changeling/changeling = L.changeling_power(0,0,100,CONSCIOUS)

	if(!changeling)
		expire()
		return

	if(!changeling.thermal_sight)
		expire()
		return

	..()

/datum/modifier/changeling/thermal_sight/expire()
	var/mob/living/L = null

	if(exterior_modifier)
		L = origin.resolve()

	else
		L = holder

	if(L)
		var/datum/changeling/changeling = L.changeling_power(0,0,100,CONSCIOUS)

		if(changeling)
			changeling.thermal_sight = FALSE

	..()
