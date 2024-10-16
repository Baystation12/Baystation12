/datum/power/changeling/cryo_sting
	name = "Cryogenic Sting"
	desc = "We silently sting a biological with a cocktail of chemicals that freeze them."
	helptext = "Does not provide a warning to the victim, though they will likely realize they are suddenly freezing.  Has \
	a three minute cooldown between uses."
	enhancedtext = "Increases the amount of chemicals injected."
	ability_icon_state = "ling_sting_cryo"
	genomecost = 1
	verbpath = /mob/proc/changeling_cryo_sting
	sting_effect = /mob/proc/ling_cryo
	is_sting = TRUE

/mob/proc/cryo_cooldown()
	to_chat(src, "<span class='notice'>Our cryogenic string is ready to be used once more.</span>")
	src.verbs |= /mob/proc/changeling_cryo_sting

/mob/proc/ling_cryo(mob/living/carbon/M, duration)
	M.reagents.add_reagent(/datum/reagent/toxin/cryotoxin, 10)

/mob/proc/changeling_cryo_sting()
	set category = "Changeling"
	set name = "Cryogenic Sting (20)"
	set desc = "Chills and freezes a biological creature."

	var/mob/living/carbon/T = changeling_sting(20,/mob/proc/changeling_cryo_sting)
	if(!T)
		return FALSE
	admin_attack_log(src,T,"Cryo sting (changeling)")
	var/inject_amount = 10
	if(src.mind.changeling.recursive_enhancement)
		inject_amount = inject_amount * 1.5
		to_chat(src, "<span class='notice'>We inject extra chemicals.</span>")
	if(T.reagents)
		T.reagents.add_reagent(/datum/reagent/toxin/cryotoxin, inject_amount)
	src.verbs -= /mob/proc/changeling_cryo_sting
	addtimer(new Callback(src,/mob/.proc/cryo_cooldown), 3 MINUTES)

	return TRUE
