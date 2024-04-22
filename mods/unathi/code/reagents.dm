/datum/reagent/toxin/yeosvenom
	name = "Esh Hashaar Haashane"
	description = "A non-lethal toxin produced by Yeosa'Unathi"
	taste_description = "absolutely vile"
	color = "#91d895"
	target_organ = BP_LIVER
	strength = 1

/datum/reagent/toxin/yeosvenom/affect_blood(mob/living/carbon/M, alien, removed)
	if(prob(volume*10))
		M.set_confused(10)
	..()
