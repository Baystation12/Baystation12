/datum/power/changeling/enrage
	name = "Enrage"
	desc = "We evolve modifications to our mind and body, allowing us to call on intense periods of rage for our benefit."
	helptext = "Renders us nearly immune to pain and superhumanly fast for one minute, and losing the ability to \
	be accurate at ranged while active. Afterwards, we will suffer extreme amounts of exhaustion, slowing us and potentially causing us to even pass out."
	enhancedtext = "The length of our rage will be extended by an additional 30 seconds."
	ability_icon_state = "ling_berserk"
	genomecost = 2
	power_category = CHANGELING_POWER_ENHANCEMENTS
	allowduringlesserform = 1
	verbpath = /mob/living/proc/changeling_berserk

// Makes the ling very upset.
/mob/living/proc/changeling_berserk()
	set category = "Changeling"
	set name = "Enrage (30)"
	set desc = "Causes you to go Berserk."

	var/datum/changeling/changeling = changeling_power(30,0,100)
	var/mob/living/carbon/human/H = src
	var/obj/item/organ/external/parent = H.get_organ(BP_GROIN)
	var/has_organ = 0;
	if(!changeling)
		return 0

	for(var/obj/item/organ/internal/augment/changeling/ragecore/rage in H.internal_organs)
		has_organ++
	if(has_organ == 0)
		var/obj/item/organ/internal/augment/changeling/rage = new /obj/item/organ/internal/augment/changeling/ragecore
		rage.forceMove(src)
		rage.replaced(src, parent)
		rage = null
		has_organ++
	if(has_organ == 1)
		for(var/obj/item/organ/internal/augment/changeling/ragecore/rage in H.internal_organs)
			if(src.mind.changeling.recursive_enhancement)
				rage.ticks_remaining = 90;
				src.mind.changeling.recursive_enhancement = FALSE
			else
				rage.ticks_remaining = 60;
			to_chat(src,SPAN_WARNING("Our adrenal glands release a surge of energy, pushing our body to its limits!"))
	changeling.chem_charges -= 30
	return TRUE
