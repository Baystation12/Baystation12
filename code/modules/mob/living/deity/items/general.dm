/datum/deity_item/general
	category = "General"

/datum/deity_item/general/potential
	name = "Increase Potential"
	desc = "Increase the amount of natural power you regenerate."
	base_cost = 10

/datum/deity_item/general/potential/buy(var/mob/living/deity/D)
	..()
	D.adjust_power_min(5)

/datum/deity_item/general/potential/get_cost(var/mob/living/deity/D)
	return base_cost + base_cost * level**2

/datum/deity_item/general/regeneration
	name = "Increase Power Syphon"
	desc = "Decreases the time it takes to charge your power."
	base_cost = 5

/datum/deity_item/general/regeneration/buy(var/mob/living/deity/D)
	..()
	D.power_per_regen++

/datum/deity_item/general/regeneration/get_cost(var/mob/living/deity/D)
	return base_cost + 10 * level