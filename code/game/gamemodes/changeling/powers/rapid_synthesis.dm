/datum/power/changeling/RapidSynthesis
	name = "Rapid Chemical Synthesis"
	desc = "We alter our chemical glands to optimize our production of internal chemicals."
	helptext = "Allows us to store an extra 30 units of chemicals, and doubles production rate."
	genomecost = 1
	isVerb = 0
	verbpath = /mob/proc/changeling_rapid_synthesis

//Increases macimum chemical storage
/mob/proc/changeling_rapid_synthesis()
	src.mind.changeling.chem_recharge_rate *= 2
	return TRUE
