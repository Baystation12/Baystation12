/datum/power/changeling/enrage
	name = "Enrage"
	desc = "We evolve modifications to our mind and body, allowing us to call on intense periods of rage for our benefit."
	helptext = "Berserks us, giving massive bonuses to fighting in close quarters for thirty seconds, and losing the ability to \
	be accurate at ranged while active. Afterwards, we will suffer extreme amounts of exhaustion for a period of two minutes, \
	during which we will be much weaker and slower than before. We cannot berserk again while exhausted. This ability requires \
	a significant amount of nutrition to use, and cannot be used if too hungry. Using this ability will end most forms of disables."
	enhancedtext = "The length of exhaustion after berserking is reduced to one minute, from two, and requires half as much nutrition."
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
	if(!changeling)
		return 0

//	var/modifier_to_use = /datum/modifier/berserk/changeling
//	if(src.mind.changeling.recursive_enhancement)
//		modifier_to_use = /datum/modifier/berserk/changeling/recursive
//		to_chat(src, "<span class='notice'>We optimize our levels of anger, which will avoid excessive stress on ourselves.</span>")

//	if(add_modifier(modifier_to_use, 30 SECONDS))
//		changeling.chem_charges -= 30
