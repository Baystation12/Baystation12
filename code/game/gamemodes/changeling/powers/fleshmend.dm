/datum/power/changeling/fleshmend
	name = "Fleshmend"
	desc = "Begins a slow regeneration of our form.  Does not effect stuns or chemicals."
	helptext = "Can be used while unconscious."
	enhancedtext = "Healing is twice as effective."
	ability_icon_state = "ling_fleshmend"
	genomecost = 1
	verbpath = /mob/proc/changeling_fleshmend

//Starts healing you every second for 50 seconds. Can be used whilst unconscious.
/mob/proc/changeling_fleshmend()
	set category = "Changeling"
	set name = "Fleshmend (10)"
	set desc = "Begins a slow rengeration of our form.  Does not effect stuns or chemicals."

	var/datum/changeling/changeling = changeling_power(10,0,100,UNCONSCIOUS)
	if(!changeling)
		return FALSE
	src.mind.changeling.chem_charges -= 10

	var/mob/living/carbon/human/C = src
	var/heal_amount = 2
	if(src.mind.changeling.recursive_enhancement)
		heal_amount = heal_amount * 2
		to_chat(src, "<span class='notice'>We will heal much faster.</span>")

	spawn(0)
		to_chat(src, "<span class='notice'>We begin to heal ourselves.</span>")
		for(var/i = 0, i<50,i++)
			if(C)
				C.adjustBruteLoss(-heal_amount)
				C.adjustOxyLoss(-heal_amount)
				C.adjustFireLoss(-heal_amount)
				sleep(1 SECOND)

	src.verbs -= /mob/proc/changeling_fleshmend
	spawn(50 SECONDS)
		to_chat(src, "<span class='notice'>Our regeneration has slowed to normal levels.</span>")
		src.verbs += /mob/proc/changeling_fleshmend
	return TRUE
