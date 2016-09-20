/mob/living/var/traumatic_shock = 0
/mob/living/carbon/var/shock_stage = 0

// proc to find out in how much pain the mob is at the moment
/mob/living/carbon/proc/updateshock()
	if (!can_feel_pain())
		src.traumatic_shock = 0
		return 0

	src.traumatic_shock = 			\
	1	* src.getOxyLoss() + 		\
	0.7	* src.getToxLoss() + 		\
	1.5	* src.getFireLoss() + 		\
	1.2	* src.getBruteLoss() + 		\
	1.7	* src.getCloneLoss() + 		\
	2	* src.halloss + 			\
	-1	* src.chem_effects[CE_PAINKILLER]

	if(src.slurring)
		src.traumatic_shock -= 20

	traumatic_shock = max(0,traumatic_shock)

	return src.traumatic_shock

/mob/living/carbon/human/updateshock()
	if (!can_feel_pain())
		src.traumatic_shock = 0
		return 0
	traumatic_shock = ..()
	for(var/obj/item/organ/external/organ in organs)
		if(organ.is_broken() || organ.open)
			src.traumatic_shock += 30
		else if(organ.is_dislocated())
			src.traumatic_shock += 15
	return src.traumatic_shock

/mob/living/carbon/proc/handle_shock()
	updateshock()
