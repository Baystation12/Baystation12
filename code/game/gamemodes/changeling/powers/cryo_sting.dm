/datum/power/changeling/cryo_sting
	name = "Cryogenic Sting"
	desc = "We silently sting a biological with a cocktail of chemicals that freeze them."
	helptext = "Does not provide a warning to the victim, though they will likely realize they are suddenly freezing."
	genomecost = 1
	verbpath = /mob/proc/changeling_cryo_sting

/mob/proc/changeling_cryo_sting()
	set category = "Changeling"
	set name = "Cryogenic Sting (20)"
	set desc = "Chills and freezes a biological creature."

	var/mob/living/carbon/T = changeling_sting(40,/mob/proc/changeling_cryo_sting)
	if(!T)
		return 0
	if(T.reagents)
		T.reagents.add_reagent("frostoil", 10)
	feedback_add_details("changeling_powers","CS")
	return 1