/datum/reagent/radiotox
	name = "Radio-Toxins"
	description = "Produced by several types of radiation scavengers."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#0047AB" //Cobalt blue!
	metabolism = REM // Default metabolism

	var/radiation_potential = 10

/datum/reagent/radiotox/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	var/mob/living/carbon/human/H = M
	if(istype(H))
		if(!(H.internal_organs_by_name[BP_LIVER] || H.internal_organs_by_name[BP_KIDNEYS]))
			//No organ to process away the toxin, so it starts to have an impact
			H.apply_effect(radiation_potential * removed, IRRADIATE, blocked = 0)
		else
			if(prob(5))
				to_chat(H, "<span class='warning'>You feel naseous</span>")
				H.adjustToxLoss(radiation_potential * removed)
			else if(prob(1))
				//Compound has broken down into real toxins
				H.vessel.add_reagent(/datum/reagent/toxin, removed)
